import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import 'workout_detail_screen.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutProgramsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Programs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync from Remote',
            onPressed: () {
              ref.read(workoutProgramsProvider.notifier).syncWorkouts();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing workouts from server...')),
              );
            },
          ),
        ],
      ),
      body: workoutsAsync.when(
        data: (programs) {
          if (programs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No workout programs available.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(workoutProgramsProvider.notifier).syncWorkouts();
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Fetch Programs'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final program = programs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailScreen(program: program),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              program.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Chip(
                              label: Text(program.level),
                              color: WidgetStateProperty.all(
                                program.level == 'Beginner'
                                    ? Colors.green.shade100
                                    : program.level == 'Intermediate'
                                        ? Colors.orange.shade100
                                        : Colors.red.shade100,
                              ),
                              labelStyle: TextStyle(
                                color: program.level == 'Beginner'
                                    ? Colors.green.shade800
                                    : program.level == 'Intermediate'
                                        ? Colors.orange.shade800
                                        : Colors.red.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          program.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 20),
                            const SizedBox(width: 4),
                            Text('${program.durationMinutes} min'),
                            const SizedBox(width: 24),
                            const Icon(Icons.fitness_center_outlined, size: 20),
                            const SizedBox(width: 4),
                            Text('${program.exercises.length} Exercises'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${err.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(workoutProgramsProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
