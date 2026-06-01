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


### GetPriceFunctionQuery
#### Required Arguments
```dart
String productId = ...;
CrabpayConnectorConnector.instance.getPriceFunctionQuery(
  productId: productId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPriceFunctionQueryData, GetPriceFunctionQueryVariables>`
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

final result = await CrabpayConnectorConnector.instance.getPriceFunctionQuery(
  productId: productId,
);
GetPriceFunctionQueryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;

final ref = CrabpayConnectorConnector.instance.getPriceFunctionQuery(
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

## Mutations

### AddProduct
#### Required Arguments
```dart
String description = ...;
String imageUrl = ...;
String name = ...;
CrabpayConnectorConnector.instance.addProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
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

final ref = CrabpayConnectorConnector.instance.addProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
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


### AddProductField
#### Required Arguments
```dart
String productId = ...;
int order = ...;
String handler = ...;
String fieldName = ...;
CrabpayConnectorConnector.instance.addProductField(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddProductField, we created `AddProductFieldBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddProductFieldVariablesBuilder {
  ...
   AddProductFieldVariablesBuilder attributes(AnyValue? t) {
   _attributes.value = t;
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
)
.attributes(attributes)
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

final ref = CrabpayConnectorConnector.instance.addProductField(
  productId: productId,
  order: order,
  handler: handler,
  fieldName: fieldName,
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


### AddPriceFunction
#### Required Arguments
```dart
String productId = ...;
String name = ...;
String type = ...;
AnyValue formulas = ...;
String currency = ...;
CrabpayConnectorConnector.instance.addPriceFunction(
  productId: productId,
  name: name,
  type: type,
  formulas: formulas,
  currency: currency,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddPriceFunctionData, AddPriceFunctionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addPriceFunction(
  productId: productId,
  name: name,
  type: type,
  formulas: formulas,
  currency: currency,
);
AddPriceFunctionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;
String name = ...;
String type = ...;
AnyValue formulas = ...;
String currency = ...;

final ref = CrabpayConnectorConnector.instance.addPriceFunction(
  productId: productId,
  name: name,
  type: type,
  formulas: formulas,
  currency: currency,
).ref();
ref.execute();
```


### DeletePriceFunction
#### Required Arguments
```dart
String id = ...;
CrabpayConnectorConnector.instance.deletePriceFunction(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeletePriceFunctionData, DeletePriceFunctionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.deletePriceFunction(
  id: id,
);
DeletePriceFunctionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = CrabpayConnectorConnector.instance.deletePriceFunction(
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


### AddProductBatch
#### Required Arguments
```dart
String productId = ...;
String description = ...;
String imageUrl = ...;
String productName = ...;
String functionName = ...;
String type = ...;
AnyValue formulas = ...;
String currency = ...;
CrabpayConnectorConnector.instance.addProductBatch(
  productId: productId,
  description: description,
  imageUrl: imageUrl,
  productName: productName,
  functionName: functionName,
  type: type,
  formulas: formulas,
  currency: currency,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddProductBatchData, AddProductBatchVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await CrabpayConnectorConnector.instance.addProductBatch(
  productId: productId,
  description: description,
  imageUrl: imageUrl,
  productName: productName,
  functionName: functionName,
  type: type,
  formulas: formulas,
  currency: currency,
);
AddProductBatchData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String productId = ...;
String description = ...;
String imageUrl = ...;
String productName = ...;
String functionName = ...;
String type = ...;
AnyValue formulas = ...;
String currency = ...;

final ref = CrabpayConnectorConnector.instance.addProductBatch(
  productId: productId,
  description: description,
  imageUrl: imageUrl,
  productName: productName,
  functionName: functionName,
  type: type,
  formulas: formulas,
  currency: currency,
).ref();
ref.execute();
```

