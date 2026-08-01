import 'package:crabpay/core/app_services/app_lifecycle.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/admin_inner_chat_handler.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_outer_circle/admin_outer_chat_handler.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_inner_database_handler.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_outer_database_handler/admin_outer_database_handler_with_supabase.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_outer_circle/supabase_outer_auth_interface.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/inner_chat_handler.dart';
import 'package:crabpay/core/backend/chat_service/chat_outer_circle/outer_chat_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_outer_circle/outer_database_handler_with_supabase.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_outer_circle/outer_cart_handler_with_supabase.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/logger/logger_outer_handler/outer_logger_handler.dart';
import 'package:crabpay/core/backend/pyament_services/payment_service.dart';

import 'utilities.dart';

void setupDependencies() {
  getIt.registerSingleton<InnerLoggerHandler>(OuterLoggerHandler());
  getIt.registerSingleton<AuthInnerInterface>(SupabaseOuterAuthInterface());
  getIt.registerSingleton<AppLifecycleService>(AppLifecycleService());
  //
  getIt.registerLazySingleton<InnerChatHandler>(
    () => OuterChatHandlerWithSupabase(),
  );
  getIt.registerLazySingleton<AdminInnerChatHandler>(
    () => AdminOuterChatHandlerWithSupabase(),
  );
  //
  getIt.registerLazySingleton<InnerDatabaseHandler>(
    () => OuterDatabaseHandlerWithSupabase(),
  );
  getIt.registerLazySingleton<AdminInnerDatabaseHandler>(
    () => AdminOuterDatabaseHandlerWithSupabase(),
  );
  //
  getIt.registerLazySingleton<InnerCartHandler>(
    () => OuterCartHandlerWithSupabase(),
  );
  //
  getIt.registerLazySingleton<PaymentOuterHandler>(() => PaymentOuterHandler());
}
