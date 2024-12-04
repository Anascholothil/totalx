import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx_testpproject/features/home/data/i_mainfacade.dart';
import 'package:totalx_testpproject/features/home/data/i_productfacade.dart';
import 'package:totalx_testpproject/features/home/presentation/provider/mainprovider.dart';
import 'package:totalx_testpproject/features/home/presentation/provider/product_provider.dart';
import 'package:totalx_testpproject/general/di/injection.dart';
import 'package:totalx_testpproject/veiw/homescreen.dart';
 
Future <void> main() async {
  // Ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependancy();


  runApp(
    MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (_) => Mainprovider(sl<IMainfacade>())),
        ChangeNotifierProvider(create: (_) => ProductProvider(sl<IProductfacade>())),
        // ChangeNotifierProvider(create: (_) => LoginProviderNew()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}


