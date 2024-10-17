import 'package:flutter/material.dart';
import 'package:survey/screens/display_dashboard/utils/color_display.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TrustScoreGaugeChart extends StatelessWidget {
  final double gaugeValue;

  const TrustScoreGaugeChart({super.key, required this.gaugeValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                startAngle: 180,
                endAngle: 0,
                showLabels: false,
                showTicks: false,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: gaugeValue,
                    color: gaugeDisplay(trustScore: gaugeValue),
                    startWidth: 50,
                    endWidth: 50,
                  ),
                  GaugeRange(
                    startValue: gaugeValue,
                    endValue: 100,
                    color: Colors.grey,
                    startWidth: 50,
                    endWidth: 50,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      "$gaugeValue %",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.1,
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 95,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Trust In Data Score : ",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      trustScoreDescription(trustScore: gaugeValue),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: gaugeDisplay(trustScore: gaugeValue) ),
                    ),
                  ],
                ),

              ],
            ),
          )
        ],
      ),
    );
  }


}

