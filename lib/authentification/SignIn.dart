
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components.dart';
import '../screen/homeScreen.dart';
import 'definitions_up_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;
  final FireBaseAuthentificationService _auth =
      FireBaseAuthentificationService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(CupertinoIcons.mail_solid),
                      errorMsg: _errorMsg,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (!RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$')
                            .hasMatch(val)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      })),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  errorMsg: _errorMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
                        }
                      });
                    },
                    icon: Icon(iconPassword),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              !signInRequired
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                signInRequired = true;
                              });
                              _signIn();
                            }
                          },
                          style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    )
                  : const CircularProgressIndicator(),
              /* const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  TextButton(
                    child: Text(
                      "⚈  Pas encore de compte?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 8),
                    ),
                    onPressed: () => const SignUpScreen(),
                  ),
                  TextButton(
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Text(
                            'Cliquez ici',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: _sizeLettre.value,
                                fontWeight: FontWeight.bold),
                          );
                        }),
                    /*
                    ),*/
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen())),
                  )
                ],
              ),*/
            ],
          )),
    );
  }

  void _signIn() async {
    User? user = await _auth.signinWithEmailAndPassword(
        emailController.text, passwordController.text);
    if (user != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Signing In...")));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MyHomePage(user: user)));
      //print("User is successfully SignIn");
    } else {
      //  print("Some error happen");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Some error happen!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
        elevation: 10.0,
        behavior: SnackBarBehavior.floating,
      ));
      setState(() {
        signInRequired = false;
        _errorMsg = 'Invalid email or password';
      });
    }
  }
}
