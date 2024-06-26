import 'dart:convert';
import 'dart:typed_data';
import 'package:a3d/api/impl/product.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomDialog.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/AddProductScreen.dart';
import 'package:a3d/screens/UpdateProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:a3d/components/EmptyProduct.dart';
import 'package:a3d/components/ListSkeleton.dart';

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
      backgroundColor: BACKGROUND,
      appBar: AppBar(
        backgroundColor: BACKGROUND,
        toolbarHeight: 200,
        automaticallyImplyLeading: false,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: "Kelola Produk",
                textStyle:
                    TextStyle(color: BLACK, fontSize: BIG_TITLE_FONTSIZE,fontWeight: FontWeight.w500)),
                    SizedBox(height: 6,),
                    CustomText(
                text: "Kelola produk yang akan Anda jual disini.",
                textStyle:
                    TextStyle(color: SEMIBLACK, fontSize: BASE_FONTSIZE)),
                    SizedBox(height: 12,),
            TextField(
              style: TextStyle(color: BLACK),
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: BLACK.withOpacity(0.3)),
                labelStyle: TextStyle(color: BLACK),
                prefixIcon: Icon(Icons.search, color: BLACK),
                filled: true,
                fillColor: WHITE,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: isLoading
            ? ListSkeleton()
            : filteredProducts.isEmpty
                ? EmptyProduct()
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
          color: WHITE,
        ),
        elevation: 0,
        backgroundColor: PURPLE,
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    // Decode base64 image string
    Uint8List imageBytes = base64Decode(product.image!);

    return Container(
      height: 124,
      margin: EdgeInsets.only(bottom: 8),
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
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.price)}',
                    style: TextStyle(color: SEMIBLACK, fontSize: BASE_FONTSIZE),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration:BoxDecoration(
              color: BLUE,
              borderRadius: BorderRadius.circular(12)
            ) ,
            child: IconButton(
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
              color: WHITE,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 16),
            decoration:BoxDecoration(
              color: RED,
              borderRadius: BorderRadius.circular(12)
            ) ,
            child: IconButton(
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
                            backgroundColor: GREY,
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
              color: WHITE,
            ),
          )
        ],
      ),
    );
  }
}
