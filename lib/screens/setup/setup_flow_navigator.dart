import 'package:flutter/material.dart';

import 'setup_models.dart';
import 'gender_screen.dart';
import 'age_screen.dart';
import 'weight_screen.dart';
import 'height_screen.dart';
import 'goal_screen.dart';
import 'physical_activity_screen.dart';
import 'profile_screen.dart';
import 'almost_there_screen.dart';
import 'all_set_screen.dart';

class SetupFlowNavigator extends StatefulWidget {
  const SetupFlowNavigator({
    super.key,
    required this.onFinish,
    required this.onExitToAuth,
    this.initialName,
  });

  final Future<void> Function(SetupProfileData data) onFinish;
  final VoidCallback onExitToAuth;
  final String? initialName;

  @override
  State<SetupFlowNavigator> createState() => _SetupFlowNavigatorState();
}

class _SetupFlowNavigatorState extends State<SetupFlowNavigator> {
  int _currentStep = 0;
  late final SetupProfileData _data = SetupProfileData(
    fullName: widget.initialName?.trim().isNotEmpty == true
        ? widget.initialName!.trim()
        : 'MoveWell User',
  );

  void _next() {
    if (_currentStep < 8) {
      setState(() => _currentStep++);
    } else {
      widget.onFinish(_data);
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      widget.onExitToAuth();
    }
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step.clamp(0, 8));
  }

  @override
  Widget build(BuildContext context) {
    Widget stepWidget;
    switch (_currentStep) {
      case 0:
        stepWidget = GenderScreen(
          selectedGender: _data.gender,
          onGenderChanged: (val) => _data.gender = val,
          onNext: _next,
          onBack: _back,
        );
        break;
      case 1:
        stepWidget = AgeScreen(
          selectedAgeRange: _data.ageRange,
          onAgeRangeChanged: (val) {
            _data.ageRange = val;
            if (val == "13 – 17") {
              _data.age = 16;
            } else if (val == "18 – 24") {
              _data.age = 22;
            } else if (val == "25 – 34") {
              _data.age = 25;
            } else if (val == "35 – 44") {
              _data.age = 38;
            } else if (val == "45 – 54") {
              _data.age = 48;
            } else if (val == "55 – 64") {
              _data.age = 58;
            } else if (val == "65+") {
              _data.age = 68;
            }
          },
          onNext: _next,
          onBack: _back,
        );
        break;
      case 2:
        stepWidget = WeightScreen(
          selectedWeight: _data.weight,
          selectedUnit: _data.weightUnit,
          onWeightChanged: (val) => _data.weight = val,
          onUnitChanged: (val) => _data.weightUnit = val,
          onNext: _next,
          onBack: _back,
        );
        break;
      case 3:
        stepWidget = HeightScreen(
          selectedHeight: _data.height,
          selectedUnit: _data.heightUnit,
          onHeightChanged: (val) => _data.height = val,
          onUnitChanged: (val) => _data.heightUnit = val,
          onNext: _next,
          onBack: _back,
        );
        break;
      case 4:
        stepWidget = GoalScreen(
          selectedGoal: _data.goal,
          onGoalChanged: (val) => _data.goal = val,
          onNext: _next,
          onBack: _back,
        );
        break;
      case 5:
        stepWidget = PhysicalActivityScreen(
          selectedActivity: _data.activityLevel,
          onActivityChanged: (val) => _data.activityLevel = val,
          onNext: _next,
          onBack: _back,
        );
        break;
      case 6:
        stepWidget = ProfileScreen(data: _data, onNext: _next, onBack: _back);
        break;
      case 7:
        stepWidget = AlmostThereScreen(
          data: _data,
          onEditProfile: () => _goToStep(6),
          onNext: _next,
          onBack: _back,
        );
        break;
      case 8:
      default:
        stepWidget = AllSetScreen(
          data: _data,
          onFinish: () => widget.onFinish(_data),
          onBack: _back,
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(key: ValueKey(_currentStep), child: stepWidget),
    );
  }
}
