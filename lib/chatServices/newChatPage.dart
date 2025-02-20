import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chatbuble.dart';
import 'message_model.dart';

bool theme = true;

/****  c'est Nice hein!?? Create by me 07/01/2025 (Valcin VAILLANT) ****/
class newChatUI extends StatefulWidget {
  const newChatUI(
      {super.key,
      required this.Sendername,
      required this.name1,
      required this.receiverId,
      required this.admSender,
      required this.admReceiver});

  final String Sendername;
  final bool admSender;
  final bool admReceiver;
  final String name1;
  final String? receiverId;

  @override
  State<newChatUI> createState() => _newChatUIState();
}

class _newChatUIState extends State<newChatUI> {
  var name = '';
  final _formkey = GlobalKey<FormState>();
  final messageController = TextEditingController(); //
  DateTime? datedujour = DateTime.now();
  bool valid = false;
  DateTime? datedujour1 = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextFormField generateTextField(controller, {required String hintText}) {
    //Fonction pour generer des champs de texte (24/08/2024).Vaillant Valcin
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade400,
      ),
      maxLines: null,
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().isEmpty) {
          return 'please add some text';
        }
        return null;
      },
    );
  }

  //afficher les message en streaming
  /* Stream<QuerySnapshot> getMessages(String userID, otherUserId) {
    List<String> ids = [userID, otherUserId];
    ids.sort();
    String chatRoomID = ids.join('_');
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }*/

  // fonction pour envoyer les messages
  Future<void> sendMessage(String receiverId, message) async {
    final String CurrentUserId = _auth.currentUser!.uid;
    final String? CurrentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    Message newmessage = Message(
        timestamp: timestamp,
        message: message,
        senderID: CurrentUserId,
        senderEmail: CurrentUserEmail!,
        receverID: receiverId,
        name: widget.Sendername);
    // on peut faire mieux
    List<String> ids = [CurrentUserId, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');
    //add new message to database

    await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newmessage.toMap());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose(); //
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.name1),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(
            child: _buildMessageList(),
          ),
          _messageInput(),
        ],
      )),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /******** pour la liste des messages dans la base de donnees******/

  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    List<String> ids = [senderID, widget.receiverId!];
    ids.sort();
    String chatRoomID = ids.join('_');

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat_rooms")
            .doc(chatRoomID)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        //getMessages(senderID, widget.receiverId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return //const Center(
                // child:
                Text(' Erreur');
            //);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return //  Center(
                //  child:
                const CircularProgressIndicator();
            //   );
          }

          if (!snapshot.hasData) {
            return const Text("Pas de Message pour aujourd'hui!");
          } else {
            // const Text("Verifiez Votre Connexion internet...");

            List<dynamic> lesMessages = [];
            snapshot.data!.docs.forEach((element) {
              lesMessages.add(element);
            });
            return ListView.builder(
                reverse: true,
                itemCount: lesMessages.length,
                itemBuilder: (context, index) {
                  final mess = lesMessages[index];
                  final message = mess['message'];
                  final name2 = mess['name'];
                  // bool admini = mess['adm'];
                  //on va verifier qui est la  (il y a une legere difference par rapport avec le chat habituel)
                  bool iscurrentuser = name2 != widget.name1;
                  // on aligne suivant le user en question
                  var main = iscurrentuser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start;
                  var cross = iscurrentuser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start;
                  final Timestamp timestamp = mess['timestamp'];
                  String? datedujour = DateFormat.yMMMMd('en_US')
                      .add_jm()
                      .format(timestamp.toDate());

                  return Container(
                      //  alignment: alignments,
                      margin:
                          EdgeInsets.symmetric(vertical: 2.5, horizontal: 15),
                      //margin: EdgeInsets.symmetric(vertical: 3,),
                      child: Row(
                          mainAxisAlignment: main,
                          crossAxisAlignment: cross,
                          children: [
                            // c'est le chat bubble
                            ChatBubble(
                              message: message,
                              iscurrentuser: iscurrentuser,
                              datedujour: datedujour,
                              administrateur: iscurrentuser
                                  ? widget.admSender
                                  : widget.admReceiver,
                            ),
                          ]));
                });
          }
        });
  }

  /*********WE GONNA SEND THE MESSAGE*****/
  Widget _messageInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Form(
        key: _formkey,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: generateTextField(messageController,
                    hintText: "Type a message")),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(225, 95, 27, 3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ]),
              margin: const EdgeInsets.all(15),
              child: IconButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      valid = true;
                    });

                    String message = messageController.text.trim();
                    // Supprimer les lignes vides au début et à la fin
                    message = message.replaceAll(RegExp(r'^\s*\n|\n\s*$'), '');
                    // final name1 = widget.name1;
// C'est Nice
                    sendMessage(widget.receiverId!, message);
                    messageController.clear();
                    //on retourne a l'ecran des message envoyes
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("MESSAGE SENT"),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 2),
                        elevation: 10.0,
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
