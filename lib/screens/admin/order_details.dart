import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/orders.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/store.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const id = "order_details";
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    String documentId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Details"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _store.loadOrderDetails(documentId),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              List<Product> products = [];
              for (var doc in snapshot.data.docs) {
                products.add(Product(
                  name: doc.data()[proName],
                  quantity: doc.data()[proQuantity],
                  price: doc.data()[proPrice],
                  category: doc.data()[proCategory],
                ));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name :   ${products[index].name}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    " Price =  ${products[index].price}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Quantity :   ${products[index].quantity}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Category :  ${products[index].category}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: products.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: RaisedButton(
                              color: mainColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "Cancel Order",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {}),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: RaisedButton(
                              color: mainColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "Confirm Order",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {}),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
