// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/backup_service.dart';

class BackupRestoreScreen extends ConsumerWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Backup & Restore Database',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Safely backup your saved Duas, audio recitations, scanned images, and custom categories into a single backup file or restore a previous backup.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 16),
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
        ],
      ),
    );
  }
}
