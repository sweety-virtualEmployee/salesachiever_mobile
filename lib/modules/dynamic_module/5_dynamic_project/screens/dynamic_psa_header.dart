import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DynamicPsaHeader extends StatelessWidget {
  final String icon;
  final String title;
  final String projectID;
  final String status;
  final String siteTown;
  final bool isVisible;

  const DynamicPsaHeader(
      {Key? key,
        required this.icon,
        required this.title,
        required this.isVisible, required this.projectID, required this.status, required this.siteTown,})
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
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width *0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                          Text(
                            projectID,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                         // SizedBox(width: 10,)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            siteTown,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                        ],
                      ),
                     // SizedBox(height: 2,),

                    ],
                  ),
                ),
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
}
