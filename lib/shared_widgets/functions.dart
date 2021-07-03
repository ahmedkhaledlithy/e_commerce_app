import 'package:e_commerce_app/models/product.dart';

List<Product> getProductByCategory(String jacketCategory,List<Product>allProducts) {
  List<Product>products=[];
  try {
    for (var product in allProducts) {
      if (product.category == jacketCategory) {
        products.add(product);
      }
    }
  }on Error catch(ex){
    print(ex);
  }
  return products;
}
