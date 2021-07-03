import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/screens/users/product_info.dart';
import 'package:e_commerce_app/services/authentication.dart';
import 'package:e_commerce_app/services/store.dart';
import 'package:e_commerce_app/shared_widgets/functions.dart';
import 'package:e_commerce_app/shared_widgets/product_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Authentication _auth = Authentication();
  Store _store = Store();
  User _userLoggedin;
  int _tabBarIndex = 0;
  int _bottomNavIndex = 0;
  List<Product> _products = [];

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() {
    _userLoggedin = _auth.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _bottomNavIndex,
                fixedColor: mainColor,
                unselectedItemColor: unActiveColor,
                onTap: (value) async {
                  if (value == 2) {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    preferences.clear();
                    await _auth.signOut();
                    Navigator.popAndPushNamed(context,"login_Screen");
                  }
                  setState(() {
                    _bottomNavIndex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text("Test")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text("Test")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.exit_to_app), title: Text("SignOut")),
                ]),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                  indicatorColor: mainColor,
                  onTap: (value) {
                    setState(() {
                      _tabBarIndex = value;
                    });
                  },
                  tabs: [
                    Text(
                      "Jackets",
                      style: TextStyle(
                          color:
                              _tabBarIndex == 0 ? Colors.black : unActiveColor,
                          fontSize: _tabBarIndex == 0 ? 16 : null),
                    ),
                    Text(
                      "T-Shirts",
                      style: TextStyle(
                          color:
                              _tabBarIndex == 1 ? Colors.black : unActiveColor,
                          fontSize: _tabBarIndex == 1 ? 16 : null),
                    ),
                    Text(
                      "Shoes",
                      style: TextStyle(
                          color:
                              _tabBarIndex == 2 ? Colors.black : unActiveColor,
                          fontSize: _tabBarIndex == 2 ? 16 : null),
                    ),
                    Text(
                      "Trouser",
                      style: TextStyle(
                          color:
                              _tabBarIndex == 3 ? Colors.black : unActiveColor,
                          fontSize: _tabBarIndex == 3 ? 16 : null),
                    ),
                  ]),
            ),
            body: TabBarView(children: [
              jacketView(),
              productView(shirtCategory, _products),
              productView(shoesCategory, _products),
              productView(trouserCategory, _products),
            ]),
          ),
        ),
        Material(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discover".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, "cart_screen");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget jacketView() {
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
            _products = [...products];
            products.clear();
            products = getProductByCategory(jacketCategory, _products);
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductInfo(products[index])));
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Expanded(
                                        child: Text(
                                            " ${products[index].price} \$")),
                                    Expanded(
                                        child:
                                            Text(products[index].description)),
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
}
