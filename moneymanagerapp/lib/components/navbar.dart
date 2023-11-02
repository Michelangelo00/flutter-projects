import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 69, 39, 241),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.people,
                color: Colors.white,
                size: 25.0,
              ),
              SizedBox(width: 30.0),
              Icon(
                Icons.picture_as_pdf_outlined,
                color: Colors.white,
                size: 25.0,
              ),
              SizedBox(width: 30.0),
              Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
