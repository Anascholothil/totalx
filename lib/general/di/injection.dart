import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:totalx_testpproject/general/di/injection.config.dart';


final GetIt sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)

Future <void>configureDependancy()async{
  await init(
    sl,environment : Environment.prod
  );
}
