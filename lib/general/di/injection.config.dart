// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/home/data/i_mainfacade.dart' as _i930;
import '../../features/home/data/i_productfacade.dart' as _i27;
import '../../features/home/repo/i_main_impl.dart' as _i707;
import '../../features/home/repo/i_product_imp.dart' as _i455;
import 'injectable_module.dart' as _i109;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final firabaseInjectableModule = _$FirabaseInjectableModule();
  await gh.factoryAsync<_i109.FirebaseServices>(
    () => firabaseInjectableModule.firebaseServices,
    preResolve: true,
  );
  gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firabaseInjectableModule.firebaseFirstore);
  gh.lazySingleton<_i59.FirebaseAuth>(
      () => firabaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i27.IProductfacade>(
      () => _i455.IProductImp(gh<_i974.FirebaseFirestore>()));
  gh.lazySingleton<_i930.IMainfacade>(
      () => _i707.IMainImpl(gh<_i974.FirebaseFirestore>()));
  return getIt;
}

class _$FirabaseInjectableModule extends _i109.FirabaseInjectableModule {}
