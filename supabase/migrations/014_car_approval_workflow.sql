-- Car approval workflow: pending listings, admin approval, rejection notifications
-- Run this in Supabase SQL Editor or through Supabase migrations.

ALTER TABLE public.cars
  ADD COLUMN IF NOT EXISTS approval_status text DEFAULT 'approved',
  ADD COLUMN IF NOT EXISTS approved_by uuid REFERENCES public.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS approved_at timestamptz,
  ADD COLUMN IF NOT EXISTS rejected_by uuid REFERENCES public.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS rejected_at timestamptz;

UPDATE public.cars
SET approval_status = 'approved'
WHERE approval_status IS NULL;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'cars_approval_status_check'
  ) THEN
    ALTER TABLE public.cars DROP CONSTRAINT cars_approval_status_check;
  END IF;
END $$;

ALTER TABLE public.cars
  ADD CONSTRAINT cars_approval_status_check
  CHECK (approval_status IN ('pending', 'approved'));

CREATE INDEX IF NOT EXISTS idx_cars_approval_status
  ON public.cars(approval_status);

CREATE INDEX IF NOT EXISTS idx_cars_approval_created_at
  ON public.cars(approval_status, created_at DESC);

CREATE TABLE IF NOT EXISTS public.app_settings (
  id bigserial PRIMARY KEY,
  key text UNIQUE NOT NULL,
  value jsonb,
  updated_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

INSERT INTO public.app_settings (key, value, created_at, updated_at)
VALUES ('require_car_approval', 'true'::jsonb, now(), now())
ON CONFLICT (key) DO NOTHING;

-- Keep the first rollout safe: after adding the approval feature, new cars
-- should wait for review unless the super admin disables this setting later.
UPDATE public.app_settings
SET value = 'true'::jsonb,
    updated_at = now()
WHERE key = 'require_car_approval';

CREATE OR REPLACE FUNCTION public.is_current_user_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  );
$$;

CREATE OR REPLACE FUNCTION public.require_car_approval_enabled()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    (
      SELECT CASE
        WHEN value IS NULL THEN false
        WHEN jsonb_typeof(value) = 'boolean' THEN (value #>> '{}')::boolean
        WHEN jsonb_typeof(value) = 'string' THEN lower(value #>> '{}') = 'true'
        ELSE false
      END
      FROM public.app_settings
      WHERE key = 'require_car_approval'
      LIMIT 1
    ),
    false
  );
$$;

CREATE OR REPLACE FUNCTION public.enforce_car_approval_workflow()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF public.require_car_approval_enabled() THEN
      NEW.approval_status := 'pending';
      NEW.approved_by := NULL;
      NEW.approved_at := NULL;
    ELSE
      NEW.approval_status := 'approved';
    END IF;
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' AND NOT public.is_current_user_admin() THEN
    NEW.approval_status := OLD.approval_status;
    NEW.approved_by := OLD.approved_by;
    NEW.approved_at := OLD.approved_at;
    NEW.rejected_by := OLD.rejected_by;
    NEW.rejected_at := OLD.rejected_at;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tr_enforce_car_approval_workflow ON public.cars;
CREATE TRIGGER tr_enforce_car_approval_workflow
BEFORE INSERT OR UPDATE ON public.cars
FOR EACH ROW
EXECUTE FUNCTION public.enforce_car_approval_workflow();

ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read app settings" ON public.app_settings;
CREATE POLICY "Anyone can read app settings"
ON public.app_settings
FOR SELECT
USING (true);

DROP POLICY IF EXISTS "Only super admin can update app settings" ON public.app_settings;
CREATE POLICY "Only super admin can update app settings"
ON public.app_settings
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND u.is_super_admin = true
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND u.is_super_admin = true
  )
);

DROP POLICY IF EXISTS "Cars are viewable by everyone" ON public.cars;
DROP POLICY IF EXISTS "Approved cars are viewable by everyone" ON public.cars;
CREATE POLICY "Approved cars are viewable by everyone"
ON public.cars
FOR SELECT
USING (
  approval_status = 'approved'
  OR auth.uid() = user_id
  OR EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  )
);

DROP POLICY IF EXISTS "Admins can approve or reject cars" ON public.cars;
CREATE POLICY "Admins can approve or reject cars"
ON public.cars
FOR UPDATE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  )
);

DROP POLICY IF EXISTS "Admins can delete rejected cars" ON public.cars;
CREATE POLICY "Admins can delete rejected cars"
ON public.cars
FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users u
    WHERE u.id = auth.uid()
      AND (u.is_admin OR u.is_super_admin)
  )
);

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'notifications_type_check'
  ) THEN
    ALTER TABLE public.notifications DROP CONSTRAINT notifications_type_check;
  END IF;
END $$;

ALTER TABLE public.notifications
  ALTER COLUMN type TYPE text;

ALTER TABLE public.notifications
  ADD CONSTRAINT notifications_type_check
  CHECK (type IN (
    'general','new_message','new_offer','car_like','car_comment','car_removed',
    'car_rejected','price_change','price_drop','message','favorite','review',
    'offer','offer_new','offer_updated','new_car','car_updated',
    'car_status_changed','car_state_changed','test'
  )) NOT VALID;
