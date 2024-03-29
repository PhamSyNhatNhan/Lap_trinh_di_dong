import 'package:flutter/material.dart';
import 'package:nhonn/Value/color.dart';
import 'package:nhonn/Value/font.dart';
import 'package:nhonn/Value/image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class LoginMat extends StatefulWidget {
  final VoidCallback changePage, loginSuccess;
  const LoginMat({Key? key, required this.changePage, required this.loginSuccess}) : super(key: key);

  @override
  State<LoginMat> createState() => _LoginMat();
}

class _LoginMat extends State<LoginMat> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/Image/back_gr.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                    child: Image.network(
                      logoImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      textDirection: TextDirection.ltr,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            color: loginFontFocus,
                            fontSize: 27,
                            fontFamily: loginTextFont,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextField(
                          controller: _emailController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: loginFont,
                            fontSize: 15,
                            fontFamily: loginTextFont,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: loginFontFocus,
                              fontSize: 15,
                              fontFamily: loginTextFont,
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: loginBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: loginTheme,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: _passController,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: loginFont,
                            fontSize: 15,
                            fontFamily: loginTextFont,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Mật khẩu',
                            labelStyle: TextStyle(
                              color: loginFontFocus,
                              fontSize: 15,
                              fontFamily: loginTextFont,
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: loginBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: loginTheme,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        // ĐĂNG NHẬP ________________________________________________________________
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: SizedBox(
                            width: 329,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  String query = "select count(*), userId, userStatus from useraccount where userEmail = '" + _emailController.text + "' and userPassword = '" + _passController.text + "'";
                                  var result = await conn.execute(query);

                                  for (final row in result.rows) {
                                    if(row.colAt(0) == '1' && row.colAt(2) == '1'){
                                      try {
                                        query = "select userId, userEmail, userName, userImage, userPhoneNumber, userAddres from useraccount where userId = '" + row.colAt(1) + "'";
                                        var result = await conn.execute(query);

                                        for (final row in result.rows) {
                                          if(row.colByName("userId") != null) user.userId = row.colByName("userId");
                                          if(row.colByName("userEmail") != null) user.userEmail = row.colByName("userEmail");
                                          if(row.colByName("userName") != null) user.userName = row.colByName("userName");
                                          if(row.colByName("userImage") != null) user.userImage = row.colByName("userImage");
                                          if(row.colByName("userPhoneNumber") != null) user.userPhoneNumber = row.colByName("userPhoneNumber");
                                          if(row.colByName("userAddres") != null) user.userAddres = row.colByName("userAddres");
                                        }
                                      }
                                      catch(e){
                                        print("error 2: " + e.toString());
                                      }

                                      widget.loginSuccess();
                                    }
                                  }
                                }catch(error){
                                  print("error 1: " + error.toString());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: loginTheme,
                              ),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: loginTextFont,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Chưa có tài khoản?',
                              style: TextStyle(
                                color: loginFont,
                                fontSize: 13,
                                fontFamily: loginTextFont,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 2.5,
                            ),
                            InkWell(
                              onTap: () {
                                widget.changePage();
                              },
                              child: const Text(
                                ' Tài khoản mới',
                                style: TextStyle(
                                  color: loginFontFocus,
                                  fontSize: 13,
                                  fontFamily: loginTextFont,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            // for got password
                            print("quên mật khẩu");
                            Uri url = Uri.parse('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
                            launchUrl(url);
                          },
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: loginFontFocus,
                              fontSize: 13,
                              fontFamily: loginTextFont,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        )
    );
  }
}