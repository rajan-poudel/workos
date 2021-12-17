import 'package:flutter/material.dart';
import 'package:workos/constants/constants.dart';

class AllWorkersWidget extends StatefulWidget {
  const AllWorkersWidget({Key? key}) : super(key: key);

  @override
  _AllWorkersWidgetState createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {},
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(
                'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'),
          ),
        ),
        title: Text(
          'Workers Name',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Constants.darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale_outlined,
              color: Colors.pink.shade800,
            ),
            const Text(
              "positions/98456788388",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.mail_outline,
            size: 30,
            color: Colors.pink.shade800,
          ),
        ),
      ),
    );
  }
}
