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

### addProductMutation
#### Required Arguments
```dart
String productId = ...;
String name = ...;
double price = ...;
CrabpayConnectorConnector.instance.addProductMutation(
  productId: productId,
  name: name,
  price: price,
).execute();
```

#### Optional Arguments
We return a builder for each query. For addProductMutation, we created `addProductMutationBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddProductMutationVariablesBuilder {
  ...
   AddProductMutationVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }
  AddProductMutationVariablesBuilder imageUrl(String? t) {
   _imageUrl.value = t;
   return this;
  }

  ...
}
CrabpayConnectorConnector.instance.addProductMutation(
  productId: productId,
  name: name,
  price: price,
)
.description(description)
.imageUrl(imageUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<addProductMutationData, addProductMutationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addProductMutation(
  productId: productId,
  name: name,
  price: price,
);
addProductMutationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;
String name = ...;
double price = ...;

final ref = CrabpayConnectorConnector.instance.addProductMutation(
  productId: productId,
  name: name,
  price: price,
).ref();
ref.execute();
```

