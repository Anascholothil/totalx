import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx_testpproject/features/home/presentation/provider/product_provider.dart';

class ProductviewScreen extends StatefulWidget {
  const ProductviewScreen({super.key, required this.userId});
  final String userId;
  @override
  State<ProductviewScreen> createState() => _ProductviewScreenState();
}

class _ProductviewScreenState extends State<ProductviewScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ProductProvider>().fetchProducts(
              userId: widget.userId,
            );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Product List',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: state.productList.length,
            itemBuilder: (context, index) {
              final products = state.productList[index];
              return ListTile(
                leading: Text(products.productName,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    )),
                trailing: Column(
                  children: [
                    Text(
                      'Stock: ${products.stock}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Price:   ${products.price}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              );
            },
          )),
    );
  }
}
