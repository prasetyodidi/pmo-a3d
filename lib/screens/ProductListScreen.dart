import 'dart:convert';
import 'dart:typed_data';
import 'package:a3d/api/impl/product.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/AddProductScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    // Fetch products from API when screen initializes
    getAllProduct(context).then((val) {
      setState(() {
        products = val;
        filteredProducts = List.from(products);
      });
    });
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: BLACK),
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: BLACK.withOpacity(0.3)),
                labelStyle: TextStyle(color: BLACK),
                prefixIcon: Icon(Icons.search, color: BLACK),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none, // No border
                ),
              ),
            ),
            SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildProductCard(filteredProducts[index]);
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddProductScreen when the FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => AddProductScreen()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    Uint8List imageBytes = base64Decode(product.image!);

    final TextEditingController _controllerTotal = TextEditingController();
    int total = 0;    
    return Container(
      height: 124,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(product.price)}',
                    style: TextStyle(color: BLACK, fontSize: BASE_FONTSIZE),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.remove_circle_outline, size: 24, color: Colors.black),
              SizedBox(
                width: 24,
                child: TextField(
                  controller: _controllerTotal,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    border: OutlineInputBorder(),
                    hintText: 'Enter number',
                  ),
                  style: TextStyle(fontSize: 14.0), 
                ),
              ),
              Icon(Icons.add_circle_outline, size: 24, color: Colors.black),
            ],
          )
        ],
      ),
    );
  }
}
