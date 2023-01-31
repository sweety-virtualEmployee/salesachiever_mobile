import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaHeader extends StatelessWidget {
  final String icon;
  final String title;
  final bool isVisible;

  const PsaHeader(
      {Key? key,
      required this.icon,
      required this.title,
      required this.isVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(title);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Image.asset(
                  icon,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlatformText(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    /*  isVisible
                          ? PlatformText(
                              "Value: 1/5",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 10,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(),*/
                    ],
                  ),
                ),
              ),
             /* isVisible
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PlatformText(
                          "Pending",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        PlatformText(
                          "Next Postpone:",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  : SizedBox(),
              isVisible
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    width: 30,
                                    height: 90,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      value: 3 / 5,
                                      backgroundColor: Colors.grey,
                                      valueColor: calculateBackgroundColor(
                                          value: 1 / 5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    "1/5",
                                    style: TextStyle(fontSize: 11),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                  : SizedBox(),*/
            ],
          ),
          Divider(
            color: const Color(0xFFFAFAFA),
            height: 1,
          ),
        ],
      ),
    );
  }

  // Define a function to calculate the adequate color:
  calculateBackgroundColor({required double value}) {
    if (value == 1 / 5) {
      return AlwaysStoppedAnimation<Color>(Colors.red);
    } else if (value == 2 / 5) {
      return AlwaysStoppedAnimation<Color>(Colors.green);
    } else if (value == 3 / 5) {
      return AlwaysStoppedAnimation<Color>(Colors.yellow);
    } else if (value == 4 / 5) {
      return AlwaysStoppedAnimation<Color>(Colors.lightGreen);
    } else if (value == 5 / 5) {
      return AlwaysStoppedAnimation<Color>(Colors.blue);
    } else {
      return Colors.grey;
    }
  }
}
