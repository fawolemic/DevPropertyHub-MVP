# DevPropertyHub Supabase Backend

This directory contains the configuration files and documentation for setting up the Supabase backend for DevPropertyHub.

## Setup Instructions

### 1. Create a Supabase Project

1. Go to [Supabase](https://supabase.com/) and sign up or log in
2. Create a new project
3. Give your project a name (e.g., "DevPropertyHub")
4. Set a secure database password
5. Choose a region closest to your users
6. Wait for your database to be provisioned

### 2. Get Your Supabase Credentials

Once your project is created:

1. Go to the project dashboard
2. Navigate to Project Settings > API
3. Copy the following credentials:
   - **URL**: Your project URL (e.g., `https://xyzproject.supabase.co`)
   - **anon/public key**: Your public API key

### 3. Configure Your Flutter Application

Update the `lib/core/config/supabase_config.dart` file with your Supabase credentials:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 4. Set Up Database Schema

1. In your Supabase project, go to the SQL Editor
2. Copy the contents of `schema.sql` from this directory
3. Paste it into the SQL Editor and run the script
4. This will create all the necessary tables, functions, and security policies

## Database Structure

The DevPropertyHub backend consists of the following tables:

### Users
- Extends Supabase auth.users
- Stores user profiles with roles (developer, buyer, admin)

### Developments
- Property developments created by developers
- Contains details like location, status, units, amenities

### Properties
- Individual properties that can be part of a development
- Contains details like price, bedrooms, bathrooms, area

### Leads
- Potential buyers interested in properties
- Contains contact information, status, and priority

## Security

The database is secured using Row Level Security (RLS) policies:

- Developers can only access their own data
- Buyers can view all developments and properties but not leads
- Admins can view all data

## Storage Buckets

The following storage buckets are set up:

- `profile_images`: For user profile pictures
- `property_images`: For property images
- `development_images`: For development images
- `backups`: For database backups (private)

## API Services

The following services are available in the Flutter application:

- `AuthService`: For user authentication and profile management
- `LeadService`: For managing leads
- `PropertyService`: For managing properties
- `DevelopmentService`: For managing developments
- `DatabaseService`: For database operations

## Troubleshooting

If you encounter issues with your Supabase setup:

1. Check that your credentials are correct in `supabase_config.dart`
2. Verify that the SQL schema was executed successfully
3. Check the Supabase logs in the dashboard
4. Ensure your Flutter app has internet permissions

For more help, refer to the [Supabase documentation](https://supabase.com/docs) or the [Flutter Supabase package documentation](https://pub.dev/packages/supabase_flutter).
