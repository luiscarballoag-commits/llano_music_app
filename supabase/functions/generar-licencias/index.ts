import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type",
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

function generarCodigo(): string {
  const alfabeto = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  const bytes = crypto.getRandomValues(new Uint8Array(12));
  const caracteres = Array.from(bytes, (b) => alfabeto[b % alfabeto.length]);

  return `LLANO-${caracteres.slice(0, 4).join("")}-${caracteres.slice(4, 8).join("")}-${caracteres.slice(8, 12).join("")}`;
}

Deno.serve(async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return responder({ ok: false, error: "metodo_no_permitido" }, 405);
  }

  const url = Deno.env.get("SUPABASE_URL");
  const clave = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const autorizacion = req.headers.get("Authorization");
  const coincidencia = autorizacion?.match(/^Bearer\s+(.+)$/i);
  const token = coincidencia?.[1];

  if (!url || !clave) {
    console.error("Falta configuración del servidor.");
    return responder({ ok: false, error: "error_servidor" }, 500);
  }

  if (!token) {
    return responder({ ok: false, error: "sesion_requerida" }, 401);
  }

  try {
    // Validar el token con Supabase Auth.
    const respuestaUsuario = await fetch(`${url}/auth/v1/user`, {
      headers: {
        "apikey": clave,
        "Authorization": `Bearer ${token}`,
      },
    });

    if (!respuestaUsuario.ok) {
      return responder({ ok: false, error: "sesion_invalida" }, 401);
    }

    const usuario: unknown = await respuestaUsuario.json();

    if (
      typeof usuario !== "object" ||
      usuario === null ||
      !("id" in usuario) ||
      typeof usuario.id !== "string"
    ) {
      return responder({ ok: false, error: "sesion_invalida" }, 401);
    }

    // Comprobar que el UUID esté autorizado como administrador.
    const consultaAdmin = new URL(
      `${url}/rest/v1/licencias_administradores`,
    );
    consultaAdmin.searchParams.set("select", "usuario_id");
    consultaAdmin.searchParams.set("usuario_id", `eq.${usuario.id}`);
    consultaAdmin.searchParams.set("limit", "1");

    const respuestaAdmin = await fetch(consultaAdmin, {
      headers: {
        "apikey": clave,
        "Authorization": `Bearer ${clave}`,
      },
    });

    if (!respuestaAdmin.ok) {
      console.error("No se pudo comprobar el administrador:", respuestaAdmin.status);
      return responder({ ok: false, error: "error_verificando_admin" }, 500);
    }

    const administradores: unknown = await respuestaAdmin.json();

    if (!Array.isArray(administradores) || administradores.length === 0) {
      return responder({ ok: false, error: "sin_permisos_administrador" }, 403);
    }

    const entrada: unknown = await req.json();

    if (
      typeof entrada !== "object" ||
      entrada === null ||
      Array.isArray(entrada)
    ) {
      return responder({ ok: false, error: "datos_invalidos" }, 400);
    }

    const cantidad = (entrada as Record<string, unknown>).cantidad ?? 1;

    if (
      typeof cantidad !== "number" ||
      !Number.isInteger(cantidad) ||
      cantidad < 1 ||
      cantidad > 20
    ) {
      return responder({
        ok: false,
        error: "cantidad_debe_ser_entera_entre_1_y_20",
      }, 400);
    }

    // Preparar todos los códigos antes de insertarlos en una sola petición.
    for (let intento = 0; intento < 5; intento++) {
      const codigos: string[] = [];
      const registros: { codigo_hash: string; estado: string }[] = [];

      for (let i = 0; i < cantidad; i++) {
        const codigo = generarCodigo();
        codigos.push(codigo);
        registros.push({
          codigo_hash: await hashTexto(codigo.trim().toUpperCase()),
          estado: "pendiente",
        });
      }

      const respuestaInsert = await fetch(
        `${url}/rest/v1/licencias_premium`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "apikey": clave,
            "Authorization": `Bearer ${clave}`,
            "Prefer": "return=minimal",
          },
          body: JSON.stringify(registros),
        },
      );

      if (respuestaInsert.ok) {
        return responder({
          ok: true,
          cantidad: codigos.length,
          mensaje: "Guarda los códigos: no se almacenan en texto legible.",
          codigos,
        });
      }

      const detalle = await respuestaInsert.text();

      if (respuestaInsert.status === 409) {
        // Colisión improbable: generar un lote nuevo.
        continue;
      }

      console.error("Error guardando licencias:", respuestaInsert.status, detalle);
      return responder({
        ok: false,
        error: "no_se_pudo_guardar_la_licencia",
      }, 502);
    }

    return responder({
      ok: false,
      error: "no_se_pudo_generar_un_codigo_unico",
    }, 500);
  } catch (error) {
    console.error("Error en generador:", error);
    return responder({ ok: false, error: "solicitud_invalida" }, 400);
  }
});
