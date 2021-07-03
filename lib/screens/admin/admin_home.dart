import 'package:e_commerce_app/consts.dart';
import 'package:flutter/material.dart';
class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text("ADMIN HOME"),
        backgroundColor: mainColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            RaisedButton(child:Text("Add Product"),onPressed: (){
              Navigator.pushNamed(context, "add_product");
            }),
            RaisedButton(child:Text("View Products"),onPressed: (){
              Navigator.pushNamed(context, "manage_product");
            }),
            RaisedButton(child:Text("View Orders"),onPressed: (){
              Navigator.pushNamed(context, "orders_screen");
            }),
          ],
        ),
      ),
    );
  }
}