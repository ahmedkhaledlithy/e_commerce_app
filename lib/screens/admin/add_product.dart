import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/store.dart';
import 'package:e_commerce_app/shared_widgets/shared.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text("ADD Products"),
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
                    child: RaisedButton(child: Text("Add",style: TextStyle(fontSize: 18),), onPressed: () {
                      if(_formKey.currentState.validate()){

                        // name=_nameController.text;
                        // price=_priceController.text;
                        // category=_categoryController.text;
                        // description=_descriptionController.text;
                        // image=_imageLocationController.text;


                       _store.addProduct(Product(
                         name: _nameController.text,
                         price: _priceController.text,
                         description: _descriptionController.text,
                         category: _categoryController.text,
                         image: _imageLocationController.text
                       ));
                       Scaffold.of(context).showSnackBar(SnackBar(
                         duration: Duration(seconds: 10),
                         content: Text("Your Add Succeed"),
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
