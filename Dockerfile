# Thin Chatwoot branding layer: Magna Rooms favicons + login styling.
# Base is the same image you already run. Bump this tag on each Chatwoot upgrade.
FROM chatwoot/chatwoot:v4.17.1-ce

# Favicons
COPY favicons/favicon.ico favicons/favicon-16x16.png favicons/favicon-32x32.png favicons/favicon-48x48.png favicons/favicon-96x96.png /app/public/
COPY favicons/android-icon-192x192.png favicons/apple-icon-180x180.png /app/public/

# Login styling: inject a stylesheet (scoped to auth pages only) via the Rails layout
COPY app/views/layouts/vueapp.html.erb /app/app/views/layouts/vueapp.html.erb
COPY login-brand.css /app/public/login-brand.css
