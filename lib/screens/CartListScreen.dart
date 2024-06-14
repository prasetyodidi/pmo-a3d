import 'dart:convert';
import 'dart:typed_data';
import 'package:a3d/api/impl/product.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/EmptyProduct.dart';
import 'package:a3d/components/ListSkeleton.dart';
import 'package:a3d/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  List<ProductCart> products = [];
  List<ProductCart> filteredProducts = [];
  List<ProductCart> productsToCheckout = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartProducts');

    _getProducts();
  }

  void _getProducts() {
    getAllProduct(context).then((val) async {
      setState(() {
        products = val
            .map((p) => ProductCart(
                id: p.id,
                name: p.name,
                price: p.price,
                image: p.image!,
                quantity: 0))
            .toList();
        filteredProducts = List.from(products);
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

  void _incrementQuantity(ProductCart product) {
    setState(() {
      if (!productsToCheckout.contains(product)) {
        productsToCheckout.add(product);
      }
      product.quantity++;
    });
    _updateCart();
  }

  void _decrementQuantity(ProductCart product) {
    if (product.quantity > 0) {
      setState(() {
        product.quantity--;
        if (product.quantity == 0) {
          productsToCheckout.remove(product);
        }
      });
      _updateCart();
    }
  }

  void _updateCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartProducts', json.encode(products));
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
              borderSide: BorderSide.none,
            ),
          ),
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
      bottomNavigationBar: productsToCheckout.length > 0
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                onPressed: () {},
                text: "Checkout",
              ),
            )
          : SizedBox(),
    );
  }

  Widget _buildProductCard(ProductCart product) {
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
            onPressed: () => _decrementQuantity(product),
            icon: Icon(Icons.remove_circle_outline),
            color: Colors.red,
          ),
          Text(product.quantity.toString(),
              style: TextStyle(fontSize: BASE_FONTSIZE, color: BLACK)),
          IconButton(
            onPressed: () => _incrementQuantity(product),
            icon: Icon(Icons.add_circle_outline),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
