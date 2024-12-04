import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:totalx_testpproject/features/home/presentation/provider/mainprovider.dart';
import 'package:totalx_testpproject/general/widgets/addproducts.dart';
import 'package:totalx_testpproject/general/widgets/loader_animation.dart';
import 'package:totalx_testpproject/veiw/productview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    final mainprovider = Provider.of<Mainprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainprovider.initData(
        scrollController: scrollController,
      );

      log('scroll:${mainprovider.userList.length}');
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 300,
                    width: 300,
                    padding: const EdgeInsets.all(5),
                    child:
                        Consumer<Mainprovider>(builder: (context, pro, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Credentials',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AddUserTextField(
                            labelText: "Name",
                            context: context,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            controller: pro.nameController,
                          ),
                          AddUserTextField(
                            labelText: "Age",
                            keyboardType: TextInputType.number,
                            context: context,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter age';
                              }
                              if (value.length != 2) {
                                return 'Age must be a 2-digit number';
                              }
                              return null;
                            },
                            controller: pro.ageController,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Buttons(
                                  context,
                                  label: "Cancel",
                                  color: Colors.grey[300]!,
                                  textColor: Colors.grey,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Buttons(
                                  context,
                                  label: "Save",
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (pro.nameController.text.isNotEmpty &&
                                        pro.ageController.text.isNotEmpty) {
                                      showProgress(context);
                                      final navi = Navigator.of(context);
                                      await pro.uploadUser(context,
                                          errors: (error) {}, onSuccess: () {});

                                      navi.pop();
                                      navi.pop();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Please fill all fields and select an image"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(95, 60, 5, 227),
          title: Consumer<Mainprovider>(
            builder: (context, provider, child) {
              return SizedBox(
                height: 40, // Adjust the height to fit the AppBar
                child: CupertinoSearchTextField(
                  controller: provider.searchController,
                  placeholder: 'Search...',
                  onChanged: (value) {
                    provider.searchOption(
                        scrollController: scrollController,
                        search: provider.searchController.text);
                  },
                  // onSubmitted: (value) {
                  // },
                  backgroundColor: Colors.white,
                  style: const TextStyle(color: Colors.black),
                  prefixInsets: const EdgeInsets.only(left: 10),
                  suffixInsets: const EdgeInsets.only(right: 10),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                bottomsheet(context, scrollController);
              },
              icon: const Icon(
                Icons.sort_by_alpha_sharp,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Consumer<Mainprovider>(
          builder: (context, prov, child) {
            return ListView.builder(
              controller: scrollController,
              itemCount: prov.userList.length + 1,
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {

                if (index == prov.userList.length) {
                  return prov.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }
                return ListTile(
                  title: Text(prov.userList[index].name),
                  subtitle: Text(prov.userList[index].age.toString()),
                  trailing: Column(children: [
                    Text(
                      DateFormat('EEE, dd-MMM-yy')
                          .format(prov.userList[index].createdAt.toDate()),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>   ProductviewScreen(userId: prov.userList[index].id!),),
                          
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 15),
                        child: Text(
                          'View',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue),
                        ),
                      ),
                    )
                  ]),
                  onTap: () => addProductPopUp(
                    context,
                    userId: prov.userList[index].id.toString(),
                  ),
                );
              },
            );
          },
        ));
  }
}

//botttom sheet
void bottomsheet(BuildContext context, ScrollController scrollController) {
  final navipop = Navigator.of(context);
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Consumer<Mainprovider>(
        builder: (context, prov, child) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Sort By Age',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RadioListTile<int>(
                  fillColor: WidgetStateProperty.all(Colors.blue),
                  title: const Text("All"),
                  value: 0,
                  groupValue: prov.sortAge,
                  onChanged: (value) async {
                    await prov
                        .updateSortOption(
                          scrollController: scrollController,
                          option: value ?? 0,
                        )
                        .whenComplete(
                          () => navipop.pop(),
                        );
                    print('all${prov.userList.length}');
                  },
                ),
                RadioListTile<int>(
                  fillColor: WidgetStateProperty.all(Colors.blue),
                  title: const Text("Age: Younger"),
                  value: 1,
                  groupValue: prov.sortAge,
                  onChanged: (value) async {
                    await prov
                        .updateSortOption(
                            scrollController: scrollController,
                            option: value ?? 1)
                        .whenComplete(
                          () => navipop.pop(),
                        );
                    log('young${prov.userList.length}');
                  },
                ),
                RadioListTile<int>(
                  fillColor: WidgetStateProperty.all(Colors.blue),
                  title: const Text("Age: Older"),
                  value: 2,
                  groupValue: prov.sortAge,
                  onChanged: (value) async {
                    await prov
                        .updateSortOption(
                            scrollController: scrollController,
                            option: value ?? 2)
                        .whenComplete(
                          () => navipop.pop(),
                        );
                    print('old${prov.userList.length}');
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget Buttons(BuildContext context,
    {required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.03),
    ),
    onPressed: onPressed,
    child: Text(
      label,
      style: TextStyle(color: textColor),
    ),
  );
}

Widget AddUserTextField({
  required String labelText,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  required BuildContext context,
  List<TextInputFormatter>? inputFormatter,
  String? Function(String?)? validator,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    inputFormatters: inputFormatter,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: screenWidth * 0.04,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ),
    validator: validator,
  );
}
