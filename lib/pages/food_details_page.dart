import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:master_chef_app/utils/app_colors.dart';

class FoodDetailsPage extends StatefulWidget {
  const FoodDetailsPage({super.key});

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int _selectedIndex = 0;

  final food = Get.arguments as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 24,
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
            ],
          ),
          _buildBottomSheet(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              food['url'],
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              food['isFavorite'] = !food['isFavorite'];
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: food['isFavorite']
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 30,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 30,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.67,
      minChildSize: 0.67,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFECECEC),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(64),
              topRight: Radius.circular(64),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Text(
                        food['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoColumn(
                            Icons.timer_outlined,
                            'Preparo',
                            food['timer'],
                          ),
                          _buildInfoColumn(
                            Icons.star_border,
                            'Dificuldade',
                            food['level'],
                          ),
                          _buildInfoColumn(
                            Icons.filter_drama_rounded,
                            'Receitas',
                            food['level'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/timer');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: AppColors.accent,
                        ),
                        child: const Text(
                          'Timer',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSelectionRow(),
                      const SizedBox(height: 16),
                      _buildContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: const Color(0xFFEA641F),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFA6A6A6),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionRow() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSelectionButton("Instruções", 0),
          _buildSelectionButton("Ingredientes", 1),
        ],
      ),
    );
  }

  Widget _buildSelectionButton(String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final List<String> data =
        _selectedIndex == 0 ? food['instructions'] : food['ingredients'];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            data[index],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
