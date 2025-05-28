import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/project_service.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectService _projectService;
  
  // Current project being created or edited
  Project? _currentProject;
  List<ProjectPhase> _phases = [];
  List<UnitType> _unitTypes = [];
  List<ProjectMedia> _media = [];
  List<PaymentPlan> _paymentPlans = [];
  
  // Loading states
  bool _isLoading = false;
  String? _error;
  
  // Current step in the wizard
  int _currentStep = 0;
  
  ProjectProvider({required ProjectService projectService}) 
    : _projectService = projectService;
  
  // Getters
  Project? get currentProject => _currentProject;
  List<ProjectPhase> get phases => _phases;
  List<UnitType> get unitTypes => _unitTypes;
  List<ProjectMedia> get media => _media;
  List<PaymentPlan> get paymentPlans => _paymentPlans;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentStep => _currentStep;
  
  // Initialize a new project
  void initNewProject(String developerId) {
    final newProject = Project(
      developerId: developerId,
      name: '',
      slug: '',
      locationState: '',
      locationLga: '',
      projectType: ProjectType.residential,
    );
    
    _currentProject = newProject;
    _phases = [];
    _unitTypes = [];
    _media = [];
    _paymentPlans = [];
    _currentStep = 0;
    _error = null;
    notifyListeners();
  }
  
  // Load an existing project for editing
  Future<void> loadProject(String projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final project = await _projectService.getProject(projectId);
      _currentProject = project;
      
      // Load related data
      await Future.wait([
        _loadProjectPhases(projectId),
        _loadProjectUnitTypes(projectId),
        _loadProjectMedia(projectId),
        _loadProjectPaymentPlans(projectId),
      ]);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // Load project phases
  Future<void> _loadProjectPhases(String projectId) async {
    try {
      _phases = await _projectService.getProjectPhases(projectId);
    } catch (e) {
      // Handle error but don't stop the whole process
      print('Error loading phases: $e');
      _phases = [];
    }
  }
  
  // Load project unit types
  Future<void> _loadProjectUnitTypes(String projectId) async {
    try {
      _unitTypes = await _projectService.getProjectUnitTypes(projectId);
    } catch (e) {
      print('Error loading unit types: $e');
      _unitTypes = [];
    }
  }
  
  // Load project media
  Future<void> _loadProjectMedia(String projectId) async {
    try {
      _media = await _projectService.getProjectMedia(projectId);
    } catch (e) {
      print('Error loading media: $e');
      _media = [];
    }
  }
  
  // Load project payment plans
  Future<void> _loadProjectPaymentPlans(String projectId) async {
    try {
      _paymentPlans = await _projectService.getProjectPaymentPlans(projectId);
    } catch (e) {
      print('Error loading payment plans: $e');
      _paymentPlans = [];
    }
  }
  
  // Update project basic info (step 1)
  void updateProjectBasicInfo({
    required String name,
    required String slug,
    String? description,
    required String locationState,
    required String locationLga,
    String? locationAddress,
    Map<String, double>? coordinates,
    required ProjectType projectType,
  }) {
    if (_currentProject == null) return;
    
    _currentProject = _currentProject!.copyWith(
      name: name,
      slug: slug,
      description: description,
      locationState: locationState,
      locationLga: locationLga,
      locationAddress: locationAddress,
      coordinates: coordinates,
      projectType: projectType,
    );
    
    notifyListeners();
  }
  
  // Update project details (step 2)
  void updateProjectDetails({
    int? totalUnits,
    required int totalPhases,
    DateTime? estimatedCompletionDate,
  }) {
    if (_currentProject == null) return;
    
    _currentProject = _currentProject!.copyWith(
      totalUnits: totalUnits,
      totalPhases: totalPhases,
      estimatedCompletionDate: estimatedCompletionDate,
    );
    
    notifyListeners();
  }
  
  // Add a project phase
  void addProjectPhase(ProjectPhase phase) {
    _phases.add(phase);
    notifyListeners();
  }
  
  // Update a project phase
  void updateProjectPhase(ProjectPhase updatedPhase) {
    final index = _phases.indexWhere((phase) => 
      phase.id == updatedPhase.id || 
      (phase.id == null && updatedPhase.id == null && phase.phaseNumber == updatedPhase.phaseNumber)
    );
    
    if (index != -1) {
      _phases[index] = updatedPhase;
      notifyListeners();
    }
  }
  
  // Remove a project phase
  void removeProjectPhase(ProjectPhase phase) {
    _phases.removeWhere((p) => 
      p.id == phase.id || 
      (p.id == null && phase.id == null && p.phaseNumber == phase.phaseNumber)
    );
    notifyListeners();
  }
  
  // Add a unit type
  void addUnitType(UnitType unitType) {
    _unitTypes.add(unitType);
    notifyListeners();
  }
  
  // Update a unit type
  void updateUnitType(UnitType updatedUnitType) {
    final index = _unitTypes.indexWhere((type) => type.id == updatedUnitType.id);
    if (index != -1) {
      _unitTypes[index] = updatedUnitType;
      notifyListeners();
    }
  }
  
  // Remove a unit type
  void removeUnitType(UnitType unitType) {
    _unitTypes.removeWhere((type) => type.id == unitType.id);
    notifyListeners();
  }
  
  // Add project media
  void addProjectMedia(ProjectMedia media) {
    _media.add(media);
    notifyListeners();
  }
  
  // Update project media
  void updateProjectMedia(ProjectMedia updatedMedia) {
    final index = _media.indexWhere((m) => m.id == updatedMedia.id);
    if (index != -1) {
      _media[index] = updatedMedia;
      notifyListeners();
    }
  }
  
  // Remove project media
  void removeProjectMedia(ProjectMedia media) {
    _media.removeWhere((m) => m.id == media.id);
    notifyListeners();
  }
  
  // Add a payment plan
  void addPaymentPlan(PaymentPlan plan) {
    _paymentPlans.add(plan);
    notifyListeners();
  }
  
  // Update a payment plan
  void updatePaymentPlan(PaymentPlan updatedPlan) {
    final index = _paymentPlans.indexWhere((plan) => plan.id == updatedPlan.id);
    if (index != -1) {
      _paymentPlans[index] = updatedPlan;
      notifyListeners();
    }
  }
  
  // Remove a payment plan
  void removePaymentPlan(PaymentPlan plan) {
    _paymentPlans.removeWhere((p) => p.id == plan.id);
    notifyListeners();
  }
  
  // Move to next step in the wizard
  void nextStep() {
    _currentStep++;
    notifyListeners();
  }
  
  // Move to previous step in the wizard
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }
  
  // Go to a specific step
  void goToStep(int step) {
    if (step >= 0) {
      _currentStep = step;
      notifyListeners();
    }
  }
  
  // Save the entire project
  Future<bool> saveProject() async {
    if (_currentProject == null) return false;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Save or update the project
      Project savedProject;
      if (_currentProject!.id == null) {
        savedProject = await _projectService.createProject(_currentProject!);
      } else {
        savedProject = await _projectService.updateProject(_currentProject!);
      }
      
      _currentProject = savedProject;
      
      // Save phases
      for (var phase in _phases) {
        final phaseToSave = phase.copyWith(projectId: savedProject.id);
        if (phase.id == null) {
          await _projectService.addProjectPhase(phaseToSave);
        }
        // Update existing phases if needed
      }
      
      // Save unit types
      for (var unitType in _unitTypes) {
        final unitTypeToSave = unitType.copyWith(projectId: savedProject.id);
        if (unitType.id == null) {
          await _projectService.addUnitType(unitTypeToSave);
        }
        // Update existing unit types if needed
      }
      
      // Save media
      for (var mediaItem in _media) {
        final mediaToSave = mediaItem.copyWith(projectId: savedProject.id);
        if (mediaItem.id == null) {
          await _projectService.addProjectMedia(mediaToSave);
        }
        // Update existing media if needed
      }
      
      // Save payment plans
      for (var plan in _paymentPlans) {
        final planToSave = plan.copyWith(projectId: savedProject.id);
        if (plan.id == null) {
          await _projectService.addPaymentPlan(planToSave);
        }
        // Update existing payment plans if needed
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Publish the project
  Future<bool> publishProject() async {
    if (_currentProject == null || _currentProject!.id == null) return false;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final publishedProject = await _projectService.publishProject(_currentProject!.id!);
      _currentProject = publishedProject;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Clear current project data
  void clearProject() {
    _currentProject = null;
    _phases = [];
    _unitTypes = [];
    _media = [];
    _paymentPlans = [];
    _currentStep = 0;
    _error = null;
    notifyListeners();
  }
}
