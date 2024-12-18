import 'package:flutter/material.dart';
import 'package:master_chef_app/utils/app_colors.dart';

class FoodDetailsPage extends StatefulWidget {
  const FoodDetailsPage({super.key});

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int _selectedIndex = 0;

  final List<String> ingredients = [
    "2 xícaras de arroz",
    "1 colher de sopa de óleo",
    "1 colher de chá de sal",
    "3 xícaras de água"
  ];

  final List<String> instructions = [
    "Lave o arroz.",
    "Aqueça o óleo em uma panela.",
    "Adicione o arroz e refogue por 2 minutos.",
    "Adicione a água e o sal, e cozinhe até secar."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
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
          _buildFakeBottomSheet(context),
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
            Navigator.pop(context);
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
              'https://www.sidechef.com/recipe/6df5d24c-24a1-417a-b317-f83d949447fc.jpg?d=1408x1120',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildFakeBottomSheet(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFECECEC), // Cor do "bottom sheet"
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(64),
            topRight: Radius.circular(64),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 32),
              const Text(
                "Ratatouille",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 24,
                        color: Color(0xFFEA641F),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '30 Min',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Preparo',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.star_border,
                        size: 24,
                        color: Color(0xFFEA641F),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Nível fácil',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Dificuldade',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.filter_drama_rounded,
                        size: 24,
                        color: Color(0xFFEA641F),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Nível Fácil',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Receitas',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 16),
              _buildSelectionRow(),
              const SizedBox(height: 16),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
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
    final List<String> data = _selectedIndex == 0 ? instructions : ingredients;

    return ListView.builder(
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
