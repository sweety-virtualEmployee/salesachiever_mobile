import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/CustomWidgets/customactivefeature.dart';
import 'package:salesachiever_mobile/modules/0_home/screens/home_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/0_dynamic_home/screens/dynamic_home_page.dart';

class PsaScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? action;
  final bool showHome;

  const PsaScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.action,
    this.showHome = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: SizedBox(
          width: 70, 
          height: 70,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFAFAFAFA).withOpacity(0.7),
              borderRadius: BorderRadius.all(
                new Radius.circular(8.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PlatformCircularProgressIndicator(),
            ),
          ),
        ),
      ),
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          material: (_, __) => MaterialAppBarData(
            centerTitle: true,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showHome ? HomeButton() : Container(),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PlatformText(
                      title,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              showHome ? SizedBox(width: 15,) : Container(),

            ],
          ),
          trailingActions: [action ?? Container()],
        ),
        body: SafeArea(
          child: Scaffold(
            body: body,
          ),
        ),
      ),
    );
  }
}

class HomeButton extends StatefulWidget {
  const HomeButton({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  CustomActiveFeature feature = CustomActiveFeature();

 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(context.platformIcons.home),
      onTap: () async {
        
       bool isContainActiveFeature = await feature.activeFeatures();
      if(isContainActiveFeature){
         Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => DyanmicHomeScreen(),
          transitionDuration: Duration(seconds: 0),
        ),
        (route) => false,
      );
      }
      else{
        print("error");
         Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(),
          transitionDuration: Duration(seconds: 0),
        ),
        (route) => false,
      );
      }   

      }
      
      
      
      // => Navigator.pushAndRemoveUntil(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (_, __, ___) => HomeScreen(),
      //     transitionDuration: Duration(seconds: 0),
      //   ),
      //   (route) => false,
      // ),
    );
  }
}
