import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_shimmer.dart';
import '../providers/dashboard_provider.dart';
import 'widgets/digital_twin_card.dart';
import 'widgets/nutrition_card.dart';
import 'widgets/golden_path_hero_card.dart';
import '../../exercise_catalog/presentation/exercise_catalog_screen.dart';
import '../../ai_coach/presentation/ai_coach_screen.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../golden_path/providers/workout_provider.dart';
import '../../golden_path/presentation/workout_session_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const _DashboardHomeTab(),
    const ExerciseCatalogScreen(),
    const AiCoachScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.darkBorder, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiaryDark,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Kokpit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_outlined),
              activeIcon: Icon(Icons.fitness_center),
              label: 'Kütüphane',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              activeIcon: Icon(Icons.auto_awesome),
              label: 'TwinFit AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              activeIcon: Icon(Icons.insights),
              label: 'Gelişim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHomeTab extends ConsumerWidget {
  const _DashboardHomeTab();

  void _startWorkoutSession(BuildContext context, WidgetRef ref, Map<String, dynamic> routine, List<Map<String, dynamic>> exercises) {
    ref.read(workoutProvider.notifier).startWorkout(
          title: routine['routine_name'] ?? 'Altın Rota Antrenmanı',
          rawExercises: exercises.isNotEmpty
              ? exercises
              : [
                  {
                    'name': 'Incline Dumbbell Bench Press',
                    'target_muscle': 'Göğüs (Üst Göğüs)',
                    'cns_load_score': 5,
                    'sfr_rating': 'elite',
                    'target_sets': 3,
                    'target_weight_kg': 32.0,
                    'target_reps_min': 8,
                    'target_reps_max': 12,
                    'rest_seconds': 90,
                  },
                  {
                    'name': 'Chest-Supported T-Bar Row',
                    'target_muscle': 'Sırt & Lats',
                    'cns_load_score': 4,
                    'sfr_rating': 'high',
                    'target_sets': 3,
                    'target_weight_kg': 50.0,
                    'target_reps_min': 8,
                    'target_reps_max': 12,
                    'rest_seconds': 90,
                  },
                  {
                    'name': 'Cable Lateral Raise',
                    'target_muscle': 'Yan Omuz',
                    'cns_load_score': 2,
                    'sfr_rating': 'elite',
                    'target_sets': 4,
                    'target_weight_kg': 12.5,
                    'target_reps_min': 12,
                    'target_reps_max': 15,
                    'rest_seconds': 60,
                  },
                ],
        );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WorkoutSessionScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    if (dashboard.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              TwinShimmer(width: double.infinity, height: 180),
              SizedBox(height: 16),
              TwinShimmer(width: double.infinity, height: 160),
              SizedBox(height: 16),
              TwinShimmer(width: double.infinity, height: 140),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.polyline, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text(
              'TWINFIT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: AppColors.textPrimaryDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(dashboardProvider.notifier).loadDashboardData(),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(dashboardProvider.notifier).loadDashboardData(),
          color: AppColors.primary,
          backgroundColor: AppColors.darkSurface,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              // 1. Digital Twin Kas Haritası & CNS
              DigitalTwinCard(
                cnsFatigueIndex: dashboard.cnsFatigueIndex,
                muscleRecoveryList: dashboard.muscleRecoveryList,
              ),
              const SizedBox(height: 16),

              // 2. Günün Altın Rotası Hero Card
              if (dashboard.activeRoutine != null) ...[
                GoldenPathHeroCard(
                  routine: dashboard.activeRoutine!,
                  exercises: dashboard.routineExercises,
                  onStartWorkout: () => _startWorkoutSession(
                    context,
                    ref,
                    dashboard.activeRoutine!,
                    dashboard.routineExercises,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 3. Beslenme & Hidrasyon Kartı
              NutritionCard(
                caloriesConsumed: dashboard.caloriesConsumed,
                caloriesTarget: dashboard.caloriesTarget,
                proteinG: dashboard.proteinG,
                proteinTargetG: dashboard.proteinTargetG,
                carbG: dashboard.carbG,
                carbTargetG: dashboard.carbTargetG,
                fatG: dashboard.fatG,
                fatTargetG: dashboard.fatTargetG,
                waterMl: dashboard.waterMl,
                waterTargetMl: dashboard.waterTargetMl,
                onAddWater: () => ref.read(dashboardProvider.notifier).addWater(250),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
