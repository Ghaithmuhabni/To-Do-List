import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/extensions/space_exs.dart';
import 'package:flutter_application_1/utils/app_colors.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill
  ];

  final List<String> texts = ["Home", "Profile", "Settings", "Details"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 200),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: AppColors.primaryGradientColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                "https://avatars.githubusercontent.com/u/91388754?v=4"),
          ),
          8.h,
          Text(
            "Ghaith",
            style: TextStyle(fontSize: 35),
          ),
          Text(
            "Flutter Dev.",
            style: TextStyle(fontSize: 25),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 60, horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: icons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    print(texts[index] + " Item Tapped!");
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Icon(
                        icons[index],
                        color: Colors.white,
                        size: 50,
                      ),
                      title: Text(
                        texts[index],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
