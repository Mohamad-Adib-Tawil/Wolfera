-- ================================================
-- Wolfera Storage Buckets & Policies Setup
-- ================================================
-- Run this SQL in Supabase Dashboard → SQL Editor
-- ================================================

-- 1. Create Storage Buckets
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


-- 2. Storage Policies for user-avatars
-- ================================================

-- Public read access for avatars
CREATE POLICY "user-avatars public read"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'user-avatars');

-- Users can upload to their own folder
CREATE POLICY "user-avatars user upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'user-avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can update their own files
CREATE POLICY "user-avatars user update"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'user-avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can delete their own files
CREATE POLICY "user-avatars user delete"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'user-avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);


-- 3. Storage Policies for car-images
-- ================================================

-- Public read access for car images
CREATE POLICY "car-images public read"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'car-images');

-- Users can upload to their own folder
CREATE POLICY "car-images user upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'car-images'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can update their own files
CREATE POLICY "car-images user update"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'car-images'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can delete their own files
CREATE POLICY "car-images user delete"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'car-images'
  AND (storage.foldername(name))[1] = auth.uid()::text
);


-- 4. Storage Policies for chat-attachments
-- ================================================

-- Owner can read their own attachments
CREATE POLICY "chat-attachments owner read"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'chat-attachments'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can upload to their own folder
CREATE POLICY "chat-attachments user upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'chat-attachments'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can update their own files
CREATE POLICY "chat-attachments user update"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'chat-attachments'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can delete their own files
CREATE POLICY "chat-attachments user delete"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'chat-attachments'
  AND (storage.foldername(name))[1] = auth.uid()::text
);


-- ================================================
-- Verification Queries (Optional)
-- ================================================

-- Check if buckets were created
-- SELECT * FROM storage.buckets;

-- Check storage policies
-- SELECT * FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects';
