import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeChart extends StatelessWidget {
  const GaugeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SfRadialGauge(
        title: const GaugeTitle(
          text: 'Overall Income Validation Score',
          textStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 146,
            startAngle: 180,
            endAngle: 0,
            showLabels: false,
            radiusFactor: 0.8,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 20,
                color: Colors.red,
                startWidth: 70,
                endWidth: 70,
              ),
              GaugeRange(
                startValue: 21,
                endValue: 41,
                color: const Color(0xFFf6b092),
                startWidth: 70,
                endWidth: 70,
              ),
              GaugeRange(
                startValue: 42,
                endValue: 62,
                color: const Color(0xFFFFDAB9),
                startWidth: 70,
                endWidth: 70,
              ),
              GaugeRange(
                startValue: 63,
                endValue: 83,
                color: const Color(0xFFcefad0),
                startWidth: 70,
                endWidth: 70,
              ),
              GaugeRange(
                startValue: 84,
                endValue: 104,
                color: const Color(0xFF98FB98),
                startWidth: 70,
                endWidth: 70,
              ),
              GaugeRange(
                startValue: 105,
                endValue: 125,
                color: Colors.green,
                startWidth: 70,
                endWidth: 70,
              ),
              GaugeRange(
                startValue: 126,
                endValue: 146,
                color: const Color(0xFF006400),
                startWidth: 70,
                endWidth: 70,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: 90,
                needleColor: Colors.black,
                lengthUnit: GaugeSizeUnit.factor,
                knobStyle: KnobStyle(knobRadius: 0),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: const Text(
                  'Very High',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                angle: 80,
                positionFactor: 0.2,
                //positionFactor: 0.5,
              )
            ],
          ),
        ],
      ),
    );
  }
}
