-- Add preferred_language to users to localize notifications per user
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS preferred_language text;

-- Optional: constrain to supported set
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.constraint_column_usage 
    WHERE table_schema = 'public' 
      AND table_name = 'users' 
      AND constraint_name = 'users_preferred_language_check') THEN
    ALTER TABLE public.users
      ADD CONSTRAINT users_preferred_language_check
      CHECK (preferred_language IS NULL OR preferred_language IN ('en','ar'));
  END IF;
END $$;

-- Optionally default existing NULLs to 'en' (comment out if you want to preserve nulls)
UPDATE public.users SET preferred_language = 'en' WHERE preferred_language IS NULL;
