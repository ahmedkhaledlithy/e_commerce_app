import 'package:e_commerce_app/consts.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController textController;

  CustomTextFormField({@required this.hint,@required this.icon,@required this.inputType,@required this.textController});

  // ignore: missing_return
  String _errorMessage(String error){
    switch(hint){
      case "Enter Your Email":return "Please Enter Your Email";
      break;
      case "Enter Your Password":return "Please Enter Your Password";
      break;
      case "Enter Your name":return "Please Enter Your Name";
      break;
      case "Enter Your Address":return "Please Enter Your Address";
      break;
      case "Product Name":return "Please Enter Product Name";
      break;
      case "Product Price":return "Please Enter Product Price";
      break;
      case "Product Description":return "Please Enter Product Description";
      break;
      case "Product Category":return "Please Enter Product Category";
      break;
      case "Product Location Image":return "Please Enter Product Image Location";
      break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: textController,
        keyboardType: inputType,
        cursorColor: mainColor,
        obscureText: hint=="Enter Your Password"?true:false,
        decoration: InputDecoration(

          prefixIcon: Icon(icon,color: mainColor,),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                color: Colors.white
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                color: Colors.white
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                color: Colors.white
            ),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black),

        ),
        validator: (value) {
          if (value.isEmpty) {
            return _errorMessage(hint);
          }
          return null;
        },
      ),
    );
  }
}



Widget drawLogo(){
  return Column(
    children: [
      Image(image: AssetImage("assets/images/logo1.png")),
      Transform.translate(
        offset: Offset(0, -20),
        child: Text(
          "Buy It",
          style: TextStyle(
              fontFamily: "Pacifico",
              fontSize: 25,
              color: Colors.white),
        ),
      ),
    ],
  );
}

