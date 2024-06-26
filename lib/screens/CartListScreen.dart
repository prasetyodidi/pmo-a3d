import 'dart:convert';
import 'dart:typed_data';
import 'package:a3d/api/impl/product.dart';
import 'package:a3d/api/impl/sale.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/EmptyProduct.dart';
import 'package:a3d/components/ListSkeleton.dart';
import 'package:a3d/components/Snackbar.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/CheckoutScreen.dart';
import 'package:flutter/cupertino.dart';
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
      product.subtotal = product.quantity * product.price;
    });
    _updateCart();
  }

  void _decrementQuantity(ProductCart product) {
    if (product.quantity > 0) {
      setState(() {
        product.quantity--;
        product.subtotal = product.quantity * product.price;
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

  void _showCartSummary() {
    if(productsToCheckout.isEmpty) return showSuccessSnackbar(context, "Belum ada produk yang dipilih");
    showModalBottomSheet(
      backgroundColor: BACKGROUND,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: BACKGROUND, borderRadius: BorderRadius.circular(28)),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Produk yang akan dijual',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Jual produk dan pantau!',
                style: TextStyle(fontSize: 16, color: SEMIBLACK),
              ),
              SizedBox(height: 16),
              ...productsToCheckout.map((product) {
                Uint8List imageBytes = base64Decode(product.image!);

                return ListTile(
                  contentPadding: EdgeInsets.all(0),
                  textColor: BLACK,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  title: Text(product.name),
                  subtitle: Text(_formatCurrency(product.price)),
                  trailing: Text("${product.quantity}x"),
                );
              }).toList(),
              SizedBox(
                height: 16,
              ),
              _LeftRightText(
                "Total Penjualan",
                _formatCurrency(productsToCheckout.fold(
                    0, (sum, product) => sum + product.subtotal)),
              ),
              SizedBox(
                height: 32,
              ),
              CustomButton(
                text: isLoading ? "..." : "Checkout",
                onPressed: () {
                  if(isLoading) return;
                  setState(() {
                    isLoading = true;
                  });
                  List<Map<String, String>> products = [];
                  for (ProductCart element in productsToCheckout) {
                    products.add({
                      "product_id": element.id.toString(),
                      "qty": element.quantity.toString()
                    });
                  }

                  processCreateSale(context, products, getToday())
                      .then((onValue) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String getToday() {
    DateTime today = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(today);
  }

  Widget _LeftRightText(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            color: SEMIBLACK,
            fontSize: BASE_FONTSIZE,
          ),
        ),
        Text(
          right,
          style: TextStyle(
            color: BLACK,
            fontSize: BASE_FONTSIZE,
          ),
        ),
      ],
    );
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
                  text: "Jual Produk",
                  textStyle: TextStyle(
                      color: BLACK,
                      fontSize: BIG_TITLE_FONTSIZE,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 6,
              ),
              CustomText(
                  text: "Pilih produk yang akan terjual dan checkout.",
                  textStyle:
                      TextStyle(color: SEMIBLACK, fontSize: BASE_FONTSIZE)),
              SizedBox(
                height: 12,
              ),
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
        floatingActionButton: Stack(
          alignment: Alignment.topRight,
          children: [
            FloatingActionButton(
              child: Icon(
                CupertinoIcons.cart,
                color: Colors.white,
              ),
              onPressed: _showCartSummary,
              elevation: 0,
              backgroundColor:
                  PURPLE, // Ganti dengan PURPLE2 jika sudah didefinisikan
            ),
            if (productsToCheckout.length > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: RED,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${productsToCheckout.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ));
  }

  Widget _buildProductCard(ProductCart product) {
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
                    style: TextStyle(color: BLACK, fontSize: 18),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatCurrency(product.price),
                        style: TextStyle(
                          color: SEMIBLACK,
                          fontSize: BASE_FONTSIZE,
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: BACKGROUND,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => _decrementQuantity(product),
                                icon: Icon(Icons.remove),
                                color: RED,
                              ),
                              Text(product.quantity.toString(),
                                  style: TextStyle(
                                      fontSize: BASE_FONTSIZE, color: BLACK)),
                              IconButton(
                                onPressed: () => _incrementQuantity(product),
                                icon: Icon(Icons.add),
                                color: PURPLE2,
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int number) {
    return 'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(number)}';
  }
}
