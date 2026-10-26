import 'package:flutter/material.dart';
import '../../../../core/theme/dua_palette.dart';

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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = color ?? DuaPalette.forCategory(name);
    final cardColor = isDark
        ? colors.surface
        : Color.lerp(base, Colors.white, .28)!;
    final ink = isDark ? colors.onSurface : const Color(0xFF183A29);
    final accent = isDark
        ? colors.primary
        : Color.lerp(base, const Color(0xFF183A29), .7)!;
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: accent.withValues(alpha: .28)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, color: accent),
                  ),
                  const Spacer(),
                  if (onDelete != null)
                    IconButton(
                      tooltip: 'Delete category',
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_outline, color: ink),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                  color: ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'View Duas  →',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
