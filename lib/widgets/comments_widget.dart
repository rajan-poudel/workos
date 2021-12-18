import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  List<Color> _color = [
    Colors.green,
    Colors.amber,
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.cyan,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    _color.shuffle();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: _color[0],
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Commenter Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Comment msg",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                )
              ],
            ))
      ],
    );
  }
}
