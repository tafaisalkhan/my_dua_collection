// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/font_scale_provider.dart';
import '../controllers/reminder_controller.dart';
import '../controllers/ad_entitlement_controller.dart';
import '../../../../core/services/backup_service.dart';
import '../../../../core/services/support_service.dart';
import '../../../../shared/widgets/no_ads_popup.dart';

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
          Text(
            'Dua Bundles',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.playlist_add,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: const Text(
                'Dua Bundle Setup',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Create and schedule groups of Duas to play automatically',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/dua-bundle'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Backup & Restore Database',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.download,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
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
                                leading: const Icon(
                                  Icons.folder_special_outlined,
                                ),
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
                        final file = await backupService
                            .saveBackupToDownloads();
                        if (context.mounted) {
                          if (file != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Backup saved to Downloads: ${file.path}',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Could not save to Downloads folder.',
                                ),
                              ),
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
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.restore,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
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
                      final success = await backupService
                          .restoreBackupFromFile();
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
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
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
            'Daily reading reminders',
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
                    title: const Text('Remind me to read a Dua'),
                    subtitle: const Text(
                      'Reminders stop for today when you mark it done',
                    ),
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
                  for (final time in settings.minutesOfDay)
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(
                        TimeOfDay(
                          hour: time ~/ 60,
                          minute: time % 60,
                        ).format(context),
                      ),
                      subtitle: const Text('Tap to change time'),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: time ~/ 60,
                            minute: time % 60,
                          ),
                        );
                        if (picked != null) {
                          await ref
                              .read(reminderControllerProvider.notifier)
                              .updateTime(time, picked.hour, picked.minute);
                        }
                      },
                      trailing: IconButton(
                        tooltip: 'Remove reminder',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => ref
                            .read(reminderControllerProvider.notifier)
                            .removeTime(time),
                      ),
                    ),
                  TextButton.icon(
                    onPressed: settings.minutesOfDay.length >= 5
                        ? null
                        : () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 23, minute: 0),
                            );
                            if (picked != null) {
                              await ref
                                  .read(reminderControllerProvider.notifier)
                                  .addTime(picked.hour, picked.minute);
                            }
                          },
                    icon: const Icon(Icons.add_alarm),
                    label: const Text('Add reminder time'),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text('Choose up to five times each day.'),
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
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.star_rounded, color: Colors.amber.shade700),
                  title: const Text('Rate App'),
                  subtitle: const Text('Leave a 5-star review on Google Play'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => NoAdsPopup.show(
                    context,
                    step: 0,
                    isAdFreePurchased: removeAds.entitled,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_rounded),
                  title: const Text('Share With Friends'),
                  subtitle: const Text('Share Favorite Dua on Google Play'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => SupportService.instance.shareApp(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.coffee_rounded, color: Colors.brown.shade600),
                  title: const Text('Buy Developer a Coffee'),
                  subtitle: Text(
                    'Support ongoing updates (${SupportService.instance.coffeePrice})',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      SupportService.instance.coffeePrice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final started = await SupportService.instance.buyCoffee();
                    if (!started && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Store is unavailable right now. Please try again later.',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
