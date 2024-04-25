import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CopyUtil {
  static void showCopyMessage(BuildContext context,Function onCopy) {
    showPlatformDialog(
      context: context,
      builder: (context) {
        return PlatformAlertDialog(
          title: Text('Project-SalesAchiever'),
          content: Text("This will create a copy of selected form, to view the record open the PDF. Do you wish to proceed?"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0, // No elevation
                        backgroundColor: Colors.transparent, // Background color
                        foregroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Square shape with no curves
                        ),
                      ),
                      child: Text('Yes'),
                      onPressed: () {
                       onCopy();
                      },
                    ),
                  ),
                  Container(width: 1,height: 50,color: Colors.black26,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0, // No elevation
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Square shape with no curves
                        ),
                      ),
                      child: Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

          ],
        );
      },
    );
  }
}
