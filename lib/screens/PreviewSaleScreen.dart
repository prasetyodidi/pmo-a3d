import 'dart:convert';
import 'dart:typed_data';

import 'package:a3d/api/impl/product.dart';
import 'package:a3d/api/impl/sale.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/ListSkeleton.dart';
import 'package:a3d/components/Navbar.dart';
import 'package:a3d/constants/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreviewSaleScreen extends StatefulWidget {
  PreviewSaleScreen({super.key, required this.sale_id});
  int sale_id;
  @override
  State<PreviewSaleScreen> createState() => _PreviewSaleScreenState();
}

class _PreviewSaleScreenState extends State<PreviewSaleScreen> {
  bool isLoading = true;
  late Sale sale = Sale(
      date: "",
      id: 0,
      line_ids: [],
      total: 0); // Assuming Sale has a default constructor

  @override
  void initState() {
    getSale();
    super.initState();
  }

  void getSale() async {
    processGetSaleById(context, widget.sale_id).then((val) {
      setState(() {
        sale = val;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: BACKGROUND,
          automaticallyImplyLeading: false,
          title: Text(
            "Detail Penjualan",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: GREY,
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => Navbar(
                            initialIndex: 1,
                          )));
            },
            child: Icon(Icons.chevron_left, color: GREY, size: 35),
          ),
        ),
        backgroundColor: BACKGROUND,
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
                                  .format(DateTime.parse(sale.date)),
                              style: TextStyle(
                                fontSize: TITLE_FONTSIZE,
                              ),
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
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sale.line_ids.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildProductCard(sale.line_ids[index]);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _LeftRightText(
                      "Total Penjualan",
                      _formatCurrency(sale.line_ids
                          .fold(0, (sum, product) => sum + product.subtotal)),
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
            : Padding(
                padding: EdgeInsets.all(20),
                child: CustomButton(
                  onPressed: () {
                    print("hahaha");
                    setState(() {
                      isLoading = true;
                    });
                    downloadPDF(context, sale.id).then((onValue) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  text: "Download PDF",
                ),
              ),
      ),
    );
  }

  Widget _buildProductCard(ProductCart product) {
    Uint8List imageBytes = base64Decode(product.image!);

    return Container(
      height: 120,
      padding: EdgeInsets.only(right: 20),
      margin: EdgeInsets.only(bottom: 8, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: WHITE,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 3,
                    style: TextStyle(
                      color: BLACK,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatCurrency(product.subtotal),
                    style: TextStyle(color: SEMIBLACK, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "${product.quantity}x",
            style: TextStyle(
              fontSize: 16,
              color: SEMIBLACK,
            ),
          ),
        ],
      ),
    );
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
