import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {required this.message,
      required this.iscurrentuser,
      required this.administrateur,
      required this.datedujour});

  final String message;
  final bool iscurrentuser;
  final String datedujour;
  final bool administrateur;

  String insertLineBreaks(String text, int wordLimit) {
    List<String> words = text.split(' ');
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < words.length; i++) {
      buffer.write(words[i]);
      if ((i + 1) % wordLimit == 0 && i != words.length - 1) {
        buffer.write('\n');
      } else {
        buffer.write(' ');
      }
    }
    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    String words = insertLineBreaks(message, 5);
    // on devra ameliorer cette fonction
    return Container(
        padding: const EdgeInsets.all(10.0),

        //  margin: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: iscurrentuser ? Colors.orange : Colors.grey.shade500,
          //borderRadius: BorderRadius.circular(20),
          borderRadius: BorderRadius.only(
            // nice
            topLeft: iscurrentuser
                ? const Radius.circular(15)
                : const Radius.circular(1),
            bottomLeft: iscurrentuser
                ? const Radius.circular(15)
                : const Radius.circular(30),
            topRight: iscurrentuser
                ? const Radius.circular(1)
                : const Radius.circular(15),
            bottomRight: iscurrentuser
                ? const Radius.circular(30)
                : const Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              iscurrentuser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Align(
              alignment: iscurrentuser ? Alignment.topLeft : Alignment.topLeft,
              child: Text(
                words,
                style: const TextStyle(fontSize: 22.0, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Text(
                  datedujour,
                  style: const TextStyle(fontSize: 10.0, color: Colors.white70),
                ),
                administrateur == true
                    ? const Icon(
                        Icons.verified,
                        color: Colors.blue,
                      )
                    : const Text(
                        '',
                      ),
              ],
            ),
          ],
        ));
  }
}
