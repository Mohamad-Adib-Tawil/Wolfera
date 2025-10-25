-- ================================================
-- Wolfera Storage Buckets & Policies Setup
-- ================================================
-- Run this SQL in Supabase Dashboard → SQL Editor
-- ================================================

-- STEP 1: Drop existing policies to avoid conflicts
-- ================================================
DROP POLICY IF EXISTS "user-avatars public read" ON storage.objects;
DROP POLICY IF EXISTS "user-avatars authenticated upload" ON storage.objects;
DROP POLICY IF EXISTS "user-avatars owner update" ON storage.objects;
DROP POLICY IF EXISTS "user-avatars owner delete" ON storage.objects;

DROP POLICY IF EXISTS "car-images public read" ON storage.objects;
DROP POLICY IF EXISTS "car-images authenticated upload" ON storage.objects;
DROP POLICY IF EXISTS "car-images owner update" ON storage.objects;
DROP POLICY IF EXISTS "car-images owner delete" ON storage.objects;

DROP POLICY IF EXISTS "chat-attachments public read" ON storage.objects;
DROP POLICY IF EXISTS "chat-attachments authenticated upload" ON storage.objects;
DROP POLICY IF EXISTS "chat-attachments participants access" ON storage.objects;

-- STEP 2: Create Storage Buckets
-- ================================================

-- Create user-avatars bucket (public)
INSERT INTO storage.buckets (id, name, public)
VALUES ('user-avatars', 'user-avatars', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Create car-images bucket (public)
INSERT INTO storage.buckets (id, name, public)
VALUES ('car-images', 'car-images', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Create chat-attachments bucket (private)
INSERT INTO storage.buckets (id, name, public)
VALUES ('chat-attachments', 'chat-attachments', false)
ON CONFLICT (id) DO UPDATE SET public = false;


-- STEP 3: Storage Policies for user-avatars
-- ================================================

-- Public read access for avatars
CREATE POLICY "user-avatars public read"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'user-avatars');

-- Authenticated users can upload to their own folder
CREATE POLICY "user-avatars authenticated upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'user-avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can update their own files
CREATE POLICY "user-avatars owner update"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'user-avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can delete their own files
CREATE POLICY "user-avatars owner delete"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'user-avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);


-- STEP 4: Storage Policies for car-images
-- ================================================

-- Public read access for car images
CREATE POLICY "car-images public read"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'car-images');

-- Authenticated users can upload to their own folder
CREATE POLICY "car-images authenticated upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'car-images'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can update their own files
CREATE POLICY "car-images owner update"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'car-images'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can delete their own files
CREATE POLICY "car-images owner delete"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'car-images'
  AND (storage.foldername(name))[1] = auth.uid()::text
);


-- STEP 5: Storage Policies for chat-attachments
-- ================================================

-- Public read access for chat attachments
CREATE POLICY "chat-attachments public read"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'chat-attachments');

-- Authenticated users can upload to their own folder
CREATE POLICY "chat-attachments authenticated upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'chat-attachments'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Chat participants can access attachments (simplified for now)
CREATE POLICY "chat-attachments participants access"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'chat-attachments');


-- ================================================
-- Verification Queries (Optional)
-- ================================================

-- Check if buckets were created
-- SELECT * FROM storage.buckets;

-- Check storage policies
-- SELECT * FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects';
