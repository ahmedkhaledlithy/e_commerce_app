import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/provider/admin_mode.dart';
import 'package:e_commerce_app/provider/prograss_modelHud.dart';
import 'package:e_commerce_app/screens/users/home_screen.dart';
import 'package:e_commerce_app/services/authentication.dart';
import 'package:e_commerce_app/shared_widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final Authentication _authentication = Authentication();
  final adminPassword = "admin12345";
  bool keepMeLoggedIn=false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      backgroundColor: mainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<prograssHud>(context).isLoading,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  drawLogo(),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    hint: "Enter Your Email",
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    textController: _emailController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    hint: "Enter Your Password",
                    icon: Icons.lock,
                    inputType: null,
                    textController: _passwordController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Theme(
                          data:ThemeData(
                            unselectedWidgetColor: Colors.white
                          ),
                          child: Checkbox(
                            activeColor: mainColor,
                              value: keepMeLoggedIn, onChanged: (value){
                            setState(() {
                              keepMeLoggedIn=value;
                            });
                          }),
                        ),
                        SizedBox(width: 10,),
                        Text("Remember Me",style: TextStyle(color: Colors.white,fontSize: 16),),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Builder(
                    builder: (context) => Container(
                      width: 150,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          onPressed: ()  {
                            if(keepMeLoggedIn==true){
                              keepUserLoggedIn();
                            }
                            _validateLogin(context);
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account  ?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "SignUp_Screen");
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: FlatButton(
                          child: Text(
                            "I'M AN ADMIN",
                            style: TextStyle(
                                color: Provider.of<AdminMode>(context).isAdmin
                                    ? mainColor
                                    : Colors.white),
                          ),
                          onPressed: () {
                            Provider.of<AdminMode>(context, listen: false).changeIsAdmin(true);
                          },
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-40, 0),
                        child: FlatButton(
                          child: Text(
                            "I'M AN USER",
                            style: TextStyle(
                                color: Provider.of<AdminMode>(context).isAdmin
                                    ? Colors.white
                                    : mainColor),
                          ),
                          onPressed: () {
                            Provider.of<AdminMode>(context, listen: false).changeIsAdmin(false);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validateLogin(BuildContext context) async {
    final model = Provider.of<prograssHud>(context, listen: false);
    model.changeLoading(true);
    if (_formKey.currentState.validate()) {
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_passwordController.text == adminPassword) {
          try {
            String _email = _emailController.text;
            String _password = _passwordController.text;
            var user = await _authentication.signIn(_email.trim(), _password.trim());
            model.changeLoading(false);
            print(user.user.uid);
            Navigator.pushNamed(context, "admin_home");
            return user;
          } catch (e) {
            model.changeLoading(false);
            Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 10),
              content: Text(e.message),
            ));
          }
        } else {
          model.changeLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 10),
            content: Text("Something  Wrong"),
          ));
        }
      } else {
        try {
          String _email = _emailController.text;
          String _password = _passwordController.text;
          var user = await _authentication.signIn(_email, _password);
          model.changeLoading(false);
          print(user.user.uid);
          Navigator.pushNamed(context, HomePage.id);
          return user;
        } catch (e) {
          model.changeLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 10),
            content: Text(e.message),
          ));
        }
      }
    }
    model.changeLoading(false);
  }

  void keepUserLoggedIn()async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setBool(KeepLoggedIn, keepMeLoggedIn);
  }
}
