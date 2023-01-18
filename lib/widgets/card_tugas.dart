import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sku_pramuka/screen/tugas_screen.dart';
import 'package:sku_pramuka/widgets/custom_checkbox.dart';

class CardTugas extends StatelessWidget {
  final String uid;
  final String title;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
  final String check;
  final List<String> kategori;
  Map<String, String> pembina;

  CardTugas(
      {super.key,
      required this.uid,
      required this.title,
      required this.iconData,
      required this.iconColor,
      required this.iconBgColor,
      required this.check,
      required this.kategori,
      required this.pembina});

  Color checkColor = Color.fromARGB(255, 170, 139, 86);

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
                      uid: uid,
                      title: title,
                      progress: check,
                      kategori: kategori,
                      pembina: check == "belum" || check == "ditolak"
                          ? pembina
                          : {}),
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: ambilWarna(check),
                      ),
                    ),
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Custom_Checkbox(
              isChecked: check != "belum",
              backgroundColor: checkColor,
              borderColor: checkColor,
              icon: icon(),
              iconColor: Colors.white,
            ),
          ),
          // Theme(
          //   data: ThemeData(
          //       primarySwatch: Colors.green,
          //       unselectedWidgetColor: Color(0xff5e616a),
          //       checkboxTheme: CheckboxThemeData(
          //         fillColor: MaterialStateProperty.all(
          //             Color.fromARGB(255, 170, 139, 86)),
          //       )),
          //   child: Transform.scale(
          //     scale: 1.5,
          //     child: Checkbox(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       checkColor: Colors.white,
          //       value: check,
          //       onChanged: null,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  IconData icon() {
    if (check == "proses") {
      return Icons.circle_outlined;
    } else if (check == "ditolak") {
      return Icons.close;
    } else {
      return Icons.check;
    }
  }

  List<Color> ambilWarna(String progress) {
    switch (progress) {
      case "belum":
        checkColor = Color.fromARGB(255, 170, 139, 86);
        return [
          Color.fromARGB(255, 247, 211, 132),
          Color.fromARGB(255, 255, 225, 156),
        ];
      case "proses":
        checkColor = Color(0xff2664fa);
        return [
          Color.fromARGB(255, 127, 164, 250),
          Color.fromARGB(255, 147, 184, 250),
        ];
      case "ditolak":
        checkColor = Color(0xFFFF6464);
        return [
          Color.fromARGB(255, 253, 125, 125),
          Color.fromARGB(255, 255, 145, 145),
        ];
      case "diterima":
        checkColor = Color(0xff00CBA9);
        return [
          Color.fromARGB(255, 147, 255, 139),
          Color.fromARGB(255, 167, 255, 159),
        ];
      default:
        return [
          Color.fromARGB(255, 247, 211, 132),
          Color.fromARGB(255, 255, 225, 156),
        ];
    }
  }
}
