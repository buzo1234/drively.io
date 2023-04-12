import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:drively/screens/login_phone.dart';
import 'package:drively/screens/verification_screen.dart';
import 'package:drively/services/user_crud.dart';
import 'package:drively/utility/app_colors.dart';
import 'package:drively/utility/app_dimens.dart';
import 'package:drively/utility/utility.dart';

class RegisterWithPhone extends StatefulWidget {
  const RegisterWithPhone({super.key});

  @override
  State<RegisterWithPhone> createState() => _RegisterWithPhoneState();
}

class _RegisterWithPhoneState extends State<RegisterWithPhone> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  AppDimens appDimens;
  TextEditingController textEditingController;
  TextEditingController nameEditingController;
  Size size;
  MediaQueryData mediaQuerydata;
  bool isLoading = false;
  bool loadingLogin = false;

  _RegisterWithPhoneState()
      : size = const Size(20, 20),
        appDimens = AppDimens(const Size(20, 20)),
        mediaQuerydata = const MediaQueryData(),
        textEditingController = TextEditingController(),
        nameEditingController = TextEditingController();

  String? mtoken = " ";

  void getToken() async {
    await messaging.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadingLogin = false;

    textEditingController = TextEditingController();
    nameEditingController = TextEditingController();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuerydata = MediaQuery.of(context);
    size = MediaQuery.of(context).size;
    appDimens = AppDimens(size);

    return Scaffold(
      backgroundColor: AppColors.MainBackGroundColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: size.height - mediaQuerydata.padding.top),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    /* Image.asset(
                      'assets/icon/icon.jfif',
                      height: 150,
                      width: 150,
                    ), */
                    const FlutterLogo(
                      size: 150,
                    ),
                    const Spacer(),
                    Container(
                      margin: EdgeInsets.only(top: appDimens.paddingw2),
                      alignment: Alignment.center,
                      child: Text(
                        "Register to continue",
                        style: TextStyle(
                          fontSize: appDimens.text20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: appDimens.paddingw20,
                    ),
                    emailMobileView(),
                    SizedBox(
                      height: appDimens.paddingw20,
                    ),
                    Utility.loginButtonsWidget(
                      "",
                      loadingLogin ? "Loading..." : "Continue",
                      () {
                        loadingLogin ? null : continueClick();
                      },
                      AppColors.SubBackGroundColor,
                      AppColors.SubBackGroundColor,
                      appDimens,
                      AppColors.whiteColor,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => (const LoginWithPhone()),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: appDimens.paddingw6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Spacer(),
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: appDimens.text16,
                              ),
                            ),
                            Text(
                              "Login!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: appDimens.text16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Spacer(),
                    Container(
                      width: size.width,
                      margin: EdgeInsets.only(bottom: appDimens.paddingw16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: appDimens.paddingw18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isLoading ? Utility.progress(context) : Container(),
          ],
        ),
      ),
    );
  }

  Widget emailMobileView() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: appDimens.paddingw16 * 2,
            right: appDimens.paddingw16 * 2,
            bottom: appDimens.paddingw16,
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            // boxShadow: [
            //   BoxShadow(
            //     offset: Offset(0, 1),
            //     blurRadius: 2,
            //     color: Colors.black54,
            //   ),
            // ],
            border: Border.all(color: AppColors.blackColor, width: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: <Widget>[
              Container(
                color: AppColors.blackColor,
                width: 0.5,
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: appDimens.paddingw6,
                ),
              ),
              Expanded(
                child: TextFormField(
                  style: TextStyle(
                      fontSize: appDimens.text16, color: AppColors.greyText),
                  controller: nameEditingController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: "Name",
                    counterText: "",
                    hintStyle: TextStyle(color: AppColors.greyText),
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          margin: EdgeInsets.only(
            left: appDimens.paddingw16 * 2,
            right: appDimens.paddingw16 * 2,
            bottom: appDimens.paddingw16,
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            // boxShadow: [
            //   BoxShadow(
            //     offset: Offset(0, 1),
            //     blurRadius: 2,
            //     color: Colors.black54,
            //   ),
            // ],
            border: Border.all(color: AppColors.blackColor, width: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: appDimens.paddingw6,
                  right: appDimens.paddingw6,
                ),
                child: Text(
                  "+91",
                  style: TextStyle(
                      fontSize: appDimens.text16, color: AppColors.greyText),
                ),
              ),
              Container(
                color: AppColors.blackColor,
                width: 0.5,
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: appDimens.paddingw6,
                ),
              ),
              Expanded(
                child: TextFormField(
                  style: TextStyle(
                      fontSize: appDimens.text16, color: AppColors.greyText),
                  controller: textEditingController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: "Mobile Number",
                    counterText: "",
                    hintStyle: TextStyle(color: AppColors.greyText),
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  addUserToDB() async {
    List<String?> tokenList = [];
    tokenList.add(mtoken);
    var response = await UserCrud.addUsers(
        name: nameEditingController.text,
        phone: textEditingController.text,
        role: "idle",
        groups: [],
        deviceToken: tokenList);

    if (response.code == 200) {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationScreen(
              mobile: textEditingController.text,
              countrycode: "+91",
              userName: nameEditingController.text,
              role: "idle",
            ),
          ),
        );
      }
    } else {}
  }

  continueClick() async {
    if (textEditingController.text.length != 10) return;
    setState(() {
      loadingLogin = true;
    });
    Future<DocumentSnapshot> resp =
        UserCrud.readUser(phoneNum: textEditingController.text);

    resp.then(
      (doc) => {
        if (doc.data() != null)
          {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      backgroundColor: AppColors.SubBackGroundColor,
                      content: const Text(
                        "Number Already Exists! Please LogIn instead",
                        textAlign: TextAlign.center,
                      ));
                }),
            setState(() {
              loadingLogin = false;
            })
          }
        else
          {addUserToDB()}
      },
    );
  }
}
