# Self-Hosted Content Engine Guide (Local n8n)
**Goal**: Run 11-channel automation from your PC (0 cost, max security).
**Architecture**: Local n8n Server -> Reads `outputs/` -> Checks `Publish Gate` -> API Upload.

## 1. Start Your Server
Run this one-liner to download and start n8n.
No installation needed (uses `npx` from Node.js).
```powershell
npx n8n start --tunnel
```
- Open your browser to the URL shown (usually `http://localhost:5678` or a tunnel URL).
- Create a local admin account (data stays on your disk).

## 2. Connect the "Brain" (Import Workflow)
1. On n8n dashboard, click **"Add workflow"** (top right).
2. Click the three dots `...` -> **"Import from File"**.
3. Select `packing-wins-lab/n8n/FLOW_SKELETON.json`.
   *(This loads the skeleton logic: Watch Folder -> Read JSON -> Split by Platform)*

## 3. Secure with Publish Gate (The "Shield")
You must add a **Defense Layer** before any upload node.
Add an **"Execute Command"** node with this logic:

**Command**:
```powershell
powershell -ExecutionPolicy Bypass -File "C:/Users/sunwo/OneDrive/wrok/projects/packing-wins-lab/scripts/publish-gate.ps1" -Platform "{{ $json.platform }}" -Text "{{ $json.post_text }}" -IsAffiliate $true
```
*(Replace path with your absolute path if needed)*

**Logic**:
- IF output contains `"verdict": "PASS"` -> **Continue** to Upload Node.
- IF output contains `"verdict": "BLOCK"` or `"REWRITE"` -> **Stop** execution (send alert to Discord/Slack).

## 4. Connect Platforms (API Auth)
In n8n, go to **Credentials** and add:
- **Google OAuth2** (for YouTube Shorts)
- **Twitter OAuth2** (for X)
- **LinkedIn OAuth2**
- etc.
*(Since it's local, `http://localhost:5678/oauth2/callback` is your redirect URI)*

## 5. Daily Routine
1. **Morning**: Turn on PC.
2. **Generate**: Run `generate_day0_packs.ps1` (or your v2 generator).
3. **Verify**: Run `publish-gate-regression.ps1`.
4. **Active**: Ensure `npx n8n start` is running.
5. **Watch**: The workflow will pick up new JSON files in `outputs/` and publish automatically.

## 6. Reddit Safety (Strict)
Even if you connect Reddit API, **DO NOT connect the 'Reddit Post' node** to the main flow.
Leave it disconnected or connected only to a "Create Draft" action (if supported), or handle manually as per `DISTRIBUTION_RULES.md`.
