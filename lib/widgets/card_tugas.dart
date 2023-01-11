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
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TugasPage(
                    title: title,
                  ),
                ),
              ),
              child: SizedBox(
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  //color: Color.fromARGB(255, 247, 211, 132),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 247, 211, 132),
                      Color.fromARGB(255, 255, 225, 156),
                    ])),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Row(
                        children: [
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
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              title,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Theme(
            data: ThemeData(
                primarySwatch: Colors.green,
                unselectedWidgetColor: Color(0xff5e616a),
                checkboxTheme: CheckboxThemeData(
                  fillColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 170, 139, 86)),
                )),
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                checkColor: Colors.white,
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
