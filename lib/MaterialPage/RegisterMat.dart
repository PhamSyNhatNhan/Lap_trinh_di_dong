import 'package:flutter/material.dart';
import 'package:nhonn/Value/color.dart';
import 'package:nhonn/Value/font.dart';
import 'package:nhonn/Value/image.dart';

class RegisterMat extends StatefulWidget {
  final VoidCallback changePage;
  const RegisterMat({Key? key, required this.changePage}) : super(key: key);

  @override
  State<RegisterMat> createState() => _RegisterMat();
}

class _RegisterMat extends State<RegisterMat> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();

  //SingleChildScrollView(
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: loginBackground,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Image/back_gr.png'),
              fit: BoxFit.cover,
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
                        'Tài khoản mới',
                        style: TextStyle(
                          color: unActiveColor,
                          fontSize: 27,
                          fontFamily: loginTextFont,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),

                      // EMAIL
                      SizedBox(
                        height: 56,
                        child: TextField(
                          controller: _emailController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: loginFont,
                            fontSize: 13,
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
                      ),
                      const SizedBox(
                        height: 17,
                      ),

                      // HO VA TEN
                      SizedBox(
                        height: 56,
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: loginBorder,
                            fontSize: 13,
                            fontFamily: loginTextFont,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Họ và tên',
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
                                color: loginFont,
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
                      ),
                      const SizedBox(
                        height: 17,
                      ),

                      // SDT
                      SizedBox(
                        height: 56,
                        child: TextField(
                          controller: _phoneController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: loginBorder,
                            fontSize: 13,
                            fontFamily: loginTextFont,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Số điện thoại',
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
                                color: loginFont,
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
                      ),
                      const SizedBox(
                        height: 17,
                      ),

                      // DIA CHI
                      SizedBox(
                        height: 56,
                        child: TextField(
                          controller: _addressController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: loginBorder,
                            fontSize: 13,
                            fontFamily: loginTextFont,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Địa chỉ',
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
                                color: loginFont,
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
                      ),
                      const SizedBox(
                        height: 17,
                      ),

                      //Mật Khẩu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 147,
                            height: 56,
                            child: TextField(
                              controller: _passController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: loginBorder,
                                fontSize: 13,
                                fontFamily: loginTextFont,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Mật khẩu',
                                hintText: 'Nhập mật khẩu',
                                hintStyle: TextStyle(
                                  color: loginFont,
                                  fontSize: 10,
                                  fontFamily: loginTextFont,
                                  fontWeight: FontWeight.w400,
                                ),
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
                          ),
                          SizedBox(
                            width: 147,
                            height: 56,
                            child: TextField(
                              controller: _repassController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: loginFont,
                                fontSize: 13,
                                fontFamily: loginTextFont,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Mật khẩu',
                                hintText: 'Xác nhận mật khẩu',
                                hintStyle: TextStyle(
                                  color: loginFont,
                                  fontSize: 10,
                                  fontFamily: loginTextFont,
                                  fontWeight: FontWeight.w400,
                                ),
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
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: SizedBox(
                          width: 329,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.changePage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: loginTheme,
                            ),
                            child: const Text(
                              'Tạo tài khoản',
                              style: TextStyle(
                                color: loginBackground,
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
                            ' có tài khoản?',
                            textAlign: TextAlign.center,
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
                              'Đăng nhập ',
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