import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/supabase_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../models/exercise_model.dart';

class ExerciseCatalogState {
  final bool isLoading;
  final List<ExerciseModel> allExercises;
  final List<ExerciseModel> filteredExercises;
  final String searchQuery;
  final String selectedMuscle; // 'all' or muscle name
  final String selectedSfr;    // 'all', 'elite', 'high', 'medium'
  final String? jointFriendlyFilter; // null, 'shoulder', 'lower_back', 'knee'

  const ExerciseCatalogState({
    this.isLoading = true,
    this.allExercises = const [],
    this.filteredExercises = const [],
    this.searchQuery = '',
    this.selectedMuscle = 'Tümü',
    this.selectedSfr = 'Tümü',
    this.jointFriendlyFilter,
  });

  ExerciseCatalogState copyWith({
    bool? isLoading,
    List<ExerciseModel>? allExercises,
    List<ExerciseModel>? filteredExercises,
    String? searchQuery,
    String? selectedMuscle,
    String? selectedSfr,
    String? jointFriendlyFilter,
  }) {
    return ExerciseCatalogState(
      isLoading: isLoading ?? this.isLoading,
      allExercises: allExercises ?? this.allExercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMuscle: selectedMuscle ?? this.selectedMuscle,
      selectedSfr: selectedSfr ?? this.selectedSfr,
      jointFriendlyFilter: jointFriendlyFilter ?? this.jointFriendlyFilter,
    );
  }
}

final exerciseCatalogProvider = StateNotifierProvider<ExerciseCatalogNotifier, ExerciseCatalogState>((ref) {
  return ExerciseCatalogNotifier();
});

class ExerciseCatalogNotifier extends StateNotifier<ExerciseCatalogState> {
  ExerciseCatalogNotifier() : super(const ExerciseCatalogState()) {
    loadExercises();
  }

  Future<void> loadExercises() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await SupabaseService.client
          .from('exercises')
          .select()
          .order('cns_load_score');

      final list = (data as List).map((json) => ExerciseModel.fromJson(json)).toList();
      await LocalStorageService.saveJson('twinfit_cached_exercises', data);

      state = state.copyWith(
        isLoading: false,
        allExercises: list,
        filteredExercises: list,
      );
    } catch (e) {
      debugPrint('Error loading exercises: $e');
      final cached = LocalStorageService.getJson('twinfit_cached_exercises');
      if (cached != null) {
        final list = (cached as List).map((json) => ExerciseModel.fromJson(json)).toList();
        state = state.copyWith(isLoading: false, allExercises: list, filteredExercises: list);
      } else {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  void setSearchQuery(String q) {
    state = state.copyWith(searchQuery: q);
    _applyFilters();
  }

  void setSelectedMuscle(String m) {
    state = state.copyWith(selectedMuscle: m);
    _applyFilters();
  }

  void setSelectedSfr(String sfr) {
    state = state.copyWith(selectedSfr: sfr);
    _applyFilters();
  }

  void toggleJointFilter(String? joint) {
    state = state.copyWith(
      jointFriendlyFilter: state.jointFriendlyFilter == joint ? null : joint,
    );
    _applyFilters();
  }

  void _applyFilters() {
    List<ExerciseModel> result = List.from(state.allExercises);

    // Search Query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      result = result.where((e) =>
          e.name.toLowerCase().contains(query) ||
          e.turkishName.toLowerCase().contains(query) ||
          e.targetMuscle.toLowerCase().contains(query)).toList();
    }

    // Muscle Filter
    if (state.selectedMuscle != 'Tümü') {
      result = result.where((e) => e.targetMuscle.toLowerCase().contains(state.selectedMuscle.toLowerCase())).toList();
    }

    // SFR Filter
    if (state.selectedSfr != 'Tümü') {
      result = result.where((e) => e.sfrRating.toLowerCase() == state.selectedSfr.toLowerCase()).toList();
    }

    // Joint Filter
    if (state.jointFriendlyFilter != null) {
      final joint = state.jointFriendlyFilter!;
      result = result.where((e) {
        final score = e.jointStressIndex[joint] as num? ?? 0;
        return score <= 2; // Low stress on this joint
      }).toList();
    }

    state = state.copyWith(filteredExercises: result);
  }

  /// Substitute generator: Finds movements matching same target muscle with lowest joint stress / highest SFR
  List<ExerciseModel> findSubstitutes(ExerciseModel original) {
    return state.allExercises.where((e) {
      if (e.id == original.id) return false;
      return e.targetMuscle == original.targetMuscle ||
          e.synergistMuscles.any((s) => original.synergistMuscles.contains(s));
    }).take(3).toList();
  }
}
