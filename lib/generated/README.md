# crabpay_connector SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
CrabpayConnectorConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetAllProductsQuery
#### Required Arguments
```dart
// No required arguments
CrabpayConnectorConnector.instance.getAllProductsQuery().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAllProductsQueryData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await CrabpayConnectorConnector.instance.getAllProductsQuery();
GetAllProductsQueryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = CrabpayConnectorConnector.instance.getAllProductsQuery().ref();
ref.execute();

ref.subscribe(...);
```


### GetProductFieldsQuery
#### Required Arguments
```dart
String productId = ...;
CrabpayConnectorConnector.instance.getProductFieldsQuery(
  productId: productId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProductFieldsQueryData, GetProductFieldsQueryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await CrabpayConnectorConnector.instance.getProductFieldsQuery(
  productId: productId,
);
GetProductFieldsQueryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;

final ref = CrabpayConnectorConnector.instance.getProductFieldsQuery(
  productId: productId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetAllCurrenciesQuery
#### Required Arguments
```dart
// No required arguments
CrabpayConnectorConnector.instance.getAllCurrenciesQuery().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAllCurrenciesQueryData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await CrabpayConnectorConnector.instance.getAllCurrenciesQuery();
GetAllCurrenciesQueryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = CrabpayConnectorConnector.instance.getAllCurrenciesQuery().ref();
ref.execute();

ref.subscribe(...);
```


### GetCartItemsQuery
#### Required Arguments
```dart
String userId = ...;
CrabpayConnectorConnector.instance.getCartItemsQuery(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetCartItemsQueryData, GetCartItemsQueryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await CrabpayConnectorConnector.instance.getCartItemsQuery(
  userId: userId,
);
GetCartItemsQueryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = CrabpayConnectorConnector.instance.getCartItemsQuery(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetUserCartCount
#### Required Arguments
```dart
String userId = ...;
CrabpayConnectorConnector.instance.getUserCartCount(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserCartCountData, GetUserCartCountVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await CrabpayConnectorConnector.instance.getUserCartCount(
  userId: userId,
);
GetUserCartCountData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = CrabpayConnectorConnector.instance.getUserCartCount(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetProductCartCount
#### Required Arguments
```dart
String userId = ...;
String productId = ...;
CrabpayConnectorConnector.instance.getProductCartCount(
  userId: userId,
  productId: productId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProductCartCountData, GetProductCartCountVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await CrabpayConnectorConnector.instance.getProductCartCount(
  userId: userId,
  productId: productId,
);
GetProductCartCountData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
String productId = ...;

final ref = CrabpayConnectorConnector.instance.getProductCartCount(
  userId: userId,
  productId: productId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### AddProduct
#### Required Arguments
```dart
String description = ...;
String imageUrl = ...;
String name = ...;
String currencies = ...;
CrabpayConnectorConnector.instance.addProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  currencies: currencies,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddProduct, we created `AddProductBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddProductVariablesBuilder {
  ...
 
  AddProductVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }

  ...
}
CrabpayConnectorConnector.instance.addProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  currencies: currencies,
)
.id(id)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AddProductData, AddProductVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  currencies: currencies,
);
AddProductData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String description = ...;
String imageUrl = ...;
String name = ...;
String currencies = ...;

final ref = CrabpayConnectorConnector.instance.addProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  currencies: currencies,
).ref();
ref.execute();
```


### DeleteProduct
#### Required Arguments
```dart
String id = ...;
CrabpayConnectorConnector.instance.deleteProduct(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteProductData, DeleteProductVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.deleteProduct(
  id: id,
);
DeleteProductData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = CrabpayConnectorConnector.instance.deleteProduct(
  id: id,
).ref();
ref.execute();
```


### UpdateProduct
#### Required Arguments
```dart
String id = ...;
CrabpayConnectorConnector.instance.updateProduct(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateProduct, we created `UpdateProductBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateProductVariablesBuilder {
  ...
   UpdateProductVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateProductVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }
  UpdateProductVariablesBuilder imageUrl(String? t) {
   _imageUrl.value = t;
   return this;
  }
  UpdateProductVariablesBuilder currencies(String? t) {
   _currencies.value = t;
   return this;
  }

  ...
}
CrabpayConnectorConnector.instance.updateProduct(
  id: id,
)
.name(name)
.description(description)
.imageUrl(imageUrl)
.currencies(currencies)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateProductData, UpdateProductVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.updateProduct(
  id: id,
);
UpdateProductData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = CrabpayConnectorConnector.instance.updateProduct(
  id: id,
).ref();
ref.execute();
```


### AddProductField
#### Required Arguments
```dart
String productId = ...;
int order = ...;
String handler = ...;
String fieldName = ...;
bool isPriceImage = ...;
CrabpayConnectorConnector.instance.addProductField(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
  isPriceImage: isPriceImage,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddProductField, we created `AddProductFieldBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddProductFieldVariablesBuilder {
  ...
   AddProductFieldVariablesBuilder priceImages(AnyValue? t) {
   _priceImages.value = t;
   return this;
  }
  AddProductFieldVariablesBuilder expectedData(List<String>? t) {
   _expectedData.value = t;
   return this;
  }

  ...
}
CrabpayConnectorConnector.instance.addProductField(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
  isPriceImage: isPriceImage,
)
.priceImages(priceImages)
.expectedData(expectedData)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AddProductFieldData, AddProductFieldVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addProductField(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
  isPriceImage: isPriceImage,
);
AddProductFieldData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;
int order = ...;
String handler = ...;
String fieldName = ...;
bool isPriceImage = ...;

final ref = CrabpayConnectorConnector.instance.addProductField(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
  isPriceImage: isPriceImage,
).ref();
ref.execute();
```


### DeleteProductField
#### Required Arguments
```dart
String id = ...;
CrabpayConnectorConnector.instance.deleteProductField(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteProductFieldData, DeleteProductFieldVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.deleteProductField(
  id: id,
);
DeleteProductFieldData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = CrabpayConnectorConnector.instance.deleteProductField(
  id: id,
).ref();
ref.execute();
```


### AddCurrencies
#### Required Arguments
```dart
String name = ...;
String mainCurrency = ...;
double rub = ...;
double usd = ...;
CrabpayConnectorConnector.instance.addCurrencies(
  name: name,
  mainCurrency: mainCurrency,
  rub: rub,
  usd: usd,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddCurrenciesData, AddCurrenciesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addCurrencies(
  name: name,
  mainCurrency: mainCurrency,
  rub: rub,
  usd: usd,
);
AddCurrenciesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;
String mainCurrency = ...;
double rub = ...;
double usd = ...;

final ref = CrabpayConnectorConnector.instance.addCurrencies(
  name: name,
  mainCurrency: mainCurrency,
  rub: rub,
  usd: usd,
).ref();
ref.execute();
```


### DeleteCurrencies
#### Required Arguments
```dart
String id = ...;
CrabpayConnectorConnector.instance.deleteCurrencies(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCurrenciesData, DeleteCurrenciesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.deleteCurrencies(
  id: id,
);
DeleteCurrenciesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = CrabpayConnectorConnector.instance.deleteCurrencies(
  id: id,
).ref();
ref.execute();
```


### productFieldUpdate
#### Required Arguments
```dart
String productId = ...;
int order = ...;
String handler = ...;
String fieldName = ...;
bool isPriceImage = ...;
CrabpayConnectorConnector.instance.productFieldUpdate(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
  isPriceImage: isPriceImage,
).execute();
```

#### Optional Arguments
We return a builder for each query. For productFieldUpdate, we created `productFieldUpdateBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ProductFieldUpdateVariablesBuilder {
  ...
 
  ProductFieldUpdateVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }
  ProductFieldUpdateVariablesBuilder priceImages(AnyValue? t) {
   _priceImages.value = t;
   return this;
  }
  ProductFieldUpdateVariablesBuilder expectedData(List<String>? t) {
   _expectedData.value = t;
   return this;
  }

  ...
}
CrabpayConnectorConnector.instance.productFieldUpdate(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
  isPriceImage: isPriceImage,
)
.id(id)
.priceImages(priceImages)
.expectedData(expectedData)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<productFieldUpdateData, productFieldUpdateVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.productFieldUpdate(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
  isPriceImage: isPriceImage,
);
productFieldUpdateData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;
int order = ...;
String handler = ...;
String fieldName = ...;
bool isPriceImage = ...;

final ref = CrabpayConnectorConnector.instance.productFieldUpdate(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
  isPriceImage: isPriceImage,
).ref();
ref.execute();
```


### currenciesUpdate
#### Required Arguments
```dart
String id = ...;
String name = ...;
String mainCurrency = ...;
double rub = ...;
double usd = ...;
CrabpayConnectorConnector.instance.currenciesUpdate(
  id: id,
  name: name,
  mainCurrency: mainCurrency,
  rub: rub,
  usd: usd,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<currenciesUpdateData, currenciesUpdateVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.currenciesUpdate(
  id: id,
  name: name,
  mainCurrency: mainCurrency,
  rub: rub,
  usd: usd,
);
currenciesUpdateData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String mainCurrency = ...;
double rub = ...;
double usd = ...;

final ref = CrabpayConnectorConnector.instance.currenciesUpdate(
  id: id,
  name: name,
  mainCurrency: mainCurrency,
  rub: rub,
  usd: usd,
).ref();
ref.execute();
```


### deleteCartItem
#### Required Arguments
```dart
String id = ...;
CrabpayConnectorConnector.instance.deleteCartItem(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<deleteCartItemData, deleteCartItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.deleteCartItem(
  id: id,
);
deleteCartItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = CrabpayConnectorConnector.instance.deleteCartItem(
  id: id,
).ref();
ref.execute();
```


### addCartItem
#### Required Arguments
```dart
String userId = ...;
String userName = ...;
String productId = ...;
String productName = ...;
AnyValue purchaseData = ...;
String currency = ...;
double checkoutPrice = ...;
String status = ...;
CrabpayConnectorConnector.instance.addCartItem(
  userId: userId,
  userName: userName,
  productId: productId,
  productName: productName,
  purchaseData: purchaseData,
  currency: currency,
  checkoutPrice: checkoutPrice,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For addCartItem, we created `addCartItemBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddCartItemVariablesBuilder {
  ...
 
  AddCartItemVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }
  AddCartItemVariablesBuilder comment(String? t) {
   _comment.value = t;
   return this;
  }

  ...
}
CrabpayConnectorConnector.instance.addCartItem(
  userId: userId,
  userName: userName,
  productId: productId,
  productName: productName,
  purchaseData: purchaseData,
  currency: currency,
  checkoutPrice: checkoutPrice,
  status: status,
)
.id(id)
.comment(comment)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<addCartItemData, addCartItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addCartItem(
  userId: userId,
  userName: userName,
  productId: productId,
  productName: productName,
  purchaseData: purchaseData,
  currency: currency,
  checkoutPrice: checkoutPrice,
  status: status,
);
addCartItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
String userName = ...;
String productId = ...;
String productName = ...;
AnyValue purchaseData = ...;
String currency = ...;
double checkoutPrice = ...;
String status = ...;

final ref = CrabpayConnectorConnector.instance.addCartItem(
  userId: userId,
  userName: userName,
  productId: productId,
  productName: productName,
  purchaseData: purchaseData,
  currency: currency,
  checkoutPrice: checkoutPrice,
  status: status,
).ref();
ref.execute();
```


### UpdateCartItem
#### Required Arguments
```dart
String id = ...;
CrabpayConnectorConnector.instance.updateCartItem(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateCartItem, we created `UpdateCartItemBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateCartItemVariablesBuilder {
  ...
   UpdateCartItemVariablesBuilder userId(String? t) {
   _userId.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder userName(String? t) {
   _userName.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder status(String? t) {
   _status.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder comment(String? t) {
   _comment.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder statusChangedAt(Timestamp? t) {
   _statusChangedAt.value = t;
   return this;
  }

  ...
}
CrabpayConnectorConnector.instance.updateCartItem(
  id: id,
)
.userId(userId)
.userName(userName)
.status(status)
.comment(comment)
.statusChangedAt(statusChangedAt)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateCartItemData, UpdateCartItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.updateCartItem(
  id: id,
);
UpdateCartItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = CrabpayConnectorConnector.instance.updateCartItem(
  id: id,
).ref();
ref.execute();
```


### DeleteLastAddedProductCartItem
#### Required Arguments
```dart
String userId = ...;
String productId = ...;
CrabpayConnectorConnector.instance.deleteLastAddedProductCartItem(
  userId: userId,
  productId: productId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteLastAddedProductCartItemData, DeleteLastAddedProductCartItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.deleteLastAddedProductCartItem(
  userId: userId,
  productId: productId,
);
DeleteLastAddedProductCartItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
String productId = ...;

final ref = CrabpayConnectorConnector.instance.deleteLastAddedProductCartItem(
  userId: userId,
  productId: productId,
).ref();
ref.execute();
```

