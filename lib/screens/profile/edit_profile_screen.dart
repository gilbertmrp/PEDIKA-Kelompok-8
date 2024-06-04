import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:violence_app/styles/color.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:violence_app/services/api_service.dart'; // Pastikan untuk mengimpor APIService
import '../../model/auth/login_request_model.dart';
import '../../provider/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _editProfile() async {
    setState(() {
      _isLoading = true;
    });

    // try {
    //   String image = _imageFile?.path ?? '';
    //   User user = await APIService().editProfilWithPost(
    //     _namaLengkapController.text,
    //     _emailController.text,
    //     _noTelpController.text,
    //     image,
    //   );
    //
    //   Provider.of<UserProvider>(context, listen: false).setUser(user);
    //
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Profil berhasil diperbarui')),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Gagal memperbarui profil: $e')),
    //   );
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    Widget profileImage = _imageFile != null
        ? CircleAvatar(
      radius: 90,
      backgroundImage: FileImage(_imageFile!),
    )
        : userProvider.user?.photo_profile != null
        ? CircleAvatar(
      radius: 90,
      backgroundImage: NetworkImage(userProvider.user!.photo_profile!),
    )
        : const CircleAvatar(
      radius: 90,
      child: Icon(Icons.person, size: 90),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Edit Akun",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-password');
            },
            child: const Text(
              "Ubah Password",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 15,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: profileImage,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nama Lengkap",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _namaLengkapController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: '${userProvider.user?.full_name}',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi tidak boleh kosong';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: '${userProvider.user?.email}',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi tidak boleh kosong';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Nomor Ponsel",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _noTelpController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: '${userProvider.user?.phone_number}',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi tidak boleh kosong';
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _editProfile,
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColor.primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: AppColor.primaryColor),
                            ),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text(
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
    );
  }
}
