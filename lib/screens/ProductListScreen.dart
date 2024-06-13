import 'dart:convert';
import 'dart:typed_data';
import 'package:a3d/api/impl/product.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomDialog.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/AddProductScreen.dart';
import 'package:a3d/screens/UpdateProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch products from API when screen initializes
    _getProducts();
  }

  void _getProducts() {
    getAllProduct(context).then((val) {
      setState(() {
        products = val;
        filteredProducts = List.from(
            products); // Initialize filteredProducts with all products initially
        isLoading = false;
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
      appBar: AppBar(
        backgroundColor: WHITE,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: TextField(
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: isLoading
            ? _buildSkeletonLoader()
            : filteredProducts.isEmpty
                ? _buildEmptyProducts()
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildProductCard(filteredProducts[index]);
                    },
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
    // Decode base64 image string
    Uint8List imageBytes = base64Decode(product.image!);

    return Container(
      height: 124,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 3,
                    style: TextStyle(
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.price)}',
                    style: TextStyle(color: BLACK, fontSize: BASE_FONTSIZE),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => UpdateProductScreen(
                          id: product.id,
                          image: product.image!,
                          name: product.name,
                          price: product.price.toString())));
            },
            icon: Icon(Icons.edit_outlined),
            color: Colors.blue,
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    title: 'ALERT',
                    content: 'Apakah anda yakin akan menghapus produk ini?',
                    actions: [
                      CustomButton(
                          text: "Hapus",
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            // Navigator.pop(context);
                            processDeleteProduct(context, product.id)
                                .then((onValue) {
                              _getProducts();
                            });
                          })
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
          )
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 124,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
                  margin: EdgeInsets.all(4),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyProducts() {
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
