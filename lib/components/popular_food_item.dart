import 'package:flutter/material.dart';

class PopularFoodItem extends StatelessWidget {
  final Map<String, String> food;

  const PopularFoodItem({required this.food, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 36,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF313131),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Para Janta',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food["title"] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFFF9F9F9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: Color(0xFFEA641F),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          food["timer"] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.filter_drama_rounded,
                          size: 16,
                          color: Color(0xFFEA641F),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          food["level"] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 120,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                food["url"] ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
