# Thin Chatwoot branding layer: swaps the baked favicons for Magna Rooms icons.
# Base is the same image you already run. Bump this tag on each Chatwoot upgrade.
FROM chatwoot/chatwoot:v4.17.1-ce

COPY favicons/favicon.ico favicons/favicon-16x16.png favicons/favicon-32x32.png favicons/favicon-48x48.png favicons/favicon-96x96.png /app/public/
COPY favicons/android-icon-192x192.png favicons/apple-icon-180x180.png /app/public/
