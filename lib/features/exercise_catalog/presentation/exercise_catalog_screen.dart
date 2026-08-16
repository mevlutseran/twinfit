import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_card.dart';
import '../../../core/widgets/twin_badge.dart';
import '../../../core/widgets/twin_input_field.dart';
import '../../../core/widgets/twin_shimmer.dart';
import '../providers/exercise_catalog_provider.dart';
import 'exercise_detail_screen.dart';

class ExerciseCatalogScreen extends ConsumerWidget {
  const ExerciseCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(exerciseCatalogProvider);
    final notifier = ref.read(exerciseCatalogProvider.notifier);

    final muscleFilters = ['Tümü', 'Göğüs', 'Sırt', 'Omuz', 'Bacak', 'Kol'];
    final sfrFilters = ['Tümü', 'elite', 'high', 'medium'];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Biyomekanik Kütüphane',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TwinInputField(
                hintText: 'Egzersiz veya kas grubu ara...',
                prefixIcon: Icons.search,
                onChanged: notifier.setSearchQuery,
              ),
            ),

            // Muscle Group Filter Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: muscleFilters.length,
                itemBuilder: (context, idx) {
                  final m = muscleFilters[idx];
                  final isSelected = catalog.selectedMuscle == m;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(m),
                      onSelected: (_) => notifier.setSelectedMuscle(m),
                      backgroundColor: AppColors.darkSurface,
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondaryDark,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.darkBorder,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),

            // SFR Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const Text('SFR Seviyesi: ', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark, fontWeight: FontWeight.w600)),
                  ...sfrFilters.map((sfr) {
                    final isSel = catalog.selectedSfr.toLowerCase() == sfr.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => notifier.setSelectedSfr(sfr),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.primary.withValues(alpha: 0.15) : AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSel ? AppColors.primary : AppColors.darkBorder),
                          ),
                          child: Text(
                            sfr.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                              color: isSel ? AppColors.primary : AppColors.textSecondaryDark,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Exercise List
            Expanded(
              child: catalog.isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 4,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: TwinShimmer(width: double.infinity, height: 90),
                      ),
                    )
                  : catalog.filteredExercises.isEmpty
                      ? const Center(
                          child: Text(
                            'Kriterlere uygun egzersiz bulunamadı.',
                            style: TextStyle(color: AppColors.textSecondaryDark),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: catalog.filteredExercises.length,
                          itemBuilder: (context, idx) {
                            final ex = catalog.filteredExercises[idx];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TwinCard(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: ex)),
                                  );
                                },
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    // Equipment Icon Container
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkSurfaceElevated,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 22),
                                    ),
                                    const SizedBox(width: 14),

                                    // Name & Muscle
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ex.turkishName.isNotEmpty ? ex.turkishName : ex.name,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimaryDark,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${ex.targetMuscle} • ${ex.equipment}',
                                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // SFR & CNS Badges
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        TwinBadge.sfr(ex.sfrRating),
                                        const SizedBox(height: 4),
                                        TwinBadge.cns(ex.cnsLoadScore),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
