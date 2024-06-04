import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:violence_app/screens/auth/login_screen.dart';
import 'package:violence_app/screens/auth/register_screen.dart';

import '../styles/color.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  _storeOnBoardingInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('onBoard', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/onboard_img.png', width: orientation == Orientation.portrait ? 200 : 300),
                    const SizedBox(height: 10,),
                    const Text("PedikaApp", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),),
                    const SizedBox(height: 20,),
                    const Text("Tangani Kekerasan Pada Perempuan dan Anak"),
                    const SizedBox(height: 20,),
                    const Text("Mulai Sekarang!"),
                    const SizedBox(height: 20,),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _storeOnBoardingInfo();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
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
                            'Daftar',
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
                    const SizedBox(height: 10,),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width, // Memperbaiki kesalahan pengetikan sizeOf menjadi of
                        height: 56,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: AppColor.primaryColor,
                            textStyle: TextStyle(fontSize: 16, color: AppColor.primaryColor),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            side: BorderSide(color: AppColor.primaryColor, width: 2), // Menambahkan border ungu
                          ),
                          onPressed: () async {
                            await _storeOnBoardingInfo();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: const Text('Masuk'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextButton(
                      child: Text(
                        "Panggilan Cepat",
                        style: TextStyle(fontSize: 17, color: AppColor.primaryColor),
                      ),
                      onPressed: () async {
                        const url = 'tel:081397739993';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
