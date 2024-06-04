import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/internet_provider.dart';
import '../../provider/user_provider.dart';
import '../../styles/color.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/snack_bar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _newConfirmPassword = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isApiCallProcess = false;
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final internetProvider = Provider.of<InternetProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.5,
            decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
            ),
          ),
          if (isApiCallProcess)
            const Center(
              child: CircularProgressIndicator(),
            ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("PedikaApp", style: TextStyle(
                      color: AppColor.descColor,
                      fontSize: 30,
                      fontFamily: 'Poppins',
                    ),),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          const Text("Lupa Kata Sandi", style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),),
                          const SizedBox(height: 10,),
                          Text("Silahkan Ganti Kata Sandi Anda!", style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Alamat Email',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF9F7BFF),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Silakan masukkan email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _newPassword,
                            obscureText: !_isPasswordVisible,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Kata Sandi',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF9F7BFF),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: const Color(0xFF837E93),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Silakan masukkan password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _newConfirmPassword,
                            obscureText: !_isConfirmPasswordVisible,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi Kata Sandi',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF9F7BFF),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: const Color(0xFF837E93),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Silakan masukkan konfirmasi password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if(!internetProvider.hasInternet) {
                                    openSnackBar(context, "Tidak ada koneksi internet", Colors.red);
                                  }else {
                                    if(validateAndSave()) {
                                      try {
                                        showLoadingAnimated(context);
                                      } catch (e) {
                                        openSnackBar(context, e.toString(), Colors.red);
                                      } finally {
                                        closeLoadingDialog(context);
                                      }
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(color: AppColor.primaryColor)
                                        )
                                    )
                                ),
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }
}
