# Tempo — deploy in ~5 minutes

## 1. Deploy to your GitHub Pages site

In your `aneesh-kuda.github.io` repo:

```bash
mkdir tempo
# copy all files from this folder into tempo/
git add tempo && git commit -m "Add Tempo time journal" && git push
```

Live at: **https://aneesh-kuda.github.io/tempo/**

(Or make it a separate repo with Pages enabled if you'd rather keep it off your portfolio domain.)

## 2. Install on your iPhone

1. Open the URL in **Safari** (must be Safari, not Chrome)
2. Tap Share → **Add to Home Screen**
3. Launch from the home screen icon — it runs fullscreen like a native app

## 3. Hourly nudge

Option A — Shortcuts automation (best):
Shortcuts app → Automation → **+** → Time of Day → set a time, Repeat **Hourly** isn't offered directly, so create one automation per waking hour (e.g. 8am–10pm) OR use a single automation with the "Repeat" trick: create it for 8:00 AM, then duplicate and adjust. Each automation: **Open URL** → your Tempo URL. Turn off "Ask Before Running."

Option B — a recurring Reminder ("Log Tempo") every hour via the Reminders app.

## Data

- Entries live in your phone's localStorage — private, on-device, survives app/browser restarts
- **Do not clear Safari website data** for this site, or entries are lost
- Export JSON from Settings weekly as a backup
- The schema is versioned and account-ready — when we add Supabase for profiles + coach access, your exported history imports straight in

## What's next (when you're ready)

- Weekly insights view (glad %, category mix, state-word trends)
- Supabase backend → login, multi-device sync, coach read-only role
- Real push notifications (works on iOS home-screen PWAs since 16.4)
- Then: wrap for the App Store (Capacitor) or rebuild native in SwiftUI
