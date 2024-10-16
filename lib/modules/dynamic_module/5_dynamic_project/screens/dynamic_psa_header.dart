
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DynamicPsaHeader extends StatelessWidget {
  final String icon;
  final String title;
  final String projectID;
  final String status;
  final String siteTown;
  final bool isVisible;
  final Color backgroundColor;

  const DynamicPsaHeader(
      {Key? key,
        required this.icon,
        required this.title,
        required this.backgroundColor,
        required this.isVisible, required this.projectID, required this.status, required this.siteTown,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor!=null ?backgroundColor: Color(0xffE67E6B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.only(left:10.0,right: 10),
                  child: Column(
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
                        softWrap: true,
                        maxLines: 1,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          status.isNotEmpty?Expanded(
                            child: Text(
                              "${status}",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ):SizedBox(),
                          Text(
                            projectID,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
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
