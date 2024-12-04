import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:totalx_testpproject/features/home/data/i_mainfacade.dart';
import 'package:totalx_testpproject/features/home/data/model/user_models.dart';
import 'package:totalx_testpproject/general/services/keyword_search.dart';

class Mainprovider extends ChangeNotifier {
  final IMainfacade iMainfacade;
  Mainprovider(this.iMainfacade);

  //init load
  bool isLoading = false;

//
  int sortAge = 0;

// Assign into List
  List<UserModel> userList = [];

  //Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController searchController = TextEditingController();



  //firestrore Instance

  //Add Func
  Future<void> uploadUser(
    BuildContext context, {
    required void Function(String) errors,
    required void Function() onSuccess,
  }) async {
    final userModel = UserModel(
      name: nameController.text,
      age: int.parse(ageController.text),
      createdAt: Timestamp.now(),
      searchKeywords: generateKeywords(nameController.text),
    );
    final result = await iMainfacade.uploadUser(userModel: userModel);
    result.fold(
      (errs) {
        log(errs.errormsg);
        errors(errs.errormsg);
        log('fty');
      },
      (success) {
        log(success);
        onSuccess.call();
      },
    );
  }

// Local call
  void adddUserfeild(UserModel user) {
    userList.insert(0, user);
    notifyListeners();
  }

  //Clear controllers
  void clearFeilds() {
    nameController.clear();
    ageController.clear();
  }


//clear userlist
  void clearUserList() {
    iMainfacade.clearData();
    userList = [];
    notifyListeners();
  }



//fetch func
  Future<void> _fetchuser({int? filterOlder, String? search}) async {
    isLoading = true;
    notifyListeners();
    final result =
        await iMainfacade.fetchUser(filterOlder: filterOlder, search: search);
    result.fold(
      (l) {
        log(l.errormsg);
      },
      (list) {
        userList.addAll(list);
        if (list.length < 11) {}
      },
    );
    isLoading = false;
    notifyListeners();
  }


//update sort
  Future<void> updateSortOption(
      {required ScrollController scrollController,
      required option,
      String? search}) async {
    sortAge = option;
    clearUserList();
    initData(
      scrollController: scrollController,
    );

    notifyListeners();
  }


//search fun
  Future<void> searchOption({
    required ScrollController scrollController,
    required String search,
  }) async {
    clearUserList();
    if (search.isNotEmpty) {
      initData(
        scrollController: scrollController,
      );
    } else {
      initData(
        scrollController: scrollController,
      );
    }
    notifyListeners();
  }

 
  Future<void> initData({
    required ScrollController scrollController,
  }) async {
    clearUserList();
    if (searchController.text != "") {
      _fetchuser(filterOlder: sortAge, search: searchController.text);
    } else {
      _fetchuser(filterOlder: sortAge);
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        _fetchuser();
      }
      if (searchController.text != "") {
        _fetchuser(filterOlder: sortAge, search: searchController.text);
      } else {
        _fetchuser(filterOlder: sortAge);
      }
    });
  }

// Future<void> initData({
//   required ScrollController scrollController,

// }) async {
//   clearUserList();

//   // Initial fetch
//   await _fetchUser(filterOlder: sortAge, search: searchController.text);

//   scrollController.addListener(() {
//     // Check if we're near the end of the list and not already loading
//     if (scrollController.position.pixels >=
//         scrollController.position.maxScrollExtent - 50 &&
//         !isLoading) {
//       // Trigger next page load
//       _fetchUser(filterOlder: sortAge, search: searchController.text);
//     }
//   });
// }

  // Future<void> scrollListener() async {
  //   if (scrollController.position.pixels ==
  //           scrollController.position.maxScrollExtent &&
  //       !isLoading) {
  //     await fetchUser();
  //   }
  // }

  // @override
  // void dispose() {
  //   scrollController.dispose();
  //   super.dispose();
  // }

// List<String> generateKeywords(String text) {
//   List<String> keywords = [];
//   final words = text.toLowerCase().split(" ");
//   for (var word in words) {
//     for (int i = 1; i <= word.length; i++) {
//       keywords.add(word.substring(0, i));
//     }
//   }
//   return keywords;
// }

// Search Method
  Future<List<UserModel>> searchUsers(String keyword) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('searchKeywords', arrayContains: keyword.toLowerCase())
        .get();

    return querySnapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();
  }
}
