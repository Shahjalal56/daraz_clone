// ═══════════════════════════════════════════════════════════════════════════
// SCROLL ARCHITECTURE EXPLANATION
//
// [1] SINGLE VERTICAL SCROLL OWNER
//     NestedScrollView owns ALL vertical scrolling.
// [2] STICKY TAB BAR via SliverAppBar bottom + forceElevated
// [3] HORIZONTAL SWIPE via TabBarView (PageView) — gesture arena handles H/V split
// [4] NO SCROLL RESET — AutomaticKeepAliveClientMixin + PageStorageKey
// [5] PULL-TO-REFRESH — RefreshIndicator with edgeOffset = _kTabBarHeight
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/route_names.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import '../view_model/product_view_model.dart';
import '../widget/product_card_widget.dart';

// expandedHeight = height of the FlexibleSpaceBar (collapsible banner area).
// SliverAppBar will additionally show kToolbarHeight for the toolbar row
// and _kTabBarHeight for the bottom tab bar.
// Total visible when expanded = kToolbarHeight(56) + _kExpandedHeight(200) + _kTabBarHeight(46)
const _kExpandedHeight = 200.0;
const _kTabBarHeight = 46.0;

const _tabs = [
  _TabDef(label: '🛍 All', category: 'all'),
  _TabDef(label: '👗 Clothing', category: "women's clothing"),
  _TabDef(label: '💍 Jewelry', category: 'jewelery'),
];

class _TabDef {
  final String label;
  final String category;
  const _TabDef({required this.label, required this.category});
}

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ProductViewModel>();
      for (final t in _tabs) {
        vm.fetchProducts(t.category);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: NestedScrollView(
        headerSliverBuilder: _buildHeader,
        body: TabBarView(
          controller: _tabController,
          children: _tabs
              .map((t) => _ProductTabBody(
            category: t.category,
            scrollKey: PageStorageKey(t.category),
          ))
              .toList(),
        ),
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverAppBar(
        expandedHeight: _kExpandedHeight,
        floating: false,
        pinned: false,
        snap: false,
        backgroundColor: const Color(0xFFFF6000),
        forceElevated: innerBoxIsScrolled,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, RouteNames.profile),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 4.w),
        ],
        flexibleSpace: const FlexibleSpaceBar(
          collapseMode: CollapseMode.none,
          background: _BannerWidget(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(_kTabBarHeight),
          child: Container(
            height: _kTabBarHeight,
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFFF6000),
              indicatorWeight: 3,
              labelColor: const Color(0xFFFF6000),
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle:
              TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              unselectedLabelStyle:
              TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildDrawer(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6000), Color(0xFFFF8C42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 36.r,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: Text(
                      user?.firstName[0].toUpperCase() ?? '?',
                      style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  if (user != null) ...[
                    Text(user.fullName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700)),
                    Text(user.email,
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13.sp)),
                  ],
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline,
                  color: const Color(0xFFFF6000), size: 22.sp),
              title: Text('Profile',
                  style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteNames.profile);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red, size: 22.sp),
              title: Text('Logout',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600)),
              onTap: () async {
                Navigator.pop(context);
                await context.read<AuthViewModel>().logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, RouteNames.login);
                }
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

// ── Banner Widget ─────────────────────────────────────────────────────────────
// KEY RULE: No SafeArea inside FlexibleSpaceBar — it causes overflow.
// Use Align(bottomLeft) + mainAxisSize.min so content sticks to the bottom
// of the expanded area and never overflows regardless of screen size.
class _BannerWidget extends StatelessWidget {
  const _BannerWidget();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6000), Color(0xFFFF4500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          // left/right/bottom padding only — no top padding needed
          // because Align.bottomLeft positions content at the bottom
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null)
                Text(
                  'Hi, ${user.firstName}! 👋',
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                ),
              SizedBox(height: 4.h),
              Text(
                'Discover Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    Icon(Icons.search,
                        color: Colors.grey.shade400, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Search for products...',
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Per-tab body ──────────────────────────────────────────────────────────────
class _ProductTabBody extends StatefulWidget {
  final String category;
  final Key scrollKey;

  const _ProductTabBody({
    required this.category,
    required this.scrollKey,
  });

  @override
  State<_ProductTabBody> createState() => _ProductTabBodyState();
}

class _ProductTabBodyState extends State<_ProductTabBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final vm = context.watch<ProductViewModel>();
    final state = vm.getState(widget.category);
    final products = vm.getProducts(widget.category);
    final error = vm.getError(widget.category);

    return RefreshIndicator(
      color: const Color(0xFFFF6000),
      edgeOffset: _kTabBarHeight,
      onRefresh: () => vm.fetchProducts(widget.category, refresh: true),
      child: CustomScrollView(
        key: widget.scrollKey,
        slivers: [
          if (state == ProductState.loading && products.isEmpty)
            _buildLoadingSliver()
          else if (state == ProductState.error && products.isEmpty)
            _buildErrorSliver(error ?? 'Something went wrong')
          else if (products.isEmpty)
              _buildEmptySliver()
            else
              _buildGridSliver(products),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  Widget _buildGridSliver(products) => SliverPadding(
    padding: EdgeInsets.all(12.w),
    sliver: SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (_, i) => ProductCardWidget(product: products[i]),
        childCount: products.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.72,
      ),
    ),
  );

  Widget _buildLoadingSliver() => SliverPadding(
    padding: EdgeInsets.all(12.w),
    sliver: SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (_, __) => _ShimmerCard(),
        childCount: 8,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.72,
      ),
    ),
  );

  Widget _buildErrorSliver(String msg) => SliverFillRemaining(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
          SizedBox(height: 12.h),
          Text(msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red.shade700, fontSize: 13.sp)),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context
                .read<ProductViewModel>()
                .fetchProducts(widget.category, refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6000),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text('Retry',
                style: TextStyle(color: Colors.white, fontSize: 14.sp)),
          ),
        ],
      ),
    ),
  );

  Widget _buildEmptySliver() => const SliverFillRemaining(
    child: Center(child: Text('No products found')),
  );
}

class _ShimmerCard extends StatefulWidget {
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _anim,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),
  );
}