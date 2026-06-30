alter table public.perfil_psi_clinico
  add column if not exists mapa_esquemas jsonb not null default '{}'::jsonb;

comment on column public.perfil_psi_clinico.mapa_esquemas is
  'Campos editáveis do Mapa de Esquemas da psicóloga.';
