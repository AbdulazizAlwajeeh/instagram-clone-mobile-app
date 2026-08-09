import { createClient } from "npm:@supabase/supabase-js@2"
import { GoogleAuth } from "npm:google-auth-library@9.0.0"

Deno.serve(async (req) => {
  console.log("--- Edge Function Execution Initiated ---")

  // --- SAFETY NET 1: Parsing Request Payload ---
  let record: any
  try {
    const body = await req.json()
    record = body.record
    console.log(`[PASS] Payload read successfully`)
  } catch (err) {
    console.error("[CRITICAL CRASH] Block 1 (Payload Parse Failed): Invalid JSON structure.")
    return new Response(JSON.stringify({ error: `Payload Parse Failure: Invalid JSON format.` }), {
        status:
        400 })
  }

  // --- SAFETY NET 2: Initializing Supabase Admin Client ---
  let supabaseAdmin: any
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error("Missing required cloud configuration dashboard secrets.")
    }

    supabaseAdmin = createClient(supabaseUrl, serviceRoleKey)
    console.log("[PASS] Supabase Admin Client initialized.")
  } catch (err) {
    console.error("[CRITICAL CRASH] Block 2 Failed to instantiate Supabase Admin client configuration.")
    return new Response(JSON.stringify({ error: `Client Init Failure: Internal server
        configuration mismatch.` }), {
        status: 500 })
  }

  // --- SAFETY NET 3: Fetching Database Device Tokens ---
  let devices: any[] | null = null
  try {
    const { data, error } = await supabaseAdmin
      .from('user_device_tokens')
      .select('device_token')
      .eq('user_id', record.receiver_id)

    if (error) throw error
    devices = data
    console.log(`[PASS] Database query finished. Target destination identified.`)

    if (!devices || devices.length === 0) {
      console.log("Early Return: Zero active device tokens registered for this user.")
      return new Response("No tokens found", { status: 200 })
    }
  } catch (err) {
    console.error("[CRITICAL CRASH] Block 3 Secure database lookup Failed.")
    return new Response(JSON.stringify({ error: `Database Query Failure: Unable to retrieve
        records.` }), {
        status: 500 })
  }

  // --- SAFETY NET 4: Google Service Account Token Handshake ---
  let accessToken: string | null = null
  try {
    const clientEmail = Deno.env.get('FIREBASE_CLIENT_EMAIL')
    const privateKey = Deno.env.get('FIREBASE_PRIVATE_KEY')

    if (!clientEmail || !privateKey) {
      throw new Error(`Missing required cryptographic credential infrastructure assets.`)
    }

    const auth = new GoogleAuth({
      credentials: {
        client_email: clientEmail,
        private_key: privateKey.replace(/\\n/g, '\n'),
      },
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })

    console.log("[PROCEDURE] Initializing external authorization sequence.")
    const client = await auth.getClient()
    const tokenResponse = await client.getAccessToken()
    accessToken = tokenResponse.token

    if (!accessToken) throw new Error("Authorization protocol generated an empty credential asset.")
    console.log("[PASS] External credential handshake completed successfully.")
  } catch (err) {
    console.error("[CRITICAL CRASH] Block 4 External authentication handshake failed.")
    return new Response(JSON.stringify({ error: `Google Authentication Failure: Protocol verification rejected.` }), { status: 401 })
  }

  // --- SAFETY NET 5: FCM Notification Transmission Loop ---
  try {
    const projectId = Deno.env.get('FIREBASE_PROJECT_ID')
    if (!projectId) throw new Error("Missing required messaging gateway configuration identifiers.")

    const fcmEndpoint = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`
    console.log(`[PROCEDURE] Dispatching notification payloads to downstream gateway.`)

    for (const item of devices) {

      const fcmResponse = await fetch(fcmEndpoint, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${accessToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          message: {
            token: item.device_token,
            notification: { title: "New Message", body: record.content },
            data: { conversation_id: String(record.conversation_id) }
          }
        })
      })

      if (!fcmResponse.ok) {
        console.error(`[FCM DELIVERY WARNING] Remote gateway rejected device submission.`)
      } else {
        console.log(`[FCM SUCCESS] Notification payload acknowledged by upstream network.`)
      }
    }

    console.log("[PASS] Notification execution complete.")
    return new Response(JSON.stringify({ success: true }), { status: 200 })
  } catch (err) {
    console.error("[CRITICAL CRASH] Block 5: Downstream notification dispatch engine failed.")
    return new Response(JSON.stringify({ error: `FCM Transmission Failure: Unable to complete message dispatch loop.` }), { status: 500 })
  }
})
