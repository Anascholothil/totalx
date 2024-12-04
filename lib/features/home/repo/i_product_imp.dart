import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:totalx_testpproject/features/home/data/i_productfacade.dart';
import 'package:totalx_testpproject/features/home/data/model/product_models.dart';
import 'package:totalx_testpproject/general/failures/failures.dart';
import 'package:totalx_testpproject/general/utils/firebase_collections.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: IProductfacade)
class IProductImp implements IProductfacade {
  final FirebaseFirestore firestore;
  IProductImp(this.firestore);

  @override
  Future<Either<MainFailures, ProductModels>> uploadProduct({
    required ProductModels prodectModels,
    required String userId,
  }) async {
    try {
      final prodectRef =
          firestore.collection(FirebaseCollections.users).doc(userId);

      final productId = const Uuid().v4();

//update meth

      await prodectRef.update({
        'products.$productId': prodectModels.copyWith(id: productId).toMap()
      });

      return right(prodectModels.copyWith(id: productId));
    } catch (e) {
      return left(MainFailures.serverFailer(errormsg: e.toString()));
    }
  }

@override
Future<Either<MainFailures, List<ProductModels>>> fetchProducts({
  required String userId,

}) async {
  try {
    // Reference to the user's document
    // final productRef = firestore.collection(FirebaseCollections.users).doc(userId);

    // Start with the products collection of the user document
    final userRef =firestore.collection(FirebaseCollections.users).doc(userId);


// Fetch the user document
    final userSnapshot = await userRef.get();


    if(!userSnapshot.exists){
      return left(const MainFailures.serverFailer(errormsg: 'user not found'));
    }


final productMap = userSnapshot.data()?['products'] as Map<String, dynamic>?;

   if (productMap == null || productMap.isEmpty) {
      return right([]); 
    }


    // Convert the map to a list
final List<ProductModels> products = productMap.entries.map((entry) {
  final productData = entry.value as Map<String, dynamic>;

  return ProductModels.fromMap(productData);
}).toList();

return right(products);
  } catch (e) {
    // Handle exceptions and return a failure
    return left(MainFailures.serverFailer(errormsg: e.toString()));
  }
}

  @override
  void clearData() {

  }


}