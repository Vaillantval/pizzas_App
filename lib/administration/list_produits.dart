import 'package:ackapizza_final/administration/add_new_produit.dart';
import 'package:ackapizza_final/screen/detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../macro.dart';

///Valcin Vaillant
///page ou l'on presente les pizzas de l'entreprise

class MyListeProducts extends StatefulWidget {
  const MyListeProducts({
    super.key,
  });

  @override
  State<MyListeProducts> createState() => _MyListeProductsState();
}

class _MyListeProductsState extends State<MyListeProducts>
    with SingleTickerProviderStateMixin {
  bool change = true;
  var nombre;
  late AnimationController _controller;
  late Animation<double> _grosseur;

  String nomUser = '';
  String numberphone = '';
  String? id1;
  User? user;

  //User? widget.user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _controller =
    AnimationController(duration: const Duration(seconds: 1), vsync: this)
      ..repeat(reverse: true);
    _grosseur = Tween<double>(begin: 15, end: 30).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surface,
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .surface,
          title: Row(
            children: [
              Image.asset('assets/images/pizza_logo.png', scale: 2.35),
              const SizedBox(width: 8),
              const Text(
                'Liste de vos produits',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              )
            ],
          ),
          actions: const [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("pizzas").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text("Pas de Pizzas disponible"));
              } else {
                List<dynamic> pizza = [];
                snapshot.data!.docs.forEach((element) {
                  pizza.add(element);
                });

                return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 16,
                        childAspectRatio: 9 / 16),
                    itemCount: pizza.length,
                    itemBuilder: (context, index) {
                      final utilisat = pizza[index];

                      final String pizzaId = utilisat['pizzaId'];
                      final String picture = utilisat['picture'];
                      final int calories = utilisat['calories'];
                      final String name = utilisat['name'];
                      final String description = utilisat['description'];
                      final int priceSmal = utilisat['priceSmal'];
                      final int priceMed = utilisat['priceMed'];

                      //final int priceLarg = utilisat['priceLarg'];
                      final bool isVeg = utilisat['isVeg'];
                      final int priceLarg = utilisat['priceLarg'];
                      final int discount = utilisat['discount'];
                      return Material(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(
                                            pizzaId: pizzaId,
                                            //pizza[index]['pizzaId'],
                                            picture: picture,
                                            // pizza[index]['picture'],
                                            calories: calories,
                                            //pizza[index]['calories'],
                                            name: name,
                                            //laisse expres
                                            description: description,
                                            //pizza[index]
                                            //   ['description'],
                                            priceSmal: priceSmal,
                                            //pizza[index]['priceSmal'],
                                            priceMed: priceMed,
                                            //pizza[index]['priceMed'],
                                            priceLarg: priceLarg,
                                            //pizza[index]['priceLarg'],
                                            discount: discount,
                                            //pizza[index]['discount'],
                                            user: user,
                                            username: nomUser,
                                            numberphone: numberphone,
                                            modifierPizza: true,
                                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(picture),
                              ),

                              //   SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color:
                                          isVeg ? Colors.green : Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Text(
                                          isVeg ? "VEG" : "NON-VEG",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    MyMacroWidget(
                                      title: "Calories",
                                      value: calories,
                                      icon: FontAwesomeIcons.fire,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "HTG ${priceMed -
                                                (priceMed * (discount) / 100)}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme
                                                    .of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "HTG $priceMed.00",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w700,
                                                decoration:
                                                TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          //on modifie
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      add_product(
                                                        IdPizza: pizzaId,
                                                        ifmodif: true,
                                                        pictureFile:
                                                        XFile(picture),
                                                      )));
                                        },
                                        child: const Text("Modifer"),
                                        style: const ButtonStyle(
                                            backgroundColor:
                                            WidgetStatePropertyAll(
                                                Colors.orange)),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            //on efface
                                            _alertedeletePizza(
                                                idpizza: pizzaId,
                                                urlpicture: picture);
                                          },
                                          style: const ButtonStyle(
                                              backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.red)),
                                          child: const Text("Effacer"))
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        ),
        floatingActionButton: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FloatingActionButton.extended(
                onPressed: () =>
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                add_product(
                                    IdPizza: "",
                                    ifmodif: false,
                                    pictureFile: XFile("")))),
                icon: Icon(
                  Icons.add_task_outlined,
                  shadows: const [
                    Shadow(
                      color: Colors.grey,
                    )
                  ],
                  size: _grosseur.value,
                ),
                label: const Text('Ajout'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                elevation: 200,
              );
            }));
  }

  //LES FONCTIONS MODIFIER ET effacer

  void _alertedeletePizza(
      {required String idpizza, required String urlpicture}) {
    const SizedBox(
      height: 100,
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(Icons.add_shopping_cart),
            content: const Text(
              'Effacer ce produit?',
              style: TextStyle(fontSize: 15),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text(
                  'Non',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () async {
                  //on efface la pub
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Row(
                      children: [
                        Text('Effacé avec succes!'),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      top: 10.0,
                      // Ajustez cette valeur selon vos besoins
                      left: 10.0,
                      right: 10.0,
                    ),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 3),
                    elevation: 10.0,
                  ));
                  //on efface
                  await FirebaseFirestore.instance
                      .collection("pizzas")
                      .doc(idpizza)
                      .delete();
                  //il faut aussi supprimer la photo
                  FirebaseStorage.instance.refFromURL(urlpicture).delete();

                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text(
                  'Oui',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          );
        });
  }

//
}
