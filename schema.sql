-- ============================================================
--  Macko's Suit and Tiebrary — database schema
--  Run this once in Supabase: Dashboard > SQL Editor > New query
--  > paste all of this > Run.
-- ============================================================

-- Books in the collection
create table if not exists public.books (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  author      text,
  genre       text,
  year        int,
  notes       text,
  created_at  timestamptz not null default now()
);

-- Checkout history. A book is "currently out" when it has a
-- row here with returned_at IS NULL.
create table if not exists public.checkouts (
  id              uuid primary key default gen_random_uuid(),
  book_id         uuid not null references public.books(id) on delete cascade,
  borrower        text not null,
  checked_out_at  timestamptz not null default now(),
  due_date        date,
  returned_at     timestamptz
);

create index if not exists checkouts_active_idx
  on public.checkouts (book_id) where returned_at is null;

-- ------------------------------------------------------------
--  Row Level Security
--  This is a friends-and-family lending library: everyone who
--  has the link can read the list, borrow, return, and (the
--  owner) add books. So we allow the public "anon" role to
--  read & write. The anon key is meant to be shared.
--  If you later want stricter rules, tighten these policies.
-- ------------------------------------------------------------
alter table public.books     enable row level security;
alter table public.checkouts enable row level security;

drop policy if exists "books_all"     on public.books;
drop policy if exists "checkouts_all" on public.checkouts;

create policy "books_all" on public.books
  for all to anon using (true) with check (true);

create policy "checkouts_all" on public.checkouts
  for all to anon using (true) with check (true);
