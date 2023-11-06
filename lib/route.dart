// private navigators
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'screens/NewsnNotice.dart';
import 'screens/boards.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'widgets/navigation.dart';


final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigator1Key = GlobalKey<NavigatorState>(debugLabel: 'Home');
final _shellNavigator2Key = GlobalKey<NavigatorState>(debugLabel: '새소식');
final _shellNavigator3Key = GlobalKey<NavigatorState>(debugLabel: '커뮤니티');
final _shellNavigator4Key = GlobalKey<NavigatorState>(debugLabel: '설정');
final _shellNavigator5Key = GlobalKey<NavigatorState>(debugLabel: '이바타');

final _shellNavigatorAAKey = GlobalKey<NavigatorState>(debugLabel: 'shellAAAA');
final _shellNavigatorBBKey = GlobalKey<NavigatorState>(debugLabel: 'shellBBBB');
final _shellNavigatorCCKey = GlobalKey<NavigatorState>(debugLabel: 'shellCCC');
final _shellNavigatorFFKey = GlobalKey<NavigatorState>(debugLabel: 'shellDDDDd');

final goRouter = GoRouter(
  initialLocation: '/main',
  // * Passing a navigatorKey causes an issue on hot reload:
  // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
  // * However it's still necessary otherwise the navigator pops back to
  // * root on hot reload
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    // Stateful navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigator1Key,
          routes: [
            GoRoute(
              path: '/main',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RootScreen(label: 'COSMOSX 월컴', detailsPath: '/main/details'),
              ),
              routes: [
                GoRoute(
                  path: 'details',
                  builder: (context, state) => const DetailsScreen(label: 'A아님감'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigator2Key,
          routes: [
            // Shopping Cart
            GoRoute(
              path: '/nwn',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: NwN(label: 'nwn', detailsPath: '/nwn/news',),
              ),
              routes: [
                GoRoute(
                  path: 'news',
                  builder: (context, state) => const News(label: 'News'),
                ),
                GoRoute(
                  path: 'notice',
                  pageBuilder: (context, state) => const NoTransitionPage(
                  child: Notice(label: 'Notice', detailPath: '/nwn/notice/noticeread',),
                  ),
                  routes: [
                    GoRoute(
                      path: 'noticeread',
                      builder: (context, state) => const NoticeDetailsScreen(label: 'A아님감'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigator3Key,
          routes: [
            // Shopping Cart
            GoRoute(
              path: '/boards',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: Boards(label: '커뮤니티 게시판', detailsPath: '/boards/free'),
              ),
              routes: [
                GoRoute(
                  path: 'free',
                  builder: (context, state) => const BoadrsFree(label: 'free'),
                ),
                GoRoute(
                  path: 'develop',
                  builder: (context, state) => const BoadrsDevelop(label: 'develop'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigator4Key,
          routes: [
            // Shopping Cart
            GoRoute(
              path: '/set',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RootScreen(label: '셋업', detailsPath: '/set/details'),
              ),
              routes: [
                GoRoute(
                  path: 'details',
                  builder: (context, state) => const DetailsScreen(label: 'C'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigator5Key,
          routes: [
            // Shopping Cart
            GoRoute(
              path: '/login',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: Login(label: 'D', detailsPath_a: '/login/details',),
              ),
              routes: [
                GoRoute(
                  path: 'details',
                  builder: (context, state) => const DetailsScreen(label: 'B'),
                ),
              ],
            ),
          ],
        ),
      ],
    ),




    // StatefulShellRoute.indexedStack(
    //   builder: (context, state, navigationShell) {
    //     return BaseDrawer(navigationShell: navigationShell, drawer: Drawer(),);
    //   },
    //   branches: [
    //     StatefulShellBranch(
    //       navigatorKey: _shellNavigatorAAKey,
    //       routes: [
    //         GoRoute(
    //           path: '/a',
    //           pageBuilder: (context, state) => const NoTransitionPage(
    //             child: RootScreen(label: 'A인감', detailsPath: '/a/details'),
    //           ),
    //           routes: [
    //             GoRoute(
    //               path: 'details',
    //               builder: (context, state) => const DetailsScreen(label: 'A아님감'),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       navigatorKey: _shellNavigatorBBKey,
    //       routes: [
    //         // Shopping Cart
    //         GoRoute(
    //           path: '/b',
    //           pageBuilder: (context, state) => const NoTransitionPage(
    //             child: RootScreen(label: 'B', detailsPath: '/b/details'),
    //           ),
    //           routes: [
    //             GoRoute(
    //               path: 'details',
    //               builder: (context, state) => const DetailsScreen(label: 'B'),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       navigatorKey: _shellNavigatorCCKey,
    //       routes: [
    //         // Shopping Cart
    //         GoRoute(
    //           path: '/ccc',
    //           pageBuilder: (context, state) => const NoTransitionPage(
    //             child: RootScreen(label: 'ccc', detailsPath: '/ccc/details'),
    //           ),
    //           routes: [
    //             GoRoute(
    //               path: 'details',
    //               builder: (context, state) => const DetailsScreen(label: 'B'),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       navigatorKey: _shellNavigatorFFKey,
    //       routes: [
    //         // Shopping Cart
    //         GoRoute(
    //           path: '/FF',
    //           pageBuilder: (context, state) => const NoTransitionPage(
    //             child: Login(label: 'FF', detailsPath_a: '/FF/details',),
    //           ),
    //           routes: [
    //             GoRoute(
    //               path: 'details',
    //               builder: (context, state) => const DetailsScreen(label: 'B'),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
  ],
);
