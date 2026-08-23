// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get failedToGetOrCreate => 'Failed to get or create support thread';

  @override
  String get failedToSendMessagePlease =>
      'Failed to send message. Please try again.';

  @override
  String get failedToFetchAllThreads => 'Failed to fetch all threads';

  @override
  String get failedToAddTheProduct => 'Failed to add the product';

  @override
  String get failedToDeleteTheProduct => 'Failed to delete the product';

  @override
  String get failedToAddTheField => 'Failed to add the field';

  @override
  String get failedToDeleteTheField => 'Failed to delete the field';

  @override
  String get failedToAddTheCurrencies => 'Failed to add the currencies';

  @override
  String get failedToDeleteTheCurrencies => 'Failed to delete the currencies';

  @override
  String get failedToAddFeaturedProduct => 'Failed to add Featured Product';

  @override
  String get failedToDeleteFeaturedProduct =>
      'Failed to delete Featured Product';

  @override
  String get failedToFetchProducts => 'Failed to fetch products';

  @override
  String get failedToFetchFields => 'Failed to fetch fields';

  @override
  String get failedToFetchCurrencies => 'Failed to fetch currencies';

  @override
  String get failedToFetchFeaturedProducts =>
      'Failed to fetch Featured Products';

  @override
  String get failedToAddUserPreference => 'Failed to add User Preference';

  @override
  String get failedToFetchUserPreference => 'Failed to fetch User Preference';

  @override
  String get failedToDeleteUserPreference => 'Failed to delete User Preference';

  @override
  String get failedToFetchCartItems => 'Failed to fetch cart items';

  @override
  String get failedToLoadOrderHistory => 'Failed to load order history';

  @override
  String get failedToFilterOrderHistory => 'Failed to filter order history';

  @override
  String get failedToDeleteTheCart => 'Failed to delete the cart item';

  @override
  String get failedToAddTheCart => 'Failed to add the cart item';

  @override
  String get failedToFetchPendingOrders =>
      'Failed to fetch pending orders cart items';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get registerToBuy => 'Register to Buy';

  @override
  String get email => 'Email*';

  @override
  String get password => 'Password*';

  @override
  String get register => 'Register';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get emptyKey => '🦀';

  @override
  String get deleting => 'Deleting';

  @override
  String get battlePassCredits => 'Battle Pass & Credits';

  @override
  String get price249 => '\$2.49';

  @override
  String get error => 'ERROR';

  @override
  String get loginButtonError => 'Login Button Error';

  @override
  String get noConnection => 'No Connection :(';

  @override
  String get crabPay => '🦀 Crab Pay';

  @override
  String get eeeeeh => 'eeeeeh';

  @override
  String get boo => 'BOO';

  @override
  String productNameUi(String productName) {
    return 'Product Name: $productName';
  }

  @override
  String get back => 'Back';

  @override
  String get notEnoughData => 'Not enough data';

  @override
  String get next => 'Next';

  @override
  String get addImediatly => 'Add imediatly';

  @override
  String get mockData => 'Mock Data';

  @override
  String get inputfield => 'InputField';

  @override
  String get radiolist => 'RadioList';

  @override
  String get dropdownlist => 'DropdownList';

  @override
  String get nameTheFielddata => 'Name The Field/Data';

  @override
  String get handler => 'Handler';

  @override
  String get aFieldWithTheSame => 'A field with the same name already exists';

  @override
  String get addTheField => 'Add The Field';

  @override
  String get nameTheOption => 'Name The Option';

  @override
  String get errorNoAppproduct => 'ERROR no AppProduct';

  @override
  String get errorAFieldWithThe =>
      'ERROR A field with the same name already exists';

  @override
  String get everyFieldMustHasA => 'Every field must has a name and a handler';

  @override
  String get noFieldsIsCreated => 'No fields is created';

  @override
  String get howComeThereIsNot => 'How come there is not just one image field';

  @override
  String get fillThePriceOptions => 'Fill the price options';

  @override
  String get noData => 'no data';

  @override
  String get sendData => 'Send Data';

  @override
  String fieldName(String fieldName) {
    return 'Field Name: $fieldName';
  }

  @override
  String get attributes => 'Attributes';

  @override
  String get expectedData => 'Expected Data';

  @override
  String get order => 'Order';

  @override
  String get productData => 'Product Data';

  @override
  String get name => 'Name';

  @override
  String get imageUrl => 'Image Url';

  @override
  String get description => '   Description';

  @override
  String get wrongInput => 'wrong input';

  @override
  String get addTheFeaturedProductId => 'Add The Featured Product Id';

  @override
  String get deleteTheFeaturedProductId => 'Delete The Featured Product Id';

  @override
  String get dbErrorTryAgain => 'Db error, try again';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get boop => 'Boop';

  @override
  String get somethingWrongWithTheFields => 'Something wrong with the fields';

  @override
  String get pushTheFields => 'Push The Fields';

  @override
  String get somethingWentWronNoProduct =>
      'Something went wron. No product id :()';

  @override
  String get typeYourQuestion => 'Type your question...';

  @override
  String get fetchAllThreads => 'Fetch all threads';

  @override
  String chatWithUser(String userId) {
    return 'Chat with user $userId';
  }

  @override
  String get fetchData => 'fetch data';

  @override
  String get addCompleteProduct => 'Add complete product';

  @override
  String get deleteInstancesFromDb => 'Delete instances from DB';

  @override
  String get addFeaturedProduct => 'Add Featured Product';

  @override
  String get answerToUsers => 'Answer to users';

  @override
  String get testLogger => 'Test logger';

  @override
  String get hey => 'Hey :)';

  @override
  String userInfoDebug(
    String id,
    String email,
    String isEmailVerified,
    String isAnonymous,
    String isAdmin,
    String isLimbo,
  ) {
    return 'Id: $id\nemail: $email\nver: $isEmailVerified\nanon: $isAnonymous\nadmin: $isAdmin\nlimbo: $isLimbo';
  }

  @override
  String get product => 'product';

  @override
  String get field => 'Field';

  @override
  String get strangeErrorNoFieldsDetected =>
      'Strange error. No fields detected';

  @override
  String get setNewPriceImage => 'Set new price image';

  @override
  String get failedToPassFieldData => 'Failed to pass field data';

  @override
  String get delete => 'Delete';

  @override
  String get pleaseWait => 'Please, wait';

  @override
  String get phew => 'Phew';

  @override
  String editField(String fieldId) {
    return 'Edit The Field: its id - $fieldId';
  }

  @override
  String fieldNameOg(String fieldName) {
    return 'Field Name. OG name: $fieldName';
  }

  @override
  String theNameWillBe(String nameText) {
    return 'The name will be $nameText';
  }

  @override
  String orderOfTheFieldOg(String order) {
    return 'Order of the field. OG order: $order';
  }

  @override
  String get mustBeInteger => 'Must be integer';

  @override
  String theOrderWillBe(String orderText) {
    return 'The order will be $orderText';
  }

  @override
  String get happilyEverAfter => 'Happily ever after';

  @override
  String get failed => 'failed';

  @override
  String get updateTheField => 'Update The Field';

  @override
  String get someErrorNoFieldFound => 'Some error - no field found';

  @override
  String get modifyPrices => 'Modify prices';

  @override
  String get wait => 'Wait';

  @override
  String get failedToUpdate => 'Failed to update';

  @override
  String get imageName => 'Image name';

  @override
  String currentImageName(String imageName) {
    return 'Current image name: $imageName';
  }

  @override
  String get productName => 'Product name';

  @override
  String currentProductName(String productName) {
    return 'Current product name: $productName';
  }

  @override
  String currentDescription(String description) {
    return 'Current description: $description';
  }

  @override
  String get chooseAproductToModify => 'Choose aproduct to modify';

  @override
  String get pushTheChanges => 'Push the changes';

  @override
  String get wrongCredentialsPleaseTryAgain =>
      'Wrong credentials. Please try again.';

  @override
  String get pleaseSignIn => 'Please, Sign In';

  @override
  String get authorizationWillBeHappeningHere =>
      'Authorization will be happening here';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterYourEmailAddressAnd => 'Enter your email address and we\\';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAnAccountToShop =>
      'Create an account to shop, top up your ballance, and get support.';

  @override
  String get submit => 'Submit';

  @override
  String get youHaveOneAlreadyThen => 'You have one already? Then';

  @override
  String registrationFailedDetailed(String error) {
    return 'Registration failed: $error';
  }

  @override
  String get sent => 'sent';

  @override
  String get beingDelivered => 'Being Delivered';

  @override
  String get delivered => 'Delivered';

  @override
  String get wer23Qf322343 => 'wer 23, qf32 | 23:43';

  @override
  String get orderEijslo93ie => 'Order: eijslo93ie';

  @override
  String get support => 'Support  ';

  @override
  String get number2 => '2';

  @override
  String get products => 'Products';

  @override
  String get orderPrice => 'Order Price';

  @override
  String get number3 => '3';

  @override
  String orderIdDisplay(String orderId) {
    return 'Order: $orderId';
  }

  @override
  String orderAmountDeliveredItems(String amount) {
    return ' $amount';
  }

  @override
  String orderAmountOfItems(String amount) {
    return ' $amount';
  }

  @override
  String orderPriceDisplay(String price) {
    return ' \$$price';
  }

  @override
  String imagesPlusMore(String count) {
    return '+$count';
  }

  @override
  String orderIdDisplayAlt(String orderId) {
    return 'Order: $orderId';
  }

  @override
  String orderAmountDeliveredItemsAlt(String amount) {
    return ' $amount';
  }

  @override
  String orderAmountOfItemsAlt(String amount) {
    return ' $amount';
  }

  @override
  String orderPriceDisplayAlt(String price) {
    return ' \$$price';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get search => 'Search';

  @override
  String get yourSearchedOrders => 'Your Searched Orders';

  @override
  String get tapHereToPickDates => 'Tap Here to Pick Dates';

  @override
  String fromDate(String date) {
    return 'From: $date';
  }

  @override
  String toDate(String date) {
    return 'To: $date';
  }

  @override
  String get fillAllTheFields => 'Fill All The Fields';

  @override
  String get readDescription => 'Read Description';

  @override
  String get addToCart => 'Add To Cart';

  @override
  String get yourProfile => 'Your profile:';

  @override
  String get signOut => '  Sign Out';

  @override
  String get adminMenu => 'Admin Menu';

  @override
  String get highGraphics => 'High Graphics';

  @override
  String get youMustRegisterToBuy => 'You must register to buy';

  @override
  String get shoppingCart => 'Shopping Cart';

  @override
  String get confirmThePurchase => 'Confirm the purchase';

  @override
  String get heyYouHaven => 'Hey, You haven\\';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Checkout';

  @override
  String orderPaymentId(String paymentId) {
    return 'Order: $paymentId';
  }

  @override
  String totalOrderPrice(String totalPrice) {
    return 'Total: $totalPrice';
  }

  @override
  String get pay => 'Pay';

  @override
  String orderCartItemsLength(String count) {
    return ' $count';
  }

  @override
  String orderTotalPriceAlt(String price) {
    return ' \$$price';
  }

  @override
  String get featuredndeals => 'Featured\nDeals';

  @override
  String get more => 'More';

  @override
  String get failedToSendTheMessage => 'Failed to send the message :(';

  @override
  String get oopsNoChatThread => 'Oops, no chat thread';

  @override
  String get startTheChat => 'Start The Chat';
}
