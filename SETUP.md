# Macko's Suit and Tiebrary — Setup Guide

This is a shared, live book-lending app. Everyone who opens the link sees the
**same** collection and the **same** checkouts in real time. To make that work,
the app needs a small free database behind it (Supabase). Setup is a one-time,
~10-minute job. No coding required — just copy and paste.

> **Want to peek first?** Just double-click `index.html`. It opens in
> *Preview mode* with sample books so you can see the look. Preview data lives
> only on your own computer and is **not** shared. Follow the steps below to go live.

---

## Step 1 — Create a free Supabase project

1. Go to **https://supabase.com** and sign up (free tier is plenty).
2. Click **New project**. Give it a name (e.g. `tiebrary`), set a database
   password (save it somewhere), pick a region near you, and create it.
3. Wait ~2 minutes for it to finish provisioning.

## Step 2 — Create the tables

1. In your project, open **SQL Editor** (left sidebar) → **New query**.
2. Open the file `schema.sql` (next to this guide), copy **everything**, and
   paste it into the editor.
3. Click **Run**. You should see "Success". This creates the `books` and
   `checkouts` tables and the sharing rules.

## Step 3 — Get your two keys

1. Go to **Project Settings** (gear icon) → **API**.
2. Copy two values:
   - **Project URL** — looks like `https://abcd1234xyz.supabase.co`
   - **anon public** key — a long string under "Project API keys"
   (Use the `anon` / `public` key, **not** the `service_role` key.)

## Step 4 — Paste the keys into the app

1. Open `index.html` in a text editor (right-click → Open With → TextEdit, or
   any editor).
2. Near the bottom, find the `CONFIG` block:

   ```js
   const CONFIG = {
     SUPABASE_URL:  "YOUR_SUPABASE_URL_HERE",
     SUPABASE_ANON_KEY: "YOUR_SUPABASE_ANON_KEY_HERE",
     OWNER_PASSPHRASE: "macko"
   };
   ```

3. Replace the URL and anon key with yours. Change `OWNER_PASSPHRASE` to a word
   only you know — it unlocks the **Add book / Import / Remove** buttons.
4. Save the file. The yellow "Preview mode" banner will disappear when you
   reopen it — that means you're live.

## Step 5 — Put it online so friends can use it

The app is a single file, so hosting it is easy and free. Pick one:

- **Netlify Drop (easiest):** go to **https://app.netlify.com/drop** and drag
  `index.html` onto the page. You instantly get a shareable link. (Tip: rename
  the file's folder so the live link looks tidy.)
- **GitHub Pages / Vercel:** if you already use these, drop the file in and
  share the URL.

Send that link to your friends. They can browse, search, check books out, and
check them back in. Only someone with your owner passphrase can add or remove
books.

---

## Adding books

- **One at a time:** click **Owner**, enter your passphrase, then **+ Add book**.
- **In bulk:** click **Import CSV**. Use `books_template.csv` as a starting
  point. Columns recognized: `title, author, genre, year, notes` — only
  `title` is required. You can also paste CSV text directly into the box.

## How checkouts work

- Anyone with the link can **Check out** a book (they enter their name and an
  optional due date) and **Check back in** when they return it.
- Each card shows whether a book is on the shelf or who currently has it.

## A note on security

This is built for a friends-and-family lending library, so the link and the
`anon` key let anyone who has them read and edit the list. That's intentional —
it's what makes "just send the link" work. The owner passphrase is a soft gate
to prevent accidental adds/deletes, not bank-grade security. Don't store
anything sensitive in here, and only share the link with people you'd lend a
book to anyway. If you ever want stricter rules, the policies in `schema.sql`
can be tightened later.

## Troubleshooting

- **"Could not load library"** — double-check the URL and anon key for typos,
  and confirm you ran `schema.sql` successfully.
- **Add/Import buttons missing** — click **Owner** and enter your passphrase.
- **Friends don't see my books** — make sure you're past Preview mode (no
  yellow banner) and that everyone is opening the *hosted* link from Step 5,
  not their own copy of the file.
