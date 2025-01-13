import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mission_chef_app/controllers/auth_controller.dart';
import 'package:mission_chef_app/utils/app_colors.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = Get.find<AuthController>();
  User? user;
  bool signingOut = false;

  void getUser() async {
    final response = FirebaseAuth.instance.currentUser;
    setState(() {
      user = response;
    });
  }

  void updateUser(String field, String value) async {
    await authController.updateUser(field, value);
    getUser();
  }

  Future<void> updateProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: await _getImageSource(),
        imageQuality: 80,
      );

      if (pickedFile == null) {
        throw Exception("Nenhuma imagem selecionada");
      }

      String photoURL = await _uploadImage(File(pickedFile.path));

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePhotoURL(photoURL);
        await user.reload();
      }
    } catch (e) {
      throw Exception("Erro ao atualizar a foto de perfil: $e");
    }
  }

  Future<ImageSource> _getImageSource() async {
    return await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("Escolha uma opção"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text("Câmera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text("Galeria"),
          ),
        ],
      ),
    );
  }

  Future<String> _uploadImage(File file) async {
    try {
      String fileName = basename(file.path);
      Reference storageRef = FirebaseStorage.instance.ref().child(
          'profile_pictures/${authController.user.value?.uid ?? ''}/$fileName');

      await storageRef.putFile(file);

      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception("Erro ao fazer upload da imagem: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLogged.value == false && signingOut == false) {
        Future.microtask(() => Get.offNamed('/login'));
        return const SizedBox.shrink();
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            "Perfil",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 30,
                  top: 20,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: ClipOval(
                            child: user?.photoURL != null
                                ? Image.network(
                                    user?.photoURL ?? '',
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: -15,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                              onPressed: () async {
                                try {
                                  await updateProfilePicture();
                                  Get.snackbar(
                                    "Sucesso",
                                    "Foto de perfil atualizada!",
                                  );
                                } catch (e) {
                                  Get.snackbar(
                                    "Erro",
                                    e.toString(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user?.displayName ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  authController.signOut();
                  setState(() {
                    signingOut = true;
                  });
                },
                child: const Text(
                  'Sair',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
