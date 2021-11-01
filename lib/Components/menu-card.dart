import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    Key? key,
    required this.cardTitle,
    required this.menuList,
  }) : super(key: key);

  final String cardTitle;
  final List<Map<String, dynamic>> menuList;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardTitle,
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Color(0xff7c7c7c)),
            ),
            SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              itemCount: menuList.length,
              itemBuilder: (context, index) => ListTile(
                onTap: menuList[index]['onTap'] == null ? null : menuList[index]['onTap'],
                contentPadding: EdgeInsets.zero,
                title: Text(
                  menuList[index]['title'],
                  style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffBDBDC7)),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1),
            ),
          ],
        ),
      ),
    );
  }
}
