-- ================================================
-- FIX ALL POLICIES - Run this in Supabase SQL Editor
-- ================================================
-- This script will fix all permission issues for users table and storage

-- 1. Drop existing policies if they exist (to recreate them correctly)
-- ================================================
DROP POLICY IF EXISTS "Users can view all profiles" ON public.users;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;

-- 2. Recreate users table policies
-- ================================================
-- Allow everyone to view all profiles
CREATE POLICY "Users can view all profiles" 
ON public.users FOR SELECT 
USING (true);

-- Allow authenticated users to insert their own profile
CREATE POLICY "Users can insert own profile" 
ON public.users FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = id);

-- Allow authenticated users to update their own profile
CREATE POLICY "Users can update own profile" 
ON public.users FOR UPDATE 
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- 3. Ensure RLS is enabled on users table
-- ================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- 4. Verify policies were created
-- ================================================
SELECT 
    policyname,
    cmd,
    roles
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'users'
ORDER BY policyname;
