import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_exceptions.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/inner_pap_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/product_controller.dart';
import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OuterProductAndPropertiesHandler
    implements InnerProductAndPropertiesHandler {
  @override
  Future<void> addProduct(AppProduct product) async {
    try {
      await CrabpayConnectorConnector.instance
          .addProduct(
            description: product.description,
            imageUrl: product.image,
            name: product.name,
            price: product.price,
          )
          .execute();
      fetchAllPAPData();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }

  @override
  Future<void> addProductProperty(AppProductProperty property) async {
    try {
      AnyValue? attributes;
      if (property.attributes != null) {
        attributes = AnyValue(property.attributes!.cast<String, dynamic>());
      }
      AnyValue? dataHandler;
      if (property.dataHandler != null) {
        dataHandler = AnyValue(property.dataHandler!.cast<String, dynamic>());
      }
      await CrabpayConnectorConnector.instance
          .addProductProperty(
            productId: property.productId,
            order: property.order,
            attributes: attributes,
            dataHandler: dataHandler,
            handler: property.handler,
            propertyName: property.propertyName,
          )
          .execute();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }

  @override
  Future<void> deleteProduct(AppProduct product) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProductProperty(AppProductProperty property) async {
    await CrabpayConnectorConnector.instance
        .deleteProductProperty(id: property.id)
        .execute();
  }

  @override
  Future<void> fetchAllPAPData() async {
    PAPDataHandler papDataHandler = PAPDataHandler();
    try {
      final productFetrcher = await CrabpayConnectorConnector.instance
          .getAllProductsQuery()
          .execute();
      final fetchedAppProducts = papDataHandler.productDataConsolidation(
        productFetrcher.data.products,
      );

      final propertyFetcher = await CrabpayConnectorConnector.instance
          .getProductPropertiesQuery(productId: productId);
      Fluttertoast.showToast(msg: 'Suck sus');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }
}


// class FirebaseDataConnectProductPropertyHandler
//     implements AppProductPropertyHandler {
//   List<AppProductProperty> _propertiesDataConsolidation(
//     List<GetProductPropertiesQueryProductProperties>
//     fetchedAppProductProperties,
//   ) {
//     List<AppProductProperty> result = [];
//     Map<String, String?>? tempAttrinutesMap;
//     Map<String, String>? tempDataHandlerMap;
//     for (var element in fetchedAppProductProperties) {
//       tempAttrinutesMap = element.attributes as Map<String, String?>?;
//       tempDataHandlerMap = element.dataHandler as Map<String, String>?;
//       result.add(
//         AppProductProperty(
//           id: element.id,
//           productId: element.productId,
//           order: element.order,
//           propertyName: element.propertyName,
//           handler: element.handler,
//           attributes: tempAttrinutesMap,
//           dataHandler: tempDataHandlerMap,
//         ),
//       );
//     }
//     return result;
//   }



//   @override
//   Future<List<AppProductProperty>> productPropertiesOfProduct(
//     String productId,
//   ) async {
//     try {
//       final fetcher = await CrabpayConnectorConnector.instance
//           .getProductPropertiesQuery(productId: productId)
//           .execute();
//       return _propertiesDataConsolidation(fetcher.data.productProperties);
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Failed to fetch $e');
//       rethrow;
//     }
//   }
// }





// List<GetAllProductsQueryProducts> fetchedAppProducts = [];

// Future<void> productDataOuterCircleFetcher() async {
//   try {
//     final fetrcher = await CrabpayConnectorConnector.instance
//         .getAllProductsQuery()
//         .execute();
//     fetchedAppProducts = fetrcher.data.products;
//     Fluttertoast.showToast(msg: 'Suck sus');
//   } catch (e) {
//     Fluttertoast.showToast(msg: 'Failed to fetch $e');
//   }
// }

// late OperationResult<AddProductData, AddProductVariables> productInserter;
// Future<void> addProductWithProperties() async {
//   try {
//     await CrabpayConnectorConnector.instance
//         .addProduct(
//           description: 'description',
//           imageUrl: 'lib/assets/images/gas-gas-gas.jpg',
//           name: 'Gas',
//           price: 123,
//         )
//         .execute();

//     Fluttertoast.showToast(msg: 'Suck sus');
//   } catch (e) {
//     Fluttertoast.showToast(msg: 'Failed to fetch $e');
//   }
// }



// final List<AppProduct> appProducts = [];

// void dataConsolidation() {
//   for (var element in fetchedAppProducts) {
//     appProducts.add(
//       AppProduct(
//         id: element.id,
//         name: element.name,
//         image: element.imageUrl!,
//         description: element.description,
//         price: element.price,
//       ),
//     );
//   }
// }
