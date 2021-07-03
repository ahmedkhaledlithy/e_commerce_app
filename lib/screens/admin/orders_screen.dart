import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/orders.dart';
import 'package:e_commerce_app/screens/admin/order_details.dart';
import 'package:e_commerce_app/services/store.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _store.loadOrders(),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              List<Order> orders = [];
              for (var doc in snapshot.data.docs) {
                orders.add(Order(
                  documentId: doc.id,
                    totalPrice: doc.data()[OrdersPrice],
                    address: doc.data()[OrdersAddress]));
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, OrderDetailsScreen.id,arguments: orders[index].documentId);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Price = \$ ${orders[index].totalPrice}",style: TextStyle(fontSize: 18),),
                              SizedBox(height: 10,),
                              Text("Address is  ${orders[index].address}",style: TextStyle(fontSize: 17),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: orders.length,
              );
            }

          }),
    );
  }
}
