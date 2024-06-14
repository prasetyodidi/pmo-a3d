import 'package:flutter/material.dart';
import 'package:a3d/constants/index.dart';
class EmptyProduct extends StatelessWidget {
  const EmptyProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 100,
            color: Colors.grey[200],
          ),
          SizedBox(height: 12),
          Text(
            'Produk tidak ditemukan',
            style: TextStyle(
              fontSize: BASE_FONTSIZE,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}