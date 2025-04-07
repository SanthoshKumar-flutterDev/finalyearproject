import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfoliobuilder/formpage/personal_section.dart';
import 'package:portfoliobuilder/formpage/project_section.dart';
import 'package:portfoliobuilder/formpage/skillsection_form.dart';

class StepperForm extends StatefulWidget {
  const StepperForm({super.key});

  @override
  State<StepperForm> createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  int _activeStepIndex = 0;

  List<Step> stepList() => [
    Step(
      title: Text("Personal"),
      content: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0XFF2A3670), // Change this color 🎨
            borderRadius: BorderRadius.circular(0),
          ),
          child: PersonalSection()),
      isActive: _activeStepIndex >= 0,
    ),
    Step(
      title: Text("Skills"),
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0XFF2A3670), // Change this color 🎨
          borderRadius: BorderRadius.circular(0),
        ),
        child: SkillSection(),
      ),
      isActive: _activeStepIndex >= 1,
    ),
    Step(
      title: Text("Project"),
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0XFF2A3670), // Change this color 🎨
          borderRadius: BorderRadius.circular(0),
        ),
        child: ProjectsSection(),
      ),
      isActive: _activeStepIndex >= 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0XFF111B47).withOpacity(0.3),
      appBar: AppBar(
        title: const Text("Stepper Form", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0XFF2C2E43), // Soft purple color
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.18, vertical: height * 0.02),
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                margin: EdgeInsets.zero,
                type: StepperType.horizontal,
                currentStep: _activeStepIndex,
                steps: stepList(),
                onStepContinue: () {
                  if (_activeStepIndex < stepList().length - 1) {
                    setState(() {
                      _activeStepIndex++;
                    });
                  }
                },
                onStepCancel: () {
                  if (_activeStepIndex > 0) {
                    setState(() {
                      _activeStepIndex--;
                    });
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white,),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150.w, 40.h),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0XFF111B47),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: details.onStepContinue,
                          label: const Text("Next"),
                        ),
                        const SizedBox(width: 15),
                        if (_activeStepIndex > 0)
                          ElevatedButton.icon(
                            onPressed: details.onStepCancel,
                            label: Text("Back"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0XFF111B47),
                              minimumSize: Size(150.w, 40.h),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)
                              )

                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
