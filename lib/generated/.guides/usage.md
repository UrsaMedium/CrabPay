# Basic Usage

```dart
CrabpayConnectorConnector.instance.AddProduct(addProductVariables).execute();
CrabpayConnectorConnector.instance.DeleteProduct(deleteProductVariables).execute();
CrabpayConnectorConnector.instance.AddProductField(addProductFieldVariables).execute();
CrabpayConnectorConnector.instance.DeleteProductField(deleteProductFieldVariables).execute();
CrabpayConnectorConnector.instance.AddPriceFunction(addPriceFunctionVariables).execute();
CrabpayConnectorConnector.instance.DeletePriceFunction(deletePriceFunctionVariables).execute();
CrabpayConnectorConnector.instance.AddCurrencies(addCurrenciesVariables).execute();
CrabpayConnectorConnector.instance.DeleteCurrencies(deleteCurrenciesVariables).execute();
CrabpayConnectorConnector.instance.AddProductBatch(addProductBatchVariables).execute();
CrabpayConnectorConnector.instance.UpdateProduct(updateProductVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await CrabpayConnectorConnector.instance.productFieldUpdate({ ... })
.id(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

