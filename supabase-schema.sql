-- 75 Hard Tracker: Supabase database setup
-- Run this once in Supabase Dashboard -> SQL Editor.

create table if not exists public.challenge_states (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.challenge_states enable row level security;

drop policy if exists "Users can read their own challenge state" on public.challenge_states;
create policy "Users can read their own challenge state"
on public.challenge_states
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own challenge state" on public.challenge_states;
create policy "Users can insert their own challenge state"
on public.challenge_states
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own challenge state" on public.challenge_states;
create policy "Users can update their own challenge state"
on public.challenge_states
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create index if not exists challenge_states_updated_at_idx
on public.challenge_states(updated_at);
