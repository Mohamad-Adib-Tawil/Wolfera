-- Admin remove car migration: add removal fields, admin flags, policies, and notifications type update
-- Run this in Supabase SQL Editor

-- 1) Cars removal metadata
ALTER TABLE public.cars
  ADD COLUMN IF NOT EXISTS removed_by uuid REFERENCES public.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS removed_at timestamptz,
  ADD COLUMN IF NOT EXISTS removal_reason text;

-- Helpful index (if not already exists)
CREATE INDEX IF NOT EXISTS idx_cars_status ON public.cars(status);

-- 2) Ensure admin flags on users table
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS is_admin boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_super_admin boolean DEFAULT false;

-- 3) RLS policies to allow admins to update/delete any car
DROP POLICY IF EXISTS "Admins can update any cars" ON public.cars;
CREATE POLICY "Admins can update any cars" ON public.cars
FOR UPDATE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  )
)
WITH CHECK (
  -- Admins can write any row; owners can still write their rows
  EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  ) OR auth.uid() = user_id
);

DROP POLICY IF EXISTS "Admins can delete any cars" ON public.cars;
CREATE POLICY "Admins can delete any cars" ON public.cars
FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  )
);

-- 4) Unify/extend notifications.type to support app types
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'notifications_type_check'
  ) THEN
    ALTER TABLE public.notifications DROP CONSTRAINT notifications_type_check;
  END IF;
END $$;

-- Widen type and re-add check with full set
ALTER TABLE public.notifications
  ALTER COLUMN type TYPE text;

ALTER TABLE public.notifications
  ADD CONSTRAINT notifications_type_check
  CHECK (type IN (
    'general','new_message','new_offer','car_like','car_comment','car_removed',
    'price_drop','message','favorite','review','offer','new_car'
  ));
