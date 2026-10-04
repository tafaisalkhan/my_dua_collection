// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/font_scale_provider.dart';
import '../controllers/reminder_controller.dart';
import '../controllers/ad_entitlement_controller.dart';
import '../../../../core/services/backup_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontScaleProvider);
    final reminder = ref.watch(reminderControllerProvider);
    final removeAds = ref.watch(removeAdsPurchaseProvider);
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
          Text(
            'Backup & Restore Database',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.download, color: Colors.white),
                  ),
                  title: const Text(
                    'Download Backup to Downloads',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Saves .bin backup directly into your phone\'s public Downloads folder (/Download/)',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    try {
                      final option = await showModalBottomSheet<String>(
                        context: context,
                        builder: (c) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.folder_special_outlined),
                                title: const Text('Save to Downloads Folder'),
                                subtitle: const Text(
                                  'Saves directly into /storage/emulated/0/Download/',
                                ),
                                onTap: () => Navigator.pop(c, 'download'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.share_outlined),
                                title: const Text('Share / Send File'),
                                subtitle: const Text(
                                  'Share via WhatsApp, Google Drive, Email, or Bluetooth',
                                ),
                                onTap: () => Navigator.pop(c, 'share'),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (option == null) return;

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Preparing backup file...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }

                      final backupService = ref.read(backupServiceProvider);
                      if (option == 'download') {
                        final file = await backupService.saveBackupToDownloads();
                        if (context.mounted) {
                          if (file != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Backup saved to Downloads: ${file.path}'),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not save to Downloads folder.')),
                            );
                          }
                        }
                      } else if (option == 'share') {
                        await backupService.shareBackup();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Backup failed: $e'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: Icon(Icons.restore, color: Colors.white),
                  ),
                  title: const Text(
                    'Restore Database & Files',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Pick a backup file from your Downloads folder or File Manager to restore',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Restore Backup?'),
                        content: const Text(
                          'Restoring will overwrite your current app database and restore all voice audio recordings and scanned images from the selected backup file. Continue?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(c, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(c, true),
                            child: const Text('Restore'),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    try {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Restoring backup file...'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                      final backupService = ref.read(backupServiceProvider);
                      final success = await backupService.restoreBackupFromFile();
                      if (context.mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Backup restored successfully! Restarting view...',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          context.go('/home');
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Restore failed: $e'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
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
          const SizedBox(height: 24),
          Text('Support', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: removeAds.entitled
                ? const ListTile(
                    leading: Icon(Icons.verified_outlined),
                    title: Text('Ads removed'),
                    subtitle: Text(
                      'Your Google Play Remove Ads purchase is active.',
                    ),
                  )
                : Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.block_outlined),
                        title: const Text('Remove Ads'),
                        subtitle: Text(
                          removeAds.product == null
                              ? 'One-time Google Play purchase'
                              : 'One-time purchase • ${removeAds.product!.price}',
                        ),
                        trailing: removeAds.loading || removeAds.purchasePending
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.chevron_right),
                        onTap: removeAds.loading || removeAds.purchasePending
                            ? null
                            : () => ref
                                  .read(removeAdsPurchaseProvider.notifier)
                                  .buy(),
                      ),
                      const Divider(height: 1),
                      TextButton.icon(
                        onPressed: removeAds.purchasePending
                            ? null
                            : () => ref
                                  .read(removeAdsPurchaseProvider.notifier)
                                  .restore(),
                        icon: const Icon(Icons.restore),
                        label: const Text('Restore purchase'),
                      ),
                      if (removeAds.message != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            removeAds.message!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
