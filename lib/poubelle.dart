/*import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/** créée Par Valcin VAILLANT-  Fev 2025 **/

/// pages des produits

class listpub extends StatefulWidget {
  listpub({
    super.key,
    required this.dossier1,
    required this.admin,
  });

  final String dossier1;
  final bool admin;

  @override
  State<listpub> createState() => _listpubState();
}

class _listpubState extends State<listpub> {
  bool alerte = false;
  bool ischek = false;
  List<String> imgList = [];
  DateTime? datedujour = DateTime.now();
  bool enbas = false;
  bool isLoading = false;
  XFile? xFile;
  File? _image;
  late final ImagePicker _picker;
  var status;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 8), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _listImages();
    status = Permission.photos.status;
    _picker = ImagePicker();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose(); //
    _picker; //a revoir
  }

  Future<void> _listImages() async {
    final storageRef = FirebaseStorage.instance.ref().child(widget.dossier1);
    final ListResult result = await storageRef.listAll();

    final List<String> urls =
    await Future.wait(result.items.map((Reference ref) async {
      final String url = await ref.getDownloadURL();
      return url;
    }).toList());

    setState(() {
      imgList = urls;
    });
  }

  Future<String?> _uploadImage({required File imag, required dossier}) async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference? imagesRef = storageRef
        .child('$dossier${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      imagesRef.putFile(imag);
      Future.delayed(Duration(seconds: 5));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(),
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
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
        elevation: 10.0,
      ));

      return await imagesRef.getDownloadURL();
    } catch (e) {
      print('Erreur lors de l\'upload: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //pour le chek box

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        //Theme.of(context).colorScheme.inversePrimary,

        title: const Text('PUBLICITES'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: imgList.map<Widget>((dynamic url) {
            return Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(225, 95, 27, 3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      )
                    ]),
                child: Column(children: [
                  /****Vaillant Valcin*****/
                  /* Align(
                    alignment: Alignment.bottomRight,
                    child: Text(url),
                  ),*/
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.network(url, fit: BoxFit.cover, width: 1200),
                  ),
                  //BOUTTON D'ALERTE ET DELETE  POUR UNE PUB
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(children: [
                      //POUR EFFACER UN CAS DANS LA BASE DE DONNEES!
                      ElevatedButton.icon(
                        onPressed: () {
                          _alertedialdelete(url: url);
                          imgList.remove(url);
                          /** tres nice **/
                        },
                        label: const Text(
                          'Effacer cette Publicité',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            // alerte==true? Colors.red:
                              Colors.black45),
                        ),
                      )
                    ]),
                  ),
                ]));
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          isLoading = true;
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
          }
        },
        label: const Text('Add PUB'),
        icon: const Icon(Icons.upload),
        backgroundColor: Colors.green,
        elevation: 600,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //ALERTE DIALOGUE POUR SUPPRIMER UN DOCUMENT
  void _alertedialdelete({required String url}) async {
    const SizedBox(
      height: 100,
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('EFFACER: '),
            content: const Text(
              'Effacer Cette Publicité?',
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
                  FirebaseStorage.instance.refFromURL(url).delete();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Publicité effacée avec succes!'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      top: 10.0,
                      // Ajustez cette valeur selon vos besoins
                      left: 10.0,
                      right: 10.0,
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                    elevation: 10.0,
                  ));
                  Navigator.pop(context);
                  setState(() {});
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

  void _alertedialajout({required File? image}) async {
    const SizedBox(
      height: 100,
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('AJOUTER'),
            content: Container(
              width: 300.0, // Définir la largeur souhaitée
              height: 400.0,
              child: Column(
                children: <Widget>[
                  const Text('Ajouter cette Publicité?'),
                  if (_isLoading) const CircularProgressIndicator(),
                  Container(
                    alignment: Alignment.center,
                    height: 200,
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
                            image: FileImage(image!), fit: BoxFit.cover)

                      /*xFile?.path != null
                        ? DecorationImage(
                            image: FileImage(File(xFile!.path)),
                            fit: BoxFit.cover)
                        : null,*/
                    ),
                    child: xFile?.path != null
                        ? const Text(' ')
                        : const Text('Aucune image selectionee'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Non'),
              ),
              TextButton(
                onPressed: () async {
                  _startLoading();
                  if (xFile != null) {
                    // _image = xFile as File?;
                    isLoading = false;
                    setState(() {});

                    ///up loading the file
                    final String? url = await _uploadImage(
                        imag: image, dossier: widget.dossier1);
                    imgList.add(url!);
                    Navigator.pop(context);
                    setState(() {});

                    setState(() {
                      enbas = true;
                    });
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
                child: const Text('Oui'),
              ),
            ],
          );
        });
  }
}
*/