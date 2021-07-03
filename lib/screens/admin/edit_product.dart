import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/store.dart';
import 'package:e_commerce_app/shared_widgets/shared.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _imageLocationController = TextEditingController();
  Store _store=Store();
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Product product=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text("Edit Products"),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                CustomTextFormField(
                    hint: "Product Name",
                    icon: Icons.shopping_cart,
                    inputType: TextInputType.text,
                    textController: _nameController),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    hint: "Product Price",
                    icon: Icons.monetization_on,
                    inputType: TextInputType.numberWithOptions(decimal: true),
                    textController: _priceController),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    hint: "Product Description",
                    icon: Icons.textsms,
                    inputType: TextInputType.text,
                    textController: _descriptionController),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    hint: "Product Category",
                    icon: Icons.category,
                    inputType: TextInputType.text,
                    textController: _categoryController),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    hint: "Product Location Image",
                    icon: Icons.image,
                    inputType: null,
                    textController: _imageLocationController),
                SizedBox(
                  height: 30,
                ),
                Builder(
                  builder:(context)=> Container(
                    width: 150,
                    child: RaisedButton(child: Text("UPDATE",style: TextStyle(fontSize: 18),), onPressed: () {
                      if(_formKey.currentState.validate()){

                        _store.editProduct(product.productId, {
                          proName:_nameController.text,
                          proPrice:_priceController.text,
                          proCategory:_categoryController.text,
                          proDescription:_descriptionController.text,
                          proImage:_imageLocationController.text,

                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 10),
                          content: Text("Updated Succeed"),
                        ));
                      }
                    },
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
