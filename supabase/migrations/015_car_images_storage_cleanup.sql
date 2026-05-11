-- Car images storage cleanup helpers.
-- Run after 014_car_approval_workflow.sql.

-- Legacy cars that existed before the approval workflow must remain visible.
UPDATE public.cars
SET approval_status = 'approved'
WHERE approval_status IS NULL;

-- Allow admins and super admins to delete car images from any seller folder.
DROP POLICY IF EXISTS "car-images admin delete" ON storage.objects;
CREATE POLICY "car-images admin delete"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'car-images'
  AND EXISTS (
    SELECT 1
    FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  )
);

-- Preview storage files whose car folder no longer has a row in public.cars.
-- These are the safest files to remove because rejected/deleted cars no longer
-- need their images.
CREATE OR REPLACE VIEW public.orphan_car_image_objects AS
SELECT
  o.id,
  o.name,
  (storage.foldername(o.name))[1] AS user_id,
  (storage.foldername(o.name))[2] AS car_id,
  o.created_at,
  o.updated_at
FROM storage.objects o
WHERE o.bucket_id = 'car-images'
  AND array_length(storage.foldername(o.name), 1) >= 3
  AND NOT EXISTS (
    SELECT 1
    FROM public.cars c
    WHERE c.id::text = (storage.foldername(o.name))[2]
  );

-- Admin-only RPC used by the app to fetch orphan file paths before deleting
-- them through the Storage API.
CREATE OR REPLACE FUNCTION public.fetch_orphan_car_image_objects()
RETURNS TABLE (
  name text,
  user_id text,
  car_id text,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, storage
AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  ) THEN
    RAISE EXCEPTION 'admin_only_action';
  END IF;

  RETURN QUERY
  SELECT
    o.name,
    (storage.foldername(o.name))[1],
    (storage.foldername(o.name))[2],
    o.created_at
  FROM storage.objects o
  WHERE o.bucket_id = 'car-images'
    AND array_length(storage.foldername(o.name), 1) >= 3
    AND NOT EXISTS (
      SELECT 1
      FROM public.cars c
      WHERE c.id::text = (storage.foldername(o.name))[2]
    )
  ORDER BY o.created_at DESC;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fetch_orphan_car_image_objects() TO authenticated;

-- Preview storage files for cars that are not visible in the public app.
-- This includes orphan files and cars with non-approved approval_status or a
-- non-public status. Pending cars are excluded by default in the RPC below so
-- the review screen can keep showing images unless explicitly requested.
CREATE OR REPLACE VIEW public.hidden_car_image_objects AS
SELECT
  o.id,
  o.name,
  (storage.foldername(o.name))[1] AS user_id,
  (storage.foldername(o.name))[2] AS car_id,
  c.approval_status,
  c.status,
  o.created_at,
  o.updated_at
FROM storage.objects o
LEFT JOIN public.cars c
  ON c.id::text = (storage.foldername(o.name))[2]
WHERE o.bucket_id = 'car-images'
  AND array_length(storage.foldername(o.name), 1) >= 3
  AND (
    c.id IS NULL
    OR COALESCE(c.approval_status, 'approved') <> 'approved'
    OR lower(COALESCE(c.status, '')) NOT IN ('active', 'available')
  );

-- Admin-only RPC used by the app to fetch hidden/non-public car image paths
-- before deleting them through the Storage API.
CREATE OR REPLACE FUNCTION public.fetch_hidden_car_image_objects(
  include_pending boolean DEFAULT false
)
RETURNS TABLE (
  name text,
  user_id text,
  car_id text,
  approval_status text,
  status text,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, storage
AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  ) THEN
    RAISE EXCEPTION 'admin_only_action';
  END IF;

  RETURN QUERY
  SELECT
    o.name,
    (storage.foldername(o.name))[1],
    (storage.foldername(o.name))[2],
    c.approval_status,
    c.status,
    o.created_at
  FROM storage.objects o
  LEFT JOIN public.cars c
    ON c.id::text = (storage.foldername(o.name))[2]
  WHERE o.bucket_id = 'car-images'
    AND array_length(storage.foldername(o.name), 1) >= 3
    AND (
      c.id IS NULL
      OR COALESCE(c.approval_status, 'approved') <> 'approved'
      OR lower(COALESCE(c.status, '')) NOT IN ('active', 'available')
    )
    AND (
      include_pending
      OR COALESCE(c.approval_status, '') <> 'pending'
    )
  ORDER BY o.created_at DESC;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fetch_hidden_car_image_objects(boolean) TO authenticated;

-- Preview orphan file paths before deleting with the Storage API:
-- SELECT * FROM public.fetch_orphan_car_image_objects();
--
-- Preview hidden/non-public car image paths:
-- SELECT * FROM public.fetch_hidden_car_image_objects(false);
-- SELECT * FROM public.fetch_hidden_car_image_objects(true); -- includes pending
--
-- Do not delete directly from storage.objects with SQL. Supabase Storage files
-- must be deleted through the Storage API remove() call so the object is removed
-- from the bucket, not only from the metadata table.
