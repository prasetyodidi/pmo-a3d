import 'package:a3d/api/impl/sale.dart';
import 'package:a3d/components/Chart.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/ListSkeleton.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/PreviewSaleScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistorySaleScreen extends StatefulWidget {
  const HistorySaleScreen({Key? key}) : super(key: key);

  @override
  State<HistorySaleScreen> createState() => _HistorySaleScreenState();
}

class _HistorySaleScreenState extends State<HistorySaleScreen> {
  List<Map<String, dynamic>> chartDatas = [];
  List<Map<String, dynamic>> sales = [];
  bool isLoading = true;

  @override
  void initState() {
    getChart(context).then((val) {
      if (mounted) {
        setState(() {
          chartDatas = val;
        });
        getAllSale(context).then((salesResponse) {
          if (mounted) {
            setState(() {
              sales = salesResponse;
              isLoading = false;
            });
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      body: Scaffold(
        backgroundColor: BACKGROUND,
        body: Padding(
          padding: EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isLoading
                  ? SkeletonItem()
                  : Chart(
                      chartDatas: chartDatas,
                    ),
              Expanded(
                child: isLoading
                    ? SkeletonItem()
                    : ListView.builder(
                        itemCount: sales.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreviewSaleScreen(
                                    sale_id: sales[index]['id'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              margin: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(color: WHITE, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sales[index]['date'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${sales[index]['line_ids'].length} Produk",
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _formatCurrency(sales[index]['total']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int number) {
    return 'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(number)}';
  }
}
