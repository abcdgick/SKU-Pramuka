import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sku_pramuka/screen/tugas_screen.dart';

class CardTugas extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
  final bool check;

  const CardTugas(
      {super.key,
      required this.title,
      required this.iconData,
      required this.iconColor,
      required this.iconBgColor,
      required this.check});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TugasPage(),
                ),
              ),
              child: SizedBox(
                height: 80,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Color(0xff2a2e3d),
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      Container(
                        height: 33,
                        width: 36,
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          iconData,
                          color: iconColor,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Theme(
            data: ThemeData(
                primarySwatch: Colors.blue,
                unselectedWidgetColor: Color(0xff5e616a),
                checkboxTheme: CheckboxThemeData(
                  fillColor: MaterialStateProperty.all(Color(0xff6cf8a9)),
                )),
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                checkColor: Color(0xff0e3e26),
                value: check,
                onChanged: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
