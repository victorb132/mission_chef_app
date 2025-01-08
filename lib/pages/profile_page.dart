import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master_chef_app/controllers/auth_controller.dart';
import 'package:master_chef_app/utils/app_colors.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = Get.find<AuthController>();
  User? user;

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
      // Permite ao usuário escolher entre galeria ou câmera
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

  /// Permite escolher entre galeria ou câmera
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

  /// Faz upload da imagem para o Firebase Storage
  Future<String> _uploadImage(File file) async {
    try {
      String fileName = basename(file.path); // Nome do arquivo
      Reference storageRef = FirebaseStorage.instance.ref().child(
          'profile_pictures/${authController.user.value?.uid ?? ''}/$fileName');

      // Faz o upload do arquivo
      await storageRef.putFile(file);

      // Obtém a URL pública da imagem
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
    void showEditDialog(String field, String title, String currentValue) {
      final TextEditingController controller = TextEditingController();
      controller.text = currentValue;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Editar $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                updateUser(field, controller.text);
                Get.back();
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      );
    }

    return Obx(() {
      if (authController.isLogged.value == false) {
        Future.microtask(() => Get.offNamed('/login'));
        return const SizedBox();
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
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
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: user?.photoURL != null
                          ? Image.network(
                              user?.photoURL ?? '',
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 120,
                            ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          await updateProfilePicture();
                          Get.snackbar("Sucesso", "Foto de perfil atualizada!");
                        } catch (e) {
                          Get.snackbar("Erro", e.toString());
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: Text(
                    user?.displayName ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      showEditDialog(
                        "displayName",
                        "Nome",
                        user?.displayName ?? '',
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.white54),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.white),
                  title: Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      showEditDialog("email", "E-mail", user?.email ?? '');
                    },
                  ),
                ),
                const Divider(color: Colors.white54),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    authController.signOut();
                    Get.toNamed(
                      '/navigation',
                    ); // Redireciona para o login após logout
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
