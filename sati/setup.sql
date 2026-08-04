-- Sati v3 database setup
-- Fresh install: if you have the old Tempo tables, drop them first (old data is being discarded per plan):
--   drop table if exists entries, reflections, coach_grants cascade;
-- Then run everything below in Supabase SQL Editor.

create table entries (
  id text primary key,
  user_id uuid not null references auth.users(id) default auth.uid(),
  start_at timestamptz not null,
  end_at timestamptz not null,
  created_at timestamptz not null default now(),
  activities jsonb not null
);

create table reflections (
  user_id uuid not null references auth.users(id) default auth.uid(),
  day date not null,
  text text not null default '',
  shared boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, day)
);

create table documents (
  id text primary key,
  user_id uuid not null references auth.users(id) default auth.uid(),
  title text not null default '',
  body text not null default '',
  shared boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table comments (
  id text primary key,
  owner_id uuid not null references auth.users(id),   -- whose journal this comment lives on
  entry_id text,
  activity_id text not null,
  author_email text not null,
  text text not null,
  starred boolean not null default false,
  created_at timestamptz not null default now()
);

create table coach_grants (
  owner_id uuid not null references auth.users(id),
  owner_email text,
  coach_email text not null,
  created_at timestamptz not null default now(),
  primary key (owner_id, coach_email)
);

create table user_settings (
  user_id uuid primary key references auth.users(id),
  categories jsonb,
  streak_picks jsonb,
  updated_at timestamptz not null default now()
);

alter table entries enable row level security;
alter table reflections enable row level security;
alter table documents enable row level security;
alter table comments enable row level security;
alter table coach_grants enable row level security;
alter table user_settings enable row level security;

-- helper predicate: current user is a granted coach of $owner
create or replace function is_coach_of(owner uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from coach_grants g
    where g.owner_id = owner
      and lower(g.coach_email) = lower(auth.jwt() ->> 'email')
  );
$$;

-- OWNERS: full control of their own rows
create policy "own entries" on entries for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own reflections" on reflections for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own documents" on documents for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own settings" on user_settings for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own grants" on coach_grants for all
  using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

-- COACHES: read timeline + settings (category colors), read only SHARED reflections/documents
create policy "coach read entries" on entries for select using (is_coach_of(user_id));
create policy "coach read shared reflections" on reflections for select using (shared and is_coach_of(user_id));
create policy "coach read shared documents" on documents for select using (shared and is_coach_of(user_id));
create policy "coach read settings" on user_settings for select using (is_coach_of(user_id));
create policy "coach read own grants" on coach_grants for select
  using (lower(coach_email) = lower(auth.jwt() ->> 'email'));

-- COMMENTS: owner and coach can read + write on the owner's journal;
-- authors and owners can edit/delete
create policy "comments read" on comments for select
  using (auth.uid() = owner_id or is_coach_of(owner_id));
create policy "comments insert" on comments for insert
  with check (
    (auth.uid() = owner_id or is_coach_of(owner_id))
    and lower(author_email) = lower(auth.jwt() ->> 'email')
  );
create policy "comments update" on comments for update
  using (auth.uid() = owner_id or lower(author_email) = lower(auth.jwt() ->> 'email'));
create policy "comments delete" on comments for delete
  using (auth.uid() = owner_id or lower(author_email) = lower(auth.jwt() ->> 'email'));
