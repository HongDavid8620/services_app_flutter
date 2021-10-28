import 'package:flutter/material.dart';

class ListDrawer extends StatelessWidget {
  const ListDrawer(
      {Key? key,
      this.selectedMenu,
      this.icon,
      this.text,
      this.indexMenu,
      this.onTap})
      : super(key: key);

  final int? selectedMenu;
  final icon;
  final String? text;
  final indexMenu;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child : InkWell(
        onTap: onTap,
        child: Padding(
          padding : const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child   : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (selectedMenu != null)
                if (selectedMenu == indexMenu)
                  Container(
                    width     : 4,
                    height    : 35,
                    decoration: BoxDecoration(
                      color       : Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )
                else if (selectedMenu != indexMenu || selectedMenu != null)
                  SizedBox(
                    width: 4,
                  ),
              if (selectedMenu != null)
                SizedBox(
                  width: 10,
                ),
              Text('$text',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal))
            ],
          ),
        ),
      ),
    );
  }
}
