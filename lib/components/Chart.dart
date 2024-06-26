import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:a3d/constants/index.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key, required this.chartDatas}) : super(key: key);
  final List<Map<String, dynamic>> chartDatas;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late double minX;
  late double maxX;

  @override
  void initState() {
    super.initState();
    minX = 0;
    maxX = widget.chartDatas.length.toDouble() - 1;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return widget.chartDatas.isEmpty
        ? SizedBox()
        : Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: AspectRatio(
              aspectRatio: 2.0,
              child: Listener(
                onPointerSignal: (signal) {
                  if (signal is PointerScrollEvent) {
                    setState(() {
                      if (signal.scrollDelta.dy.isNegative) {
                        minX += maxX * 0.05;
                        maxX -= maxX * 0.05;
                      } else {
                        minX -= maxX * 0.05;
                        maxX += maxX * 0.05;
                      }
                    });
                  }
                },
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      minX = 0;
                      maxX = widget.chartDatas.length.toDouble() - 1;
                    });
                  },
                  onHorizontalDragUpdate: (dragUpdDet) {
                    setState(() {
                      double primDelta = dragUpdDet.primaryDelta ?? 0.0;
                      if (primDelta != 0) {
                        if (primDelta.isNegative) {
                          minX += maxX * 0.005;
                          maxX += maxX * 0.005;
                        } else {
                          minX -= maxX * 0.005;
                          maxX -= maxX * 0.005;
                        }
                      }
                    });
                  },
                  child: LineChart(
                    LineChartData(
                      // gridData: FlGridData(horizontalInterval: 1),
                      minX: minX,
                      maxX: maxX,
                      maxY: maxY,
                      minY: 0,
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((touchedSpot) {
                              return LineTooltipItem(
                                'Date: ${widget.chartDatas[touchedSpot.spotIndex]['date']}\nTotal: ${_formatCurrency(widget.chartDatas[touchedSpot.spotIndex]['total'])}',
                                const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: widget.chartDatas.length > 10
                                ? (widget.chartDatas.length / 10).ceilToDouble()
                                : 1,
                            getTitlesWidget: bottomTitleWidgets,
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            getTitlesWidget: leftTitleWidgets,
                            showTitles: true,
                            interval: intervalY,
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: SEMIBLACK, width: 4),
                          left: const BorderSide(color: Colors.transparent),
                          right: const BorderSide(color: Colors.transparent),
                          top: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                      lineBarsData: lineBarsData1,
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  double get maxY => widget.chartDatas.isEmpty
      ? 1
      : (widget.chartDatas
                  .map((s) => s['total'] as int)
                  .reduce((a, b) => a > b ? a : b) /
              1000)
          .ceilToDouble();
  double get intervalY =>
      maxY / 4; // Adjusting interval to have 4 intervals on Y axis

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        preventCurveOverShooting: true,
        gradient: LinearGradient(colors: [
          BLACK,
          PURPLE,
          RED,
          PURPLE2
        ]),
        barWidth: 3,
        dotData: const FlDotData(show: true, ),
        belowBarData: BarAreaData(show: true, color: SEMIBLACK.withOpacity(0.2)),
        spots: List.generate(widget.chartDatas.length, (index) {
          return FlSpot(index.toDouble(),
              (widget.chartDatas[index]['total'] / 1000).toDouble());
        }),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    String text = '${value.toInt()}k';

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    String text;
    if (value.toInt() >= 0 && value.toInt() < widget.chartDatas.length) {
      text = widget.chartDatas[value.toInt()]['date'];
    } else {
      text = '';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  String _formatCurrency(int number) {
    return 'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(number)}';
  }
}
