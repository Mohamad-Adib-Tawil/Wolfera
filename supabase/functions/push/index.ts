// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
const FCM_SERVER_KEY = Deno.env.get("FCM_SERVER_KEY");

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY env variables");
}
if (!FCM_SERVER_KEY) {
  console.error("Missing FCM_SERVER_KEY env variable");
}

const supabase = createClient(SUPABASE_URL!, SUPABASE_SERVICE_ROLE_KEY!, {
  auth: { persistSession: false },
});

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  try {
    const body = (await req.json()) as any;
    const userId = body.user_id as string;
    const title = (body.title as string) ?? "";
    const message = (body.body as string) ?? "";
    const data = (body.data as Record<string, any>) ?? {};

    if (!userId) {
      return Response.json({ error: "user_id is required" }, { status: 400 });
    }

    const { data: devices, error } = await supabase
      .from("user_devices")
      .select("token, platform")
      .eq("user_id", userId);

    if (error) {
      console.error("DB error fetching devices:", error);
      return Response.json({ error: "db_error" }, { status: 500 });
    }

    const tokens = (devices ?? []).map((d: any) => d.token).filter(Boolean);

    if (!tokens.length) {
      return Response.json({ ok: true, skipped: "no_tokens" });
    }

    // Legacy FCM endpoint for simplicity
    const fcmRes = await fetch("https://fcm.googleapis.com/fcm/send", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `key=${FCM_SERVER_KEY}`,
      },
      body: JSON.stringify({
        registration_ids: tokens,
        priority: "high",
        notification: {
          title,
          body: message,
        },
        data,
      }),
    });

    const fcmJson = await fcmRes.json().catch(() => ({}));
    if (!fcmRes.ok) {
      console.error("FCM error", fcmRes.status, fcmJson);
      return Response.json({ error: "fcm_error", details: fcmJson }, { status: 502 });
    }

    return Response.json({ ok: true, result: fcmJson });
  } catch (e) {
    console.error("Unhandled error in push function", e);
    return Response.json({ error: "server_error" }, { status: 500 });
  }
});
