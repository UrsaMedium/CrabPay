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


### GetProductPropertiesQuery
#### Required Arguments
```dart
String productId = ...;
CrabpayConnectorConnector.instance.getProductPropertiesQuery(
  productId: productId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProductPropertiesQueryData, GetProductPropertiesQueryVariables>`
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

final result = await CrabpayConnectorConnector.instance.getProductPropertiesQuery(
  productId: productId,
);
GetProductPropertiesQueryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;

final ref = CrabpayConnectorConnector.instance.getProductPropertiesQuery(
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


### AddProductProperty
#### Required Arguments
```dart
String productId = ...;
int order = ...;
String handler = ...;
String propertyName = ...;
CrabpayConnectorConnector.instance.addProductProperty(
  productId: productId,
  order: order,
  handler: handler,
  propertyName: propertyName,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddProductProperty, we created `AddProductPropertyBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddProductPropertyVariablesBuilder {
  ...
   AddProductPropertyVariablesBuilder attributes(AnyValue? t) {
   _attributes.value = t;
   return this;
  }
  AddProductPropertyVariablesBuilder dataHandler(AnyValue? t) {
   _dataHandler.value = t;
   return this;
  }

  ...
}
CrabpayConnectorConnector.instance.addProductProperty(
  productId: productId,
  order: order,
  handler: handler,
  propertyName: propertyName,
)
.attributes(attributes)
.dataHandler(dataHandler)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AddProductPropertyData, AddProductPropertyVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addProductProperty(
  productId: productId,
  order: order,
  handler: handler,
  propertyName: propertyName,
);
AddProductPropertyData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;
int order = ...;
String handler = ...;
String propertyName = ...;

final ref = CrabpayConnectorConnector.instance.addProductProperty(
  productId: productId,
  order: order,
  handler: handler,
  propertyName: propertyName,
).ref();
ref.execute();
```


### DeleteProductProperty
#### Required Arguments
```dart
String id = ...;
CrabpayConnectorConnector.instance.deleteProductProperty(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteProductPropertyData, DeleteProductPropertyVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.deleteProductProperty(
  id: id,
);
DeleteProductPropertyData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = CrabpayConnectorConnector.instance.deleteProductProperty(
  id: id,
).ref();
ref.execute();
```

