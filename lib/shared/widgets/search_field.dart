import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => TextField(
    readOnly: onTap != null,
    onTap: onTap,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.search),
      hintText: 'Search Duas...',
    ),
  );
}
