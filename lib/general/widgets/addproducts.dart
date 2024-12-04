import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:totalx_testpproject/features/home/presentation/provider/product_provider.dart';

void addProductPopUp(BuildContext context,{required String userId}) {
  

  // GlobalKey for form validation
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer<ProductProvider>(builder: (context, pro, child) {
          
          return SingleChildScrollView(
            child: Container(
              height:
                  600, // Increased height to accommodate both fields and buttons
              width: 300,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey, // Attach the form key to the form
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Product Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Product Name Field
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 20),
                          child: Text(
                            'Product Name',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: pro.productNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: 'Enter Product Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 20),
                          child: Text(
                            'Product Stock',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        ],
                        controller: pro.productStockController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: 'Enter Product Stock',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
            
                    // Product Price Field
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text(
                            'Product Price',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: pro.productPriceController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Enter Product Price',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product price';
                          }
                          final price = double.tryParse(value);
                          if (price == null || price <= 0) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
            
                    // Buttons for Save and Close
            
                    const SizedBox(width: 20),
                    // Save Button
                    Consumer<ProductProvider>(
                      builder: (context,prov,child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(
                                255, 43, 170, 104), // Set text color (Close Button)
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              // Get the product details from controllers
                              final productName =prov. productNameController.text;
                              final productPrice =prov. productPriceController.text;
                        
                              // You can handle saving the product here, for example:
                              // saveProduct(productName, productPrice);
                        
                              // Show confirmation or success message
                              Navigator.pop(context); // Close the dialog after saving
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Product Saved",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightGreenAccent),
                                    ),
                                    content: Text(
                                        'Product: $productName\nPrice: \$$productPrice'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          pro.uploadProduct(onFailure: (){}, onSuccess: (){}, userId: userId);
                                          Navigator.pop(context);
            
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}
