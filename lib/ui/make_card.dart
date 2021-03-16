import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:vacinas_covid/model/vacinas_dssg.dart';
import 'package:vacinas_covid/defaults.dart';
import 'package:vacinas_covid/ui/chart.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';


class MakeCard extends StatelessWidget {
  final int id;
  final String title;
  final String field_type;
  final int display_number;
  final List<VaccinesDSSG> vacinas;

  const MakeCard({
    Key key,
    @required this.id, this.title, this.field_type, this.display_number, this.vacinas
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: PopupChart(id: id, title: title, field_type: field_type, vacinas: vacinas), //creates popup for the chart
            ),
          ),
        );
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        tag: id,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Material(
            elevation: 20,
            color: AppDefaults.popupColor,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Countup(
                    begin: 0,
                    end: display_number.toDouble(),
                    duration: Duration(seconds: 1),
                    separator: '.',
                    style: TextStyle(
                      fontSize: 50
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5C5C5C)),),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class PopupChart extends StatelessWidget {

  final int id;
  final String title;
  final String field_type;
  final List<VaccinesDSSG> vacinas;

  const PopupChart({
    Key key,
    @required this.id, this.title, this.field_type, this.vacinas
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: id,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin, end: end);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: AppDefaults.popupColor,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: LineChartWidget(id: id, title: title, field_type: field_type, vacinas: vacinas), //draw chart
              ),
            ),
          ),
        ),
      ),
    );
  }
}

