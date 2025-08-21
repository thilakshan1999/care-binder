import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/btn/primaryBtn/primaryBtn.dart';
import 'package:care_sync/src/screens/document/documentScreen.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:iconify_flutter/icons/uim.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';

class MainScreen extends StatefulWidget {
  final int initialSelected;
  const MainScreen({super.key, this.initialSelected = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int selected;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
    controller = PageController(initialPage: selected);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: StylishBottomBar(
        backgroundColor:
            Theme.of(context).extension<CustomColors>()?.primarySurface,
        option: AnimatedBarOptions(
          padding: const EdgeInsets.only(bottom: 6, top: 8),
          iconStyle: IconStyle.Default,
        ),
        items: [
          bottomBarItem(
            icon: AntDesign.home_outlined,
            selectedIcon: AntDesign.home_fill,
            title: "Home",
          ),
          bottomBarItem(
            icon: Ph.pill_duotone,
            selectedIcon: Ph.pill_fill,
            title: "Med",
          ),
          bottomBarItem(
            icon: Uil.calender,
            selectedIcon: Uim.calender,
            title: "Appoint",
          ),
          bottomBarItem(
            icon: MaterialSymbols.document_scanner_outline,
            selectedIcon: MaterialSymbols.document_scanner,
            title: "Doc",
          ),
          bottomBarItem(
            icon: Ri.heart_pulse_line,
            selectedIcon: Ri.heart_pulse_fill,
            title: "Vitals",
          ),
          bottomBarItem(
            icon: MaterialSymbols.account_circle_outline,
            selectedIcon: MaterialSymbols.account_circle,
            title: "Profile",
          ),
        ],
        hasNotch: false,
        currentIndex: selected,
        notchStyle: NotchStyle.square,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      body: SafeArea(
        top: false,
        child: PageView(
          controller: controller,
          children: [
            const Center(child: Text('Home')),
            const Center(child: Text('Medication')),
            const Center(child: Text('Appointment')),
            const DocumentScreen(),
            const Center(child: Text('Vitals')),
            Center(
                child: Column(
              children: [
                const Text('Profile'),
                PrimaryBtn(
                    label: "Logout",
                    onPressed: () {
                      context.read<UserBloc>().clear();
                    })
              ],
            )),
          ],
        ),
      ),
    );
  }

  BottomBarItem bottomBarItem({
    required String icon,
    required String selectedIcon,
    required String title,
  }) {
    return BottomBarItem(
      icon: Iconify(
        icon,
        color: Theme.of(context).colorScheme.onSecondary,
        size: 32,
      ),
      selectedIcon: Iconify(
        selectedIcon,
        color: Theme.of(context).colorScheme.primary,
        size: 32,
      ),
      selectedColor: Theme.of(context).colorScheme.primary,
      unSelectedColor: Theme.of(context).colorScheme.onSecondary,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
