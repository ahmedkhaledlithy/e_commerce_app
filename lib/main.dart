import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/provider/admin_mode.dart';
import 'package:e_commerce_app/provider/cartItem.dart';
import 'package:e_commerce_app/provider/prograss_modelHud.dart';
import 'package:e_commerce_app/screens/admin/add_product.dart';
import 'package:e_commerce_app/screens/admin/edit_product.dart';
import 'package:e_commerce_app/screens/admin/manage_product.dart';
import 'package:e_commerce_app/screens/admin/order_details.dart';
import 'package:e_commerce_app/screens/admin/orders_screen.dart';
import 'file:///C:/Users/ahmed%20leithy/Flutter_Projects/e_commerce_app/lib/screens/users/home_screen.dart';
import 'package:e_commerce_app/screens/signup_screen.dart';
import 'package:e_commerce_app/screens/users/cartScreen.dart';
import 'package:e_commerce_app/screens/users/product_info.dart';
import 'file:///C:/Users/ahmed%20leithy/Flutter_Projects/e_commerce_app/lib/screens/admin/admin_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 bool isUserLoggedIn=false;
  @override
  Widget build(BuildContext context) {
      return FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder:(context,snapshot){
        if(!snapshot.hasData){
           return  MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()),));
        }
        else{
          isUserLoggedIn=snapshot.data.getBool(KeepLoggedIn)??false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<prograssHud>(
                create: (context)=>prograssHud(),
              ),

              ChangeNotifierProvider<AdminMode>(
                create: (context)=>AdminMode(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context)=>CartItem(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: (isUserLoggedIn)?HomePage.id:"login_Screen",
              routes: {
                "login_Screen":(context)=>LoginScreen(),
                "SignUp_Screen":(context)=>signUpScreen(),
                 HomePage.id:(context)=>HomePage(),
                "admin_home":(context)=>AdminHome(),
                "add_product":(context)=>AddProduct(),
                "manage_product":(context)=>ManageProduct(),
                "edit_product":(context)=>EditProduct(),
                "cart_screen":(context)=>CartScreen(),
                "orders_screen":(context)=>OrdersScreen(),
                OrderDetailsScreen.id:(context)=>OrderDetailsScreen(),
              },
            ),
          );
        }
      });
  }
}

