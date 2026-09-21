import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
    this.onDelete,
    this.color,
  });
  final String name;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final Color? color;
  @override
  Widget build(BuildContext context) => Card(
    color: color,
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (onDelete != null)
                  IconButton(
                    tooltip: 'Delete category',
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.black87,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'View Duas',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    ),
  );
}
