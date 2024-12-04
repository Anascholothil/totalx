import 'package:dartz/dartz.dart';
import 'package:totalx_testpproject/features/home/data/model/product_models.dart';

import '../../../general/failures/failures.dart';

abstract class IProductfacade {
  Future<Either<MainFailures, ProductModels>> uploadProduct(
      {required ProductModels prodectModels, required String userId}) {
    throw UnimplementedError('Not Implemented');
  }

  Future<Either<MainFailures, List<ProductModels>>> fetchProducts({
    required String userId,
  }) {
    throw UnimplementedError('Not Implemented');
  }

  void clearData();
}
