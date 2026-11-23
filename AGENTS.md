# AGENTS.md

Flutter storefront + admin app (`crabpay`) backed by Supabase (Auth, pg_graphql, Realtime) and an external payment server.

## Required local config (gitignored)
A fresh clone does not compile until these exist:
- `lib/core/backend/supabase/supabase_conf.dart` → `const Map<String, String> supabaseAccessConf = {'url': ..., 'publishableKey': ...};`
- `lib/core/backend/pyament_services/payment_server_conf.dart` → `final String linkToThePaymentServer = '...';`

Never commit real keys or print their values.

## Commands
- `flutter pub get` — installs deps and regenerates l10n (`generate: true`).
- `flutter analyze` — primary verification. The analyzer excludes `build/` and all platform directories.
- `dart format .` — style is non-default: `page_width: 256`, `trailing_commas: preserve` from `analysis_options.yaml`. Don't reflow long lines by hand.
- `flutter test` — currently fails: the only test, `test/widget_test.dart`, is the stale counter template and doesn't match the app. Don't chase it or break unrelated code for it.
- No CI, Makefile, build_runner, or codegen besides l10n.

## Architecture
- Backend splits into `*_inner_circle` (abstract handler interfaces, models, blocs/events/states) and `*_outer_circle` (Supabase/HTTP implementations). Depend on the inner interface; implementations are registered in `lib/core/set_up/get_it.dart`.
- `lib/core/set_up/app_providers.dart` exposes handlers via `RepositoryProvider` and creates the global blocs (`AuthBloc`, `DatabaseBloc`, `CartBloc`, `ChatBloc`, admin variants, `PaymentBloc`). Read with `context.read`/`context.watch`.
- Screens use `driver/` + `view/material/`: the `*Driver` is a `StatefulWidget` that owns the page cubit and wires blocs; the material view is pure UI. Routes point at drivers.
- Postgres CRUD goes through pg_graphql (`SupabaseGraphQLClient`; camelCase collections such as `productCollection`, `cartItemCollection`, `userPreferenceCollection`). Realtime `.from(...).stream(...)` is used for cart counters and pending payments. Supabase Auth sits behind `AuthInnerInterface`.
- All route paths/names live in the `AppRoutes` enum (`lib/core/app_routes/app_routes.dart`). Add a route there, then register it in `main_screen_routes.dart`, `admin_routes.dart`, `auth_routes.dart`, or `other_routes.dart`; `app_router.dart` composes them.
- Use `context.appColorScheme` (`views/custom_ui_elements/utilities/ui_utilities.dart`). `AppTheme.light/dark` exist, but `theme:`/`darkTheme:` are commented out in `main.dart`.
- Admin UI lives under `views/main_screen/_sub/admin_views` and shares `AdminBloc` from `admin_routes.dart`.

## Localization
- ARBs: `lib/l10n/app_en.arb` (template) and `app_ru.arb`. Add every key to both.
- Generated `app_localizations*.dart` are committed. After ARB edits run `flutter gen-l10n` and commit the regenerated files.
- Use `context.l10n.key` (`core/extensions/l10n_extension.dart`), not raw `Text('...')`.
- `main.dart` hardcodes `locale: Locale('ru')`; `GlobalLanguageCubit` only drives the settings toggle and is not connected to `MaterialApp`.
- `tool/*.dart` are destructive one-off codemods (`extract_strings.dart` overwrites `app_en.arb`; `replace_strings.dart` rewrites `Text(...)` across `lib/`). Don't run them without a clear reason.

## Gotchas
- Anonymous auth is the default: `AppLocalStorage` creates a temp user id, and `AuthBloc` may hold an anonymous/temp user while "logged out".
- `build/` at the repo root is generated (Android Gradle redirects there); never edit it.
- Some legacy code hardcodes the Supabase host (`supabase/supanase_server.dart`); prefer `supabaseAccessConf`.
