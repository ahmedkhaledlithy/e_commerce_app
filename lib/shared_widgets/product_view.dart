import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/shared_widgets/functions.dart';
import 'package:flutter/material.dart';

Widget productView(String category,List<Product>allProduct) {
  List<Product>products=[];
  products=getProductByCategory(category,allProduct);
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.8),
    itemBuilder: (context, index) {
      return Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, "product_info",arguments: products[index]);
            },
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image(
                    image: AssetImage(products[index].image),
                    fit: BoxFit.fill,
                  )),
              Positioned(
                bottom: 0,
                child: Opacity(
                  opacity: 0.6,
                  child: Container(
                    color: Colors.white,
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Transform.translate(
                      offset: Offset(70, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                                products[index].name,
                                style:
                                TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Expanded(
                              child:
                              Text(" ${products[index].price} \$")),
                          Expanded(
                              child: Text(products[index].description)),
                          Expanded(
                              child: Text(products[index].category)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
    itemCount: products.length,
  );
}
