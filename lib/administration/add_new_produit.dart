import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ackapizza_final/components.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class add_product extends StatefulWidget {
  const add_product({
    required this.IdPizza,
    required this.ifmodif,
    required this.pictureFile,
    super.key,
  });

  final bool ifmodif;
  final XFile pictureFile;
  final String IdPizza;

  @override
  State<add_product> createState() => _add_productState();
}

class _add_productState extends State<add_product> {
  final nameController = TextEditingController();
  final caloriesController = TextEditingController();
  final priceMController = TextEditingController();
  final priceSController = TextEditingController();
  final priceLController = TextEditingController();
  final descripController = TextEditingController();
  final discountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool addRequired = false;
  bool ifVegan = false;

//pour les images

  XFile? xFile;
  bool isLoading = false;
  File? _image;
  late final ImagePicker _picker;

  var status;

/*  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        _isLoading = false;
      });
    });
  }*/

  Future<String?> _uploadPizza({
    required File imag,
    required dossier,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference? imagesRef = storageRef
        .child('$dossier${DateTime.now().millisecondsSinceEpoch}.jpg');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 5,
          ),
          Text('Uploading...'),
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
      duration: Duration(seconds: 5),
      elevation: 10.0,
    ));
    try {
      imagesRef.putFile(imag);
      //Future.delayed(Duration(seconds: 2));

      /// on va mettre ca dans firebase data base
      String urL = await imagesRef.getDownloadURL();
      String nompizza = nameController.text;
      String time = DateTime.now().toString();
      List<String> ids = [nompizza, time];
      ids.sort();
      String IdPizza = widget.ifmodif ? widget.IdPizza : ids.join('_');

      await FirebaseFirestore.instance.collection("pizzas").doc(IdPizza).set({
        'pizzaId': IdPizza,
        'picture': urL.toString(),
        'calories': caloriesController.text,
        'name': nameController.text,
        'description': descripController.text,
        'priceSmal': priceMController.text,
        'priceMed': priceMController.text,
        'priceLarg': priceLController.text,
        'isVeg': ifVegan,
        'discount': discountController.text,
      });
      xFile = null;
      caloriesController.clear();
      nameController.clear();
      priceMController.clear();
      priceSController.clear();
      priceLController.clear();
      descripController.clear();
      discountController.clear();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Text('SUCCESS'),
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
        duration: Duration(seconds: 4),
        elevation: 10.0,
      ));
      return urL;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning),
            Text('Erreur: $e'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          top: 10.0,
          // Ajustez cette valeur selon vos besoins
          left: 10.0,
          right: 10.0,
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 10),
        elevation: 10.0,
      ));
      print('Erreur lors de l\'upload: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.ifmodif) {
      xFile = widget.pictureFile;
    }

    status = Permission.photos.status;
    _picker = ImagePicker();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _picker;
    nameController.dispose();
    priceLController.dispose();
    priceMController.dispose();
    priceSController.dispose();
    caloriesController.dispose();
    descripController.dispose();
    discountController.dispose();
  }

  /*  isLoading = true;
          setState(() {});
          xFile = await _picker.pickImage(source: ImageSource.gallery);
          if (xFile != null) {
            _image = File(xFile!.path);
            isLoading = false;
            setState(() {});
            _alertedialajout(image: _image);
            if (enbas == true)
              setState(() {
                _scrollToEnd;
              });

            return;
          }*/

  picImagebanm() async {
    xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      _image = File(xFile!.path);
      setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nouveau produit"),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      picImagebanm();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 250,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(225, 95, 27, 3),
                            blurRadius: 10,
                            offset: Offset(3, 3),
                          )
                        ],
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(30),
                        image: xFile?.path != null
                            ? DecorationImage(
                                image: FileImage(_image!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: xFile?.path != null
                          ? const Text("")
                          : TextButton(
                              onPressed: () => picImagebanm(),
                              child: const Text("Choisir une image")),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    //width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                        controller: nameController,
                        hintText: 'Nom du produit',
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(CupertinoIcons.arrow_up_bin),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() async {
                              ifVegan = !ifVegan;
                              //  oui, il faut modifier la valeur de adm dans la base
                            });
                            setState(() {});
                          },
                          child: Text(
                            "Végétarien:",
                            style: TextStyle(
                                fontSize: 15.0,
                                color: ifVegan ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          child: CupertinoSwitch(
                            value: ifVegan,
                            onChanged: (value) {
                              ifVegan = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 1,
                    color: CupertinoColors.systemGrey5,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    //width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                        controller: descripController,
                        hintText: 'Description',
                        obscureText: false,
                        keyboardType: TextInputType.multiline,
                        prefixIcon: const Icon(FontAwesomeIcons.list),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          //width: MediaQuery.of(context).size.width * 0.9,
                          child: SizedBox(
                            //width: MediaQuery.of(context).size.width * 0.9,
                            child: MyTextField(
                                controller: caloriesController,
                                hintText: 'Calories',
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.fire,
                                  color: Colors.red,
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if ((val.contains(RegExp(r'[A-Z]'))) ||
                                      (val.contains(RegExp(r'[a-z]'))) ||
                                      (val.contains(RegExp(
                                          r'^(?=.*?[!@#$&*~`)%\-(_=;:,.<>/?"[{\]}|^])'))) ||
                                      (!val.contains(RegExp(r'[0-9]')))) {
                                    return 'Please enter a valid Number';
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: MyTextField(
                              controller: discountController,
                              hintText: ' % Rabais',
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              prefixIcon:
                                  const Icon(FontAwesomeIcons.moneyBills),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if ((val.contains(RegExp(r'[A-Z]'))) ||
                                    (val.contains(RegExp(r'[a-z]'))) ||
                                    (val.contains(RegExp(
                                        r'^(?=.*?[!@#$&*~`)%\-(_=;:,.<>/?"[{\]}|^])'))) ||
                                    (!val.contains(RegExp(r'[0-9]')))) {
                                  return 'Please enter a valid Number';
                                }
                                return null;
                              }),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Les Prix: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: MyTextField(
                              controller: priceSController,
                              hintText: 'Small',
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              prefixIcon: null,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if ((val.contains(RegExp(r'[A-Z]'))) ||
                                    (val.contains(RegExp(r'[a-z]'))) ||
                                    (val.contains(RegExp(
                                        r'^(?=.*?[!@#$&*~`)%\-(_=;:,.<>/?"[{\]}|^])'))) ||
                                    (!val.contains(RegExp(r'[0-9]')))) {
                                  return 'Please enter a valid Number';
                                }
                                return null;
                              }),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          //width: MediaQuery.of(context).size.width * 0.9,
                          child: MyTextField(
                              controller: priceMController,
                              hintText: 'Medium',
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              prefixIcon: null,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if ((val.contains(RegExp(r'[A-Z]'))) ||
                                    (val.contains(RegExp(r'[a-z]'))) ||
                                    (val.contains(RegExp(
                                        r'^(?=.*?[!@#$&*~`)%\-(_=;:,.<>/?"[{\]}|^])'))) ||
                                    (!val.contains(RegExp(r'[0-9]')))) {
                                  return 'Please enter a valid Number ';
                                }
                                return null;
                              }),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          //width: MediaQuery.of(context).size.width * 0.9,
                          child: MyTextField(
                              controller: priceLController,
                              hintText: 'Large',
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              prefixIcon: null,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if ((val.contains(RegExp(r'[A-Z]'))) ||
                                    (val.contains(RegExp(r'[a-z]'))) ||
                                    (val.contains(RegExp(
                                        r'^(?=.*?[!@#$&*~`)%\-(_=;:,.<>/?"[{\]}|^])'))) ||
                                    (!val.contains(RegExp(r'[0-9]')))) {
                                  return 'Please enter a valid Number ';
                                }
                                return null;
                              }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  !addRequired
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _alertedialajout(
                                    image: _image,
                                    modif: widget.ifmodif,
                                  );
                                  setState(() {
                                    addRequired = true;
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: Text(
                                  "Ajouter",
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
        ));
  }

  void _alertedialajout({
    required File? image,
    required bool modif,
  }) async {
    const SizedBox(
      height: 100,
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(!modif ? 'AJOUTER:' : "MODIFIER:"),
            content: SizedBox(
              width: 300.0, // Définir la largeur souhaitée
              height: 420.0,
              child: Column(
                children: <Widget>[
                  Text(
                    !modif
                        ? 'Ajouter ce nouveau produit?'
                        : "Modifier Ce produit",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  //if (_isLoading) const CircularProgressIndicator(),
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(225, 95, 27, 3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ],
                        image: DecorationImage(
                            image: FileImage(image!), fit: BoxFit.cover)),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: [
                        Text("Nom: ${nameController.text}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text("Description: ${descripController.text}"),
                        const Text(
                          "Prix",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Small: ${priceSController.text} HTG"),
                            Text("Medium: ${priceMController.text} HTG"),
                            Text("Large: ${priceLController.text} HTG"),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  addRequired = false;
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Non'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (xFile != null) {
                    /// on envoie le pizza
                    await _uploadPizza(imag: image, dossier: "produits/pizzas");
                    addRequired = false;
                    setState(() {});
                    /** c'est nice **/
                    return;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Aucune image selectionnee!'),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        top: 10.0,
                        // Ajustez cette valeur selon vos besoins
                        left: 10.0,
                        right: 10.0,
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                      elevation: 10.0,
                    ));
                  }
                },
                child: const Text(
                  'Oui',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          );
        });
  }
}
