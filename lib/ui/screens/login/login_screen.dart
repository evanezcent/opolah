import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opolah/constant/constans.dart';
import 'package:opolah/ui/components/login-register/button_ok.dart';
import 'package:opolah/ui/components/login-register/change_login_register.dart';
import 'package:opolah/ui/components/login-register/header.dart';
import 'package:opolah/ui/screens/main_screen.dart';
import 'package:opolah/ui/screens/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textEmailUsername = new TextEditingController();
  TextEditingController textPassword = new TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  colorSecondary,
                  colorPrimary,
                  colorPrimary,
                ])),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HeaderLoginRegister(
                    size: size,
                    title: 'Log in',
                    word: 'Shop now and start here !'),
                SizedBox(height: 70),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: textEmailUsername,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 18),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Email / No Hp',
                            hintStyle: TextStyle(color: Colors.white),
                            focusColor: Colors.white,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textPassword,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 18),
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                            focusColor: Colors.white,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: FaIcon(
                                _obscureText
                                    ? FontAwesomeIcons.solidEye
                                    : FontAwesomeIcons.eye,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            )),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            child: Text("Forgot password",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                ButtonOk(
                    size: size,
                    onClick: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    }),
                SizedBox(height: 100),
                ChangePageLoginRegister(
                  question: 'Your first time ?',
                  change: 'Register',
                  onClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}