// private navigators
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:refltter/view/screens/boards.dart';
import 'package:refltter/view/screens/home.dart';
import 'package:refltter/view/screens/login.dart';
import 'package:refltter/view/screens/news_notice_screen.dart';
import 'package:refltter/view/widgets/navigation.dart';

import 'view/screens/post_write_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigator1Key = GlobalKey<NavigatorState>(debugLabel: 'Home');
final _shellNavigator2Key = GlobalKey<NavigatorState>(debugLabel: '새소식');
final _shellNavigator3Key = GlobalKey<NavigatorState>(debugLabel: '커뮤니티');
final _shellNavigator4Key = GlobalKey<NavigatorState>(debugLabel: '설정');
final _shellNavigator5Key = GlobalKey<NavigatorState>(debugLabel: '이바타');

final goRouter = GoRouter(
  initialLocation: '/',
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
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RootScreen(label: 'COSMOSX 월컴', detailsPath: '/PostWrite'),
              ),
              routes: [
                GoRoute(
                  path: 'PostWrite',
                  builder: (context, state) => const PostWrite(),
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
              redirect: (context,state) {
                if (state.location  == '/nwn') {
                  return '/nwn/news';
                }
                return null;
              },
              pageBuilder: (context, state) => const NoTransitionPage(
                child: NewsNoticeMain(label: 'nwn', detailsPath: '/nwn/news'),
              ),
              routes: [
                GoRoute(
                  path: 'news',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: News(label: 'News', detailPath: '/nwn/news/s',),
                  ),
                  routes: [
                    GoRoute(
                      path: 's',
                      builder: (BuildContext context, GoRouterState state) {
                        print('Current path: ${state.location}');
                        print('Query parameters: ${state.queryParameters}');
                        final id = state.queryParameters['itemIndex'];
                        return NewsDetailsScreen(
                          label: 'COSMOSX > 공지게시판',
                          itemIndex: id,
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'notice',
                  pageBuilder: (context, state) => const NoTransitionPage(
                  child: Notice(label: 'Notice', detailPath: '/nwn/notice/noticeread',),
                  ),
                  routes: [
                    GoRoute(
                      path: 'noticeread',
                      builder: (BuildContext context, GoRouterState state) {
                        print('Current path: ${state.location}');
                        print('Query parameters: ${state.queryParameters}');
                        final id = state.queryParameters['itemIndex'];
                        return NoticeDetailsScreen(
                          label: 'COSMOSX > 공지게시판',
                          itemIndex: id,
                        );
                      },
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
  ],
);


