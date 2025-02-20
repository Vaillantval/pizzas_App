import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTile extends StatefulWidget {
  const UserTile(
      {super.key,
      required this.text,
      required this.idCommande,
      required this.onTap,
      required this.message,
      required this.date,
      required this.ifdeliver,
      required this.numero,
      required this.ifadmin});

  final String text;
  final String date;
  final String message;
  final bool ifdeliver;
  final void Function()? onTap;
  final String numero;
  final bool ifadmin;
  final String idCommande;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    bool ifdel = widget.ifdeliver;
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shadowColor: Colors.orange,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10, 5.0),
          child: Column(
            children: [
              ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      Align(
                        child: Text(widget.message),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          children: [
                            Text(
                              !widget.ifdeliver ? 'NON DELIVRE' : 'DELIVRE ☺',
                              style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                  checkColor: Colors.green,
                                  value: ifdel,
                                  onChanged: (bool? value) async {
                                    if (widget.ifadmin) {
                                      ifdel = value!;
                                      await FirebaseFirestore.instance
                                          .collection('commandes')
                                          .doc(widget.idCommande)
                                          .update({
                                        'ifdeliver': ifdel,
                                      });
                                    }
                                    setState(() {});
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.call,
                                color: Colors.blue,
                              ),
                              Text(widget.numero),
                            ],
                          )),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(widget.date),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
