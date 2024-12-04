import 'package:dartz/dartz.dart';
import 'package:totalx_testpproject/features/home/data/model/user_models.dart';
import 'package:totalx_testpproject/general/failures/failures.dart';

abstract class IMainfacade {  
  Future<Either<MainFailures, String>> uploadUser({required  UserModel userModel}){
    throw UnimplementedError('Not Implemented');
  }

  Future<Either<MainFailures,List<UserModel>>>fetchUser({int? filterOlder, String? search}){
        throw UnimplementedError('Not Implemented');
  }
  void clearData();

}