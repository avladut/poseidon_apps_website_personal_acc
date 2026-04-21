# Deploying Poseidon Apps to Azure

This is the complete playbook for shipping the Flutter Web build to
`poseidonapps.net` on Azure — custom domain, HTTPS, CI/CD, and email coexistence.

---

## 1. Why Azure Static Web Apps (SWA)

A Flutter Web build produces static assets (HTML, JS, CanvasKit, fonts). The
right Azure product is **Azure Static Web Apps** — purpose-built for this shape
of app, global CDN, free HTTPS, free custom domain, and generous Free tier.

| Tier      | Price         | Limits                                                    |
|-----------|---------------|-----------------------------------------------------------|
| **Free**  | $0 / month    | 100 GB egress/mo · 250 MB app size · custom domain · SSL · PR preview envs |
| Standard  | ~$9 / month   | Same + SLA, larger app size (~500 MB), private endpoints  |

For a marketing site the Free tier is sufficient indefinitely. Azure **won't**
charge you if traffic goes over 100 GB — it just rate-limits — so there's no
runaway-bill risk.

**Things to avoid on Azure for this site:**
- App Service (Basic B1 = ~$13/month — unnecessary; you're not running a server)
- Azure VMs (~$10–50/month — way overkill)
- Azure Front Door standalone (it's a routing layer, not a host)

---

## 2. Prerequisites

- GitHub account + a new repo for this project (public or private).
- Azure account — sign up at [portal.azure.com](https://portal.azure.com). New
  accounts get $200 of free credit; SWA Free tier doesn't consume credit.
- Flutter SDK ≥ 3.22 installed locally. Check with `flutter --version`.
- (Optional) Azure CLI for one-off deploys: `brew install azure-cli`.

---

## 3. Build locally to verify

Before pushing, confirm the site builds clean:

```bash
flutter pub get
flutter build web --release
```

Output lands in `build/web/`. Smoke-test it:

```bash
cd build/web
python3 -m http.server 8000
# open http://localhost:8000
```

If everything renders, you're ready to deploy.

---

## 4. Push to GitHub

```bash
git init
git add .
git commit -m "Initial Poseidon Apps website"
git branch -M main
git remote add origin https://github.com/<your-user>/poseidonapps-site.git
git push -u origin main
```

---

## 5. Create the Azure Static Web App

Two options — the **Portal path** is the easiest the first time.

### 5a. Portal path (auto-wires GitHub)

1. [portal.azure.com](https://portal.azure.com) → **Create a resource** →
   search **Static Web App** → **Create**.
2. Fill in:
   - **Subscription**: your default.
   - **Resource group**: create `poseidonapps-rg` (a new one is fine).
   - **Name**: `poseidonapps-site`.
   - **Plan type**: **Free**.
   - **Region**: **West Europe** (or closest to your audience).
   - **Source**: **GitHub** → authorize → pick your repo and `main` branch.
   - **Build presets**: **Custom**.
   - **App location**: `/`
   - **Api location**: *(leave empty)*
   - **Output location**: `build/web`
3. **Review + create** → **Create**.

What Azure does next, for you:
- Commits a GitHub Actions workflow to your repo under `.github/workflows/`.
- Stores a deploy token as a repo secret (`AZURE_STATIC_WEB_APPS_API_TOKEN`).
- Triggers the first build & deploy.

Within ~3 minutes you'll have a live URL like
`https://brave-forest-01234.1.azurestaticapps.net`.

> ⚠️ **If you use this path**, delete the workflow Azure commits and keep the
> included `.github/workflows/azure-deploy.yml` instead. The auto-generated one
> uses Azure's Oryx build system, which does **not** understand Flutter. Our
> workflow installs Flutter, builds the web release, and uploads the result
> with `skip_app_build: true`.

### 5b. Manual path (use the included workflow)

Use this if you prefer full control of the CI config.

1. In the Portal → create the Static Web App with **Source: Other** (not
   GitHub). Keep **Plan: Free**, region West Europe.
2. After creation: **Overview → Manage deployment token** → copy the token.
3. In GitHub: **Settings → Secrets and variables → Actions → New repo secret**:
   - Name: `AZURE_STATIC_WEB_APPS_API_TOKEN`
   - Value: *(the token)*
4. Push to `main`. The workflow at `.github/workflows/azure-deploy.yml` runs
   automatically and deploys.

---

## 6. Connect `poseidonapps.net` as the custom domain

First deploys live on `*.azurestaticapps.net`. Attaching your real domain
takes ~10 minutes.

You'll add two hostnames: `www.poseidonapps.net` (CNAME) and the apex
`poseidonapps.net` (A or ALIAS + TXT verification).

### 6.1. Add `www.poseidonapps.net` (easier, do this first)

In Azure → your SWA → **Custom domains** → **+ Add custom domain on other DNS**:

1. Enter `www.poseidonapps.net`.
2. Validation method: **CNAME delegation**.
3. Azure shows a target host like `brave-forest-01234.1.azurestaticapps.net`.
4. In your DNS provider's zone editor, add:

   | Type  | Host | Value                                         | TTL  |
   |-------|------|-----------------------------------------------|------|
   | CNAME | www  | brave-forest-01234.1.azurestaticapps.net      | 3600 |

5. Back in Azure → **Validate** → wait for green check → **Add**.

### 6.2. Add the apex `poseidonapps.net`

Apex (root) domains can't use CNAMEs (RFC), so the flow is slightly different:

1. In Azure, same screen, add `poseidonapps.net`.
2. Validation method: **TXT**. Azure gives you a TXT value
   (e.g. `_dnsauth.poseidonapps.net` with value `abc123...`).
3. In your DNS provider, add:
   - A **TXT** record with the value Azure gave you.
   - **Either** an **ALIAS / ANAME** record at `@` pointing to the same
     `azurestaticapps.net` hostname (Cloudflare, DNSimple, Route53, Azure DNS
     all support ALIAS), **or** an **A record** at `@` pointing to the IPs
     Azure shows in the UI.
4. Wait 2–5 minutes for DNS propagation → **Validate** → **Add**.

**If your registrar doesn't support ALIAS/ANAME** (e.g. GoDaddy's basic plan,
Namecheap's default DNS), the common fix is to:
- Move DNS to **Cloudflare** (free, takes 10 minutes). Cloudflare supports
  CNAME flattening at the apex, which behaves like ALIAS. Point the nameservers
  at Cloudflare, then add a CNAME at `@` targeting the SWA hostname.

### 6.3. Pick a canonical host (apex vs www)

Azure treats both as equal. Pick one as canonical (usually the apex, shorter):
- If DNS is on Cloudflare, add a **Page Rule** (free, 3 included):
  - URL: `www.poseidonapps.net/*` → **Forwarding URL (301)** →
    `https://poseidonapps.net/$1`.
- Or reverse it if you prefer `www`.

---

## 7. HTTPS

Nothing to configure. Azure SWA auto-provisions and auto-renews a DigiCert
certificate for each validated custom domain. The cert appears 1–10 minutes
after validation — you'll see **Ready** in the Custom domains panel.

---

## 8. SPA routing (already configured)

Flutter Web uses client-side routing. If someone deep-links to
`https://poseidonapps.net/some/path`, the server must still return `index.html`
so the Flutter app can render that route.

The included `web/staticwebapp.config.json` handles this:

```json
{
  "navigationFallback": { "rewrite": "/index.html" },
  ...
}
```

Flutter's `flutter build web` copies everything in `web/` into `build/web/`, so
the config lands at the root of the deployed output automatically.

It also sets long cache headers on versioned assets (`/assets/*`, `/canvaskit/*`)
and `no-cache` on the HTML shell — so updates ship instantly while repeat
visitors benefit from CDN caching.

---

## 9. One-off deploy without GitHub (Azure CLI + SWA CLI)

Useful for a quick hotfix when you don't want to go through CI:

```bash
# one-time
npm install -g @azure/static-web-apps-cli
az login

# each deploy
flutter build web --release
swa deploy ./build/web \
  --deployment-token <AZURE_STATIC_WEB_APPS_API_TOKEN> \
  --env production
```

The deployment token comes from Portal → your SWA → **Manage deployment token**.

---

## 10. What you'll actually pay

- **Static Web App**: **$0**, assuming <100 GB egress/month.
  - A ~2.5 MB Flutter bundle × 40,000 page views ≈ 100 GB. Realistic for a
    marketing site → free forever.
- **Custom domain + SSL**: free.
- **DNS**:
  - Keep DNS at your registrar → free.
  - Move DNS to Cloudflare → free (recommended if your registrar lacks ALIAS).
  - Move DNS to Azure DNS → ~$0.50 / zone / month (not necessary).
- **If you later upgrade to Standard**: $9/month flat + $0.20/GB after the
  first 100 GB.

**Realistic monthly bill for this site: $0.**

---

## 11. Living with Microsoft 365 email on the same domain

Your website (Azure SWA) and your email (Microsoft 365) share the same DNS
zone but use completely different record types, so they don't conflict.

Your zone will look something like this when everything is live:

```
; --- Website (Azure SWA) ---
@        A / ALIAS   <azure-target>           ; apex → SWA
www      CNAME       <swa>.azurestaticapps.net.

; --- Email (Microsoft 365) ---
@        MX 0        poseidonapps-net.mail.protection.outlook.com.
@        TXT         v=spf1 include:spf.protection.outlook.com -all
autodiscover    CNAME  autodiscover.outlook.com.
selector1._domainkey  CNAME  selector1-poseidonapps-net._domainkey.<tenant>.onmicrosoft.com.
selector2._domainkey  CNAME  selector2-poseidonapps-net._domainkey.<tenant>.onmicrosoft.com.
_dmarc   TXT         v=DMARC1; p=quarantine; rua=mailto:hello@poseidonapps.net
```

Order of operations that avoids downtime:

1. Set up Microsoft 365 and complete domain verification **first** (only needs
   a TXT record, doesn't touch MX or A records).
2. Add the website A/CNAME records alongside.
3. Switch the MX and DKIM records last, once M365 is fully configured.

---

## 12. Monitoring & day-2 operations

- **Live deploy logs**: Portal → SWA → **Monitoring → Log stream**.
- **Application Insights** (optional, free for 5 GB/month):
  - Portal → SWA → **Application Insights** → **Enable**. You get client-side
    errors, page-load timings, and user funnels.
- **Preview environments**: every PR against `main` automatically gets a
  unique preview URL. Great for client sign-off.
- **Instant rollback**: Portal → SWA → **Deployment history** → pick a prior
  run → **Promote to production**.

---

## 13. Troubleshooting

**"Blank white page in production"** — check the browser console. Usually the
`canvaskit/` folder didn't upload. Verify it exists in `build/web/canvaskit/`
before the deploy step, and that `output_location` in the workflow is correct.

**"404 on page reload or deep link"** — `staticwebapp.config.json` isn't being
picked up. It **must** sit at the root of the deployed folder (`build/web/`),
not in a subfolder. Flutter's build handles this because the file lives in
`web/`.

**"DNS validated but browser shows cert error"** — Azure is still issuing the
cert. Wait 10–15 minutes after validation turned green.

**"Oryx build fails: Could not detect any platform"** — Azure tried to build
with its default (language auto-detect) system, which doesn't know Flutter.
Use our workflow (which uses `skip_app_build: true`) or delete Azure's
auto-generated workflow.

**"Deploy succeeds but site is still the old version"** — browser cache. Our
config sends `Cache-Control: no-cache` on HTML, so hard-refresh once (Cmd-Shift-R)
and subsequent loads are fresh.

**"Custom domain stuck on 'Validating'"** — propagate your DNS first. Test with
`dig www.poseidonapps.net CNAME +short` from your terminal before hitting
Validate.

**"GitHub Action fails: secret not found"** — the `AZURE_STATIC_WEB_APPS_API_TOKEN`
repo secret either wasn't added, or was added at the org level instead of repo
level. Add it at **repo Settings → Secrets and variables → Actions**.

---

## 14. Quick reference

| Task                         | Where                                                    |
|------------------------------|----------------------------------------------------------|
| Trigger deploy               | `git push origin main`                                   |
| View build logs              | GitHub → repo → **Actions**                              |
| View live deploy logs        | Portal → SWA → **Monitoring → Log stream**               |
| Add/remove custom domain     | Portal → SWA → **Custom domains**                        |
| Rotate deploy token          | Portal → SWA → **Manage deployment token**               |
| Roll back                    | Portal → SWA → **Deployment history** → Promote          |
| Preview a PR                 | GitHub → PR comment, the bot posts the preview URL       |
| Enable error tracking        | Portal → SWA → **Application Insights** → Enable         |

---

That's the full loop. Push to `main` → site is live at `poseidonapps.net`
under three minutes, every time.
