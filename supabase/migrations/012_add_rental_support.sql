-- Add rental support to cars table
ALTER TABLE public.cars
  ADD COLUMN IF NOT EXISTS listing_type text DEFAULT 'sale',
  ADD COLUMN IF NOT EXISTS rental_period text,
  ADD COLUMN IF NOT EXISTS rental_price_per_day numeric,
  ADD COLUMN IF NOT EXISTS rental_price_per_week numeric,
  ADD COLUMN IF NOT EXISTS rental_price_per_month numeric,
  ADD COLUMN IF NOT EXISTS rental_price_per_3months numeric,
  ADD COLUMN IF NOT EXISTS rental_price_per_6months numeric,
  ADD COLUMN IF NOT EXISTS rental_price_per_year numeric;

-- Add check constraint for listing_type
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.constraint_column_usage 
    WHERE table_schema = 'public' 
      AND table_name = 'cars' 
      AND constraint_name = 'cars_listing_type_check') THEN
    ALTER TABLE public.cars
      ADD CONSTRAINT cars_listing_type_check
      CHECK (listing_type IN ('sale', 'rent', 'both'));
  END IF;
END $$;

-- Add check constraint for rental_period
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.constraint_column_usage 
    WHERE table_schema = 'public' 
      AND table_name = 'cars' 
      AND constraint_name = 'cars_rental_period_check') THEN
    ALTER TABLE public.cars
      ADD CONSTRAINT cars_rental_period_check
      CHECK (rental_period IS NULL OR rental_period IN ('day', 'week', 'month', '3months', '6months', 'year'));
  END IF;
END $$;

-- Create index for listing_type for better query performance
CREATE INDEX IF NOT EXISTS idx_cars_listing_type ON public.cars(listing_type);

-- Update existing cars to have listing_type = 'sale' if NULL
UPDATE public.cars SET listing_type = 'sale' WHERE listing_type IS NULL;
