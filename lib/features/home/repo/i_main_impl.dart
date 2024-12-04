import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:totalx_testpproject/features/home/data/i_mainfacade.dart';
import 'package:totalx_testpproject/features/home/data/model/user_models.dart';
import 'package:totalx_testpproject/general/failures/failures.dart';
import 'package:totalx_testpproject/general/utils/firebase_collections.dart';

@LazySingleton(as: IMainfacade)
class IMainImpl implements IMainfacade {
  final FirebaseFirestore firestore;
  IMainImpl(this.firestore);

  @override
  Future<Either<MainFailures, String>> uploadUser(
      {required UserModel userModel}) async {
    try {
      final userRef = firestore.collection(FirebaseCollections.users);

      final id = userRef.doc().id;

      final user = userModel.copyWith(id: id);
      await userRef.doc(id).set(user.toMap());

      return right('User Added');
    } catch (e) {
      return left(MainFailures.serverFailer(errormsg: e.toString()));
    }
  }

  DocumentSnapshot? lastDocument;
  bool hasMore = false;

  @override
  Future<Either<MainFailures, List<UserModel>>> fetchUser(
      {int? filterOlder, String? search}) async {
    if (hasMore) return right([]);
    try {
      Query query = FirebaseFirestore.instance
          .collection("users")
          .orderBy('age', descending: true);

      if (filterOlder != null) {
        //  log("filter$filterOlder");
        if (filterOlder == 1) {
          query = query.where('age', isLessThanOrEqualTo: 40);
        } else if (filterOlder == 2) {
          query = query.where('age', isGreaterThan: 40);
        }
      }

      if (search != null) {
        query = query.where('searchKeywords',
            arrayContains: search.replaceAll(" ", "").toLowerCase());
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final querySnapshot = await query.limit(11).get();
      // log("snap ${querySnapshot.docs.length.toString()}");

      if (querySnapshot.docs.length < 11) {
        hasMore = true;
      } else {
        lastDocument = querySnapshot.docs.last;
      }

      final list = querySnapshot.docs
          .map(
            (e) => UserModel.fromMap(e.data() as Map<String, dynamic>),
          )
          .toList();

      return right(list);
    } catch (e) {
      return left(MainFailures.serverFailer(errormsg: e.toString()));
    }
  }

  @override
  void clearData() {
    lastDocument = null;
    hasMore = false;
  }
}
