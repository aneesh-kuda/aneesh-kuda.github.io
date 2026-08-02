# Sati v3 — time & energy journal

Renamed from Tempo. New model: Anabolic/Catabolic energy per activity, categories + subcategories,
fast collapsed entry, streaks, timeline comments with gold stars, documents, analysis page,
learner/coach accounts.

## Fresh deploy (replaces Tempo)
1. Supabase → SQL Editor: run `setup.sql` (drop the old Tempo tables first — see comment at top of the file)
2. Paste your existing SUPABASE_URL + SUPABASE_ANON_KEY into the top of index.html (same values as before)
3. In your repo, replace the contents of the `tempo/` folder with these files — or better, create a `sati/` folder and retire /tempo/
4. On iPhone: remove the old home-screen icon, open the new URL in Safari, Add to Home Screen
5. Log in (Settings) with the same email — the old data is gone by design; day one starts now

## How things map
- Entry page: category → optional subcategory → optional Anabolic/Catabolic → "+ details" for description & energy notes
- % is the default allocation; adding activities auto-splits evenly until you edit a number
- Home shows: % of today logged, % anabolic today, and your chosen streaks (pick up to 5 in Settings)
- Timeline: one row per activity, green/red by energy; 💬 opens comments; ★ gold-stars a key insight
- Journal tab: daily reflections + documents, each with created/updated dates and a per-item "Share w/ coach" toggle
- Analysis: anabolic % by week/month/all-time, day-of-week, hour-of-day, category/subcategory tables
- Coach: grant by email in Settings; they log in at the same URL, see your timeline/analysis/shared items, and can comment

## iPhone beta (next phase)
When ready for TestFlight: wrap this same codebase with Capacitor, add push notifications
(hourly nudge!), submit for TestFlight beta review (~1-2 days). The Supabase backend carries over unchanged.
