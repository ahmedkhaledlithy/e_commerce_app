import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/provider/cartItem.dart';
import 'package:e_commerce_app/screens/users/product_info.dart';
import 'package:e_commerce_app/services/store.dart';
import 'package:e_commerce_app/shared_widgets/custom_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appbarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Cart",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          LayoutBuilder(builder: (context, constraint) {
            if (products.isNotEmpty) {
              return Container(
                height: screenHeight - (screenHeight * 0.08) - appbarHeight - statusBarHeight,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTapUp: (details) {
                        customShowMenu(details, products[index], context);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          height: screenHeight * 0.19,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(products[index].image),
                                backgroundColor: Colors.transparent,
                                radius: screenHeight * 0.17 / 2,
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    products[index].name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "total : ".toUpperCase(),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 70,
                                      ),
                                      Text(
                                        products[index].price,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Quantity : ".toUpperCase(),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 70,
                                      ),
                                      Text(
                                        products[index].quantity.toString(),
                                        style: TextStyle(fontSize: 21),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              );
            } else {
              return Container(
                height: screenHeight -
                    (screenHeight * 0.08) -
                    appbarHeight -
                    statusBarHeight,
                child: Center(
                  child: Text("Cart is Empty"),
                ),
              );
            }
          }),
          Builder(
            builder: (context) => ButtonTheme(
                minWidth: screenWidth,
                height: screenHeight * 0.08,
                child: RaisedButton(
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Order".toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      showCustomDialog(products,context);
                    })),
          ),
        ],
      ),
    );
  }

  void customShowMenu(details, product, context) async {
    double left = details.globalPosition.dx;
    double top = details.globalPosition.dy;
    double right = MediaQuery.of(context).size.width - left;
    double bottom = MediaQuery.of(context).size.height - top;

    await showMenu(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        position: RelativeRect.fromLTRB(left, top, right, bottom),
        items: [
          MyPopupMenuItem(
              child: Text("Edit"),
              onclick: () {
                Navigator.pop(context);
                Provider.of<CartItem>(context, listen: false)
                    .deleteProduct(product);
                 Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductInfo(product)) );
              }),
          MyPopupMenuItem(
              child: Text("Delete"),
              onclick: () {
                Provider.of<CartItem>(context, listen: false)
                    .deleteProduct(product);
              }),
        ]);
  }

  void showCustomDialog(List<Product> products,context) async {
    var totalPrice = getTotalPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        MaterialButton(
            child: Text("Confirm"),
            onPressed: () {
              try {
                _store.storeOrders(
                    {OrdersPrice: totalPrice, OrdersAddress: address},
                    products);
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Ordered Successfully"),
                  ),
                );
                Navigator.pop(context);
              } catch (e) {
                return e.message();
              }
            }),
      ],
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(hintText: "Enter Your Address"),
      ),
      title: Text("Total Price = \$ $totalPrice "),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotalPrice(List<Product> products) {
    var totalPrice = 0;
    for (var product in products) {
      totalPrice += int.parse(product.price);
    }
    return totalPrice;
  }
}
