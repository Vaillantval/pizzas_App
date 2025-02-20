import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ackapizza_final/components.dart';

import '../local_notification.dart';
import '../screen/homeScreen.dart';
import 'definitions_up_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final telController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool contain6Length = false;
  final FireBaseAuthentificationService _auth =
      FireBaseAuthentificationService();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    telController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Center(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    onChanged: (val) {
                      if (val!.length >= 6) {
                        setState(() {
                          contain6Length = true;
                        });
                      } else {
                        setState(() {
                          contain6Length = false;
                        });
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (val.length < 6) {
                        return 'Please enter a password with at least 6 characters';
                      }
                      return null;
                    }),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(CupertinoIcons.person_fill),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (val.length > 30) {
                        return 'Name too long';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                    controller: telController,
                    hintText: 'Tel',
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    prefixIcon:
                        const Icon(CupertinoIcons.phone_arrow_down_left),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if ((val.contains(RegExp(r'[A-Z]'))) ||
                          (val.contains(RegExp(r'[a-z]'))) ||
                          (val.contains(RegExp(
                              r'^(?=.*?[!@#$&*~`)%\-(_=;:,.<>/?"[{\]}|^])'))) ||
                          (!val.contains(RegExp(r'[0-9]')))) {
                        return 'Please enter a valid Number Phone';
                      }
                      return null;
                    }),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              !signUpRequired
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                signUpRequired = true;
                              });
                              _signUp();
                            }
                          },
                          style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor:
                                 Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    )
                  : const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String username = nameController.text;
    String password = passwordController.text;
    String email = emailController.text;
    String Token = '';
    String numero = telController.text;
    // User? user1 = FirebaseAuth.instance.currentUser;
    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User $username is succeessfully created! ")));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>  MyHomePage(user: user)));
      //IL LE FAUT CAR ON DOIT AUSSI ENREGISTRE LE TOKEN DANS LA BASE DE DONNE PROFIL
      final apnsToken = await FirebaseMessaging.instance.getToken();

      if (apnsToken != null) {
        // APNS token is available, make FCM plugin API requests...
        Token = apnsToken;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("SUCCESS!"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              top: 10.0, // Ajustez cette valeur selon vos besoins
              left: 10.0,
              right: 10.0,
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
            elevation: 10.0,
          ),
        );
        //ca c'est la partie ou l'on sauvegarde le profil de l'utilisateur dans idtelephone (04/10/2024, valcin Vaillant)
        await FirebaseFirestore.instance
            .collection('idtelephone')
            .doc('clients')
            .collection('tokens')
            .doc(email)
            .set({'token': Token});

        //SAUVEGARDE DU PROFIL DE L UTILISATEUR AVEC SON EMAIL COMME ID DU DOCUMENT
        DocumentSnapshot casRef = await FirebaseFirestore.instance
            .collection('profil')
            .doc('clients')
            .collection('users')
            .doc(email)
            .get();
        // est ce necessaire de verifier cela ?
        if (casRef.exists) {
          String utilisateur = casRef['username'];

          NotificationService.showNotifications(
              title: 'Warning!',
              body: 'Cet email appartient deja a $utilisateur',
              payload: 'ackaPizza');
        } else {
          // Si le document n'existe pas, créer un nouveau document avec le token

          await FirebaseFirestore.instance
              .collection('usersglobal')
              .doc(email)
              .set({
            'username': username,
            'email': email,
            'password': password,
            'adm': false,
            'token': Token,
            'numero': numero,
            'id': user.uid,
            // new sauvegarde
          });

         /* await FirebaseFirestore.instance
              .collection('usersglobal')
              .doc(email).collection('panier').add({

          });*/
        }
      }

      //NotificationService.showPeriodiqueNotifications(title: 'HAH SOP', body: 'Verifiez si vous n avez pas d urgence pour aujourd hui', payload: 'HAH');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Some error happens!"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: 20.0,
          // Ajustez cette valeur selon vos besoins
          left: 10.0,
          right: 10.0,
        ),
        backgroundColor: Colors.red,
        duration: Duration(
          seconds: 7,
        ),
      ));

      setState(() {
        signUpRequired = false;
      });
    }
  }
}
