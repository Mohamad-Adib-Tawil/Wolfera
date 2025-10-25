-- Wolfera Database Schema for Supabase
-- ===========================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users Table (extends Supabase Auth)
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone_number TEXT,
    avatar_url TEXT,
    location TEXT,
    city TEXT,
    country TEXT,
    is_dealer BOOLEAN DEFAULT false,
    dealer_name TEXT,
    dealer_license TEXT,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    total_reviews INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Cars Table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.cars (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    
    -- Basic Info
    brand TEXT NOT NULL,
    model TEXT NOT NULL,
    year INTEGER NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    currency TEXT DEFAULT 'USD',
    
    -- Specifications
    mileage INTEGER,
    transmission TEXT CHECK (transmission IN ('manual', 'automatic', 'cvt', 'dct')),
    fuel_type TEXT CHECK (fuel_type IN ('petrol', 'diesel', 'electric', 'hybrid', 'plug-in-hybrid')),
    body_type TEXT,
    color TEXT,
    engine_capacity DECIMAL(3, 1),
    cylinders INTEGER,
    seats INTEGER,
    doors INTEGER,
    drive_type TEXT CHECK (drive_type IN ('fwd', 'rwd', 'awd', '4wd')),
    
    -- Condition
    condition TEXT CHECK (condition IN ('new', 'used', 'certified')),
    accidents_history BOOLEAN DEFAULT false,
    service_history BOOLEAN DEFAULT false,
    warranty BOOLEAN DEFAULT false,
    warranty_details TEXT,
    
    -- Description
    title TEXT NOT NULL,
    description TEXT,
    
    -- Features (stored as JSON arrays)
    safety_features JSONB DEFAULT '[]',
    interior_features JSONB DEFAULT '[]',
    exterior_features JSONB DEFAULT '[]',
    
    -- Images
    main_image_url TEXT,
    image_urls JSONB DEFAULT '[]',
    
    -- Location
    location TEXT,
    city TEXT,
    country TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    
    -- Status
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'sold', 'pending', 'inactive')),
    views_count INTEGER DEFAULT 0,
    favorites_count INTEGER DEFAULT 0,
    is_featured BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    sold_at TIMESTAMP WITH TIME ZONE
);

-- 3. Favorites Table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    car_id UUID NOT NULL REFERENCES public.cars(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, car_id)
);

-- 4. Conversations Table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    car_id UUID NOT NULL REFERENCES public.cars(id) ON DELETE CASCADE,
    buyer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    seller_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    last_message TEXT,
    last_message_at TIMESTAMP WITH TIME ZONE,
    buyer_unread_count INTEGER DEFAULT 0,
    seller_unread_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(car_id, buyer_id, seller_id)
);

-- 5. Messages Table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'offer')),
    attachments JSONB DEFAULT '[]',
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Reviews Table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reviewer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    reviewed_user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    car_id UUID REFERENCES public.cars(id) ON DELETE SET NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(reviewer_id, reviewed_user_id, car_id)
);

-- 7. Notifications Table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('message', 'favorite', 'price_drop', 'new_car', 'review', 'offer')),
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. Search History Table
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.search_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    search_query TEXT,
    filters JSONB DEFAULT '{}',
    results_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. Car Views Table (for tracking)
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS public.car_views (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    car_id UUID NOT NULL REFERENCES public.cars(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    ip_address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===========================================
-- INDEXES for Performance
-- ===========================================

-- Cars indexes
CREATE INDEX idx_cars_user_id ON public.cars(user_id);
CREATE INDEX idx_cars_status ON public.cars(status);
CREATE INDEX idx_cars_brand_model ON public.cars(brand, model);
CREATE INDEX idx_cars_price ON public.cars(price);
CREATE INDEX idx_cars_year ON public.cars(year);
CREATE INDEX idx_cars_location ON public.cars(city, country);
CREATE INDEX idx_cars_created_at ON public.cars(created_at DESC);

-- Favorites indexes
CREATE INDEX idx_favorites_user_id ON public.favorites(user_id);
CREATE INDEX idx_favorites_car_id ON public.favorites(car_id);

-- Messages indexes
CREATE INDEX idx_messages_conversation_id ON public.messages(conversation_id);
CREATE INDEX idx_messages_sender_id ON public.messages(sender_id);
CREATE INDEX idx_messages_created_at ON public.messages(created_at DESC);

-- Conversations indexes
CREATE INDEX idx_conversations_buyer_id ON public.conversations(buyer_id);
CREATE INDEX idx_conversations_seller_id ON public.conversations(seller_id);
CREATE INDEX idx_conversations_car_id ON public.conversations(car_id);

-- Notifications indexes
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_is_read ON public.notifications(is_read);

-- ===========================================
-- ROW LEVEL SECURITY (RLS)
-- ===========================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cars ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.search_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.car_views ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view all profiles" ON public.users
    FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Cars policies
CREATE POLICY "Cars are viewable by everyone" ON public.cars
    FOR SELECT USING (true);

CREATE POLICY "Users can insert own cars" ON public.cars
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own cars" ON public.cars
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own cars" ON public.cars
    FOR DELETE USING (auth.uid() = user_id);

-- Favorites policies
CREATE POLICY "Users can view own favorites" ON public.favorites
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can add favorites" ON public.favorites
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove favorites" ON public.favorites
    FOR DELETE USING (auth.uid() = user_id);

-- Conversations policies
CREATE POLICY "Users can view own conversations" ON public.conversations
    FOR SELECT USING (auth.uid() = buyer_id OR auth.uid() = seller_id);

CREATE POLICY "Users can create conversations" ON public.conversations
    FOR INSERT WITH CHECK (auth.uid() = buyer_id);

-- Messages policies
CREATE POLICY "Users can view messages in their conversations" ON public.messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.conversations
            WHERE conversations.id = messages.conversation_id
            AND (conversations.buyer_id = auth.uid() OR conversations.seller_id = auth.uid())
        )
    );

CREATE POLICY "Users can send messages" ON public.messages
    FOR INSERT WITH CHECK (auth.uid() = sender_id);

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- ===========================================
-- FUNCTIONS & TRIGGERS
-- ===========================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cars_updated_at BEFORE UPDATE ON public.cars
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON public.conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update user rating after new review
CREATE OR REPLACE FUNCTION update_user_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.users
    SET rating = (
        SELECT AVG(rating)::DECIMAL(3, 2)
        FROM public.reviews
        WHERE reviewed_user_id = NEW.reviewed_user_id
    ),
    total_reviews = (
        SELECT COUNT(*)
        FROM public.reviews
        WHERE reviewed_user_id = NEW.reviewed_user_id
    )
    WHERE id = NEW.reviewed_user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_rating_trigger
AFTER INSERT OR UPDATE ON public.reviews
    FOR EACH ROW EXECUTE FUNCTION update_user_rating();

-- Function to increment view count
CREATE OR REPLACE FUNCTION increment_car_view_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.cars
    SET views_count = views_count + 1
    WHERE id = NEW.car_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increment_car_views
AFTER INSERT ON public.car_views
    FOR EACH ROW EXECUTE FUNCTION increment_car_view_count();

-- ===========================================
-- STORAGE BUCKETS
-- ===========================================
-- Run these in Supabase Dashboard:
-- 1. Create 'car-images' bucket for car photos
-- 2. Create 'user-avatars' bucket for profile pictures
-- 3. Create 'chat-attachments' bucket for message attachments
-- 4. Set appropriate policies for each bucket
