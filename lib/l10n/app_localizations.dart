import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @failedToGetOrCreate.
  ///
  /// In en, this message translates to:
  /// **'Failed to get or create support thread'**
  String get failedToGetOrCreate;

  /// No description provided for @failedToSendMessagePlease.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Please try again.'**
  String get failedToSendMessagePlease;

  /// No description provided for @failedToFetchAllThreads.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch all threads'**
  String get failedToFetchAllThreads;

  /// No description provided for @failedToAddTheProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to add the product'**
  String get failedToAddTheProduct;

  /// No description provided for @failedToDeleteTheProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete the product'**
  String get failedToDeleteTheProduct;

  /// No description provided for @failedToAddTheField.
  ///
  /// In en, this message translates to:
  /// **'Failed to add the field'**
  String get failedToAddTheField;

  /// No description provided for @failedToDeleteTheField.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete the field'**
  String get failedToDeleteTheField;

  /// No description provided for @failedToAddTheCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Failed to add the currencies'**
  String get failedToAddTheCurrencies;

  /// No description provided for @failedToDeleteTheCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete the currencies'**
  String get failedToDeleteTheCurrencies;

  /// No description provided for @failedToAddFeaturedProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to add Featured Product'**
  String get failedToAddFeaturedProduct;

  /// No description provided for @failedToDeleteFeaturedProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete Featured Product'**
  String get failedToDeleteFeaturedProduct;

  /// No description provided for @failedToFetchProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch products'**
  String get failedToFetchProducts;

  /// No description provided for @failedToFetchFields.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch fields'**
  String get failedToFetchFields;

  /// No description provided for @failedToFetchCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch currencies'**
  String get failedToFetchCurrencies;

  /// No description provided for @failedToFetchFeaturedProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch Featured Products'**
  String get failedToFetchFeaturedProducts;

  /// No description provided for @failedToAddUserPreference.
  ///
  /// In en, this message translates to:
  /// **'Failed to add User Preference'**
  String get failedToAddUserPreference;

  /// No description provided for @failedToFetchUserPreference.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch User Preference'**
  String get failedToFetchUserPreference;

  /// No description provided for @failedToDeleteUserPreference.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete User Preference'**
  String get failedToDeleteUserPreference;

  /// No description provided for @failedToFetchCartItems.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch cart items'**
  String get failedToFetchCartItems;

  /// No description provided for @failedToLoadOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load order history'**
  String get failedToLoadOrderHistory;

  /// No description provided for @failedToFilterOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to filter order history'**
  String get failedToFilterOrderHistory;

  /// No description provided for @failedToDeleteTheCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete the cart item'**
  String get failedToDeleteTheCart;

  /// No description provided for @failedToAddTheCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to add the cart item'**
  String get failedToAddTheCart;

  /// No description provided for @failedToFetchPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch pending orders cart items'**
  String get failedToFetchPendingOrders;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @registerToBuy.
  ///
  /// In en, this message translates to:
  /// **'Register to Buy'**
  String get registerToBuy;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email*'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password*'**
  String get password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @emptyKey.
  ///
  /// In en, this message translates to:
  /// **'🦀'**
  String get emptyKey;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting'**
  String get deleting;

  /// No description provided for @battlePassCredits.
  ///
  /// In en, this message translates to:
  /// **'Battle Pass & Credits'**
  String get battlePassCredits;

  /// No description provided for @price249.
  ///
  /// In en, this message translates to:
  /// **'\$2.49'**
  String get price249;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'ERROR'**
  String get error;

  /// No description provided for @loginButtonError.
  ///
  /// In en, this message translates to:
  /// **'Login Button Error'**
  String get loginButtonError;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No Connection :('**
  String get noConnection;

  /// No description provided for @crabPay.
  ///
  /// In en, this message translates to:
  /// **'🦀 Crab Pay'**
  String get crabPay;

  /// No description provided for @eeeeeh.
  ///
  /// In en, this message translates to:
  /// **'eeeeeh'**
  String get eeeeeh;

  /// No description provided for @boo.
  ///
  /// In en, this message translates to:
  /// **'BOO'**
  String get boo;

  /// No description provided for @productNameUi.
  ///
  /// In en, this message translates to:
  /// **'Product Name: {productName}'**
  String productNameUi(String productName);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @notEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data'**
  String get notEnoughData;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @addImediatly.
  ///
  /// In en, this message translates to:
  /// **'Add imediatly'**
  String get addImediatly;

  /// No description provided for @mockData.
  ///
  /// In en, this message translates to:
  /// **'Mock Data'**
  String get mockData;

  /// No description provided for @inputfield.
  ///
  /// In en, this message translates to:
  /// **'InputField'**
  String get inputfield;

  /// No description provided for @radiolist.
  ///
  /// In en, this message translates to:
  /// **'RadioList'**
  String get radiolist;

  /// No description provided for @dropdownlist.
  ///
  /// In en, this message translates to:
  /// **'DropdownList'**
  String get dropdownlist;

  /// No description provided for @nameTheFielddata.
  ///
  /// In en, this message translates to:
  /// **'Name The Field/Data'**
  String get nameTheFielddata;

  /// No description provided for @handler.
  ///
  /// In en, this message translates to:
  /// **'Handler'**
  String get handler;

  /// No description provided for @aFieldWithTheSame.
  ///
  /// In en, this message translates to:
  /// **'A field with the same name already exists'**
  String get aFieldWithTheSame;

  /// No description provided for @addTheField.
  ///
  /// In en, this message translates to:
  /// **'Add The Field'**
  String get addTheField;

  /// No description provided for @nameTheOption.
  ///
  /// In en, this message translates to:
  /// **'Name The Option'**
  String get nameTheOption;

  /// No description provided for @errorNoAppproduct.
  ///
  /// In en, this message translates to:
  /// **'ERROR no AppProduct'**
  String get errorNoAppproduct;

  /// No description provided for @errorAFieldWithThe.
  ///
  /// In en, this message translates to:
  /// **'ERROR A field with the same name already exists'**
  String get errorAFieldWithThe;

  /// No description provided for @everyFieldMustHasA.
  ///
  /// In en, this message translates to:
  /// **'Every field must has a name and a handler'**
  String get everyFieldMustHasA;

  /// No description provided for @noFieldsIsCreated.
  ///
  /// In en, this message translates to:
  /// **'No fields is created'**
  String get noFieldsIsCreated;

  /// No description provided for @howComeThereIsNot.
  ///
  /// In en, this message translates to:
  /// **'How come there is not just one image field'**
  String get howComeThereIsNot;

  /// No description provided for @fillThePriceOptions.
  ///
  /// In en, this message translates to:
  /// **'Fill the price options'**
  String get fillThePriceOptions;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'no data'**
  String get noData;

  /// No description provided for @sendData.
  ///
  /// In en, this message translates to:
  /// **'Send Data'**
  String get sendData;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Field Name: {fieldName}'**
  String fieldName(String fieldName);

  /// No description provided for @attributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get attributes;

  /// No description provided for @expectedData.
  ///
  /// In en, this message translates to:
  /// **'Expected Data'**
  String get expectedData;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @productData.
  ///
  /// In en, this message translates to:
  /// **'Product Data'**
  String get productData;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image Url'**
  String get imageUrl;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'   Description'**
  String get description;

  /// No description provided for @wrongInput.
  ///
  /// In en, this message translates to:
  /// **'wrong input'**
  String get wrongInput;

  /// No description provided for @addTheFeaturedProductId.
  ///
  /// In en, this message translates to:
  /// **'Add The Featured Product Id'**
  String get addTheFeaturedProductId;

  /// No description provided for @deleteTheFeaturedProductId.
  ///
  /// In en, this message translates to:
  /// **'Delete The Featured Product Id'**
  String get deleteTheFeaturedProductId;

  /// No description provided for @dbErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Db error, try again'**
  String get dbErrorTryAgain;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @boop.
  ///
  /// In en, this message translates to:
  /// **'Boop'**
  String get boop;

  /// No description provided for @somethingWrongWithTheFields.
  ///
  /// In en, this message translates to:
  /// **'Something wrong with the fields'**
  String get somethingWrongWithTheFields;

  /// No description provided for @pushTheFields.
  ///
  /// In en, this message translates to:
  /// **'Push The Fields'**
  String get pushTheFields;

  /// No description provided for @somethingWentWronNoProduct.
  ///
  /// In en, this message translates to:
  /// **'Something went wron. No product id :()'**
  String get somethingWentWronNoProduct;

  /// No description provided for @typeYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Type your question...'**
  String get typeYourQuestion;

  /// No description provided for @fetchAllThreads.
  ///
  /// In en, this message translates to:
  /// **'Fetch all threads'**
  String get fetchAllThreads;

  /// No description provided for @chatWithUser.
  ///
  /// In en, this message translates to:
  /// **'Chat with user {userId}'**
  String chatWithUser(String userId);

  /// No description provided for @fetchData.
  ///
  /// In en, this message translates to:
  /// **'fetch data'**
  String get fetchData;

  /// No description provided for @addCompleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Add complete product'**
  String get addCompleteProduct;

  /// No description provided for @deleteInstancesFromDb.
  ///
  /// In en, this message translates to:
  /// **'Delete instances from DB'**
  String get deleteInstancesFromDb;

  /// No description provided for @addFeaturedProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Featured Product'**
  String get addFeaturedProduct;

  /// No description provided for @answerToUsers.
  ///
  /// In en, this message translates to:
  /// **'Answer to users'**
  String get answerToUsers;

  /// No description provided for @testLogger.
  ///
  /// In en, this message translates to:
  /// **'Test logger'**
  String get testLogger;

  /// No description provided for @hey.
  ///
  /// In en, this message translates to:
  /// **'Hey :)'**
  String get hey;

  /// No description provided for @userInfoDebug.
  ///
  /// In en, this message translates to:
  /// **'Id: {id}\nemail: {email}\nver: {isEmailVerified}\nanon: {isAnonymous}\nadmin: {isAdmin}\nlimbo: {isLimbo}'**
  String userInfoDebug(
    String id,
    String email,
    String isEmailVerified,
    String isAnonymous,
    String isAdmin,
    String isLimbo,
  );

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get product;

  /// No description provided for @field.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get field;

  /// No description provided for @strangeErrorNoFieldsDetected.
  ///
  /// In en, this message translates to:
  /// **'Strange error. No fields detected'**
  String get strangeErrorNoFieldsDetected;

  /// No description provided for @setNewPriceImage.
  ///
  /// In en, this message translates to:
  /// **'Set new price image'**
  String get setNewPriceImage;

  /// No description provided for @failedToPassFieldData.
  ///
  /// In en, this message translates to:
  /// **'Failed to pass field data'**
  String get failedToPassFieldData;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please, wait'**
  String get pleaseWait;

  /// No description provided for @phew.
  ///
  /// In en, this message translates to:
  /// **'Phew'**
  String get phew;

  /// No description provided for @editField.
  ///
  /// In en, this message translates to:
  /// **'Edit The Field: its id - {fieldId}'**
  String editField(String fieldId);

  /// No description provided for @fieldNameOg.
  ///
  /// In en, this message translates to:
  /// **'Field Name. OG name: {fieldName}'**
  String fieldNameOg(String fieldName);

  /// No description provided for @theNameWillBe.
  ///
  /// In en, this message translates to:
  /// **'The name will be {nameText}'**
  String theNameWillBe(String nameText);

  /// No description provided for @orderOfTheFieldOg.
  ///
  /// In en, this message translates to:
  /// **'Order of the field. OG order: {order}'**
  String orderOfTheFieldOg(String order);

  /// No description provided for @mustBeInteger.
  ///
  /// In en, this message translates to:
  /// **'Must be integer'**
  String get mustBeInteger;

  /// No description provided for @theOrderWillBe.
  ///
  /// In en, this message translates to:
  /// **'The order will be {orderText}'**
  String theOrderWillBe(String orderText);

  /// No description provided for @happilyEverAfter.
  ///
  /// In en, this message translates to:
  /// **'Happily ever after'**
  String get happilyEverAfter;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get failed;

  /// No description provided for @updateTheField.
  ///
  /// In en, this message translates to:
  /// **'Update The Field'**
  String get updateTheField;

  /// No description provided for @someErrorNoFieldFound.
  ///
  /// In en, this message translates to:
  /// **'Some error - no field found'**
  String get someErrorNoFieldFound;

  /// No description provided for @modifyPrices.
  ///
  /// In en, this message translates to:
  /// **'Modify prices'**
  String get modifyPrices;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get wait;

  /// No description provided for @failedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update'**
  String get failedToUpdate;

  /// No description provided for @imageName.
  ///
  /// In en, this message translates to:
  /// **'Image name'**
  String get imageName;

  /// No description provided for @currentImageName.
  ///
  /// In en, this message translates to:
  /// **'Current image name: {imageName}'**
  String currentImageName(String imageName);

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @currentProductName.
  ///
  /// In en, this message translates to:
  /// **'Current product name: {productName}'**
  String currentProductName(String productName);

  /// No description provided for @currentDescription.
  ///
  /// In en, this message translates to:
  /// **'Current description: {description}'**
  String currentDescription(String description);

  /// No description provided for @chooseAproductToModify.
  ///
  /// In en, this message translates to:
  /// **'Choose aproduct to modify'**
  String get chooseAproductToModify;

  /// No description provided for @pushTheChanges.
  ///
  /// In en, this message translates to:
  /// **'Push the changes'**
  String get pushTheChanges;

  /// No description provided for @wrongCredentialsPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Wrong credentials. Please try again.'**
  String get wrongCredentialsPleaseTryAgain;

  /// No description provided for @pleaseSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please, Sign In'**
  String get pleaseSignIn;

  /// No description provided for @authorizationWillBeHappeningHere.
  ///
  /// In en, this message translates to:
  /// **'Authorization will be happening here'**
  String get authorizationWillBeHappeningHere;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterYourEmailAddressAnd.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\\'**
  String get enterYourEmailAddressAnd;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAnAccountToShop.
  ///
  /// In en, this message translates to:
  /// **'Create an account to shop, top up your ballance, and get support.'**
  String get createAnAccountToShop;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @youHaveOneAlreadyThen.
  ///
  /// In en, this message translates to:
  /// **'You have one already? Then'**
  String get youHaveOneAlreadyThen;

  /// No description provided for @registrationFailedDetailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed: {error}'**
  String registrationFailedDetailed(String error);

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'sent'**
  String get sent;

  /// No description provided for @beingDelivered.
  ///
  /// In en, this message translates to:
  /// **'Being Delivered'**
  String get beingDelivered;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @wer23Qf322343.
  ///
  /// In en, this message translates to:
  /// **'wer 23, qf32 | 23:43'**
  String get wer23Qf322343;

  /// No description provided for @orderEijslo93ie.
  ///
  /// In en, this message translates to:
  /// **'Order: eijslo93ie'**
  String get orderEijslo93ie;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support  '**
  String get support;

  /// No description provided for @number2.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get number2;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @orderPrice.
  ///
  /// In en, this message translates to:
  /// **'Order Price'**
  String get orderPrice;

  /// No description provided for @number3.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get number3;

  /// No description provided for @orderIdDisplay.
  ///
  /// In en, this message translates to:
  /// **'Order: {orderId}'**
  String orderIdDisplay(String orderId);

  /// No description provided for @orderAmountDeliveredItems.
  ///
  /// In en, this message translates to:
  /// **' {amount}'**
  String orderAmountDeliveredItems(String amount);

  /// No description provided for @orderAmountOfItems.
  ///
  /// In en, this message translates to:
  /// **' {amount}'**
  String orderAmountOfItems(String amount);

  /// No description provided for @orderPriceDisplay.
  ///
  /// In en, this message translates to:
  /// **' \${price}'**
  String orderPriceDisplay(String price);

  /// No description provided for @imagesPlusMore.
  ///
  /// In en, this message translates to:
  /// **'+{count}'**
  String imagesPlusMore(String count);

  /// No description provided for @orderIdDisplayAlt.
  ///
  /// In en, this message translates to:
  /// **'Order: {orderId}'**
  String orderIdDisplayAlt(String orderId);

  /// No description provided for @orderAmountDeliveredItemsAlt.
  ///
  /// In en, this message translates to:
  /// **' {amount}'**
  String orderAmountDeliveredItemsAlt(String amount);

  /// No description provided for @orderAmountOfItemsAlt.
  ///
  /// In en, this message translates to:
  /// **' {amount}'**
  String orderAmountOfItemsAlt(String amount);

  /// No description provided for @orderPriceDisplayAlt.
  ///
  /// In en, this message translates to:
  /// **' \${price}'**
  String orderPriceDisplayAlt(String price);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @yourSearchedOrders.
  ///
  /// In en, this message translates to:
  /// **'Your Searched Orders'**
  String get yourSearchedOrders;

  /// No description provided for @tapHereToPickDates.
  ///
  /// In en, this message translates to:
  /// **'Tap Here to Pick Dates'**
  String get tapHereToPickDates;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From: {date}'**
  String fromDate(String date);

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To: {date}'**
  String toDate(String date);

  /// No description provided for @fillAllTheFields.
  ///
  /// In en, this message translates to:
  /// **'Fill All The Fields'**
  String get fillAllTheFields;

  /// No description provided for @readDescription.
  ///
  /// In en, this message translates to:
  /// **'Read Description'**
  String get readDescription;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get addToCart;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile:'**
  String get yourProfile;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'  Sign Out'**
  String get signOut;

  /// No description provided for @adminMenu.
  ///
  /// In en, this message translates to:
  /// **'Admin Menu'**
  String get adminMenu;

  /// No description provided for @highGraphics.
  ///
  /// In en, this message translates to:
  /// **'High Graphics'**
  String get highGraphics;

  /// No description provided for @youMustRegisterToBuy.
  ///
  /// In en, this message translates to:
  /// **'You must register to buy'**
  String get youMustRegisterToBuy;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// No description provided for @confirmThePurchase.
  ///
  /// In en, this message translates to:
  /// **'Confirm the purchase'**
  String get confirmThePurchase;

  /// No description provided for @heyYouHaven.
  ///
  /// In en, this message translates to:
  /// **'Hey, You haven\\'**
  String get heyYouHaven;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @orderPaymentId.
  ///
  /// In en, this message translates to:
  /// **'Order: {paymentId}'**
  String orderPaymentId(String paymentId);

  /// No description provided for @totalOrderPrice.
  ///
  /// In en, this message translates to:
  /// **'Total: {totalPrice}'**
  String totalOrderPrice(String totalPrice);

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @orderCartItemsLength.
  ///
  /// In en, this message translates to:
  /// **' {count}'**
  String orderCartItemsLength(String count);

  /// No description provided for @orderTotalPriceAlt.
  ///
  /// In en, this message translates to:
  /// **' \${price}'**
  String orderTotalPriceAlt(String price);

  /// No description provided for @featuredndeals.
  ///
  /// In en, this message translates to:
  /// **'Featured\nDeals'**
  String get featuredndeals;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @failedToSendTheMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send the message :('**
  String get failedToSendTheMessage;

  /// No description provided for @oopsNoChatThread.
  ///
  /// In en, this message translates to:
  /// **'Oops, no chat thread'**
  String get oopsNoChatThread;

  /// No description provided for @startTheChat.
  ///
  /// In en, this message translates to:
  /// **'Start The Chat'**
  String get startTheChat;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
