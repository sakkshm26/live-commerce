import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchbase/common/widgets/custom_textfield.dart';
import 'package:touchbase/common/widgets/form_button.dart';
import 'package:touchbase/common/widgets/primary_button.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/constants/util_functions.dart';
import 'package:touchbase/features/store/services/product_services.dart';
import 'package:image_picker/image_picker.dart';

class AddOrEditProductScreen extends StatefulWidget {
  static const String routeName = '/add-or-edit-product';
  final String type;
  final String? id;
  final String? title;
  final String? description;
  final num? price;
  final String? productUrl;
  const AddOrEditProductScreen(
      {super.key, required this.type, this.id, this.title, this.description, this.price, this.productUrl});

  @override
  State<AddOrEditProductScreen> createState() => _AddOrEditProductScreenState();
}

class _AddOrEditProductScreenState extends State<AddOrEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _productUrl = TextEditingController();
  bool isLoading = false;
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: "Failed to pick image");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.type == "EDIT") {
      _titleController.text = widget.title!;
      _descriptionController.text = widget.description!;
      _priceController.text = widget.price!.toString();
      _productUrl.text = widget.productUrl == null ? "" : widget.productUrl!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _productUrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(controller: _titleController, hintText: "Title", theme: "light"),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(controller: _descriptionController, hintText: "Description", theme: "light"),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controller: _priceController,
                            hintText: "Price",
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            theme: "light",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(controller: _productUrl, hintText: "Product URL", theme: "light"),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: Column(
                              children: [
                                PrimaryButton(
                                  onPressed: pickImage,
                                  title: "Upload Image",
                                  isLoading: false,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                image != null ? Text(image!.path.split('/').last) : const Text("No Image Uploaded"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FormButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.type == "ADD") {
                          if (image == null) {
                            if (context.mounted) {
                              showCustomSnackBar(context: context, message: "Product image is required");
                            }
                            return;
                          }
                          if (mounted) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          ServiceReturnType res = await ProductServices().addProduct(
                            context: context,
                            data: {
                              "title": _titleController.text,
                              "description": _descriptionController.text,
                              "price": _priceController.text,
                              "product_url": _productUrl.text,
                              "image": image
                            },
                          );

                          if (res.errorMessage != null) {
                            if (context.mounted) {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              showCustomSnackBar(context: context, message: res.errorMessage!);
                            }
                          } else {
                            if (context.mounted) {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              Navigator.pop(context);
                            }
                          }
                        } else {
                          if (mounted) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          ServiceReturnType res = await ProductServices().updateProduct(
                            context: context,
                            data: {
                              "id": widget.id,
                              "title": _titleController.text,
                              "description": _descriptionController.text,
                              "price": double.parse(_priceController.text),
                              "image": image,
                              "product_url": _productUrl.text
                            },
                          );

                          if (res.errorMessage != null) {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            if (context.mounted) {
                              showCustomSnackBar(context: context, message: res.errorMessage!);
                            }
                          } else {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            if (context.mounted) {
                              Navigator.pop(
                                context,
                                {
                                  "title": res.data["title"],
                                  "description": res.data["description"],
                                  "price": res.data["price"],
                                  "image_url": res.data["image_url"],
                                  "product_url": res.data["product_url"],
                                },
                              );
                            }
                          }
                        }
                      }
                    },
              title: widget.type == "ADD" ? "Add" : "Update",
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}
