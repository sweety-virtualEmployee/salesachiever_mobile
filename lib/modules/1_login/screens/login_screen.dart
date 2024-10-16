import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:salesachiever_mobile/CustomWidgets/customactivefeature.dart';
import 'package:salesachiever_mobile/exceptions/invalid_license_exception.dart';
import 'package:salesachiever_mobile/modules/0_home/screens/home_screen.dart';
import 'package:salesachiever_mobile/modules/1_login/services/login_service.dart';
import 'package:salesachiever_mobile/modules/1_login/widgets/language_selector.dart';
import 'package:salesachiever_mobile/modules/1_login/widgets/login_button.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/0_dynamic_home/screens/dynamic_home_page.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';
import 'package:salesachiever_mobile/shared/widgets/dialog_loader.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  TextEditingController apiController = TextEditingController();
  TextEditingController loginNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  String version = '1.0.0';
  String localeId = '1033';
  CustomActiveFeature feature = CustomActiveFeature();
  String firstUrl = 'https://dev.psacrm.com/API_423';
  String secondUrl = '';
  bool _isBiometricAvailable = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _initiateLoginDetails();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      setState(() {
        _isBiometricAvailable = canCheckBiometrics;
      });
    } catch (e) {
      print("Error checking biometrics: $e");
    }
  }

  void _initiateLoginDetails() async {
    bool firstTime = StorageUtil.getBool('first');
    String newUrl = StorageUtil.getString('newUrl');
    String changeUrl = StorageUtil.getString('changeFirstUrl');
    if (changeUrl != '') {
      firstUrl = changeUrl;
    }

    if (newUrl != '') {
      apiController.text = newUrl;
    } else {
      apiController.text = firstUrl;
    }

    loginNameController.text = StorageUtil.getString('loginName');
    companyController.text = StorageUtil.getString('company');

    var savedLocaleId = StorageUtil.getString('localeId');
    if (savedLocaleId != '') localeId = savedLocaleId;

    _getVersion();

    if (_isBiometricAvailable) {
      _authenticateWithBiometrics();
    }
  }

  void _getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        String storedPassword = StorageUtil.getString('password');
        if (storedPassword.isNotEmpty) {
          _login(
            context,
            apiController.text,
            loginNameController.text,
            storedPassword,
            companyController.text,
            localeId,
          );
        }
      }
    } catch (e) {
      print("Error during biometric authentication: $e");
    }
  }

  void _login(
    BuildContext context,
    String api,
    String loginName,
    String password,
    String company,
    String languageId,
  ) async {
    if (api.isEmpty ||
        loginName.isEmpty ||
        password.isEmpty ||
        company.isEmpty) {
      Fluttertoast.showToast(
        msg: "All fields are required.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.black87,
      );
      return;
    }

    bool isSecure = Uri.parse(api).isScheme('HTTPS');

    if (!isSecure) {
      Fluttertoast.showToast(
        msg: MessageUtil.getMessage('UserLogin.InvalidURL.Message'),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.black87,
      );
      return;
    }

    DialogLoader.showLoadingDialog(context, _keyLoader);

    try {
      await LoginService().login(
        api,
        loginName,
        password,
        company,
        languageId,
        firstUrl,
        apiController.text,
      );
      bool isContainActiveFeature = await feature.activeFeatures();
      print("isContain$isContainActiveFeature");
      if (isContainActiveFeature) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;

        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('myTimestampKey', timestamp);

        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DyanmicHomeScreen(),
            transitionDuration: Duration(seconds: 0),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => HomeScreen(),
            transitionDuration: Duration(seconds: 0),
          ),
          (route) => false,
        );
      }
    } on DioException catch (e) {
      Navigator.pop(context);
      if (e.response?.statusCode.toString() == '401') {
        String message = e.response?.data['Errors'][0]['Message'] ?? '0';
        ErrorUtil.showErrorMessage(context,
            MessageUtil.getMessage(message.replaceAll('ResourceStrings:', '')));
      } else {
        ErrorUtil.showErrorMessage(context,
            MessageUtil.getMessage(e.response?.statusCode.toString() ?? '0'));
      }
    } on InvalidLicenceException {
      Navigator.pop(context);
      ErrorUtil.showErrorMessage(
          context, MessageUtil.getMessage('IncorrectDatabaseVersion.Message'));
    } catch (e) {
      Navigator.pop(context);
      ErrorUtil.showErrorMessage(
          context, MessageUtil.getMessage('IncorrectLogin.Message"'));
    }
  }

  void _onLanguageChanged(String lang) {
    if (lang.isNotEmpty) {
      setState(() {
        localeId = lang;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    var psaLogo = Image(
      width: 300,
      image: AssetImage('assets/images/ProjectSalesAchieverLogo.png'),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 66, 165, 245),
                  Color.fromARGB(255, 21, 101, 165)
                ],
                stops: [0.1, 1.0],
              ),
              image: DecorationImage(
                image: ExactAssetImage('assets/images/buildings_image.png'),
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomLeft,
                scale: MediaQuery.of(context).size.width > 480 ? 1 : 1.4,
              ),
            ),
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LanguageSelector(
                        localeId: localeId,
                        onLanguageChanged: _onLanguageChanged,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: psaLogo,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width < 440
                            ? MediaQuery.of(context).size.width - 40
                            : 400,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFFAFAFAFA),
                                borderRadius: BorderRadius.all(
                                  new Radius.circular(8.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    PsaTextField(
                                      controller: loginNameController,
                                      placeholder: 'UserName',
                                      keyboardType: TextInputType.text,
                                      onEditingComplete: () => node.nextFocus(),
                                      textInputAction: TextInputAction.next,
                                    ),
                                    PsaTextField(
                                      controller: passwordController,
                                      placeholder: 'Password',
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      isPassword: true,
                                      onEditingComplete: () => node.nextFocus(),
                                      textInputAction: TextInputAction.next,
                                    ),
                                    PsaTextField(
                                      controller: apiController,
                                      placeholder: 'Url',
                                      keyboardType: TextInputType.url,
                                      onEditingComplete: () => node.nextFocus(),
                                      textInputAction: TextInputAction.next,
                                    ),
                                    PsaTextField(
                                      controller: companyController,
                                      placeholder: 'Database',
                                      keyboardType: TextInputType.text,
                                      onEditingComplete: () => node.nextFocus(),
                                      textInputAction: TextInputAction.go,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            LoginButton(
                              onTap: (context) {
                                _login(
                                  context,
                                  apiController.text,
                                  loginNameController.text,
                                  passwordController.text,
                                  companyController.text,
                                  localeId,
                                );
                              },
                            ),
                            if (_isBiometricAvailable)
                              TextButton(
                                onPressed: _authenticateWithBiometrics,
                                child: Text('Use Face ID/Touch ID',style: TextStyle(
                                  color: Colors.white
                                ),),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))));
  }
}
