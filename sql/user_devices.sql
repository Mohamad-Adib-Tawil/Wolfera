-- User devices table for FCM tokens
create table if not exists public.user_devices (
  token text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  platform text not null check (platform in ('android','ios','other')),
  updated_at timestamptz not null default now()
);

alter table public.user_devices enable row level security;

-- Allow users to insert their own device token
drop policy if exists user_devices_insert_self on public.user_devices;
create policy user_devices_insert_self
on public.user_devices
for insert
with check (auth.uid() = user_id);

-- Allow users to update their own device token row (for upsert on token)
drop policy if exists user_devices_update_self on public.user_devices;
create policy user_devices_update_self
on public.user_devices
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Allow users to view their own device tokens (optional)
drop policy if exists user_devices_select_self on public.user_devices;
create policy user_devices_select_self
on public.user_devices
for select
using (auth.uid() = user_id);

-- Optional: allow users to delete their own device tokens
drop policy if exists user_devices_delete_self on public.user_devices;
create policy user_devices_delete_self
on public.user_devices
for delete
using (auth.uid() = user_id);
