# Chatwoot White-Label Image (Magna)

One thin Chatwoot image that serves **many clients**. Per-client identity and
branding are configured at runtime — no per-client forks or rebuilds.

Base image: `chatwoot/chatwoot:v4.17.1-ce` + overlaid favicons and a scoped
login stylesheet. Bump `FROM` in `Dockerfile` on Chatwoot upgrades.

## Image

Built and pushed by GitHub Actions on every push to `main`:

- `ghcr.io/mrdgalan/chatwoot-brand:latest`
- `ghcr.io/mrdgalan/chatwoot-brand:<commit-sha>`

## Per-client configuration (all runtime — set once per install)

Set as Chatwoot **InstallationConfig** (Super Admin → Installation Configs,
or `rails runner`):

| Key | Purpose | Example |
|-----|---------|---------|
| `INSTALLATION_NAME` | Name on login + browser tab | `Acme Rooms` |
| `LOGO` | Login logo (URL) | `https://acme.com/logo.png` |
| `LOGO_DARK` | Login logo, dark mode (URL) | `https://acme.com/logo_dark.png` |
| `LOGO_THUMBNAIL` | Small icon / 512px favicon (URL) | `https://acme.com/iso.png` |
| `BRAND_COLOR` | Primary accent | `#0092ae` |
| `BRAND_COLOR_DARK` | Deep gradient stop | `#0b6e86` |
| `BRAND_COLOR_LIGHT` | Light gradient stop | `#18b7d1` |

Example (one-liner, run in the Chatwoot container):

```bash
bundle exec rails runner '
values = { "INSTALLATION_NAME" => "Acme Rooms", "BRAND_COLOR" => "#0092ae",
           "LOGO" => "https://acme.com/logo.png",
           "LOGO_THUMBNAIL" => "https://acme.com/iso.png" }
values.each do |k, v|
  c = InstallationConfig.find_or_initialize_by(name: k)
  c.value = v; c.locked = false; c.save!
end'
```

## Client deployment (compose)

Replace the Chatwoot web service image with this image (sidekiq/postgres/redis
unchanged). Data volumes are untouched.

```yaml
services:
  chatwoot:
    image: 'ghcr.io/mrdgalan/chatwoot-brand:v4.17.1'
    # ...rest of the standard chatwoot service config...
```

## How it works

- `app/views/layouts/vueapp.html.erb` (overridden) injects, on auth pages only,
  an inline `:root` block of CSS variables from the runtime config above, plus a
  link to `login-brand.css`.
- `login-brand.css` styles the login using `var(--brand-*)`.
- Favicon static assets are overlaid in the image.
- Name/logo are rendered by Chatwoot itself from `INSTALLATION_NAME`/`LOGO`.

To change styling, edit `login-brand.css` and rebuild the image.
