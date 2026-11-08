-- ============================================================================
-- Despeses v5.0 — migració de Supabase
-- Executa-ho UNA vegada a: Supabase → SQL Editor → New query → Run.
-- És segur tornar-ho a executar. NO esborra ni modifica cap dada.
-- ============================================================================

-- 1) Devolucions: nova columna (les files existents queden com a "no devolució")
alter table public.expenses
  add column if not exists refund boolean not null default false;

-- 2) Seguretat: cada usuari només pot llegir i escriure les SEVES files.
--    La clau "anon" de l'app és pública per disseny; la protecció real és aquesta.
--    Es treuen les polítiques que hi hagi en aquestes 5 taules i es creen les estrictes.
do $$
declare
  t text;
  p record;
begin
  foreach t in array array['expenses','categories','merchants','bank_formats','user_settings'] loop
    execute format('alter table public.%I enable row level security', t);
    for p in select policyname from pg_policies where schemaname = 'public' and tablename = t loop
      execute format('drop policy %I on public.%I', p.policyname, t);
    end loop;
    execute format($f$create policy "own rows: select" on public.%I for select to authenticated using (auth.uid() = user_id)$f$, t);
    execute format($f$create policy "own rows: insert" on public.%I for insert to authenticated with check (auth.uid() = user_id)$f$, t);
    execute format($f$create policy "own rows: update" on public.%I for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id)$f$, t);
    execute format($f$create policy "own rows: delete" on public.%I for delete to authenticated using (auth.uid() = user_id)$f$, t);
  end loop;
end $$;

-- 3) Comprovació: hauria de mostrar 5 taules amb rls = true i 4 polítiques cadascuna
select c.relname as taula,
       c.relrowsecurity as rls,
       (select count(*) from pg_policies p where p.schemaname = 'public' and p.tablename = c.relname) as politiques
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relname in ('expenses','categories','merchants','bank_formats','user_settings')
order by 1;
