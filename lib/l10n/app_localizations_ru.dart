// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get failedToGetOrCreate =>
      'Не удалось получить или создать чат поддержки';

  @override
  String get favorite => 'Избранное';

  @override
  String get favoriteEmpty => 'Избранное? :(';

  @override
  String get failedToSendMessagePlease =>
      'Не удалось отправить сообщение. Пожалуйста, попробуйте снова.';

  @override
  String get failedToFetchAllThreads => 'Не удалось загрузить все чаты';

  @override
  String get failedToAddTheProduct => 'Не удалось добавить товар';

  @override
  String get failedToDeleteTheProduct => 'Не удалось удалить товар';

  @override
  String get failedToAddTheField => 'Не удалось добавить поле';

  @override
  String get failedToDeleteTheField => 'Не удалось удалить поле';

  @override
  String get failedToAddTheCurrencies => 'Не удалось добавить валюты';

  @override
  String get failedToDeleteTheCurrencies => 'Не удалось удалить валюты';

  @override
  String get failedToAddFeaturedProduct =>
      'Не удалось добавить рекомендуемый товар';

  @override
  String get failedToDeleteFeaturedProduct =>
      'Не удалось удалить рекомендуемый товар';

  @override
  String get failedToFetchProducts => 'Не удалось загрузить товары';

  @override
  String get failedToFetchFields => 'Не удалось загрузить поля';

  @override
  String get failedToFetchCurrencies => 'Не удалось загрузить валюты';

  @override
  String get failedToFetchFeaturedProducts =>
      'Не удалось загрузить рекомендуемые товары';

  @override
  String get failedToAddUserPreference =>
      'Не удалось добавить настройки пользователя';

  @override
  String get failedToFetchUserPreference =>
      'Не удалось загрузить настройки пользователя';

  @override
  String get failedToDeleteUserPreference =>
      'Не удалось удалить настройки пользователя';

  @override
  String get failedToFetchCartItems => 'Не удалось загрузить товары в корзине';

  @override
  String get failedToLoadOrderHistory => 'Не удалось загрузить историю заказов';

  @override
  String get failedToFilterOrderHistory =>
      'Не удалось отфильтровать историю заказов';

  @override
  String get failedToDeleteTheCart => 'Не удалось удалить товар из корзины';

  @override
  String get failedToAddTheCart => 'Не удалось добавить товар в корзину';

  @override
  String get failedToFetchPendingOrders =>
      'Не удалось загрузить ожидающие заказы';

  @override
  String get orders => 'Заказы';

  @override
  String get from_date => 'От';

  @override
  String get to_date => 'До';

  @override
  String get registrationFailed => 'Ошибка регистрации';

  @override
  String get registerToBuy => 'Зарегистрируйтесь для покупки';

  @override
  String get email => 'Email*';

  @override
  String get password => 'Пароль*';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get dismiss => 'Скрыть';

  @override
  String get emptyKey => '🦀';

  @override
  String get deleting => 'Удаление';

  @override
  String get battlePassCredits => 'Боевой пропуск и кредиты';

  @override
  String get price249 => '\$2.49';

  @override
  String get error => 'ОШИБКА';

  @override
  String get loginButtonError => 'Ошибка кнопки входа';

  @override
  String get noConnection => 'Нет подключения :(';

  @override
  String get crabPay => '🦀 Crab Pay';

  @override
  String get eeeeeh => 'э-э-э';

  @override
  String get boo => 'БУ';

  @override
  String get turnOnRussian => 'Использовать Русский';

  @override
  String productNameUi(String productName) {
    return 'Название товара: $productName';
  }

  @override
  String get mobileGames => 'Мобильные игры';

  @override
  String get services => 'Сервисы';

  @override
  String get back => 'Назад';

  @override
  String get notEnoughData => 'Недостаточно данных';

  @override
  String get next => 'Далее';

  @override
  String get addImediatly => 'Добавить немедленно';

  @override
  String get mockData => 'Моковые данные';

  @override
  String get inputfield => 'Поле ввода';

  @override
  String get radiolist => 'Список радиокнопок';

  @override
  String get dropdownlist => 'Выпадающий список';

  @override
  String get nameTheFielddata => 'Назовите поле/данные';

  @override
  String get handler => 'Обработчик';

  @override
  String get aFieldWithTheSame => 'Поле с таким именем уже существует';

  @override
  String get addTheField => 'Добавить поле';

  @override
  String get nameTheOption => 'Назовите опцию';

  @override
  String get errorNoAppproduct => 'ОШИБКА нет AppProduct';

  @override
  String get errorAFieldWithThe => 'ОШИБКА Поле с таким именем уже существует';

  @override
  String get everyFieldMustHasA => 'Каждое поле должно иметь имя и обработчик';

  @override
  String get noFieldsIsCreated => 'Поля не созданы';

  @override
  String get howComeThereIsNot =>
      'Как так вышло, что нет ни одного поля с изображением';

  @override
  String get fillThePriceOptions => 'Заполните варианты цен';

  @override
  String get noData => 'нет данных';

  @override
  String get sendData => 'Отправить данные';

  @override
  String fieldName(String fieldName) {
    return 'Имя поля: $fieldName';
  }

  @override
  String get attributes => 'Атрибуты';

  @override
  String get expectedData => 'Ожидаемые данные';

  @override
  String get order => 'Заказ';

  @override
  String get productData => 'Данные товара';

  @override
  String get name => 'Название';

  @override
  String get imageUrl => 'URL изображения';

  @override
  String get description => '   Описание';

  @override
  String get wrongInput => 'неверный ввод';

  @override
  String get addTheFeaturedProductId => 'Добавить ID рекомендуемого товара';

  @override
  String get deleteTheFeaturedProductId => 'Удалить ID рекомендуемого товара';

  @override
  String get dbErrorTryAgain => 'Ошибка БД, попробуйте снова';

  @override
  String get adminPanel => 'Панель администратора';

  @override
  String get boop => 'Буп';

  @override
  String get somethingWrongWithTheFields => 'Что-то не так с полями';

  @override
  String get pushTheFields => 'Отправить поля';

  @override
  String get somethingWentWronNoProduct =>
      'Что-то пошло не так. Нет id товара :()';

  @override
  String get typeYourQuestion => 'Введите ваш вопрос...';

  @override
  String get fetchAllThreads => 'Загрузить все чаты';

  @override
  String chatWithUser(String userId) {
    return 'Чат с пользователем $userId';
  }

  @override
  String get fetchData => 'получить данные';

  @override
  String get addCompleteProduct => 'Добавить товар целиком';

  @override
  String get deleteInstancesFromDb => 'Удалить записи из БД';

  @override
  String get addFeaturedProduct => 'Добавить рекомендуемый товар';

  @override
  String get answerToUsers => 'Ответить пользователям';

  @override
  String get testLogger => 'Тестовый логгер';

  @override
  String get hey => 'Привет :)';

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
  String get product => 'товар';

  @override
  String get field => 'Поле';

  @override
  String get strangeErrorNoFieldsDetected =>
      'Странная ошибка. Поля не обнаружены';

  @override
  String get setNewPriceImage => 'Установить новое изображение цены';

  @override
  String get failedToPassFieldData => 'Не удалось передать данные поля';

  @override
  String get delete => 'Удалить';

  @override
  String get pleaseWait => 'Пожалуйста, подождите';

  @override
  String get waitingYourPayment => 'Ожидают вашей оплаты';

  @override
  String get phew => 'Фух';

  @override
  String editField(String fieldId) {
    return 'Редактировать поле: его id - $fieldId';
  }

  @override
  String fieldNameOg(String fieldName) {
    return 'Имя поля. Ориг. имя: $fieldName';
  }

  @override
  String theNameWillBe(String nameText) {
    return 'Имя будет $nameText';
  }

  @override
  String orderOfTheFieldOg(String order) {
    return 'Порядок поля. Ориг. порядок: $order';
  }

  @override
  String get mustBeInteger => 'Должно быть целым числом';

  @override
  String theOrderWillBe(String orderText) {
    return 'Порядок будет $orderText';
  }

  @override
  String get happilyEverAfter => 'Долго и счастливо';

  @override
  String get failed => 'ошибка';

  @override
  String get updateTheField => 'Обновить поле';

  @override
  String get someErrorNoFieldFound => 'Какая-то ошибка - поле не найдено';

  @override
  String get modifyPrices => 'Изменить цены';

  @override
  String get wait => 'Подождите';

  @override
  String get failedToUpdate => 'Не удалось обновить';

  @override
  String get imageName => 'Имя изображения';

  @override
  String currentImageName(String imageName) {
    return 'Текущее имя изображения: $imageName';
  }

  @override
  String get productName => 'Название товара';

  @override
  String currentProductName(String productName) {
    return 'Текущее название товара: $productName';
  }

  @override
  String currentDescription(String description) {
    return 'Текущее описание: $description';
  }

  @override
  String get somethingWentWrongWithDescription =>
      'Ой-йойю Что-то пошло не так с описанием';

  @override
  String get chooseAproductToModify => 'Выберите товар для изменения';

  @override
  String get pushTheChanges => 'Применить изменения';

  @override
  String get wrongCredentialsPleaseTryAgain =>
      'Неверные учетные данные. Пожалуйста, попробуйте снова.';

  @override
  String get pleaseSignIn => 'Пожалуйста, войдите';

  @override
  String get authorizationWillBeHappeningHere =>
      'Здесь будет проходить авторизация';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get signIn => 'Войти';

  @override
  String get dontHaveAnAccount => 'Нет аккаунта?';

  @override
  String get signUp => 'Регистрация';

  @override
  String get resetPassword => 'Сбросить пароль';

  @override
  String get enterYourEmailAddressAnd => 'Введите ваш email, и мы\\';

  @override
  String get sendResetLink => 'Отправить ссылку для сброса';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get createAnAccountToShop =>
      'Создайте аккаунт, чтобы совершать покупки, пополнять баланс и получать поддержку.';

  @override
  String get submit => 'Подтвердить';

  @override
  String get youHaveOneAlreadyThen => 'Уже есть аккаунт? Тогда';

  @override
  String registrationFailedDetailed(String error) {
    return 'Ошибка регистрации: $error';
  }

  @override
  String get sent => 'отправлен';

  @override
  String get beingDelivered => 'Доставляется';

  @override
  String get delivered => 'Доставлен';

  @override
  String get wer23Qf322343 => 'wer 23, qf32 | 23:43';

  @override
  String get orderEijslo93ie => 'Заказ: eijslo93ie';

  @override
  String get support => 'Поддержка  ';

  @override
  String get number2 => '2';

  @override
  String get products => 'Товары';

  @override
  String get orderPrice => 'Сумма заказа';

  @override
  String get number3 => '3';

  @override
  String orderIdDisplay(String orderId) {
    return 'Заказ: $orderId';
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
    return 'Заказ: $orderId';
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
  String get cancel => 'Отмена';

  @override
  String get search => 'Поиск';

  @override
  String get yourSearchedOrders => 'Найденные заказы';

  @override
  String get tapHereToPickDates => 'Нажмите здесь, чтобы выбрать даты';

  @override
  String fromDate(String date) {
    return 'С: $date';
  }

  @override
  String toDate(String date) {
    return 'По: $date';
  }

  @override
  String get fillAllTheFields => 'Заполните все поля';

  @override
  String get readDescription => 'Прочтите описание';

  @override
  String get addToCart => 'В корзину';

  @override
  String get yourProfile => 'Ваш профиль:';

  @override
  String get signOut => '  Выйти';

  @override
  String get adminMenu => 'Меню администратора';

  @override
  String get highGraphics => 'Высокая графика';

  @override
  String get youMustRegisterToBuy => 'Вам нужно зарегистрироваться для покупки';

  @override
  String get shoppingCart => 'Корзина';

  @override
  String get confirmThePurchase => 'Подтвердите покупку';

  @override
  String get contctOurSupportTeamFoAssistance =>
      'Свяжитесь с поддержкой\n для помощи';

  @override
  String get heyYouHaven => 'Эй, вы не выбрали ничего';

  @override
  String get youHave1UnpaidOrder => 'У вас 1 неоплаченный заказ!';

  @override
  String get youHavenUnpaidOrdersSTART => 'У вас';

  @override
  String get youHavenUnpaidOrdersEND => 'Неоплаченных заказов!';

  @override
  String get howDidYouGEtHere => 'Как вы сюда попали?!';

  @override
  String get total => 'Итого';

  @override
  String get checkout => 'Оформить заказ';

  @override
  String orderPaymentId(String paymentId) {
    return 'Заказ: $paymentId';
  }

  @override
  String totalOrderPrice(String totalPrice) {
    return 'Итого: $totalPrice';
  }

  @override
  String get pay => 'Оплатить';

  @override
  String orderCartItemsLength(String count) {
    return ' $count';
  }

  @override
  String orderTotalPriceAlt(String price) {
    return ' \$$price';
  }

  @override
  String get featuredndeals => 'Рекомендуемые\nпредложения';

  @override
  String get more => 'Ещё';

  @override
  String get failedToSendTheMessage => 'Не удалось отправить сообщение :(';

  @override
  String get oopsNoChatThread => 'Упс, нет ветки чата';

  @override
  String get startTheChat => 'Начать чат';
}
