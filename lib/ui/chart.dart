import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vacinas_covid/model/vacinas_dssg.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
    show: true,
    bottomTitles: SideTitles(
      showTitles: false,
    ),
    leftTitles: SideTitles(
      showTitles: false,
    ),
  );
}

class LineChartWidget extends StatelessWidget {

  final int id;
  final String title;
  final String field_type;
  final List<VaccinesDSSG> vacinas;

  LineChartWidget({
    Key key,
    @required this.id, this.title, this.field_type, this.vacinas
  }) : super(key: key);

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {

    List<VaccinesDSSG> copy_vacinas = List.from(vacinas);

    double maxY = 0;
    double maxX = vacinas.length.toDouble();

    List<FlSpot> chart_values_list = [];
    var dates_list = [];

    switch (field_type) {
      case 'doses':
        copy_vacinas.sort((a, b) => a.doses.compareTo(b.doses));
        maxY = copy_vacinas.last.doses.toDouble();

        for (var i = 0; i < vacinas.length; i++) {
          chart_values_list.add(FlSpot(i.toDouble() + 1, vacinas[i].doses.toDouble()));
          dates_list.add(vacinas[i].data);
        }
        break;
      case 'doses_novas':
        copy_vacinas.sort((a, b) => a.doses_novas.compareTo(b.doses_novas));
        maxY = copy_vacinas.last.doses_novas.toDouble();

        for (var i = 0; i < vacinas.length; i++) {
          chart_values_list.add(FlSpot(i.toDouble() + 1, vacinas[i].doses_novas.toDouble()));
          dates_list.add(vacinas[i].data);
        }
        break;
      case 'doses1':
        copy_vacinas.sort((a, b) => a.doses1.compareTo(b.doses1));
        maxY = copy_vacinas.last.doses1.toDouble();

        for (var i = 0; i < vacinas.length; i++) {
          chart_values_list.add(FlSpot(i.toDouble() + 1, vacinas[i].doses1.toDouble()));
          dates_list.add(vacinas[i].data);
        }
        break;
      case 'doses1_novas':
        copy_vacinas.sort((a, b) => a.doses1_novas.compareTo(b.doses1_novas));
        maxY = copy_vacinas.last.doses1_novas.toDouble();

        for (var i = 0; i < vacinas.length; i++) {
          chart_values_list.add(FlSpot(i.toDouble() + 1, vacinas[i].doses1_novas.toDouble()));
          dates_list.add(vacinas[i].data);
        }
        break;
      case 'doses2':
        copy_vacinas.sort((a, b) => a.doses2.compareTo(b.doses2));
        maxY = copy_vacinas.last.doses2.toDouble();

        for (var i = 0; i < vacinas.length; i++) {
          chart_values_list.add(FlSpot(i.toDouble() + 1, vacinas[i].doses2.toDouble()));
          dates_list.add(vacinas[i].data);
        }
        break;
      case 'doses2_novas':
        copy_vacinas.sort((a, b) => a.doses2_novas.compareTo(b.doses2_novas));
        maxY = copy_vacinas.last.doses2_novas.toDouble();

        for (var i = 0; i < vacinas.length; i++) {
          chart_values_list.add(FlSpot(i.toDouble() + 1, vacinas[i].doses2_novas.toDouble()));
          dates_list.add(vacinas[i].data);
        }
        break;
    }

    maxY += 30; // to add some extra space on top

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: maxY,
        titlesData: LineTitles.getTitleData(),
        gridData: FlGridData(
          show: false
        ),
        borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: chart_values_list,
            isCurved: true,
            colors: gradientColors,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ],
          lineTouchData: LineTouchData(
              getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((spotIndex) {
                  return TouchedSpotIndicatorData(
                    FlLine(color: Colors.blue, strokeWidth: 2),
                    FlDotData(
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 4,
                            strokeColor: Colors.deepOrange);
                      },
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final flSpot = barSpot;
                      return LineTooltipItem(
                        '${dates_list[flSpot.x.toInt()-1]}\n${flSpot.y.toInt()}', //get respective date to show in the tooltip
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  }),
              ),
      ),
    );
  }
}