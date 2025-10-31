-- Create favorites table
CREATE TABLE IF NOT EXISTS public.favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    car_id UUID NOT NULL REFERENCES public.cars(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT favorites_user_car_unique UNIQUE (user_id, car_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON public.favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_car_id ON public.favorites(car_id);
CREATE INDEX IF NOT EXISTS idx_favorites_created_at ON public.favorites(created_at DESC);

-- Enable Row Level Security
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own favorites
CREATE POLICY "Users can view own favorites"
    ON public.favorites
    FOR SELECT
    USING (auth.uid() = user_id);

-- Policy: Users can insert their own favorites
CREATE POLICY "Users can insert own favorites"
    ON public.favorites
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own favorites
CREATE POLICY "Users can delete own favorites"
    ON public.favorites
    FOR DELETE
    USING (auth.uid() = user_id);

-- Policy: Users can update their own favorites (optional)
CREATE POLICY "Users can update own favorites"
    ON public.favorites
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_favorites_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-update updated_at
CREATE TRIGGER update_favorites_updated_at_trigger
    BEFORE UPDATE ON public.favorites
    FOR EACH ROW
    EXECUTE FUNCTION public.update_favorites_updated_at();

-- Add comment to table
COMMENT ON TABLE public.favorites IS 'Stores user favorite cars';
COMMENT ON COLUMN public.favorites.user_id IS 'Reference to the user who favorited the car';
COMMENT ON COLUMN public.favorites.car_id IS 'Reference to the favorited car';
COMMENT ON COLUMN public.favorites.created_at IS 'Timestamp when the favorite was added';
COMMENT ON COLUMN public.favorites.updated_at IS 'Timestamp when the favorite was last updated';
