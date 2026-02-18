-- Supabase Storage policy örnekleri
-- Not: Bucket isimleri: product-images (public), product-docs (public)
-- Bu policy'ler Storage -> Policies ekranından da eklenebilir.

-- Okuma: bucket public ise ekstra policy gerekmeyebilir.

-- Upload: sadece admin
create policy if not exists "admin_upload_product_images"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'product-images'
  and public.is_admin()
);

create policy if not exists "admin_upload_product_docs"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'product-docs'
  and public.is_admin()
);

-- Delete: sadece admin
create policy if not exists "admin_delete_product_images"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'product-images'
  and public.is_admin()
);

create policy if not exists "admin_delete_product_docs"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'product-docs'
  and public.is_admin()
);
