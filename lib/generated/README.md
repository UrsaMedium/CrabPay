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

## Mutations

### AddProduct
#### Required Arguments
```dart
String description = ...;
String imageUrl = ...;
String name = ...;
double price = ...;
CrabpayConnectorConnector.instance.addProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  price: price,
).execute();
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
  price: price,
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
double price = ...;

final ref = CrabpayConnectorConnector.instance.addProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  price: price,
).ref();
ref.execute();
```


### AddProductPropertiesToProduct
#### Required Arguments
```dart
String productId = ...;
AnyValue attributes = ...;
AnyValue dataHandler = ...;
String handler = ...;
String propertyName = ...;
CrabpayConnectorConnector.instance.addProductPropertiesToProduct(
  productId: productId,
  attributes: attributes,
  dataHandler: dataHandler,
  handler: handler,
  propertyName: propertyName,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddProductPropertiesToProductData, AddProductPropertiesToProductVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addProductPropertiesToProduct(
  productId: productId,
  attributes: attributes,
  dataHandler: dataHandler,
  handler: handler,
  propertyName: propertyName,
);
AddProductPropertiesToProductData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;
AnyValue attributes = ...;
AnyValue dataHandler = ...;
String handler = ...;
String propertyName = ...;

final ref = CrabpayConnectorConnector.instance.addProductPropertiesToProduct(
  productId: productId,
  attributes: attributes,
  dataHandler: dataHandler,
  handler: handler,
  propertyName: propertyName,
).ref();
ref.execute();
```

