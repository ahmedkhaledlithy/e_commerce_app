import 'package:e_commerce_app/consts.dart';
import 'package:e_commerce_app/provider/prograss_modelHud.dart';
import 'package:e_commerce_app/services/authentication.dart';
import 'package:e_commerce_app/shared_widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
class signUpScreen extends StatefulWidget {
  @override
  _signUpScreenState createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final Authentication _authentication = Authentication();

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
                    hint: "Enter Your name",
                    icon: Icons.perm_identity,
                    inputType: TextInputType.text,
                    textController: null,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    hint: "Enter Your Address",
                    icon: Icons.location_city,
                    inputType: TextInputType.streetAddress,
                    textController: null,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    hint: "Enter Your Email",
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    textController: _emailController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    hint: "Enter Your Password",
                    icon: Icons.lock,
                    inputType: null,
                    textController: _passwordController,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Builder(
                    builder:(context)=> Container(
                      width: 150,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: Text(
                            "SignUp",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          onPressed: () async {
                            final model=Provider.of<prograssHud>(context,listen: false);
                            model.changeLoading(true);
                            if (_formKey.currentState.validate()) {

                              try {
                                String _email = _emailController.text;
                                String _password = _passwordController.text;
                                var user = await _authentication.signUp(_email.trim(), _password.trim());
                                model.changeLoading(false);
                                print(user.user.uid);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(seconds: 10),
                                  content: Text("Your Register Succeed"),
                                ));
                                return user;

                              } catch (e) {
                                model.changeLoading(false);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(seconds: 10),
                                  content: Text(e.message),
                                ));
                              }
                            }
                            model.changeLoading(false);

                          }),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do have an Account  ?",
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
                            "Login",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "login_Screen");
                          }),
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
}
