create table if not exists public.investigacoes_clinicas (
  id uuid primary key default gen_random_uuid(),
  psi_user_id uuid not null references auth.users(id) on delete cascade,
  paciente_id uuid,
  paciente_nome text not null default '',
  modulo text not null default 'IC-TDAH',
  status text not null default 'rascunho' check (status in ('rascunho','concluido')),
  etapa_atual integer not null default 1,
  respostas jsonb not null default '{}'::jsonb,
  sintese jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (psi_user_id, paciente_id, modulo)
);

alter table public.investigacoes_clinicas enable row level security;

drop policy if exists investigacoes_select_own on public.investigacoes_clinicas;
create policy investigacoes_select_own on public.investigacoes_clinicas
for select to authenticated using (psi_user_id = auth.uid());

drop policy if exists investigacoes_insert_own on public.investigacoes_clinicas;
create policy investigacoes_insert_own on public.investigacoes_clinicas
for insert to authenticated with check (psi_user_id = auth.uid());

drop policy if exists investigacoes_update_own on public.investigacoes_clinicas;
create policy investigacoes_update_own on public.investigacoes_clinicas
for update to authenticated using (psi_user_id = auth.uid()) with check (psi_user_id = auth.uid());

drop policy if exists investigacoes_delete_own on public.investigacoes_clinicas;
create policy investigacoes_delete_own on public.investigacoes_clinicas
for delete to authenticated using (psi_user_id = auth.uid());

notify pgrst, 'reload schema';
