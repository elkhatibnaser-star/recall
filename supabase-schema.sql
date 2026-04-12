create table if not exists public.recall_sync_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.recall_sync_state enable row level security;

drop policy if exists "Users can read their own recall sync state" on public.recall_sync_state;
create policy "Users can read their own recall sync state"
on public.recall_sync_state
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own recall sync state" on public.recall_sync_state;
create policy "Users can insert their own recall sync state"
on public.recall_sync_state
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own recall sync state" on public.recall_sync_state;
create policy "Users can update their own recall sync state"
on public.recall_sync_state
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
