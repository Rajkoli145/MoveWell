import 'package:flutter/material.dart';

void main() => runApp(const MoveWellApp());

const _blue = Color(0xff8ed5fb);
const _ink = Color(0xff101419);
const _slate = Color(0xff718096);

class MoveWellApp extends StatelessWidget {
  const MoveWellApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
    home: const OnboardingFlow(),
  );
}

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});
  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _page = 0;
  void _next() => setState(() => _page = (_page + 1).clamp(0, 9));
  void _back() => setState(() => _page = (_page - 1).clamp(0, 9));
  void _go(int page) => setState(() => _page = page);

  @override
  Widget build(BuildContext context) {
    final pages = [
      ReferenceScreen('assets/references/launch.png', _next),
      ReferenceScreen('assets/references/onboard.png', _next),
      AuthPage(onContinue: _next, onForgot: () => _go(10)),
      ChoicePage(
        step: 1,
        title: 'What’s your gender?',
        subtitle: 'This helps us personalize your\nexperience.',
        choices: const [
          ('Male', Icons.male_rounded, null),
          ('Female', Icons.female_rounded, null),
          ('Prefer not to say', Icons.transgender_rounded, null),
        ],
        onNext: _next,
        onBack: _back,
      ),
      AgePage(onNext: _next, onBack: _back),
      HeightPage(onNext: _next, onBack: _back),
      ChoicePage(
        step: 5,
        title: 'What is your goal?',
        subtitle: 'This helps us create a personalized\nplan for your fitness journey.',
        choices: const [
          (
            'Build Muscle',
            Icons.fitness_center_rounded,
            'Gain strength and build lean muscle.',
          ),
          (
            'Lose Weight',
            Icons.monitor_weight_outlined,
            'Burn fat and get in shape.',
          ),
          (
            'Improve Health',
            Icons.favorite_border_rounded,
            'Feel better and boost your energy.',
          ),
          (
            'Increase Endurance',
            Icons.directions_run_rounded,
            'Build stamina and be more active.',
          ),
          (
            'General Fitness',
            Icons.star_border_rounded,
            'Stay active and maintain a healthy lifestyle.',
          ),
        ],
        onNext: _next,
        onBack: _back,
      ),
      ProfilePage(onNext: _next, onBack: _back),
      ReviewPage(onNext: _next, onBack: _back),
      SuccessPage(onBack: _back),
      ForgotPasswordPage(onBack: () => _go(2)),
    ];
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(key: ValueKey(_page), child: pages[_page]),
      ),
    );
  }
}

class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen(this.asset, this.onTap, {super.key});
  final String asset;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ColoredBox(
      color: const Color(0xffe8f7ff),
      child: Center(
        child: AspectRatio(
          aspectRatio: 899 / 1750,
          child: Image.asset(asset, fit: BoxFit.contain),
        ),
      ),
    ),
  );
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.step,
    required this.child,
    required this.onNext,
    required this.onBack,
  });
  final int step;
  final Widget child;
  final VoidCallback onNext, onBack;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xfffafdff), Color(0xffe4f6ff)]),
    ),
    child: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 26),
            child: Column(
              children: [
                _Header(step, onBack),
                Expanded(child: SingleChildScrollView(child: child)),
                _Cta(onNext),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header(this.step, this.back);
  final int step;
  final VoidCallback back;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: back,
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xffe7f2fb),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
      ),
      const SizedBox(width: 18),
      Expanded(
        child: LinearProgressIndicator(
          value: step / 6,
          minHeight: 7,
          color: _blue,
          backgroundColor: const Color(0xffdce8f2),
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      const SizedBox(width: 18),
      Text('$step / 6', style: const TextStyle(fontSize: 17, color: _slate)),
    ],
  );
}

class _Cta extends StatelessWidget {
  const _Cta(this.tap);
  final VoidCallback tap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: SizedBox(
      width: double.infinity,
      height: 70,
      child: FilledButton(
        onPressed: tap,
        style: FilledButton.styleFrom(
          backgroundColor: _ink,
          shape: const StadiumBorder(),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Continue',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            CircleAvatar(
              backgroundColor: _blue,
              radius: 26,
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.black,
                size: 31,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ChoicePage extends StatefulWidget {
  const ChoicePage({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.choices,
    required this.onNext,
    required this.onBack,
  });
  final int step;
  final String title, subtitle;
  final List<(String, IconData, String?)> choices;
  final VoidCallback onNext, onBack;
  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  late String choice = widget.choices.first.$1;
  @override
  Widget build(BuildContext context) => PageFrame(
    step: widget.step,
    onNext: widget.onNext,
    onBack: widget.onBack,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Intro(widget.title, widget.subtitle),
        ...widget.choices.map(
          (item) => _ChoiceCard(
            label: item.$1,
            icon: item.$2,
            detail: item.$3,
            selected: choice == item.$1,
            onTap: () => setState(() => choice = item.$1),
          ),
        ),
      ],
    ),
  );
}

class AgePage extends StatefulWidget {
  const AgePage({super.key, required this.onNext, required this.onBack});
  final VoidCallback onNext, onBack;
  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  String selected = '25 – 34';
  final ages = const [
    ('13 – 17', 'Teen'),
    ('18 – 24', 'Young Adult'),
    ('25 – 34', 'Adult'),
    ('35 – 44', 'Mid Adult'),
    ('45 – 54', 'Adult'),
    ('55 – 64', 'Pre-Senior'),
    ('65+', 'Senior'),
  ];
  @override
  Widget build(BuildContext context) => PageFrame(
    step: 2,
    onNext: widget.onNext,
    onBack: widget.onBack,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Intro(
          'How old are you?',
          'This helps us create a plan that\nfits your needs.',
        ),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .95,
          children: ages
              .map(
                (age) => InkWell(
                  onTap: () => setState(() => selected = age.$1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected == age.$1
                          ? const Color(0xffd9f2ff)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: selected == age.$1
                          ? Border.all(color: const Color(0xff0789d0), width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          age.$1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(age.$2, style: const TextStyle(color: _slate)),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 28),
        const _Info(
          Icons.cake_outlined,
          'Why we ask?',
          'Your age helps us tailor workout intensity, nutrition plans and goals for safe and effective results.',
        ),
      ],
    ),
  );
}

class HeightPage extends StatelessWidget {
  const HeightPage({super.key, required this.onNext, required this.onBack});
  final VoidCallback onNext, onBack;
  @override
  Widget build(BuildContext context) => PageFrame(
    step: 4,
    onNext: onNext,
    onBack: onBack,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Intro(
          'What is your height?',
          'This helps us create a personalized\nplan for your fitness and nutrition goals.',
        ),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xffe7f1f9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'cm',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'ft & in',
                    style: TextStyle(color: _slate, fontSize: 21),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Container(
          height: 240,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            '170\n\n171\n\n172     cm\n\n173\n\n174',
            textAlign: TextAlign.center,
            style: TextStyle(color: _slate, fontSize: 22, height: 1.1),
          ),
        ),
        const SizedBox(height: 30),
        const _Info(
          Icons.straighten_rounded,
          'Why we ask?',
          'Your height helps us calculate your BMI, set accurate calorie goals and create better workout recommendations.',
        ),
      ],
    ),
  );
}

class _Intro extends StatelessWidget {
  const _Intro(this.title, this.subtitle);
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 76, bottom: 36),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 38,
            height: 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 22, height: 1.3, color: _slate),
        ),
      ],
    ),
  );
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.label,
    required this.icon,
    required this.detail,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final String? detail;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(18),
        constraints: BoxConstraints(minHeight: detail == null ? 102 : 112),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffd6f1ff) : Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 31,
              backgroundColor: selected
                  ? const Color(0xff9eddfd)
                  : const Color(0xffe1f3ff),
              child: Icon(icon, color: Colors.black, size: 34),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (detail != null)
                    Text(
                      detail!,
                      style: const TextStyle(color: _slate, fontSize: 16),
                    ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected
                  ? const Color(0xff0789d0)
                  : const Color(0xffd6e2ee),
              size: 38,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Info extends StatelessWidget {
  const _Info(this.icon, this.title, this.body);
  final IconData icon;
  final String title, body;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xffd9f1ff),
          child: Icon(icon, color: Colors.black, size: 32),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                body,
                style: const TextStyle(
                  color: _slate,
                  fontSize: 17,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.onContinue, required this.onForgot});
  final VoidCallback onContinue, onForgot;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool login = true, hidden = true;
  @override
  Widget build(BuildContext context) => _PlainPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 26),
        const Center(child: _Brand()),
        const SizedBox(height: 30),
        const Text(
          'Move Better\nLive Fuller',
          style: TextStyle(
            fontSize: 35,
            height: 1.04,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Small steps. A healthier, happier you.',
          style: TextStyle(color: _slate),
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: _Tab('Log In', login, () => setState(() => login = true)),
            ),
            Expanded(
              child: _Tab(
                'Sign Up',
                !login,
                () => setState(() => login = false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _Field(Icons.mail_outline_rounded, 'Email'),
        const SizedBox(height: 12),
        _Field(
          Icons.lock_outline_rounded,
          'Password',
          obscure: hidden,
          suffix: IconButton(
            onPressed: () => setState(() => hidden = !hidden),
            icon: Icon(
              hidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        if (login)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgot,
              child: const Text('Forgot password?'),
            ),
          ),
        _DarkButton(login ? 'Log In' : 'Create Account', widget.onContinue),
        const SizedBox(height: 18),
      ],
    ),
  );
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key, required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _PlainPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: IconButton.styleFrom(backgroundColor: const Color(0xffe7f2fb)),
        ),
        const SizedBox(height: 38),
        const Center(child: _Brand()),
        const SizedBox(height: 42),
        const Text(
          'Forgot your password?',
          style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        const Text(
          'Enter your email and we’ll send you instructions to reset your password.',
          style: TextStyle(fontSize: 17, height: 1.35, color: _slate),
        ),
        const SizedBox(height: 28),
        const _Field(Icons.mail_outline_rounded, 'Email address'),
        const SizedBox(height: 18),
        _DarkButton('Send Reset Link', () {}),
        Center(
          child: TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to Log In'),
          ),
        ),
      ],
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onNext, required this.onBack});
  final VoidCallback onNext, onBack;
  @override
  Widget build(BuildContext context) => _FinalShell(
    title: 'Fill your profile',
    subtitle: 'This information helps us personalize your fitness plan and experience.',
    onBack: onBack,
    button: _DarkButton('Complete Profile', onNext),
    child: Column(
      children: const [
        _ProfilePhoto(),
        SizedBox(height: 12),
        _ProfileRow(Icons.person_outline_rounded, 'Full Name', 'Fred Nicklson'),
        _ProfileRow(Icons.male_rounded, 'Gender', 'Male'),
        _ProfileRow(
          Icons.calendar_today_outlined,
          'Date of Birth',
          '12 May 2000',
        ),
        _ProfileRow(Icons.straighten_rounded, 'Height', '172 cm'),
        _ProfileRow(Icons.monitor_weight_outlined, 'Weight', '72 kg'),
        _ProfileRow(
          Icons.directions_run_rounded,
          'Activity Level',
          'Moderately Active',
        ),
      ],
    ),
  );
}

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key, required this.onNext, required this.onBack});
  final VoidCallback onNext, onBack;
  @override
  Widget build(BuildContext context) => _FinalShell(
    title: 'Almost there!',
    subtitle: 'Here’s a summary of your information. You can edit it anytime.',
    onBack: onBack,
    button: _DarkButton('Continue to Home', onNext),
    child: Column(
      children: const [
        _ProfilePhoto(compact: true),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _Summary(Icons.male_rounded, 'Gender', 'Male')),
            SizedBox(width: 10),
            Expanded(child: _Summary(Icons.cake_outlined, 'Age', '25 years')),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _Summary(Icons.monitor_weight_outlined, 'Weight', '72 kg'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _Summary(Icons.straighten_rounded, 'Height', '172 cm'),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _Summary(Icons.adjust_rounded, 'Goal', 'Build Muscle'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _Summary(
                Icons.directions_run_rounded,
                'Activity Level',
                'Moderate',
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _Info(
          Icons.emoji_events_outlined,
          'You’re all set!',
          'Let’s build a healthier, stronger and happier you.',
        ),
      ],
    ),
  );
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _PlainPage(
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 44,
          backgroundColor: Color(0xffd6fae8),
          child: Icon(Icons.check_rounded, size: 52, color: Color(0xff18bd70)),
        ),
        const SizedBox(height: 20),
        const Text(
          'You’re all set!',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
        ),
        const Text(
          'Your profile is complete. Let’s start\nyour fitness journey!',
          textAlign: TextAlign.center,
          style: TextStyle(color: _slate, height: 1.4),
        ),
        const SizedBox(height: 24),
        const _ProfileRow(
          Icons.person_outline_rounded,
          'Full Name',
          'Fred Nicklson',
          checked: true,
        ),
        const _ProfileRow(Icons.male_rounded, 'Gender', 'Male', checked: true),
        const _ProfileRow(
          Icons.calendar_today_outlined,
          'Date of Birth',
          '12 May 2000',
          checked: true,
        ),
        const _ProfileRow(
          Icons.straighten_rounded,
          'Height',
          '172 cm',
          checked: true,
        ),
        const _ProfileRow(
          Icons.monitor_weight_outlined,
          'Weight',
          '72 kg',
          checked: true,
        ),
        const _ProfileRow(
          Icons.directions_run_rounded,
          'Activity Level',
          'Moderately Active',
          checked: true,
        ),
        const Spacer(),
        _DarkButton('Go to Dashboard', () {}),
      ],
    ),
  );
}

class _PlainPage extends StatelessWidget {
  const _PlainPage({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xfff9fdff), Color(0xffe4f6ff)]),
    ),
    child: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: child,
          ),
        ),
      ),
    ),
  );
}

class _Brand extends StatelessWidget {
  const _Brand();
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      Icon(Icons.sports_gymnastics_rounded, size: 48),
      Text(
        'MoveWell',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
      ),
      Text(
        'A  H E A L T H I E R  Y O U ,  E V E R Y D A Y',
        style: TextStyle(fontSize: 7, color: _slate),
      ),
    ],
  );
}

class _Tab extends StatelessWidget {
  const _Tab(this.label, this.active, this.tap);
  final String label;
  final bool active;
  final VoidCallback tap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: tap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: active ? _blue : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: active ? Colors.black : _slate,
        ),
      ),
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field(this.icon, this.hint, {this.obscure = false, this.suffix});
  final IconData icon;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) => TextField(
    obscureText: obscure,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

class _DarkButton extends StatelessWidget {
  const _DarkButton(this.label, this.tap);
  final String label;
  final VoidCallback tap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 58,
    child: FilledButton(
      onPressed: tap,
      style: FilledButton.styleFrom(
        backgroundColor: _ink,
        shape: const StadiumBorder(),
      ),
      child: Row(
        children: [
          const Spacer(),
          Text(label),
          const Spacer(),
          const CircleAvatar(
            radius: 21,
            backgroundColor: _blue,
            child: Icon(Icons.arrow_forward_rounded, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

class _FinalShell extends StatelessWidget {
  const _FinalShell({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.button,
    required this.onBack,
  });
  final String title, subtitle;
  final Widget child, button;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _PlainPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            const Spacer(),
            const SizedBox(
              width: 160,
              child: LinearProgressIndicator(
                value: 1,
                color: _blue,
                minHeight: 5,
              ),
            ),
            const Spacer(),
            const Text('6 / 6', style: TextStyle(color: _slate)),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w800),
        ),
        Text(subtitle, style: const TextStyle(color: _slate)),
        const SizedBox(height: 16),
        Expanded(child: SingleChildScrollView(child: child)),
        const SizedBox(height: 12),
        button,
      ],
    ),
  );
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({this.compact = false});
  final bool compact;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: compact ? 26 : 34,
          backgroundColor: const Color(0xffd7ebf7),
          child: const Icon(Icons.person, size: 38),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add a profile photo',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                'A clear photo helps us personalize your experience.',
                style: TextStyle(fontSize: 11, color: _slate),
              ),
            ],
          ),
        ),
        if (compact) const Icon(Icons.edit_outlined),
      ],
    ),
  );
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow(this.icon, this.label, this.value, {this.checked = false});
  final IconData icon;
  final String label, value;
  final bool checked;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: const Color(0xffe5f4fc),
          child: Icon(icon, color: Colors.black, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: _slate)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Icon(
          checked ? Icons.check_circle : Icons.keyboard_arrow_down_rounded,
          color: checked ? const Color(0xff51c879) : _slate,
          size: 19,
        ),
      ],
    ),
  );
}

class _Summary extends StatelessWidget {
  const _Summary(this.icon, this.label, this.value);
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 19,
          backgroundColor: const Color(0xffe5f4fc),
          child: Icon(icon, color: Colors.black, size: 19),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: _slate)),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
