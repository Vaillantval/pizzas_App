import 'package:ackapizza_final/Paiement_Service/MonCash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../macro.dart';
import 'homeScreen.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(
      {required this.pizzaId,
      required this.picture,
      required this.calories,
      required this.name,
      required this.description,
      required this.priceSmal,
      required this.priceMed,
      required this.priceLarg,
      required this.discount,
      required this.username,
      required this.numberphone,
      required this.user,
      required this.modifierPizza,
      super.key});

  final bool modifierPizza;
  final String pizzaId;
  final String picture;
  final int calories;
  final String name;
  final String description;
  final int priceSmal;
  final int priceMed;
  final int priceLarg;
  final int discount;
  final String numberphone;
  final String username;
  final User? user;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  String size = 'M';
  late int price;
  String? COMMAND;

  Timestamp datedujour = Timestamp.now();
  late int price1;

  //int plus = 1;

  void updatePrice() {
    setState(() {
      switch (size) {
        case 'S':
          price = widget.priceSmal;
          price1 = price;
          break;
        case 'M':
          price = widget.priceMed;
          price1 = price;
          break;
        case 'L':
          price = widget.priceLarg;
          price1 = price;
          break;
      }
      price *= quantity;
      //a verifer
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_controller.dispose();
    super.dispose();
  }

  _setcommande() {
    COMMAND = "${widget.name}: $quantity Unité(s)  \n Size:$size  " +
        "montant total: HTG ${quantity * price1} \n";
  }

  @override
  void initState() {
    super.initState();
    price = widget.priceMed;
    price1 = widget.priceMed;
    _setcommande();

    /*_controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat(reverse: true);
    _widthAnimation = Tween<double>(begin: 290, end: 350).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _heightAnimation = Tween<double>(begin: 50, end: 60).animate(_controller)
      ..addListener(() {
        setState(() {});
      });*/ // Initial size is 'S'
  }

  @override
  Widget build(BuildContext context) {
    //initialise la valeur de price
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Détails'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(onPressed: (){/*
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const moncashScreen()));*/
          }, icon: Icon(FontAwesomeIcons.cashRegister))
        ],
      ),
      
      body: SingleChildScrollView(
        //SingleChildScrollView pourrait etre un Padding de preference

        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - (25),
              //c etait a 40
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(3, 3), blurRadius: 5)
                  ],
                  image: DecorationImage(image: NetworkImage(widget.picture))),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(3, 3), blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.description,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        MyMacroWidget(
                                          title: "Calories",
                                          value: widget.calories*quantity,
                                          icon: FontAwesomeIcons.fire,
                                        ),
                                      ],
                                    )),
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  " HTG ${price - (price * (widget.discount) / 100)}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  "HTG $price.00",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    _setcommande();
                                    updatePrice();
                                  }
                                });
                              },
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 18),
                            ),
                            /*  ChoiceChip(
                              label: const Text('+'),
                              selected: plus == 1,
                              onSelected: (bool selected) {
                                quantity++;
                                plus = 1;
                                updatePrice();
                              },
                            ),*/
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  {
                                    quantity++;
                                    _setcommande();
                                    updatePrice();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ChoiceChip(
                              label: const Text('S'),
                              selected: size == 'S',
                              onSelected: (bool selected) {
                                // setState(() {
                                size = 'S';
                                quantity = 1;
                                _setcommande();
                                updatePrice();
                                //   });
                              },
                            ),
                            const SizedBox(width: 10),
                            ChoiceChip(
                              label: const Text('M'),
                              selected: size == 'M',
                              onSelected: (bool selected) {
                                // setState(() {
                                size = 'M';
                                quantity = 1;
                                _setcommande();
                                updatePrice();
                                //   });
                                setState(() {});
                              },
                            ),
                            const SizedBox(width: 10),
                            ChoiceChip(
                              label: const Text('L'),
                              selected: size == 'L',
                              onSelected: (bool selected) {
                                // setState(() {
                                size = 'L';
                                _setcommande();
                                quantity = 1;
                                updatePrice();
                                // });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _boutton(modif: widget.modifierPizza),
                    //   })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _boutton({required bool modif}) {
    //TODO IL FAUT IMPORTER LES FONCTIONS MODIFIER ET EFFACER DANS CETTE PAGE
    String text1 = '';
    String text2 = '';
    if (modif == true) {
      text1 = 'Modifier les info';
      text2 = 'Effacer ce produit';
    } else {
      text1 = 'Ajouter au panier';
      text2 = 'Acheter maintenant';
    }

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: TextButton(
            onPressed: () {
              if (modif == false) {
                _alerteAddCart(context);
              } else {
                //modifier les champs pour ce pizza
              }
            },
            style: TextButton.styleFrom(
                elevation: 3.0,
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text(
              text1,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
/* width: _widthAnimation.value,
                            height: _heightAnimation.value,*/
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: TextButton(
            onPressed: () {
              if (modif == false)
                _alerteCommande(context, commandes: COMMAND!);
              else {
                //efface de la liste
                _alertedeletePizza(
                    idpizza: widget.pizzaId, urlpicture: widget.picture);
                //  Future.delayed(Duration(seconds: 5) );
                Future.delayed(const Duration(seconds: 10), () {
                  setState(() {
                    Navigator.pop(context);
                  });
                });
              }
            },
            style: TextButton.styleFrom(
                elevation: 3.0,
                backgroundColor: modif ? Colors.red : Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text(
              text2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }

  void _AddCart() async {
    CollectionReference _collection = await FirebaseFirestore.instance
        .collection("usersglobal")
        .doc(widget.user!.email)
        .collection('panier');
    //  DocumentSnapshot pizza = await _collection.doc(widget.pizzaId).get();

    /*if (pizza.exists) {
      _collection.doc(widget.pizzaId).update({
        /*  'pizzaId': widget.pizzaId,
        'picture': widget.picture,
        'name': widget.name,
        'description': widget.description,
        'priceSmal': widget.priceSmal,
        'priceMed': widget.priceMed,
        'priceLarg': widget.priceLarg,
        'discount': widget.discount,*/
        'price': price1,
        'nombre': quantity,
        'size': size,
        'datedujour': datedujour,
        'somme': price - (price * (widget.discount) / 100),
      });*/
    //  } else { //doc(widget.pizzaId).set
    String Idpiza = widget.pizzaId;
    String time = datedujour.toString();
    List<String> ids = [Idpiza, time];
    ids.sort();
    String IdPanier = ids.join('_');
    _collection.doc(IdPanier).set({
      'IdPanier': IdPanier,
      'pizzaId': widget.pizzaId,
      'picture': widget.picture,
      'name': widget.name,
      'description': widget.description,
      'priceSmal': widget.priceSmal,
      'priceMed': widget.priceMed,
      'priceLarg': widget.priceLarg,
      'discount': widget.discount,
      'price': price1,
      //'${price - (price * (widget.discount) / 100)}',
      'nombre': quantity,
      'size': size,
      'datedujour': datedujour,
      'somme': price - (price * (widget.discount) / 100),
    });
    //   }
  }

  void _alerteAddCart(BuildContext context) async {
    const SizedBox(
      height: 100,
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(Icons.add_shopping_cart),
            content: const Text(
              'Ajouter dans le panier?',
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
                onPressed: () {
                  //on efface la pub
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Row(
                      children: [
                        Text('Pizza ajoutée dans le panier'),
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.orange,
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
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                    elevation: 10.0,
                  ));
                  //on l'ajoute
                  _AddCart();
                  setState(() {});
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(user: widget.user)));
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

  void _alerteCommande(context, {required String commandes}) {
    const SizedBox(
      height: 120,
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(Icons.send_and_archive),
            content: const Text(
              'Vous allez placer une commande:',
              style: TextStyle(fontSize: 15),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () async {
                  //on place la commande
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Row(
                      children: [
                        Text('Commande effectuée ☺'),
                        Icon(
                          Icons.send_outlined,
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

                  //nous allons creer un id pour cette commandes
                  String nom = widget.username;
                  List<String> ids = [nom, Timestamp.now().toString()];
                  ids.sort();
                  String IdCommande = ids.join('_');

                  await FirebaseFirestore.instance
                      .collection("commandes")
                      .doc(IdCommande)
                      .set({
                    'idcommande': IdCommande,
                    'iduser': widget.user!.uid,
                    'username': widget.username,
                    'adm': false,
                    'timestamp': Timestamp.now(),
                    'deliver': false,
                    'email': widget.user!.email,
                    'numero': widget.numberphone,
                    'commande': commandes
                  });

                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          );
        });
  }

  //ca c'est pour le panel de l'adm
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
}
