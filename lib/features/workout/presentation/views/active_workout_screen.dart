import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/workout_program.dart';
import '../../../history/domain/entities/workout_session.dart';
import '../../../history/presentation/providers/history_provider.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final WorkoutProgram program;

  const ActiveWorkoutScreen({super.key, required this.program});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _timeString = "00:00";
  
  // Stores the logs: exercise index -> set index -> reps & weight controllers
  final List<List<SetLogController>> _exerciseLogControllers = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTime);

    // Initialize text controllers for reps and weights based on default program exercises
    for (final exercise in widget.program.exercises) {
      final setControllers = List.generate(
        exercise.sets,
        (index) => SetLogController(
          repsController: TextEditingController(text: exercise.reps.toString()),
          weightController: TextEditingController(text: exercise.defaultWeight.toString()),
        ),
      );
      _exerciseLogControllers.add(setControllers);
    }
  }

  void _updateTime(Timer timer) {
    if (_stopwatch.isRunning) {
      final duration = _stopwatch.elapsed;
      final minutes = duration.inMinutes.toString().padLeft(2, '0');
      final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      setState(() {
        _timeString = "$minutes:$seconds";
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    for (final setControllers in _exerciseLogControllers) {
      for (final controller in setControllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _finishWorkout() async {
    _timer.cancel();
    _stopwatch.stop();
    final durationMinutes = _stopwatch.elapsed.inMinutes;

    final List<ExerciseLog> exercisesDone = [];
    for (int i = 0; i < widget.program.exercises.length; i++) {
      final exercise = widget.program.exercises[i];
      final controllers = _exerciseLogControllers[i];

      final List<SetLog> sets = [];
      for (final controller in controllers) {
        final reps = int.tryParse(controller.repsController.text) ?? 0;
        final weight = double.tryParse(controller.weightController.text) ?? 0.0;
        sets.add(SetLog(reps: reps, weight: weight));
      }

      exercisesDone.add(
        ExerciseLog(
          exerciseName: exercise.name,
          category: exercise.category,
          sets: sets,
        ),
      );
    }

    final session = WorkoutSession(
      id: 0, // ObjectBox auto-generates IDs when set to 0
      programName: widget.program.name,
      dateTime: DateTime.now(),
      durationMinutes: durationMinutes > 0 ? durationMinutes : 1, // at least 1 minute
      exercises: exercisesDone,
    );

    // Save session to ObjectBox and refresh history provider
    await ref.read(workoutHistoryProvider.notifier).addSession(session);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Workout Completed! 🎉'),
          content: Text(
            'Congratulations! You completed ${widget.program.name} in $durationMinutes minute(s). Your session has been saved.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Pop dialog
                Navigator.pop(context); // Pop active workout screen back to dashboard
              },
              child: const Text('Great!'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Workout'),
        automaticallyImplyLeading: false, // Prevent accidental back navigation
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Cancel Workout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cancel Workout?'),
                  content: const Text('Are you sure you want to end this workout? Progress will not be saved.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Pop dialog
                        Navigator.pop(context); // Pop active workout screen
                      },
                      child: const Text('Yes, Cancel'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer Widget
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Column(
                children: [
                  const Text('ELAPSED TIME'),
                  Text(
                    _timeString,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.program.exercises.length,
              itemBuilder: (context, exIndex) {
                final exercise = widget.program.exercises[exIndex];
                final setControllers = _exerciseLogControllers[exIndex];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          exercise.category,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        const Divider(),
                        // Header row for Sets
                        const Row(
                          children: [
                            Expanded(child: Text('SET', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('KG', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('REPS', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Sets list
                        ...List.generate(exercise.sets, (setIndex) {
                          final controller = setControllers[setIndex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CircleAvatar(
                                    maxRadius: 16,
                                    child: Text('${setIndex + 1}'),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controller.weightController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: controller.repsController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
            onPressed: _finishWorkout,
            icon: const Icon(Icons.check),
            label: const Text('Finish Workout'),
          ),
        ),
      ),
    );
  }
}

class SetLogController {
  final TextEditingController repsController;
  final TextEditingController weightController;

  SetLogController({
    required this.repsController,
    required this.weightController,
  });

  void dispose() {
    repsController.dispose();
    weightController.dispose();
  }
}
