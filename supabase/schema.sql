-- DevPropertyHub Database Schema for Supabase

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Set up storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES ('profile_images', 'Profile Images', true);
INSERT INTO storage.buckets (id, name, public) VALUES ('property_images', 'Property Images', true);
INSERT INTO storage.buckets (id, name, public) VALUES ('development_images', 'Development Images', true);
INSERT INTO storage.buckets (id, name, public) VALUES ('backups', 'Database Backups', false);

-- Create tables

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  first_name TEXT,
  last_name TEXT,
  phone TEXT,
  avatar_url TEXT,
  company_name TEXT,
  bio TEXT,
  user_type TEXT NOT NULL DEFAULT 'buyer' CHECK (user_type IN ('developer', 'buyer', 'admin', 'viewer')),
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  last_login TIMESTAMP WITH TIME ZONE,
  preferences JSONB DEFAULT '{}'::jsonb,
  profile_data JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Developments table
CREATE TABLE IF NOT EXISTS public.developments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  developer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'planning' CHECK (status IN ('planning', 'under_construction', 'completed', 'selling', 'sold_out')),
  location TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  start_date TIMESTAMP WITH TIME ZONE,
  completion_date TIMESTAMP WITH TIME ZONE,
  total_units INTEGER NOT NULL DEFAULT 0,
  available_units INTEGER NOT NULL DEFAULT 0,
  image_urls TEXT[],
  amenities TEXT[],
  additional_details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Properties table
CREATE TABLE IF NOT EXISTS public.properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  developer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  development_id UUID REFERENCES public.developments(id) ON DELETE SET NULL,
  type TEXT NOT NULL DEFAULT 'apartment' CHECK (type IN ('apartment', 'house', 'villa', 'penthouse', 'land', 'commercial', 'duplex', 'studio', 'office', 'retail', 'other')),
  status TEXT NOT NULL DEFAULT 'under_construction' CHECK (status IN ('pre_launch', 'under_construction', 'ready_to_move', 'sold_out')),
  price DOUBLE PRECISION NOT NULL,
  price_unit TEXT DEFAULT 'USD',
  bedrooms INTEGER NOT NULL DEFAULT 0,
  bathrooms INTEGER NOT NULL DEFAULT 0,
  area DOUBLE PRECISION NOT NULL,
  area_unit TEXT DEFAULT 'sqft',
  location TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  features TEXT[],
  image_urls TEXT[],
  additional_details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Leads table
CREATE TABLE IF NOT EXISTS public.leads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID REFERENCES public.properties(id) ON DELETE SET NULL,
  buyer_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  developer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'interested', 'viewing_scheduled', 'negotiating', 'converted', 'lost')),
  priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  budget_range JSONB DEFAULT '{}'::jsonb,
  requirements JSONB DEFAULT '{}'::jsonb,
  source TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Lead Activities table
CREATE TABLE IF NOT EXISTS public.lead_activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lead_id UUID NOT NULL REFERENCES public.leads(id) ON DELETE CASCADE,
  activity_type TEXT NOT NULL CHECK (activity_type IN ('call', 'email', 'meeting', 'site_visit', 'document_sent')),
  description TEXT,
  scheduled_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_by UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Set up Row Level Security (RLS)

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.developments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lead_activities ENABLE ROW LEVEL SECURITY;

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

-- Developments table policies
CREATE POLICY "Developers can view their own developments" ON public.developments
  FOR SELECT USING (developer_id = auth.uid());

CREATE POLICY "Developers can insert their own developments" ON public.developments
  FOR INSERT WITH CHECK (developer_id = auth.uid());

CREATE POLICY "Developers can update their own developments" ON public.developments
  FOR UPDATE USING (developer_id = auth.uid());

CREATE POLICY "Developers can delete their own developments" ON public.developments
  FOR DELETE USING (developer_id = auth.uid());

CREATE POLICY "Buyers can view all developments" ON public.developments
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'buyer'
    )
  );

CREATE POLICY "Admins can view all developments" ON public.developments
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Properties table policies
CREATE POLICY "Developers can view their own properties" ON public.properties
  FOR SELECT USING (developer_id = auth.uid());

CREATE POLICY "Developers can insert their own properties" ON public.properties
  FOR INSERT WITH CHECK (developer_id = auth.uid());

CREATE POLICY "Developers can update their own properties" ON public.properties
  FOR UPDATE USING (developer_id = auth.uid());

CREATE POLICY "Developers can delete their own properties" ON public.properties
  FOR DELETE USING (developer_id = auth.uid());

CREATE POLICY "Buyers can view all properties" ON public.properties
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'buyer'
    )
  );

CREATE POLICY "Admins can view all properties" ON public.properties
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Leads table policies
CREATE POLICY "Developers can view their own leads" ON public.leads
  FOR SELECT USING (developer_id = auth.uid());

CREATE POLICY "Developers can insert their own leads" ON public.leads
  FOR INSERT WITH CHECK (developer_id = auth.uid());

CREATE POLICY "Developers can update their own leads" ON public.leads
  FOR UPDATE USING (developer_id = auth.uid());

CREATE POLICY "Developers can delete their own leads" ON public.leads
  FOR DELETE USING (developer_id = auth.uid());

CREATE POLICY "Admins can view all leads" ON public.leads
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Create functions for database initialization

-- Function to create users table if it doesn't exist
CREATE OR REPLACE FUNCTION create_users_table()
RETURNS void AS $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'users') THEN
    CREATE TABLE public.users (
      id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
      email TEXT NOT NULL UNIQUE,
      full_name TEXT,
      photo_url TEXT,
      role TEXT NOT NULL DEFAULT 'buyer' CHECK (role IN ('developer', 'buyer', 'admin')),
      is_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
      metadata JSONB,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE
    );
    
    ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
    
    CREATE POLICY "Users can view their own profile" ON public.users
      FOR SELECT USING (auth.uid() = id);
    
    CREATE POLICY "Users can update their own profile" ON public.users
      FOR UPDATE USING (auth.uid() = id);
    
    CREATE POLICY "Admins can view all users" ON public.users
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.users
          WHERE id = auth.uid() AND role = 'admin'
        )
      );
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to create developments table if it doesn't exist
CREATE OR REPLACE FUNCTION create_developments_table()
RETURNS void AS $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'developments') THEN
    CREATE TABLE public.developments (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      developer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
      status TEXT NOT NULL DEFAULT 'planning' CHECK (status IN ('planning', 'under_construction', 'completed', 'selling', 'sold_out')),
      location TEXT NOT NULL,
      latitude DOUBLE PRECISION,
      longitude DOUBLE PRECISION,
      start_date TIMESTAMP WITH TIME ZONE,
      completion_date TIMESTAMP WITH TIME ZONE,
      total_units INTEGER NOT NULL DEFAULT 0,
      available_units INTEGER NOT NULL DEFAULT 0,
      image_urls TEXT[],
      amenities TEXT[],
      additional_details JSONB,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE
    );
    
    ALTER TABLE public.developments ENABLE ROW LEVEL SECURITY;
    
    CREATE POLICY "Developers can view their own developments" ON public.developments
      FOR SELECT USING (developer_id = auth.uid());
    
    CREATE POLICY "Developers can insert their own developments" ON public.developments
      FOR INSERT WITH CHECK (developer_id = auth.uid());
    
    CREATE POLICY "Developers can update their own developments" ON public.developments
      FOR UPDATE USING (developer_id = auth.uid());
    
    CREATE POLICY "Developers can delete their own developments" ON public.developments
      FOR DELETE USING (developer_id = auth.uid());
    
    CREATE POLICY "Buyers can view all developments" ON public.developments
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.users
          WHERE id = auth.uid() AND role = 'buyer'
        )
      );
    
    CREATE POLICY "Admins can view all developments" ON public.developments
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.users
          WHERE id = auth.uid() AND role = 'admin'
        )
      );
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to create properties table if it doesn't exist
CREATE OR REPLACE FUNCTION create_properties_table()
RETURNS void AS $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'properties') THEN
    CREATE TABLE public.properties (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      developer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
      development_id UUID REFERENCES public.developments(id) ON DELETE SET NULL,
      type TEXT NOT NULL DEFAULT 'apartment' CHECK (type IN ('apartment', 'house', 'villa', 'land', 'commercial', 'other')),
      status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'reserved', 'sold', 'under_construction', 'coming_soon')),
      price DOUBLE PRECISION NOT NULL,
      price_unit TEXT DEFAULT 'USD',
      bedrooms INTEGER NOT NULL DEFAULT 0,
      bathrooms INTEGER NOT NULL DEFAULT 0,
      area DOUBLE PRECISION NOT NULL,
      area_unit TEXT DEFAULT 'sqft',
      location TEXT NOT NULL,
      latitude DOUBLE PRECISION,
      longitude DOUBLE PRECISION,
      features TEXT[],
      image_urls TEXT[],
      additional_details JSONB,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE
    );
    
    ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
    
    CREATE POLICY "Developers can view their own properties" ON public.properties
      FOR SELECT USING (developer_id = auth.uid());
    
    CREATE POLICY "Developers can insert their own properties" ON public.properties
      FOR INSERT WITH CHECK (developer_id = auth.uid());
    
    CREATE POLICY "Developers can update their own properties" ON public.properties
      FOR UPDATE USING (developer_id = auth.uid());
    
    CREATE POLICY "Developers can delete their own properties" ON public.properties
      FOR DELETE USING (developer_id = auth.uid());
    
    CREATE POLICY "Buyers can view all properties" ON public.properties
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.users
          WHERE id = auth.uid() AND role = 'buyer'
        )
      );
    
    CREATE POLICY "Admins can view all properties" ON public.properties
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.users
          WHERE id = auth.uid() AND role = 'admin'
        )
      );
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to create leads table if it doesn't exist
CREATE OR REPLACE FUNCTION create_leads_table()
RETURNS void AS $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'leads') THEN
    CREATE TABLE public.leads (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT,
      property_id UUID REFERENCES public.properties(id) ON DELETE SET NULL,
      property_name TEXT,
      developer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
      status TEXT NOT NULL DEFAULT 'new_lead' CHECK (status IN ('new_lead', 'interested', 'viewing_scheduled', 'offer_made', 'converted', 'lost')),
      priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
      budget TEXT,
      notes TEXT,
      last_contact_date TIMESTAMP WITH TIME ZONE,
      tags TEXT[],
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE
    );
    
    ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;
    
    CREATE POLICY "Developers can view their own leads" ON public.leads
      FOR SELECT USING (developer_id = auth.uid());
    
    CREATE POLICY "Developers can insert their own leads" ON public.leads
      FOR INSERT WITH CHECK (developer_id = auth.uid());
    
    CREATE POLICY "Developers can update their own leads" ON public.leads
      FOR UPDATE USING (developer_id = auth.uid());
    
    CREATE POLICY "Developers can delete their own leads" ON public.leads
      FOR DELETE USING (developer_id = auth.uid());
    
    CREATE POLICY "Admins can view all leads" ON public.leads
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.users
          WHERE id = auth.uid() AND role = 'admin'
        )
      );
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Create triggers

-- Trigger to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the trigger to all tables
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_developments_updated_at
  BEFORE UPDATE ON public.developments
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_properties_updated_at
  BEFORE UPDATE ON public.properties
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_leads_updated_at
  BEFORE UPDATE ON public.leads
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create a trigger to update available_units when a property status changes
CREATE OR REPLACE FUNCTION update_development_available_units()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'UPDATE' AND OLD.status != NEW.status) THEN
    IF (NEW.status = 'sold' AND OLD.status != 'sold') THEN
      -- Property was sold, decrease available units
      UPDATE public.developments
      SET available_units = available_units - 1
      WHERE id = NEW.development_id;
    ELSIF (OLD.status = 'sold' AND NEW.status != 'sold') THEN
      -- Property was un-sold, increase available units
      UPDATE public.developments
      SET available_units = available_units + 1
      WHERE id = NEW.development_id;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_development_units_on_property_status_change
  AFTER UPDATE ON public.properties
  FOR EACH ROW
  WHEN (OLD.development_id IS NOT NULL AND NEW.development_id IS NOT NULL)
  EXECUTE FUNCTION update_development_available_units();

-- Create a trigger to handle user creation in auth.users
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, role, is_email_verified, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    COALESCE(NEW.raw_user_meta_data->>'role', 'buyer'),
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
    SET is_email_verified = TRUE
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
