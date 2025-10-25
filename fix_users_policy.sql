-- Fix: Add INSERT policy for users table
-- This is needed for upsert operations to work properly
-- Run this in Supabase SQL Editor if you get permission errors when updating profile

-- Check if policy already exists, if not create it
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'users' 
        AND policyname = 'Users can insert own profile'
    ) THEN
        CREATE POLICY "Users can insert own profile" ON public.users
            FOR INSERT WITH CHECK (auth.uid() = id);
        RAISE NOTICE 'Policy "Users can insert own profile" created successfully';
    ELSE
        RAISE NOTICE 'Policy "Users can insert own profile" already exists';
    END IF;
END $$;
