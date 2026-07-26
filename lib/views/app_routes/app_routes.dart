enum AppRoutes {
  //
  //User UI
  // Main screen and pages
  home('/', 'home'),
  store('/store', 'store'),
  support('/support', 'support'),
  cart('/cart', 'cart'),
  purchases('/purchases_view', 'purchases'),

  // Product View
  productCard(
    '/card_view/:productId/:additionalSuffix/:index',
    'card_view',
  ),

  // Auth
  login('/login_view', 'login'),
  register('register_view', 'register'),
  resetPassword('reset_password_view', 'reset_password'),

  //
  //Admin UI
  // Admin Panels accesed from UI
  updateProduct(
    '/update_product_admin_panel_view/:productId',
    'update_product',
  ),
  updateField(
    '/update_field_admin_panel_view/:fieldId/:productId',
    'update_field',
  ),
  updatePriceImages(
    '/update_price_images_field_admin_panel_view/:fieldId/:productId',
    'update_price_images',
  ),
  addField('/add_field_admin_panel_view/:productId', 'add_field'),
  resetPriceImage(
    '/reset_price_image_field_admin_panel_view/:productId',
    'reset_price_image',
  ),
  deleting('/deleting_view', 'deleting'),
  addFeaturedProduct('/add_featured_product_view', 'add_featured_product'),

  // Other Admin Panels
  adminTools('/admin_tools_view', 'admin_tools'),
  adminSupportChat(
    'admin_support_chat_view/:threadId',
    'admin_support_chat_view',
  ),
  addCompleteProduct(
    '/add_complete_product_product_view',
    'add_complete_product',
  ),
  chooseThread('/choose_thread_view', 'choose_thread_view'),
  addProductFields('add_product_fields_view', 'add_product_fields'),
  priceSpaceFill('price_space_fill_view', 'price_space_fill'),
  dataOverview('data_overview_view', 'data_overview');

  final String path;
  final String name;
  const AppRoutes(this.path, this.name);
}
