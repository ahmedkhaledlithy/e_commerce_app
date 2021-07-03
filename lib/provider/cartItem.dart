
import 'package:e_commerce_app/models/product.dart';
import 'package:flutter/foundation.dart';

class CartItem extends ChangeNotifier{
  List<Product>products=[];


  addProduct(Product product){
    products.add(product);
    notifyListeners();
  }

  deleteProduct(Product product){
    products.remove(product);
    notifyListeners();
  }

}