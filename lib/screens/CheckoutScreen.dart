import 'dart:convert';
import 'dart:typed_data';

import 'package:a3d/api/impl/product.dart';
import 'package:a3d/api/impl/sale.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/ListSkeleton.dart';
import 'package:a3d/constants/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({super.key, required this.productsToCheckout});
  List<ProductCart> productsToCheckout;
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String formattedToday = '';
  late double totalShoppingAmount = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    // Formatting today's date
    DateTime today = DateTime.now();
    formattedToday = DateFormat('yyyy-MM-dd').format(today);

    // Calculating the total shopping amount
    totalShoppingAmount = widget.productsToCheckout.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Block the back button press
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "Pesanan Baru",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: GREY,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: ListSkeleton(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              color: BLACK,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy')
                                  .format(DateTime.parse(formattedToday)),
                              style: TextStyle(
                                  fontSize: TITLE_FONTSIZE,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.app_badge,
                              color: BLACK,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Rangkuman",
                              style: TextStyle(
                                  fontSize: TITLE_FONTSIZE,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        _summarize("Total Produk",
                            widget.productsToCheckout.length.toString()),
                        _summarize("Total",
                            _formatCurrency(totalShoppingAmount.toInt())),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.list_bullet_below_rectangle,
                              color: BLACK,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Produk Terjual",
                              style: TextStyle(
                                  fontSize: TITLE_FONTSIZE,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.productsToCheckout.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildProductCard(
                            widget.productsToCheckout[index]);
                      },
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                color: Colors.grey.shade100,
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        List<Map<String, String>> products = [];
                        for (ProductCart element in widget.productsToCheckout) {
                          products.add({
                            "product_id": element.id.toString(),
                            "qty": element.quantity.toString()
                          });
                        }

                        processCreateSale(context, products, formattedToday)
                            .then((onValue) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      text: "Buat Pesanan",
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "Batalkan Pesanan",
                      backgroundColor: Colors.red,
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProductCard(ProductCart product) {
    Uint8List imageBytes = base64Decode(product.image!);

    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.2,
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
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.price)} x ${product.quantity.toString()}',
                    style: TextStyle(color: BLACK, fontSize: BASE_FONTSIZE),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.subtotal)}",
            style: TextStyle(
                fontSize: BASE_FONTSIZE,
                color: BLACK,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _LeftRightText(String left, String right, TextStyle? rightStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            color: BLACK,
            fontSize: BASE_FONTSIZE,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          right,
          style: rightStyle ??
              TextStyle(
                color: BLACK,
                fontSize: BASE_FONTSIZE,
              ),
        ),
      ],
    );
  }

  String _formatCurrency(int number) {
    return 'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(number)}';
  }

  Widget _summarize(String title, String description) {
    return Container(
      padding: const EdgeInsets.only(left: 28.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title),
          Text(
            description,
            style: TextStyle(fontSize: BASE_FONTSIZE),
          )
        ],
      ),
    );
  }
}
