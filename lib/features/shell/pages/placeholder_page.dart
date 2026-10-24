import 'package:flutter/material.dart';
import 'package:my_multi_platform_app/mock/items_mock.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.title,
    this.subtitle,
    this.itemId,
  });

  final String title;
  final String? subtitle;
  final String? itemId;

  @override
  Widget build(BuildContext context) {
    final item = itemId == null ? null : ItemsMock.byId(itemId!);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            [
              subtitle ?? 'Coming in a later sprint.',
              if (item != null) item.name,
            ].join('\n'),
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.5),
          ),
        ),
      ),
    );
  }
}
