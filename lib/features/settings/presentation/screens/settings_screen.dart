// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/font_scale_provider.dart';
import '../controllers/reminder_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontScaleProvider);
    final reminder = ref.watch(reminderControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.playlist_play),
              title: const Text('Dua Bundle Scheduler'),
              subtitle: const Text(
                'Combine Duas with individual repeats and daily, weekly, or monthly timing',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/dua-bundle'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Daily reminder',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: reminder.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => ListTile(
                leading: const Icon(Icons.error_outline),
                title: const Text('Could not load reminders'),
                subtitle: Text(error.toString()),
              ),
              data: (settings) => Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_active_outlined),
                    title: const Text('Daily Dua reminder'),
                    subtitle: const Text('Receive one reminder every day'),
                    value: settings.enabled,
                    onChanged: (value) async {
                      final allowed = await ref
                          .read(reminderControllerProvider.notifier)
                          .setEnabled(value);
                      if (!allowed && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Notification permission was not granted.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    enabled: settings.enabled,
                    leading: const Icon(Icons.schedule),
                    title: const Text('Reminder time'),
                    subtitle: Text(
                      TimeOfDay(
                        hour: settings.hour,
                        minute: settings.minute,
                      ).format(context),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: settings.enabled
                        ? () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: settings.hour,
                                minute: settings.minute,
                              ),
                            );
                            if (picked != null)
                              await ref
                                  .read(reminderControllerProvider.notifier)
                                  .setTime(picked.hour, picked.minute);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile(
                  value: ThemeMode.system,
                  groupValue: mode,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).setMode(v!),
                  title: const Text('System theme'),
                ),
                RadioListTile(
                  value: ThemeMode.light,
                  groupValue: mode,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).setMode(v!),
                  title: const Text('Light'),
                ),
                RadioListTile(
                  value: ThemeMode.dark,
                  groupValue: mode,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).setMode(v!),
                  title: const Text('Dark'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Text size', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.format_size),
              title: const Text('Font size'),
              subtitle: const Text('Changes Dua text, translations, and menus'),
              trailing: DropdownButton<double>(
                value: fontScale,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: 0.9, child: Text('Small')),
                  DropdownMenuItem(value: 1.0, child: Text('Medium')),
                  DropdownMenuItem(value: 1.15, child: Text('Large')),
                  DropdownMenuItem(value: 1.35, child: Text('Extra Large')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(fontScaleProvider.notifier).setScale(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
