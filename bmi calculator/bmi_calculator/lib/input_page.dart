import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constant_file.dart';
import 'reuseable_card_widgets.dart';
import 'icon_column.dart';
import 'result_page.dart';
import 'bottom_button.dart';

enum Gender { male, female }

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputPage> {
  Gender? selectedGender;
  int height = 180;
  int weight = 60;
  int age = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI CALCULATOR')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReuseableContainer(
                    onPress: () => setState(() => selectedGender = Gender.male),
                    colorr: selectedGender == Gender.male
                        ? kactiveColor
                        : kinactiveColor,
                    cardWidget: const IconColumn(
                      icon: Icons.male,
                      label: 'Male',
                    ),
                  ),
                ),
                Expanded(
                  child: ReuseableContainer(
                    onPress: () => setState(() => selectedGender = Gender.female),
                    colorr: selectedGender == Gender.female
                        ? kactiveColor
                        : kinactiveColor,
                    cardWidget: const IconColumn(
                      icon: Icons.female,
                      label: 'Female',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReuseableContainer(
              colorr: kactiveColor,
              cardWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Height', style: kLabelStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(height.toString(), style: kNumberStyle),
                      const Text('cm', style: kLabelStyle),
                    ],
                  ),
                  Slider(
                    value: height.toDouble(),
                    min: 120,
                    max: 220,
                    activeColor: Colors.yellowAccent,
                    inactiveColor: Colors.lightGreenAccent,
                    onChanged: (v) => setState(() => height = v.round()),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReuseableContainer(
                    colorr: kactiveColor,
                    cardWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Weight', style: kLabelStyle),
                        Text(weight.toString(), style: kNumberStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () => setState(() => weight++),
                            ),
                            const SizedBox(width: 10.0),
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () => setState(() => weight--),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReuseableContainer(
                    colorr: kactiveColor,
                    cardWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Age', style: kLabelStyle),
                        Text(age.toString(), style: kNumberStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () => setState(() => age++),
                            ),
                            const SizedBox(width: 10.0),
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () => setState(() => age--),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomButton(
            buttonTitle: 'CALCULATE',
            onTap: () {
              final bmi = weight / ((height / 100) * (height / 100));
              final bmiString = bmi.toStringAsFixed(1);

              String resultText;
              String interpretation;

              if (bmi >= 25) {
                resultText = 'Overweight';
                interpretation = 'Try to exercise more.';
              } else if (bmi >= 18.5) {
                resultText = 'Normal';
                interpretation = 'Great job! Keep it up.';
              } else {
                resultText = 'Underweight';
                interpretation = 'You might need to eat a bit more.';
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultPage(
                    bmiResult: bmiString,
                    resultText: resultText,
                    interpretation: interpretation,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(width: 45, height: 45),
      fillColor: kBottomContainerColour,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Icon(icon),
    );
  }
}
