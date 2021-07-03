import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/store.dart';
import 'package:e_commerce_app/shared_widgets/custom_menu.dart';
import 'package:flutter/material.dart';

class ManageProduct extends StatefulWidget {
  @override
  _ManageProductState createState() => _ManageProductState();
}

Store _store = Store();

class _ManageProductState extends State<ManageProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Products"),
        centerTitle: true,
      ),
      body: _drawStreamBuilder(),

      //_drawStreamBuilder2(),

      // _drawFutureBuilder(),
    );
  }
}



Widget _drawStreamBuilder() {
  return StreamBuilder<QuerySnapshot>(
      stream: _store.loadFlowProduct(),
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

          snapshot.data.docs.map((DocumentSnapshot document) {
            products.add(Product(
              productId: document.id,
              name: document.data()[proName],
              price: document.data()[proPrice],
              category: document.data()[proCategory],
              description: document.data()[proDescription],
              image: document.data()[proImage],
            ));
          }).toList();
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
                  onTapUp: (details)async {
                    double left = details.globalPosition.dx;
                    double top = details.globalPosition.dy;
                    double right = MediaQuery.of(context).size.width - left;
                    double bottom = MediaQuery.of(context).size.height - top;

                    await showMenu(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        context: context,
                        position:
                        RelativeRect.fromLTRB(left, top, right, bottom),
                        items: [
                         MyPopupMenuItem(child: Text("Edit"), onclick: (){
                           Navigator.pushNamed(context, "edit_product",arguments: products[index]);
                         }),
                         MyPopupMenuItem(child: Text("Delete"), onclick: (){
                           _store.deleteProduct(products[index].productId);
                           Navigator.pop(context);
                         }),
                        ]);
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
      });
}




Widget _drawStreamBuilder2() {
  return StreamBuilder<QuerySnapshot>(
      stream: _store.loadFlowProduct(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Card(
                child: ListTile(
                  title: Text(document.data()[proName]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.data()[proPrice]),
                      Text(document.data()[proCategory]),
                      Text(document.data()[proDescription]),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      });
}

Widget _drawFutureBuilder() {
  return FutureBuilder<List<Product>>(
      future: _store.loadProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Card(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(snapshot.data[index].name),
                    Text(snapshot.data[index].description),
                    Text("${snapshot.data[index].price}"),
                  ],
                );
              },
              itemCount: snapshot.data.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: CircularProgressIndicator());
        }
        return Center(child: CircularProgressIndicator());
      });
}

