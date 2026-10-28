import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json; charset=utf-8",
};

function responder(datos: unknown, status = 200): Response {
  return new Response(JSON.stringify(datos), {
    status,
    headers: corsHeaders,
  });
}

async function hashTexto(texto: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(texto),
  );

  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

function generarToken(): string {
  const bytes = crypto.getRandomValues(new Uint8Array(32));
  return Array.from(bytes)
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

function esObjeto(valor: unknown): valor is Record<string, unknown> {
  return typeof valor === "object" && valor !== null &&
    !Array.isArray(valor);
}

Deno.serve(async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return responder({ ok: false, estado: "metodo_no_permitido" }, 405);
  }

  try {
    const entrada: unknown = await req.json();

    if (!esObjeto(entrada)) {
      return responder({ ok: false, estado: "datos_invalidos" }, 400);
    }

    const accion = entrada.accion ?? "activar";
    const dispositivo = entrada.dispositivo_id;

    if (
      typeof dispositivo !== "string" ||
      dispositivo.trim().length < 8 ||
      dispositivo.length > 256
    ) {
      return responder({ ok: false, estado: "datos_invalidos" }, 400);
    }

    const dispositivoId = dispositivo.trim();
    const url = Deno.env.get("SUPABASE_URL");
    const clave = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!url || !clave) {
      console.error("Falta la configuración del servidor.");
      return responder({ ok: false, estado: "error_servidor" }, 500);
    }

    const cabeceras = {
      "Content-Type": "application/json",
      "apikey": clave,
      "Authorization": `Bearer ${clave}`,
    };

    async function consultar(
      ruta: string,
      opciones: RequestInit = {},
    ): Promise<Response> {
      return await fetch(`${url}/rest/v1/${ruta}`, {
        ...opciones,
        headers: {
          ...cabeceras,
          ...(opciones.headers ?? {}),
        },
      });
    }

    // ACTIVAR: validar código y emitir una sesión para el dispositivo.
    if (accion === "activar") {
      const codigo = entrada.codigo;

      if (
        typeof codigo !== "string" ||
        codigo.trim().length === 0 ||
        codigo.length > 128
      ) {
        return responder({ ok: false, estado: "datos_invalidos" }, 400);
      }

      const codigoHash = await hashTexto(codigo.trim().toUpperCase());

      const rpc = await consultar("rpc/activar_licencia_premium", {
        method: "POST",
        body: JSON.stringify({
          p_codigo_hash: codigoHash,
          p_dispositivo_id: dispositivoId,
        }),
      });

      if (!rpc.ok) {
        console.error("Falló la activación:", rpc.status);
        return responder({ ok: false, estado: "error_servidor" }, 502);
      }

      const resultado: unknown = await rpc.json();

      if (!esObjeto(resultado) || resultado.ok !== true) {
        return responder(
          esObjeto(resultado)
            ? resultado
            : { ok: false, estado: "respuesta_invalida" },
        );
      }

      const consultaLicencia = await consultar(
        "licencias_premium" +
          `?codigo_hash=eq.${encodeURIComponent(codigoHash)}` +
          "&select=id,estado,dispositivo_id,fecha_vencimiento",
      );

      if (!consultaLicencia.ok) {
        console.error("No se pudo consultar la licencia.");
        return responder({ ok: false, estado: "error_servidor" }, 502);
      }

      const licencias: unknown = await consultaLicencia.json();

      if (!Array.isArray(licencias) || licencias.length !== 1) {
        return responder({ ok: false, estado: "licencia_no_encontrada" });
      }

      const licencia = licencias[0];

      if (
        !esObjeto(licencia) ||
        licencia.estado !== "activa" ||
        licencia.dispositivo_id !== dispositivoId ||
        typeof licencia.id !== "string" ||
        typeof licencia.fecha_vencimiento !== "string"
      ) {
        return responder({ ok: false, estado: "licencia_no_valida" });
      }

      if (Date.parse(licencia.fecha_vencimiento) <= Date.now()) {
        return responder({ ok: false, estado: "vencida" });
      }

      const token = generarToken();
      const tokenHash = await hashTexto(token);

      const guardarSesion = await consultar(
        "licencias_sesiones?on_conflict=licencia_id",
        {
          method: "POST",
          headers: {
            "Prefer": "resolution=merge-duplicates,return=minimal",
          },
          body: JSON.stringify({
            licencia_id: licencia.id,
            token_hash: tokenHash,
            dispositivo_id: dispositivoId,
          }),
        },
      );

      if (!guardarSesion.ok) {
        console.error("No se pudo guardar la sesión:", guardarSesion.status);
        return responder({ ok: false, estado: "error_sesion" }, 502);
      }

      return responder({
        ok: true,
        estado: "activa",
        fecha_vencimiento: licencia.fecha_vencimiento,
        token,
      });
    }

    // VERIFICAR: comprobar token, dispositivo y vigencia en el servidor.
    if (accion === "verificar") {
      const token = entrada.token;

      if (
        typeof token !== "string" ||
        !/^[a-f0-9]{64}$/.test(token)
      ) {
        return responder({ ok: false, estado: "sesion_invalida" });
      }

      const tokenHash = await hashTexto(token);

      const consultaSesion = await consultar(
        "licencias_sesiones" +
          `?token_hash=eq.${encodeURIComponent(tokenHash)}` +
          "&select=licencia_id,dispositivo_id",
      );

      if (!consultaSesion.ok) {
        console.error("Falló la consulta de sesión:", consultaSesion.status);
        return responder({ ok: false, estado: "error_servidor" }, 502);
      }

      const sesiones: unknown = await consultaSesion.json();

      if (!Array.isArray(sesiones) || sesiones.length !== 1) {
        return responder({ ok: false, estado: "sesion_invalida" });
      }

      const sesion = sesiones[0];

      if (
        !esObjeto(sesion) ||
        sesion.dispositivo_id !== dispositivoId ||
        typeof sesion.licencia_id !== "string"
      ) {
        return responder({ ok: false, estado: "otro_dispositivo" });
      }

      const consultaLicencia = await consultar(
        "licencias_premium" +
          `?id=eq.${encodeURIComponent(sesion.licencia_id)}` +
          "&select=estado,dispositivo_id,fecha_vencimiento",
      );

      if (!consultaLicencia.ok) {
        console.error("Falló la consulta de licencia:", consultaLicencia.status);
        return responder({ ok: false, estado: "error_servidor" }, 502);
      }

      const licencias: unknown = await consultaLicencia.json();

      if (!Array.isArray(licencias) || licencias.length !== 1) {
        return responder({ ok: false, estado: "licencia_no_encontrada" });
      }

      const licencia = licencias[0];

      if (!esObjeto(licencia)) {
        return responder({ ok: false, estado: "licencia_no_valida" });
      }

      if (licencia.estado === "revocada") {
        return responder({ ok: false, estado: "revocada" });
      }

      if (
        licencia.estado !== "activa" ||
        licencia.dispositivo_id !== dispositivoId ||
        typeof licencia.fecha_vencimiento !== "string"
      ) {
        return responder({ ok: false, estado: "licencia_no_valida" });
      }

      if (Date.parse(licencia.fecha_vencimiento) <= Date.now()) {
        return responder({
          ok: false,
          estado: "vencida",
          fecha_vencimiento: licencia.fecha_vencimiento,
        });
      }

      return responder({
        ok: true,
        estado: "activa",
        fecha_vencimiento: licencia.fecha_vencimiento,
      });
    }

    return responder({ ok: false, estado: "accion_no_valida" }, 400);
  } catch (error) {
    console.error("Error procesando la solicitud:", error);
    return responder({ ok: false, estado: "solicitud_invalida" }, 400);
  }
});
