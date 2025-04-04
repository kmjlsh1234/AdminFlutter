// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/app/pages/board_page/board_write_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/drop_out_user_page/drop_out_user_list_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/menu/menu_list_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/privilege/privilege_list_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/menus_page/role/role_list_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/bundle/bundle_list_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/item/item_add_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/item_unit/item_unit_list_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/product/product_add_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/product/product_info_view.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/user_currency_record_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../pages/shop/bundle/bundle_add_view.dart';
import '../pages/shop/bundle/bundle_info_view.dart';
import '../pages/shop/item/item_info_view.dart';
import '../pages/shop/product/products_list_view.dart';
import '../pages/user_manage_page/user_profile_view.dart' as userMng;
import '../pages/admin_manage_page/admin_profile_view.dart';
import '../pages/admin_manage_page/admin_list_view.dart';
import '../pages/app_version_page/app_version_list_view.dart';
import '../pages/board_page/board_info_view.dart';
import '../pages/board_page/board_list_view.dart';
import '../pages/pages.dart';
import '../pages/shop/category/category_list_view.dart';
import '../pages/shop/item/item_list_view.dart';
import '../pages/user_manage_page/user_currency_view.dart';
import '../pages/user_manage_page/user_list_view.dart';
import '../providers/providers.dart';

abstract class AcnooAppRoutes {
  //--------------Navigator Keys--------------//
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _emailShellNavigatorKey = GlobalKey<NavigatorState>();

  //--------------Navigator Keys--------------//

  static const _initialPath = '/';
  static final routerConfig = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: _initialPath,
    routes: [
      // Landing Route Handler
      GoRoute(
        path: _initialPath,
        redirect: (context, state) {
          final _appLangProvider = Provider.of<AppLanguageProvider>(context);

          if (state.uri.queryParameters['rtl'] == 'true') {
            _appLangProvider.isRTL = true;
          }
          return '/admins';
        },
      ),
      // Global Shell Route
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: ShellRouteWrapper(child: child),
          );
        },
        routes: [
          //Admins Route
          GoRoute(
            path: '/admins',
            redirect: (context, state) async {
              if (state.fullPath == '/admins') {
                return '/admins/admin-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'admin-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AdminsListView(),
                ),
              ),
              GoRoute(
                path: 'profile/:id',
                pageBuilder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  final int adminId = int.parse(id);
                  return NoTransitionPage<void>(
                    child: AdminProfileView(adminId: adminId),
                  );
                },
              ),
            ],
          ),

          // Users Route
          GoRoute(
            path: '/users',
            redirect: (context, state) async {
              if (state.fullPath == '/users') {
                return '/users/user-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'user-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UserListView(),
                ),
              ),
              GoRoute(
                path: 'block-user-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UserListView(),
                ),
              ),
              GoRoute(
                path: 'drop-out-user-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DropOutUserListView(),
                ),
              ),
              GoRoute(
                path: 'profile/:id',
                pageBuilder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  final int userId = int.parse(id);
                  return NoTransitionPage<void>(
                    child: userMng.UserProfileView(userId: userId),
                  );
                },
              ),
              GoRoute(
                path: 'currency/:id',
                pageBuilder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  final int userId = int.parse(id);
                  return NoTransitionPage<void>(
                    child: UserCurrencyView(userId: userId),
                  );
                },
              ),
              GoRoute(
                path: 'currency/record/:id',
                pageBuilder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  final int userId = int.parse(id);
                  return NoTransitionPage<void>(
                    child: UserCurrencyRecordView(userId: userId)
                  );
                },
              ),
            ],
          ),

          //System Route
          GoRoute(
            path: '/systems',
            redirect: (context, state) async {
              if (state.fullPath == '/systems') {
                return '/systems/version-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'version-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AppVersionListView(),
                ),
              ),
            ],
          ),

          //Board Route
          GoRoute(
            path: '/boards',
            redirect: (context, state) async {
              if (state.fullPath == '/boards') {
                return '/boards/board-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'board-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BoardListView(),
                ),
              ),
              GoRoute(
                path: 'write',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BoardWriteView(),
                ),
              ),
              GoRoute(
                path: 'info/:id',
                pageBuilder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  final int boardId = int.parse(id);
                  return NoTransitionPage<void>(
                    child: BoardInfoView(boardId: boardId),
                  );
                },
              ),
            ],
          ),

          //Shops Route
          GoRoute(
            path: '/shops',
            redirect: (context, state) async {
              if (state.fullPath == '/shops') {
                return '/shops/product-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'item-unit-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ItemUnitListView(),
                ),
              ),
              GoRoute(
                path: 'category-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: CategoryListView(),
                ),
              ),
              GoRoute(
                path: 'items',
                redirect: (context, state) async {
                  if (state.fullPath == '/shops/items') {
                    return '/shops/items/item-list';
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                    path: 'item-list',
                    pageBuilder: (context, state) => const NoTransitionPage<void>(
                      child: ItemListView(),
                    ),
                  ),
                  GoRoute(
                    path: 'info/:id',
                    pageBuilder: (context, state) {
                      final String id = state.pathParameters['id']!;
                      final int itemId = int.parse(id);
                      return NoTransitionPage<void>(
                        child: ItemInfoView(itemId: itemId),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) => const NoTransitionPage<void>(
                      child: ItemAddView(),
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: '/bundles',
                redirect: (context, state) async {
                  if (state.fullPath == '/shops/bundles') {
                    return '/shops/bundles/bundle-list';
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                    path: 'bundle-list',
                    pageBuilder: (context, state) => const NoTransitionPage<void>(
                      child: BundleListView(),
                    ),
                  ),
                  GoRoute(
                    path: 'info/:id',
                    pageBuilder: (context, state) {
                      final String id = state.pathParameters['id']!;
                      final int bundleId = int.parse(id);
                      return NoTransitionPage<void>(
                        child: BundleInfoView(bundleId: bundleId),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) => const NoTransitionPage<void>(
                      child: BundleAddView(),
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: '/products',
                redirect: (context, state) async {
                  if (state.fullPath == '/shops/products') {
                    return '/shops/products/products-list';
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                    path: 'products-list',
                    pageBuilder: (context, state) => const NoTransitionPage<void>(
                      child: ProductsListView(),
                    ),
                  ),
                  GoRoute(
                    path: 'info/:id',
                    pageBuilder: (context, state) {
                      final String id = state.pathParameters['id']!;
                      final int productId = int.parse(id);
                      return NoTransitionPage<void>(
                        child: ProductInfoView(productId: productId),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) => const NoTransitionPage<void>(
                      child: ProductAddView(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          //Menus Route
          GoRoute(
            path: '/menus',
            redirect: (context, state) async {
              if (state.fullPath == '/menus') {
                return '/menus/menu-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'menu-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: MenuListView(),
                ),
              ),
              GoRoute(
                path: 'privilege-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PrivilegeListView(),
                ),
              ),
              GoRoute(
                path: 'role-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: RoleListView(),
                ),
              ),
            ],
          ),
          //--------------Application Section--------------//

          //--------------Tables & Forms--------------//
          GoRoute(
            path: '/tables',
            redirect: (context, state) async {
              if (state.fullPath == '/tables') {
                return '/tables/basic-table';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'basic-table',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BasicTableView(),
                ),
              ),
              GoRoute(
                path: 'data-table',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DataTableView(),
                ),
              ),
            ],
          ),

          GoRoute(
            path: '/forms',
            redirect: (context, state) async {
              if (state.fullPath == '/forms') {
                return '/forms/basic-forms';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'basic-forms',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BasicFormsView(),
                ),
              ),
              GoRoute(
                path: 'form-select',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FormSelectView(),
                ),
              ),
              GoRoute(
                path: 'form-validation',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FormValidationView(),
                ),
              ),
            ],
          ),
          //--------------Tables & Forms--------------//

          //--------------Components--------------//
          GoRoute(
            path: '/components',
            redirect: (context, state) async {
              if (state.fullPath == '/components') {
                return '/components/buttons';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'buttons',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ButtonsView(),
                ),
              ),
              GoRoute(
                path: 'colors',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ColorsView(),
                ),
              ),
              GoRoute(
                path: 'alerts',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AlertsView(),
                ),
              ),
              GoRoute(
                path: 'typography',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TypographyView(),
                ),
              ),
              GoRoute(
                path: 'cards',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: CardsView(),
                ),
              ),
              GoRoute(
                path: 'avatars',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AvatarsView(),
                ),
              ),
              GoRoute(
                path: 'dragndrop',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DragAndDropView(),
                ),
              ),
            ],
          ),
          //--------------Components--------------//

          //--------------Pages--------------//
          GoRoute(
            path: '/pages',
            redirect: (context, state) async {
              if (state.fullPath == '/pages') {
                return '/pages/gallery';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'gallery',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: GalleryView(),
                ),
              ),
              GoRoute(
                path: 'maps',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: MapsView(),
                ),
              ),
              GoRoute(
                path: 'pricing',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PricingView(),
                ),
              ),
              GoRoute(
                path: 'tabs-and-pills',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TabsNPillsView(),
                ),
              ),
              GoRoute(
                path: '404',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: NotFoundView(),
                ),
              ),
              GoRoute(
                path: 'faqs',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FaqView(),
                ),
              ),
              GoRoute(
                path: 'privacy-policy',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PrivacyPolicyView(),
                ),
              ),
              GoRoute(
                path: 'terms-conditions',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TermsConditionView(),
                ),
              ),
            ],
          ),


          // Dashboard Routes
          GoRoute(
            path: '/dashboard',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard') {
                return '/dashboard/ecommerce-admin';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'ecommerce-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ECommerceAdminDashboardView(),
                ),
              ),
              GoRoute(
                path: 'open-ai-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: OpenAIDashboardView(),
                ),
              ),
              GoRoute(
                path: 'erp-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ERPAdminDashboardView(),
                ),
              ),
              GoRoute(
                path: 'pos-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'earning-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: RewardEarningAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'sms-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SMSAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'influencer-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: InfluencerAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'hrm-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: HRMAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'news-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: NewsAdminDashboard(),
                ),
              ),
              GoRoute(
                path: 'store-analytics',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: StoreAnalyticsDashboard(),
                ),
              ),
            ],
          ),

          // Widgets Routes
          GoRoute(
            path: '/widgets',
            redirect: (context, state) async {
              if (state.fullPath == '/widgets') {
                return '/widgets/general-widgets';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'general-widgets',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: GeneralWidgetsView(),
                ),
              ),
              GoRoute(
                path: 'chart-widgets',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ChartWidgetsView(),
                ),
              ),
            ],
          ),

          //--------------Application Section--------------//
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: CalendarView(),
            ),
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ChatView(),
            ),
          ),

          // Email Shell Routes
          GoRoute(
            path: '/email',
            redirect: (context, state) async {
              if (state.fullPath == '/email') {
                return '/email/inbox';
              }
              return null;
            },
            routes: [
              ShellRoute(
                navigatorKey: _emailShellNavigatorKey,
                pageBuilder: (context, state, child) {
                  return NoTransitionPage(
                    child: EmailView(child: child),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'inbox',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailInboxView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'starred',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailStarredView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'sent',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailSentView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'drafts',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailDraftsView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'spam',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailSpamView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'trash',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailTrashView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':folder/details',
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailDetailsView(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ProjectsView(),
            ),
          ),
          GoRoute(
            path: '/kanban',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: KanbanView(),
            ),
          ),

          // E-Commerce Routes
          GoRoute(
            path: '/ecommerce',
            redirect: (context, state) async {
              if (state.fullPath == '/ecommerce') {
                return '/ecommerce/product-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "product-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProductListView(),
                ),
              ),
              GoRoute(
                path: "product-details",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProductDetailsView(),
                ),
              ),
              GoRoute(
                path: "cart",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CartView(),
                ),
              ),
              GoRoute(
                path: "checkout",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CheckoutView(),
                ),
              ),
            ],
          ),

          // POS Inventory Routes
          GoRoute(
            path: '/pos-inventory',
            redirect: (context, state) async {
              if (state.fullPath == '/pos-inventory') {
                return '/pos-inventory/sale';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "sale",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSSaleView(),
                ),
              ),
              GoRoute(
                path: "sale-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSSaleListView(),
                ),
              ),
              GoRoute(
                path: "purchase",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSPurchaseView(),
                ),
              ),
              GoRoute(
                path: "purchase-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSPurchaseListView(),
                ),
              ),
              GoRoute(
                path: "product",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSProductView(),
                ),
              ),
            ],
          ),

          // Open AI Routes
          GoRoute(
            path: '/open-ai',
            redirect: (context, state) async {
              if (state.fullPath == '/open-ai') {
                return '/open-ai/ai-writter';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'ai-writter',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiWriterView(),
                ),
              ),
              GoRoute(
                path: 'ai-image',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiImageView(),
                ),
              ),
              StatefulShellRoute.indexedStack(
                pageBuilder: (context, state, page) {
                  AIChatPageListener.initialize(page);
                  return NoTransitionPage(
                    child: AiChatView(page: page),
                  );
                },
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: 'ai-chat',
                        pageBuilder: (context, state) => const NoTransitionPage(
                          child: AIChatDetailsView(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'ai-code',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiCodeView(),
                ),
              ),
              GoRoute(
                path: 'ai-voiceover',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiVoiceoverView(),
                ),
              ),
            ],
          ),

          //--------------Pages--------------//
        ],
      ),


      // Full Screen Pages
      GoRoute(
        path: '/authentication/signup',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignupView(),
        ),
      ),
      GoRoute(
        path: '/authentication/signin',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SigninView(),
        ),
      )
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundView(),
    ),
  );
}
