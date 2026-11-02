-- Execute este arquivo no SQL Editor do seu projeto Supabase.
create extension if not exists pgcrypto;

create table if not exists public.companies (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 2 and 120),
  created_at timestamptz not null default now()
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  type text not null check (type in ('income','expense','receita','despesa')),
  description text not null check (char_length(description) between 1 and 240),
  category text not null default 'Outros',
  amount numeric(14,2) not null check (amount > 0),
  due_date date not null default current_date,
  status text not null default 'pending' check (status in ('pending','paid','received','overdue')),
  account text not null default 'Conta principal',
  created_at timestamptz not null default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  name text not null,
  type text not null check (type in ('income','expense')),
  created_at timestamptz not null default now(),
  unique(company_id,name,type)
);

create table if not exists public.accounts (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  name text not null,
  account_type text not null default 'checking',
  opening_balance numeric(14,2) not null default 0,
  created_at timestamptz not null default now(),
  unique(company_id,name)
);

create table if not exists public.contacts (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  name text not null,
  contact_type text not null default 'customer' check (contact_type in ('customer','supplier','both')),
  email text,
  phone text,
  created_at timestamptz not null default now()
);

create index if not exists transactions_company_due_idx on public.transactions(company_id,due_date desc);
create index if not exists categories_company_idx on public.categories(company_id);
create index if not exists accounts_company_idx on public.accounts(company_id);
create index if not exists contacts_company_idx on public.contacts(company_id);

alter table public.companies enable row level security;
alter table public.transactions enable row level security;
alter table public.categories enable row level security;
alter table public.accounts enable row level security;
alter table public.contacts enable row level security;

drop policy if exists "Owners manage their companies" on public.companies;
create policy "Owners manage their companies" on public.companies for all to authenticated
using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "Company owners manage transactions" on public.transactions;
create policy "Company owners manage transactions" on public.transactions for all to authenticated
using (exists(select 1 from public.companies c where c.id=company_id and c.owner_id=auth.uid()))
with check (exists(select 1 from public.companies c where c.id=company_id and c.owner_id=auth.uid()));

drop policy if exists "Company owners manage categories" on public.categories;
create policy "Company owners manage categories" on public.categories for all to authenticated
using (exists(select 1 from public.companies c where c.id=company_id and c.owner_id=auth.uid()))
with check (exists(select 1 from public.companies c where c.id=company_id and c.owner_id=auth.uid()));

drop policy if exists "Company owners manage accounts" on public.accounts;
create policy "Company owners manage accounts" on public.accounts for all to authenticated
using (exists(select 1 from public.companies c where c.id=company_id and c.owner_id=auth.uid()))
with check (exists(select 1 from public.companies c where c.id=company_id and c.owner_id=auth.uid()));

drop policy if exists "Company owners manage contacts" on public.contacts;
create policy "Company owners manage contacts" on public.contacts for all to authenticated
using (exists(select 1 from public.companies c where c.id=company_id and c.owner_id=auth.uid()))
with check (exists(select 1 from public.companies c where c.id=company_id and c.owner_id=auth.uid()));

