-- DevPropertyHub Complete Database Schema for Supabase
-- Based on the comprehensive architecture proposal

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "citext";

-- Set up storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES ('profile_images', 'Profile Images', true)
ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('property_images', 'Property Images', true)
ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('property_units', 'Property Unit Plans', true)
ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('backups', 'Database Backups', false)
ON CONFLICT (id) DO NOTHING;

-- Create user-related tables

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) UNIQUE NOT NULL,
  user_type VARCHAR(50) NOT NULL CHECK (user_type IN ('developer', 'buyer', 'viewer', 'admin')),
  profile_data JSONB,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE,
  last_login TIMESTAMP WITH TIME ZONE
);

-- User Profiles
CREATE TABLE IF NOT EXISTS public.user_profiles (
  user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone VARCHAR(20),
  avatar_url VARCHAR(500),
  company_name VARCHAR(200),
  bio TEXT,
  preferences JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Property-related tables

-- Properties
CREATE TABLE IF NOT EXISTS public.properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  developer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  location JSONB NOT NULL, -- {address, city, state, coordinates}
  property_type VARCHAR(50) NOT NULL CHECK (property_type IN ('residential', 'commercial', 'mixed')),
  status VARCHAR(50) NOT NULL CHECK (status IN ('pre_launch', 'under_construction', 'ready_to_move', 'sold_out')),
  total_units INTEGER NOT NULL DEFAULT 0,
  available_units INTEGER NOT NULL DEFAULT 0,
  price_range JSONB, -- {min, max, currency}
  amenities TEXT[],
  specifications JSONB,
  media_urls TEXT[],
  completion_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Property Units
CREATE TABLE IF NOT EXISTS public.property_units (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,
  unit_number VARCHAR(50) NOT NULL,
  floor INTEGER,
  area_sqft DECIMAL NOT NULL,
  bedrooms INTEGER NOT NULL DEFAULT 0,
  bathrooms INTEGER NOT NULL DEFAULT 0,
  price DECIMAL NOT NULL,
  status VARCHAR(50) NOT NULL CHECK (status IN ('available', 'reserved', 'sold')),
  unit_plan_url VARCHAR(500),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(property_id, unit_number)
);

-- Lead-related tables

-- Leads
CREATE TABLE IF NOT EXISTS public.leads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID REFERENCES public.properties(id) ON DELETE SET NULL,
  buyer_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  developer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  status VARCHAR(50) NOT NULL CHECK (status IN ('new', 'contacted', 'interested', 'viewing_scheduled', 'negotiating', 'converted', 'lost')),
  priority VARCHAR(50) NOT NULL CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  budget_range JSONB,
  requirements JSONB,
  source VARCHAR(50) CHECK (source IN ('website', 'referral', 'advertisement', 'social_media')),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Lead Activities
CREATE TABLE IF NOT EXISTS public.lead_activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lead_id UUID NOT NULL REFERENCES public.leads(id) ON DELETE CASCADE,
  activity_type VARCHAR(50) NOT NULL CHECK (activity_type IN ('call', 'email', 'meeting', 'site_visit', 'document_sent')),
  description TEXT,
  scheduled_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_by UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Analytics-related tables

-- Property Views
CREATE TABLE IF NOT EXISTS public.property_views (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  session_id VARCHAR(255) NOT NULL,
  user_agent TEXT,
  ip_address INET,
  referrer VARCHAR(500),
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Market Analytics
CREATE TABLE IF NOT EXISTS public.market_analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  location VARCHAR(255) NOT NULL,
  property_type VARCHAR(100) NOT NULL,
  avg_price_per_sqft DECIMAL,
  total_listings INTEGER,
  sold_count INTEGER,
  avg_days_on_market INTEGER,
  price_trend DECIMAL, -- percentage change
  analysis_date DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notification-related tables

-- Notifications
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL CHECK (type IN ('lead_received', 'property_update', 'price_change', 'system_alert')),
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  data JSONB, -- Additional context data
  read_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notification Preferences
CREATE TABLE IF NOT EXISTS public.notification_preferences (
  user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  email_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  push_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  sms_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  lead_notifications BOOLEAN NOT NULL DEFAULT TRUE,
  property_updates BOOLEAN NOT NULL DEFAULT TRUE,
  market_reports BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for better performance

-- Users indexes
CREATE INDEX IF NOT EXISTS idx_users_user_type ON public.users(user_type);
CREATE INDEX IF NOT EXISTS idx_users_verified ON public.users(is_verified);

-- Properties indexes
CREATE INDEX IF NOT EXISTS idx_properties_developer ON public.properties(developer_id);
CREATE INDEX IF NOT EXISTS idx_properties_status ON public.properties(status);
CREATE INDEX IF NOT EXISTS idx_properties_type ON public.properties(property_type);
CREATE INDEX IF NOT EXISTS idx_properties_location ON public.properties USING gin(location);

-- Property Units indexes
CREATE INDEX IF NOT EXISTS idx_property_units_property ON public.property_units(property_id);
CREATE INDEX IF NOT EXISTS idx_property_units_status ON public.property_units(status);
CREATE INDEX IF NOT EXISTS idx_property_units_price ON public.property_units(price);

-- Leads indexes
CREATE INDEX IF NOT EXISTS idx_leads_developer ON public.leads(developer_id);
CREATE INDEX IF NOT EXISTS idx_leads_property ON public.leads(property_id);
CREATE INDEX IF NOT EXISTS idx_leads_buyer ON public.leads(buyer_id);
CREATE INDEX IF NOT EXISTS idx_leads_status ON public.leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_priority ON public.leads(priority);

-- Lead Activities indexes
CREATE INDEX IF NOT EXISTS idx_lead_activities_lead ON public.lead_activities(lead_id);
CREATE INDEX IF NOT EXISTS idx_lead_activities_created_by ON public.lead_activities(created_by);

-- Property Views indexes
CREATE INDEX IF NOT EXISTS idx_property_views_property ON public.property_views(property_id);
CREATE INDEX IF NOT EXISTS idx_property_views_user ON public.property_views(user_id);
CREATE INDEX IF NOT EXISTS idx_property_views_date ON public.property_views(viewed_at);

-- Notifications indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON public.notifications(read_at);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON public.notifications(type);

-- Set up Row Level Security (RLS)

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.property_units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lead_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.property_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.market_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_preferences ENABLE ROW LEVEL SECURITY;

-- Users table policies
CREATE POLICY "Users can view their own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can view all users" ON public.users
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- User Profiles policies
CREATE POLICY "Users can view their own profile details" ON public.user_profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile details" ON public.user_profiles
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all user profiles" ON public.user_profiles
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Properties policies
CREATE POLICY "Developers can manage their own properties" ON public.properties
  FOR ALL USING (developer_id = auth.uid());

CREATE POLICY "Anyone can view properties" ON public.properties
  FOR SELECT USING (true);

-- Property Units policies
CREATE POLICY "Developers can manage their own property units" ON public.property_units
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.properties
      WHERE id = property_id AND developer_id = auth.uid()
    )
  );

CREATE POLICY "Anyone can view property units" ON public.property_units
  FOR SELECT USING (true);

-- Leads policies
CREATE POLICY "Developers can view their own leads" ON public.leads
  FOR SELECT USING (developer_id = auth.uid());

CREATE POLICY "Developers can insert their own leads" ON public.leads
  FOR INSERT WITH CHECK (developer_id = auth.uid());

CREATE POLICY "Developers can update their own leads" ON public.leads
  FOR UPDATE USING (developer_id = auth.uid());

CREATE POLICY "Developers can delete their own leads" ON public.leads
  FOR DELETE USING (developer_id = auth.uid());

CREATE POLICY "Buyers can view leads related to them" ON public.leads
  FOR SELECT USING (buyer_id = auth.uid());

CREATE POLICY "Buyers can create leads" ON public.leads
  FOR INSERT WITH CHECK (buyer_id = auth.uid());

CREATE POLICY "Admins can view all leads" ON public.leads
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Lead Activities policies
CREATE POLICY "Developers can view activities for their leads" ON public.lead_activities
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.leads
      WHERE id = lead_id AND developer_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage activities they created" ON public.lead_activities
  FOR ALL USING (created_by = auth.uid());

CREATE POLICY "Admins can view all lead activities" ON public.lead_activities
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Property Views policies
CREATE POLICY "Developers can view analytics for their properties" ON public.property_views
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.properties
      WHERE id = property_id AND developer_id = auth.uid()
    )
  );

CREATE POLICY "Anyone can insert property views" ON public.property_views
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Admins can view all property views" ON public.property_views
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Market Analytics policies
CREATE POLICY "Anyone can view market analytics" ON public.market_analytics
  FOR SELECT USING (true);

CREATE POLICY "Admins can manage market analytics" ON public.market_analytics
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Notifications policies
CREATE POLICY "Users can view their own notifications" ON public.notifications
  FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can update their own notifications" ON public.notifications
  FOR UPDATE USING (user_id = auth.uid());

-- Notification Preferences policies
CREATE POLICY "Users can view their notification preferences" ON public.notification_preferences
  FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can update their notification preferences" ON public.notification_preferences
  FOR UPDATE USING (user_id = auth.uid());

-- Create triggers

-- Trigger to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the trigger to all tables with updated_at column
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON public.user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_properties_updated_at
  BEFORE UPDATE ON public.properties
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_property_units_updated_at
  BEFORE UPDATE ON public.property_units
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_leads_updated_at
  BEFORE UPDATE ON public.leads
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lead_activities_updated_at
  BEFORE UPDATE ON public.lead_activities
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_notification_preferences_updated_at
  BEFORE UPDATE ON public.notification_preferences
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create a trigger to update available_units when a property unit status changes
CREATE OR REPLACE FUNCTION update_property_available_units()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'UPDATE' AND OLD.status != NEW.status) THEN
    IF (NEW.status = 'sold' AND OLD.status != 'sold') THEN
      -- Unit was sold, decrease available units
      UPDATE public.properties
      SET available_units = available_units - 1
      WHERE id = NEW.property_id;
    ELSIF (OLD.status = 'sold' AND NEW.status != 'sold') THEN
      -- Unit was un-sold, increase available units
      UPDATE public.properties
      SET available_units = available_units + 1
      WHERE id = NEW.property_id;
    END IF;
  ELSIF (TG_OP = 'INSERT' AND NEW.status != 'sold') THEN
    -- New available unit added
    UPDATE public.properties
    SET available_units = available_units + 1
    WHERE id = NEW.property_id;
  ELSIF (TG_OP = 'DELETE' AND OLD.status != 'sold') THEN
    -- Available unit removed
    UPDATE public.properties
    SET available_units = available_units - 1
    WHERE id = OLD.property_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_property_units_on_status_change
  AFTER INSERT OR UPDATE OR DELETE ON public.property_units
  FOR EACH ROW
  EXECUTE FUNCTION update_property_available_units();

-- Create a trigger to create user profile when a user is created
CREATE OR REPLACE FUNCTION create_user_profile()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (user_id)
  VALUES (NEW.id);
  
  INSERT INTO public.notification_preferences (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_user_created
  AFTER INSERT ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION create_user_profile();

-- Create a trigger to handle user creation in auth.users
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (
    id, 
    email, 
    user_type, 
    is_verified, 
    created_at
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'user_type', 'buyer'),
    NEW.email_confirmed_at IS NOT NULL,
    NEW.created_at
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- Create a trigger to update user email verification status
CREATE OR REPLACE FUNCTION handle_user_email_verification()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email_confirmed_at IS NOT NULL AND OLD.email_confirmed_at IS NULL THEN
    UPDATE public.users
    SET is_verified = TRUE
    WHERE id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_auth_user_email_verified
  AFTER UPDATE ON auth.users
  FOR EACH ROW
  WHEN (NEW.email_confirmed_at IS NOT NULL AND OLD.email_confirmed_at IS NULL)
  EXECUTE FUNCTION handle_user_email_verification();

-- Create a function to update user last login
CREATE OR REPLACE FUNCTION update_user_last_login()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.users
  SET last_login = NOW()
  WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_user_signed_in
  AFTER INSERT ON auth.sessions
  FOR EACH ROW
  EXECUTE FUNCTION update_user_last_login();

-- Create sample admin user function
CREATE OR REPLACE FUNCTION create_admin_user(email TEXT, password TEXT)
RETURNS void AS $$
DECLARE
  user_id UUID;
BEGIN
  -- Create user in auth.users
  user_id := (SELECT id FROM auth.users WHERE auth.users.email = create_admin_user.email);
  
  IF user_id IS NULL THEN
    user_id := extensions.uuid_generate_v4();
    
    INSERT INTO auth.users (
      id,
      email,
      email_confirmed_at,
      raw_user_meta_data,
      created_at,
      updated_at
    ) VALUES (
      user_id,
      email,
      NOW(),
      jsonb_build_object('user_type', 'admin'),
      NOW(),
      NOW()
    );
    
    -- Insert password
    INSERT INTO auth.identities (
      id,
      user_id,
      identity_data,
      provider,
      last_sign_in_at,
      created_at,
      updated_at
    ) VALUES (
      user_id,
      user_id,
      jsonb_build_object('sub', user_id, 'email', email),
      'email',
      NOW(),
      NOW(),
      NOW()
    );
  ELSE
    -- Update existing user to admin
    UPDATE public.users
    SET user_type = 'admin'
    WHERE id = user_id;
  END IF;
END;
$$ LANGUAGE plpgsql;
