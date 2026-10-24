import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_multi_platform_app/features/find/pages/find_page.dart';
import 'package:my_multi_platform_app/features/home/pages/home_page.dart';
import 'package:my_multi_platform_app/features/items/pages/items_page.dart';
import 'package:my_multi_platform_app/features/shell/pages/placeholder_page.dart';
import 'package:my_multi_platform_app/features/shell/pages/shell_page.dart';

final _rootKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomePage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/items',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ItemsPage(filter: state.uri.queryParameters['filter']),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootKey,
                  builder: (context, state) => PlaceholderPage(
                    title: 'Item detail',
                    itemId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/alerts',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PlaceholderPage(
                  title: 'Alerts',
                  subtitle: 'Open / All grouping lands with the alerts sprint.',
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PlaceholderPage(
                  title: 'Settings',
                  subtitle: 'White-label and billing land later.',
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/find/:id',
      parentNavigatorKey: _rootKey,
      builder: (context, state) => FindPage(
        itemId: state.pathParameters['id'] ?? 'bag',
      ),
    ),
    GoRoute(
      path: '/places/:id',
      parentNavigatorKey: _rootKey,
      builder: (context, state) => PlaceholderPage(
        title: 'Location history',
        subtitle: "Today's route and playback.",
        itemId: state.pathParameters['id'],
      ),
    ),
  ],
);
