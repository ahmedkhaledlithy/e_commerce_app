import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/provider/cartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {

 final Product product;

 ProductInfo(this.product);

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {

  int _quantity = 1;
  var money;

  @override
  void initState() {
    super.initState();
    setState(() {
      money=widget.product.price;
    });
  }

  @override
  Widget build(BuildContext context) {
   // Product  product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, 20),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: AssetImage(widget.product.image),
                  fit: BoxFit.fill,
                )),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Info".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(icon: Icon(Icons.shopping_cart),onPressed: (){
                    Navigator.pushNamed(context, "cart_screen");
                  },),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.product.description,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "\$ $money",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ClipOval(
                                child: InkWell(
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      color: mainColor,
                                      child: Icon(Icons.add),
                                    ),
                                    onTap: () {
                                      add(widget.product);
                                    }),
                              ),
                              Text(
                                _quantity.toString(),
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              ClipOval(
                                child: InkWell(
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      color: mainColor,
                                      child: Icon(Icons.remove),
                                    ),
                                    onTap: () {
                                      if (money > int.parse(widget.product.price)) {
                                        subtract(widget.product);
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonTheme(
                  height: MediaQuery.of(context).size.height * 0.08,
                  minWidth: MediaQuery.of(context).size.width,
                  child: Builder(
                    builder: (context) => RaisedButton(
                        color: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          "add to cart".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                        addToCart(context, widget.product);
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  add(Product product) {
    if (_quantity < 10) {
      setState(() {
        _quantity++;
        money = int.parse(product.price) * _quantity;
      });
    }
  }

  subtract(Product product) {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        money = money - int.parse(product.price);
      });
    }
  }



  void addToCart(context, product) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    bool exist=false;
    product.quantity = _quantity;
    product.price=money.toString();
    var productsInCart=cartItem.products;
    for(var productInCart in productsInCart){
      if(productInCart.name==product.name){
        exist=true;
      }
    }
    if(exist){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("You Added this Item before")));
    }else{
      cartItem.addProduct(product);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Cart Item Added Succeed")));
    }

  }
}
