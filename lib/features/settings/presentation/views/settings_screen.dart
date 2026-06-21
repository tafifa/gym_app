import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../history/data/models/workout_session_entity.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/shorebird/shorebird_service.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../../core/config/environment_config.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _checkingShorebird = false;
  Map<String, dynamic>? _shorebirdStatus;

  Future<void> _checkShorebirdUpdate() async {
    setState(() {
      _checkingShorebird = true;
      _shorebirdStatus = null;
    });

    final status = await ShorebirdService.checkAndDownloadUpdate();

    setState(() {
      _shorebirdStatus = status;
      _checkingShorebird = false;
    });
  }

  Future<void> _resetDatabase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Database?'),
        content: const Text('This will delete all workout programs and completed session history. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final store = ref.read(objectBoxProvider).store;
      
      // Clean ObjectBox boxes
      store.box<WorkoutSessionEntity>().removeAll();
      
      // Refresh providers
      ref.invalidate(workoutHistoryProvider);
      ref.invalidate(workoutProgramsProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database reset successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Push Notifications Card
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications_active, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Push Notifications (OneSignal)'),
                  subtitle: const Text('Enable or disable workout reminders'),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (val) {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? 'Notifications enabled!' : 'Notifications disabled!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    'Initialized using OneSignal Flutter SDK. Ensure your appId is updated in onesignal_service.dart.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Environment Config Card
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.cloud, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Environment'),
                  subtitle: const Text('Change the API environment'),
                  trailing: DropdownButton<AppEnvironment>(
                    value: ref.watch(environmentProvider),
                    onChanged: (AppEnvironment? newValue) {
                      if (newValue != null) {
                        ref.read(environmentProvider.notifier).updateEnvironment(newValue);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Environment changed to ${newValue.name}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    items: AppEnvironment.values.map<DropdownMenuItem<AppEnvironment>>((AppEnvironment env) {
                      return DropdownMenuItem<AppEnvironment>(
                        value: env,
                        child: Text(env.name),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Current API: ${ref.watch(environmentProvider).baseUrl}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Shorebird Code Push Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.system_update, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Shorebird Code Push (OTA)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Shorebird allows pushing over-the-air hot fixes without redistributing the app to stores.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  if (_shorebirdStatus != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Supported: ${_shorebirdStatus!['supported']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Current Patch: ${_shorebirdStatus!['currentPatch'] ?? 'None'}'),
                          Text('Status: ${_shorebirdStatus!['message']}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _checkingShorebird ? null : _checkShorebirdUpdate,
                        icon: _checkingShorebird
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh),
                        label: Text(_checkingShorebird ? 'Checking...' : 'Check For Updates'),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text(
                    'How to push updates with Shorebird CLI:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '1. shorebird init\n2. shorebird run\n3. shorebird patch',
                    style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Developer options card
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Reset Database', style: TextStyle(color: Colors.red)),
                  subtitle: const Text('Wipe all local ObjectBox databases'),
                  onTap: _resetDatabase,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
