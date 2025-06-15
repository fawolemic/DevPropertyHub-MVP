import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/core/models/user_model.dart';
import 'package:devpropertyhub/core/models/lead_model.dart';
import 'package:devpropertyhub/core/models/property_model.dart';
import 'package:devpropertyhub/core/models/lead_activity_model.dart';

void main() {
  group('UserModel Tests', () {
    test('fromMap correctly parses user data', () {
      final now = DateTime.now();
      final nowString = now.toIso8601String();

      final userData = {
        'id': 'user-123',
        'email': 'test@example.com',
        'first_name': 'John',
        'last_name': 'Doe',
        'phone': '1234567890',
        'avatar_url': 'https://example.com/avatar.jpg',
        'company_name': 'Test Company',
        'bio': 'Test bio',
        'user_type': 'developer',
        'is_verified': true,
        'last_login': nowString,
        'created_at': nowString,
        'updated_at': nowString,
        'preferences': {'theme': 'dark'},
        'profile_data': {'address': '123 Test St'},
      };

      final user = UserModel.fromMap(userData);

      expect(user.id, 'user-123');
      expect(user.email, 'test@example.com');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.phone, '1234567890');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.companyName, 'Test Company');
      expect(user.bio, 'Test bio');
      expect(user.role, UserRole.developer);
      expect(user.isVerified, true);
      expect(user.lastLogin?.toIso8601String(), nowString);
      expect(user.createdAt.toIso8601String(), nowString);
      expect(user.updatedAt?.toIso8601String(), nowString);
      expect(user.preferences?['theme'], 'dark');
      expect(user.profileData?['address'], '123 Test St');
    });

    test('toMap correctly serializes user data', () {
      final now = DateTime.now();

      final user = UserModel(
        id: 'user-123',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        phone: '1234567890',
        avatarUrl: 'https://example.com/avatar.jpg',
        companyName: 'Test Company',
        bio: 'Test bio',
        role: UserRole.developer,
        isVerified: true,
        lastLogin: now,
        createdAt: now,
        updatedAt: now,
        preferences: {'theme': 'dark'},
        profileData: {'address': '123 Test St'},
      );

      final map = user.toMap();

      expect(map['id'], 'user-123');
      expect(map['email'], 'test@example.com');
      expect(map['first_name'], 'John');
      expect(map['last_name'], 'Doe');
      expect(map['phone'], '1234567890');
      expect(map['avatar_url'], 'https://example.com/avatar.jpg');
      expect(map['company_name'], 'Test Company');
      expect(map['bio'], 'Test bio');
      expect(map['user_type'], 'developer');
      expect(map['is_verified'], true);
      expect(map['last_login'], now.toIso8601String());
      expect(map['created_at'], now.toIso8601String());
      expect(map['updated_at'], isNotNull);
      expect(map['preferences']['theme'], 'dark');
      expect(map['profile_data']['address'], '123 Test St');
    });

    test('roleToString and stringToRole work correctly', () {
      expect(UserModel.roleToString(UserRole.developer), 'developer');
      expect(UserModel.roleToString(UserRole.buyer), 'buyer');
      expect(UserModel.roleToString(UserRole.admin), 'admin');
      expect(UserModel.roleToString(UserRole.viewer), 'viewer');

      expect(UserModel.stringToRole('developer'), UserRole.developer);
      expect(UserModel.stringToRole('buyer'), UserRole.buyer);
      expect(UserModel.stringToRole('admin'), UserRole.admin);
      expect(UserModel.stringToRole('viewer'), UserRole.viewer);
      expect(UserModel.stringToRole('invalid'), UserRole.viewer); // Default
    });

    test('copyWith correctly updates user fields', () {
      final user = UserModel(
        id: 'user-123',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        role: UserRole.developer,
        createdAt: DateTime.now(),
      );

      final updatedUser = user.copyWith(
        firstName: 'Jane',
        lastName: 'Smith',
        role: UserRole.admin,
      );

      expect(updatedUser.id, 'user-123'); // Unchanged
      expect(updatedUser.email, 'test@example.com'); // Unchanged
      expect(updatedUser.firstName, 'Jane'); // Changed
      expect(updatedUser.lastName, 'Smith'); // Changed
      expect(updatedUser.role, UserRole.admin); // Changed
    });
  });

  group('LeadModel Tests', () {
    test('fromMap correctly parses lead data', () {
      final now = DateTime.now();
      final nowString = now.toIso8601String();

      final leadData = {
        'id': 'lead-123',
        'property_id': 'property-123',
        'buyer_id': 'buyer-123',
        'developer_id': 'developer-123',
        'status': 'interested',
        'priority': 'high',
        'budget_range': {'min': 100000, 'max': 200000},
        'requirements': {'bedrooms': 2, 'bathrooms': 2},
        'source': 'website',
        'notes': 'Test notes',
        'created_at': nowString,
        'updated_at': nowString,
      };

      final lead = LeadModel.fromMap(leadData);

      expect(lead.id, 'lead-123');
      expect(lead.propertyId, 'property-123');
      expect(lead.buyerId, 'buyer-123');
      expect(lead.developerId, 'developer-123');
      expect(lead.status, LeadStatus.interested);
      expect(lead.priority, LeadPriority.high);
      expect(lead.budgetRange?['min'], 100000);
      expect(lead.budgetRange?['max'], 200000);
      expect(lead.requirements?['bedrooms'], 2);
      expect(lead.requirements?['bathrooms'], 2);
      expect(lead.source, 'website');
      expect(lead.notes, 'Test notes');
      expect(lead.createdAt.toIso8601String(), nowString);
      expect(lead.updatedAt?.toIso8601String(), nowString);
    });

    test('toMap correctly serializes lead data', () {
      final now = DateTime.now();

      final lead = LeadModel(
        id: 'lead-123',
        propertyId: 'property-123',
        buyerId: 'buyer-123',
        developerId: 'developer-123',
        status: LeadStatus.interested,
        priority: LeadPriority.high,
        budgetRange: {'min': 100000, 'max': 200000},
        requirements: {'bedrooms': 2, 'bathrooms': 2},
        source: 'website',
        notes: 'Test notes',
        createdAt: now,
        updatedAt: now,
      );

      final map = lead.toMap();

      expect(map['id'], 'lead-123');
      expect(map['property_id'], 'property-123');
      expect(map['buyer_id'], 'buyer-123');
      expect(map['developer_id'], 'developer-123');
      expect(map['status'], 'interested');
      expect(map['priority'], 'high');
      expect(map['budget_range']['min'], 100000);
      expect(map['budget_range']['max'], 200000);
      expect(map['requirements']['bedrooms'], 2);
      expect(map['requirements']['bathrooms'], 2);
      expect(map['source'], 'website');
      expect(map['notes'], 'Test notes');
      expect(map['created_at'], now.toIso8601String());
      expect(map['updated_at'], isNotNull);
    });

    test('statusToString and stringToStatus work correctly', () {
      expect(LeadModel.statusToString(LeadStatus.new_lead), 'new');
      expect(LeadModel.statusToString(LeadStatus.contacted), 'contacted');
      expect(LeadModel.statusToString(LeadStatus.interested), 'interested');

      expect(LeadModel.stringToStatus('new'), LeadStatus.new_lead);
      expect(LeadModel.stringToStatus('contacted'), LeadStatus.contacted);
      expect(LeadModel.stringToStatus('interested'), LeadStatus.interested);
      expect(
          LeadModel.stringToStatus('invalid'), LeadStatus.new_lead); // Default
    });
  });

  group('PropertyModel Tests', () {
    test('fromMap correctly parses property data', () {
      final now = DateTime.now();
      final nowString = now.toIso8601String();

      final propertyData = {
        'id': 'property-123',
        'title': 'Test Property',
        'description': 'Test description',
        'developer_id': 'developer-123',
        'development_id': 'development-123',
        'type': 'apartment',
        'status': 'under_construction',
        'price': 150000,
        'price_unit': 'USD',
        'bedrooms': 2,
        'bathrooms': 2,
        'area': 1000,
        'area_unit': 'sqft',
        'location': 'Test Location',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'features': ['balcony', 'parking'],
        'image_urls': ['https://example.com/image1.jpg'],
        'additional_details': {'year_built': 2023},
        'created_at': nowString,
        'updated_at': nowString,
      };

      final property = PropertyModel.fromMap(propertyData);

      expect(property.id, 'property-123');
      expect(property.title, 'Test Property');
      expect(property.description, 'Test description');
      expect(property.developerId, 'developer-123');
      expect(property.developmentId, 'development-123');
      expect(property.type, PropertyType.apartment);
      expect(property.status, PropertyStatus.under_construction);
      expect(property.price, 150000);
      expect(property.priceUnit, 'USD');
      expect(property.bedrooms, 2);
      expect(property.bathrooms, 2);
      expect(property.area, 1000);
      expect(property.areaUnit, 'sqft');
      expect(property.location, 'Test Location');
      expect(property.latitude, 37.7749);
      expect(property.longitude, -122.4194);
      expect(property.features, ['balcony', 'parking']);
      expect(property.imageUrls, ['https://example.com/image1.jpg']);
      expect(property.additionalDetails?['year_built'], 2023);
    });

    test('statusToString and stringToStatus work correctly', () {
      expect(PropertyModel.statusToString(PropertyStatus.pre_launch),
          'pre_launch');
      expect(PropertyModel.statusToString(PropertyStatus.under_construction),
          'under_construction');
      expect(PropertyModel.statusToString(PropertyStatus.ready_to_move),
          'ready_to_move');
      expect(PropertyModel.statusToString(PropertyStatus.sold_out), 'sold_out');

      expect(PropertyModel.stringToStatus('pre_launch'),
          PropertyStatus.pre_launch);
      expect(PropertyModel.stringToStatus('under_construction'),
          PropertyStatus.under_construction);
      expect(PropertyModel.stringToStatus('ready_to_move'),
          PropertyStatus.ready_to_move);
      expect(PropertyModel.stringToStatus('sold_out'), PropertyStatus.sold_out);
      expect(PropertyModel.stringToStatus('invalid'),
          PropertyStatus.under_construction); // Default
    });
  });

  group('LeadActivityModel Tests', () {
    test('fromMap correctly parses lead activity data', () {
      final now = DateTime.now();
      final nowString = now.toIso8601String();

      final activityData = {
        'id': 'activity-123',
        'lead_id': 'lead-123',
        'activity_type': 'call',
        'description': 'Test call',
        'scheduled_at': nowString,
        'completed_at': nowString,
        'created_by': 'user-123',
        'created_at': nowString,
        'updated_at': nowString,
      };

      final activity = LeadActivityModel.fromMap(activityData);

      expect(activity.id, 'activity-123');
      expect(activity.leadId, 'lead-123');
      expect(activity.activityType, ActivityType.call);
      expect(activity.description, 'Test call');
      expect(activity.scheduledAt?.toIso8601String(), nowString);
      expect(activity.completedAt?.toIso8601String(), nowString);
      expect(activity.createdById, 'user-123');
      expect(activity.createdAt.toIso8601String(), nowString);
      expect(activity.updatedAt?.toIso8601String(), nowString);
    });

    test('toMap correctly serializes lead activity data', () {
      final now = DateTime.now();

      final activity = LeadActivityModel(
        id: 'activity-123',
        leadId: 'lead-123',
        activityType: ActivityType.call,
        description: 'Test call',
        scheduledAt: now,
        completedAt: now,
        createdById: 'user-123',
        createdAt: now,
        updatedAt: now,
      );

      final map = activity.toMap();

      expect(map['id'], 'activity-123');
      expect(map['lead_id'], 'lead-123');
      expect(map['activity_type'], 'call');
      expect(map['description'], 'Test call');
      expect(map['scheduled_at'], now.toIso8601String());
      expect(map['completed_at'], now.toIso8601String());
      expect(map['created_by'], 'user-123');
      expect(map['created_at'], now.toIso8601String());
      expect(map['updated_at'], isNotNull);
    });

    test('activityTypeToString and stringToActivityType work correctly', () {
      expect(LeadActivityModel.activityTypeToString(ActivityType.call), 'call');
      expect(
          LeadActivityModel.activityTypeToString(ActivityType.email), 'email');
      expect(LeadActivityModel.activityTypeToString(ActivityType.meeting),
          'meeting');

      expect(LeadActivityModel.stringToActivityType('call'), ActivityType.call);
      expect(
          LeadActivityModel.stringToActivityType('email'), ActivityType.email);
      expect(LeadActivityModel.stringToActivityType('meeting'),
          ActivityType.meeting);
      expect(LeadActivityModel.stringToActivityType('invalid'),
          ActivityType.call); // Default
    });
  });
}
