# Basic Usage

```dart
CrabpayConnectorConnector.instance.GetAllProductsQuery().execute();
CrabpayConnectorConnector.instance.GetProductFieldsQuery(getProductFieldsQueryVariables).execute();
CrabpayConnectorConnector.instance.GetAllCurrenciesQuery().execute();
CrabpayConnectorConnector.instance.GetCartItemsQuery(getCartItemsQueryVariables).execute();
CrabpayConnectorConnector.instance.GetUserCartCount(getUserCartCountVariables).execute();
CrabpayConnectorConnector.instance.GetProductCartCount(getProductCartCountVariables).execute();
CrabpayConnectorConnector.instance.GetFeaturedProducts().execute();
CrabpayConnectorConnector.instance.AddProduct(addProductVariables).execute();
CrabpayConnectorConnector.instance.DeleteProduct(deleteProductVariables).execute();
CrabpayConnectorConnector.instance.UpdateProduct(updateProductVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await CrabpayConnectorConnector.instance.UpdateCartItem({ ... })
.userId(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

