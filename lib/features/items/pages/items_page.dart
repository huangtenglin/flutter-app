import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_multi_platform_app/mock/items_mock.dart';
import 'package:my_multi_platform_app/widgets/stateless/item_row.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key, this.filter});

  final String? filter;

  @override
  Widget build(BuildContext context) {
    final items = ItemsMock.filtered(filter);
    final title = switch (filter) {
      'fresh' => 'Fresh',
      'stale' => 'Stale',
      _ => 'Items',
    };
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Pair a tracker',
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemRow(
            item: item,
            onTap: () => context.push('/items/${item.id}'),
          );
        },
      ),
    );
  }
}
