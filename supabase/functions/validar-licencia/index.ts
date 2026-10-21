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

async function calcularHash(codigo: string): Promise<string> {
  const normalizado = codigo.trim().toUpperCase();
  const bytes = new TextEncoder().encode(normalizado);
  const digest = await crypto.subtle.digest("SHA-256", bytes);

  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

Deno.serve(async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return responder({ ok: false, estado: "metodo_no_permitido" }, 405);
  }

  try {
    const { codigo, dispositivo_id } = await req.json();

    if (
      typeof codigo !== "string" ||
      typeof dispositivo_id !== "string" ||
      codigo.trim().length === 0 ||
      codigo.length > 128 ||
      dispositivo_id.trim().length < 8 ||
      dispositivo_id.length > 256
    ) {
      return responder({ ok: false, estado: "datos_invalidos" }, 400);
    }

    const url = Deno.env.get("SUPABASE_URL");
    const clave = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!url || !clave) {
      console.error("Falta la configuración del servidor.");
      return responder({ ok: false, estado: "error_servidor" }, 500);
    }

    const codigoHash = await calcularHash(codigo);

    const respuesta = await fetch(
      `${url}/rest/v1/rpc/activar_licencia_premium`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "apikey": clave,
          "Authorization": `Bearer ${clave}`,
        },
        body: JSON.stringify({
          p_codigo_hash: codigoHash,
          p_dispositivo_id: dispositivo_id.trim(),
        }),
      },
    );

    if (!respuesta.ok) {
      console.error("Falló la consulta de activación:", respuesta.status);
      return responder({ ok: false, estado: "error_servidor" }, 502);
    }

    const resultado = await respuesta.json();
    return responder(resultado);
  } catch {
    return responder({ ok: false, estado: "solicitud_invalida" }, 400);
  }
});
