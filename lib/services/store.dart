import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/product.dart';

class Store {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) async {
    return await firestore.collection(storeCollection).doc().set({
      proName: product.name,
      proPrice: product.price,
      proDescription: product.description,
      proCategory: product.category,
      proImage: product.image,
    }).then((value) => print("Product Added"))
        .catchError((error) => print("Failed to add product: $error"));
  }

  Future<List<Product>> loadProduct() async {
    var snapshot = await firestore.collection(storeCollection).get();
    List<Product>products = [];
    snapshot.docs.map((var doc) =>
    {
      products.add(Product(
        name: doc.data()[proName],
        price: doc.data()[proPrice],
        category: doc.data()[proCategory],
        description: doc.data()[proDescription],
        image: doc.data()[proImage],
      )),

    }).toList();
    return products;
  }

  Stream<QuerySnapshot> loadFlowProduct() {
    return firestore.collection(storeCollection).snapshots();
  }

  deleteProduct(documentId){
    firestore.collection(storeCollection).doc(documentId).delete();
  }

 Future<void> editProduct(documentId,data)async{
   await firestore.collection(storeCollection).doc(documentId).update(data);
  }

  storeOrders(data,List<Product>products){
   var document= firestore.collection(OrdersCollections).doc();
   document.set(data);
   for(var product in products){
     document.collection(OrdersDetails).doc().set({
       proName: product.name,
       proPrice: product.price,
       proDescription: product.description,
       proCategory: product.category,
       proImage: product.image,
       proQuantity:product.quantity
     });
   }
  }

  Stream<QuerySnapshot> loadOrders(){
    return firestore.collection(OrdersCollections).snapshots();
  }

  Stream<QuerySnapshot>loadOrderDetails(documentId){
   return firestore.collection(OrdersCollections).doc(documentId).collection(OrdersDetails).snapshots();
  }
}