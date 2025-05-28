import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ProjectService {
  final String baseUrl;
  final Map<String, String> headers;

  ProjectService({
    required this.baseUrl,
    required this.headers,
  });

  // Create a new project
  Future<Project> createProject(Project project) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(project.toJson()),
      );

      if (response.statusCode == 201) {
        return Project.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  // Get a project by ID
  Future<Project> getProject(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/projects/$projectId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Project.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get project: $e');
    }
  }

  // Update a project
  Future<Project> updateProject(Project project) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/projects/${project.id}'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(project.toJson()),
      );

      if (response.statusCode == 200) {
        return Project.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  // Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/projects/$projectId'),
        headers: headers,
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }

  // Get all projects for a developer
  Future<List<Project>> getDeveloperProjects(String developerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/developers/$developerId/projects'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> projectsJson = jsonDecode(response.body);
        return projectsJson.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get developer projects: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get developer projects: $e');
    }
  }

  // Add a phase to a project
  Future<ProjectPhase> addProjectPhase(ProjectPhase phase) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects/${phase.projectId}/phases'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(phase.toJson()),
      );

      if (response.statusCode == 201) {
        return ProjectPhase.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add project phase: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add project phase: $e');
    }
  }

  // Get all phases for a project
  Future<List<ProjectPhase>> getProjectPhases(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/projects/$projectId/phases'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> phasesJson = jsonDecode(response.body);
        return phasesJson.map((json) => ProjectPhase.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get project phases: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get project phases: $e');
    }
  }

  // Add a unit type to a project
  Future<UnitType> addUnitType(UnitType unitType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects/${unitType.projectId}/unit-types'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(unitType.toJson()),
      );

      if (response.statusCode == 201) {
        return UnitType.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add unit type: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add unit type: $e');
    }
  }

  // Get all unit types for a project
  Future<List<UnitType>> getProjectUnitTypes(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/projects/$projectId/unit-types'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> unitTypesJson = jsonDecode(response.body);
        return unitTypesJson.map((json) => UnitType.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get project unit types: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get project unit types: $e');
    }
  }

  // Add media to a project
  Future<ProjectMedia> addProjectMedia(ProjectMedia media) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects/${media.projectId}/media'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(media.toJson()),
      );

      if (response.statusCode == 201) {
        return ProjectMedia.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add project media: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add project media: $e');
    }
  }

  // Get all media for a project
  Future<List<ProjectMedia>> getProjectMedia(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/projects/$projectId/media'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> mediaJson = jsonDecode(response.body);
        return mediaJson.map((json) => ProjectMedia.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get project media: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get project media: $e');
    }
  }

  // Add a payment plan to a project
  Future<PaymentPlan> addPaymentPlan(PaymentPlan plan) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects/${plan.projectId}/payment-plans'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(plan.toJson()),
      );

      if (response.statusCode == 201) {
        return PaymentPlan.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add payment plan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add payment plan: $e');
    }
  }

  // Get all payment plans for a project
  Future<List<PaymentPlan>> getProjectPaymentPlans(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/projects/$projectId/payment-plans'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> plansJson = jsonDecode(response.body);
        return plansJson.map((json) => PaymentPlan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get project payment plans: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get project payment plans: $e');
    }
  }

  // Add an update to a project
  Future<ProjectUpdate> addProjectUpdate(ProjectUpdate update) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects/${update.projectId}/updates'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(update.toJson()),
      );

      if (response.statusCode == 201) {
        return ProjectUpdate.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add project update: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add project update: $e');
    }
  }

  // Get all updates for a project
  Future<List<ProjectUpdate>> getProjectUpdates(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/projects/$projectId/updates'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> updatesJson = jsonDecode(response.body);
        return updatesJson.map((json) => ProjectUpdate.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get project updates: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get project updates: $e');
    }
  }

  // Publish a project (change status to published)
  Future<Project> publishProject(String projectId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects/$projectId/publish'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Project.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to publish project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to publish project: $e');
    }
  }
}
