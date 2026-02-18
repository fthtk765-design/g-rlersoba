-- Gurlersoba.com Supabase şema + RLS
-- Tarih: 2026-02-13
-- Not: Bu dosyayı Supabase SQL Editor'da çalıştırın.

-- Gerekli extension
create extension if not exists pgcrypto;

-- PROFILES (role yönetimi)
create table if not exists public.profiles (
  uid uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'viewer',
  created_at timestamptz not null default now()
);

-- Basit admin kontrol fonksiyonu
create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.profiles p
    where p.uid = auth.uid() and p.role = 'admin'
  );
$$;

-- CATEGORIES
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  sort_order int not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

-- PRODUCTS
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories(id) on delete restrict,
  name text not null,
  slug text not null unique,
  short_desc text,
  long_desc text,
  fuel_type text,
  power_kw numeric,
  area_m2_min int,
  area_m2_max int,
  dimensions_json jsonb,
  weight_kg numeric,
  flue_diameter_mm int,
  material text,
  glass_type text,
  efficiency_pct numeric,
  warranty_years int,
  is_featured boolean not null default false,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_products_updated_at on public.products;
create trigger trg_products_updated_at
before update on public.products
for each row execute function public.set_updated_at();

-- PRODUCT MEDIA
create table if not exists public.product_media (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  kind text not null check (kind in ('image', 'pdf')),
  url text not null,
  alt_text text,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists idx_product_media_product_id on public.product_media(product_id);

-- SETTINGS (public okuyabilir; admin günceller)
create table if not exists public.settings (
  key text primary key,
  value text,
  updated_at timestamptz not null default now()
);

drop trigger if exists trg_settings_updated_at on public.settings;
create trigger trg_settings_updated_at
before update on public.settings
for each row execute function public.set_updated_at();

-- Default WhatsApp telefonu (değiştirilebilir)
insert into public.settings(key, value)
values ('whatsapp_phone', '90XXXXXXXXXX')
on conflict (key) do nothing;

-- LEADS
create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  email text,
  city text,
  message text,
  product_id uuid references public.products(id) on delete set null,
  page_url text,
  status text not null default 'new' check (status in ('new', 'contacted', 'closed')),
  admin_note text,
  created_at timestamptz not null default now()
);

create index if not exists idx_leads_created_at on public.leads(created_at desc);

-- =========================
-- RLS
-- =========================
alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.product_media enable row level security;
alter table public.leads enable row level security;
alter table public.settings enable row level security;

-- PROFILES: kullanıcı kendi profilini okuyabilir; admin her şeyi görebilir
create policy if not exists "profiles_select_self_or_admin"
on public.profiles
for select
to authenticated
using (uid = auth.uid() or public.is_admin());

create policy if not exists "profiles_upsert_admin_only"
on public.profiles
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- CATEGORIES
create policy if not exists "categories_public_read_active"
on public.categories
for select
to anon, authenticated
using (is_active = true);

create policy if not exists "categories_admin_all"
on public.categories
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- PRODUCTS
create policy if not exists "products_public_read_published"
on public.products
for select
to anon, authenticated
using (is_published = true);

create policy if not exists "products_admin_all"
on public.products
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- PRODUCT MEDIA: sadece yayınlı ürünlerin medyası public görünür
create policy if not exists "product_media_public_read_published_products"
on public.product_media
for select
to anon, authenticated
using (
  exists (
    select 1
    from public.products p
    where p.id = product_media.product_id
      and p.is_published = true
  )
);

create policy if not exists "product_media_admin_all"
on public.product_media
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- SETTINGS: public select, admin write
create policy if not exists "settings_public_read"
on public.settings
for select
to anon, authenticated
using (true);

create policy if not exists "settings_admin_write"
on public.settings
for insert, update, delete
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- LEADS: public insert (form), admin read/update
create policy if not exists "leads_public_insert"
on public.leads
for insert
to anon, authenticated
with check (true);

create policy if not exists "leads_admin_select"
on public.leads
for select
to authenticated
using (public.is_admin());

create policy if not exists "leads_admin_update"
on public.leads
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- Not: Storage bucket policy'leri storage.objects tablosundan ayrıca ayarlanmalı.
-- Öneri:
-- - product-images ve product-docs bucket'larını public yapın (read).
-- - upload/delete işlemlerini sadece admin'e izin veren policy ekleyin.
