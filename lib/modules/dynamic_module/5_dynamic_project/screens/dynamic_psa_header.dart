import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DynamicPsaHeader extends StatelessWidget {
  final String icon;
  final String title;
  final String projectID;
  final String status;
  final bool isVisible;

  const DynamicPsaHeader(
      {Key? key,
        required this.icon,
        required this.title,
        required this.isVisible, required this.projectID, required this.status,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffE67E6B),
     // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       // mainAxisAlignment: MainAxisAlignment.center,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlatformText(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  PlatformText(
                    projectID,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  PlatformText(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                 // SizedBox(height: 2,),

                ],
              ),
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
