import 'package:flutter/material.dart';
import 'package:survey/screens/display_dashboard/utils/color_display.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FieldGaugeChart extends StatelessWidget {
  final String headerText;
  final String annotationText;

  const FieldGaugeChart(
      {super.key,
      required this.headerText,
      required this.annotationText,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            headerText,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 150,
            child: annotationText.toLowerCase() == "nan"
                ? Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text("NA",style: TextStyle(fontSize: 55,color: Colors.grey.withOpacity(0.7)),),
                        Text("Not Applicable",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold))
                      ],
                    ),
                  )
                : SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 6,
                        startAngle: 180,
                        endAngle: 0,
                        showLabels: false,
                        showTicks: false,
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 0,
                            endValue: getFieldGaugeValue(annotationText),
                            color: getFieldGaugeColor(annotationText),
                            startWidth: 40,
                            endWidth: 40,
                          ),
                          GaugeRange(
                            startValue: getFieldGaugeValue(annotationText),
                            endValue: 6,
                            color: Colors.grey.withOpacity(0.3),
                            startWidth: 40,
                            endWidth: 40,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Column(
                              children: [
                                SizedBox(
                                  height: 80,
                                ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Cost => ",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        annotationText,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            angle: 90,
                            positionFactor: 0.1,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
