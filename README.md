# DarazClone — Flutter Clean Architecture

## Run
```bash
flutter pub get
flutter run
```
**Demo login:** `mor_2314` / `83r5^_`

---

## Folder Structure
```
lib/
├── main.dart
├── app/
│   ├── config/app_config.dart
│   ├── routes/app_routes.dart + route_names.dart
│   └── viewmodels/app_viewmodels.dart
├── core/
│   ├── di/di_config.dart              ← GetIt setup
│   ├── endpoints/api_endpoints.dart
│   ├── error/error_handler.dart
│   ├── network/network.dart           ← Dio singleton + token interceptor
│   └── services/
│       ├── api/api_services.dart
│       └── storage/token_storage.dart
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── data_source/auth_remote_data_source.dart
    │   │   ├── model/login_response_model.dart + user_model.dart
    │   │   └── repository_impl/auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entity/user_entity.dart
    │   │   ├── repository/auth_repository.dart
    │   │   └── use_case/login_use_case.dart + get_profile_use_case.dart
    │   └── presentation/
    │       ├── view/login_screen.dart + profile_screen.dart
    │       └── view_model/auth_view_model.dart
    └── products/
        ├── data/
        │   ├── data_source/product_remote_data_source.dart
        │   ├── model/product_model.dart
        │   └── repository_impl/product_repository_impl.dart
        ├── domain/
        │   ├── entity/product_entity.dart
        │   ├── repository/product_repository.dart
        │   └── use_case/get_products_use_case.dart
        └── presentation/
            ├── view/product_listing_screen.dart  ← scroll architecture
            ├── view_model/product_view_model.dart
            └── widget/product_card_widget.dart
```

---

## Scroll Architecture

### 1. Horizontal Swipe
`TabBarView` internally uses `PageView` which registers `HorizontalDragGestureRecognizer`. Flutter's gesture arena automatically separates horizontal drags (→ PageView → tab switch) from vertical drags (→ NestedScrollView → list scroll). No manual `GestureDetector` needed.

### 2. Vertical Scroll Owner
`NestedScrollView` is the **single** vertical scroll owner. It coordinates between collapsing the `SliverAppBar` banner and scrolling the inner product list via its internal `NestedScrollViewCoordinator`. There is no second `ScrollController` anywhere.

### 3. Trade-offs
| Decision | Trade-off |
|---|---|
| `NestedScrollView` | Best Flutter-native solution; minor edge cases with `RefreshIndicator` fixed via `edgeOffset` |
| `AutomaticKeepAliveClientMixin` | Keeps all tab states in memory; fine for 3 tabs |
| `wantKeepAlive = true` | Scroll position preserved on tab switch — no reset |
| Dio interceptor for token | Clean auth injection; `LogInterceptor` should be disabled in production |
