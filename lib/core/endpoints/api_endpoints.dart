class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static String user(int id) => '/users/$id';

  // Products
  static const String products = '/products';
  static String productsByCategory(String category) =>
      '/products/category/$category';
  static const String categories = '/products/categories';
}
