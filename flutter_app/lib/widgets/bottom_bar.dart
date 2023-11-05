import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<NavItem> navItems;
  const BottomBar({super.key, required this.selectedIndex, required this.onTap, required this.navItems});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  // final List<NavItem> navItems = [
  //   NavItem(index: 0, label: 'HOME', icon: Iconsax.home_1),
  //   NavItem(index: 1, label: 'MESSAGES', icon: Iconsax.message_2),
  //   NavItem(index: 2, label: 'BOOKMARKS', icon: Iconsax.heart),
  //   NavItem(index: 3, label: 'PROFILE', icon: Iconsax.profile_circle),
  // ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      height: 80,
      color: const Color(0xFF141414),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.navItems
              .map<Widget>((NavItem e) => Container(
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        start: e.index > 0 && widget.selectedIndex == e.index
                            ? const BorderSide(
                                width: 2, color: Color(0xFF2B2E10))
                            : const BorderSide(width: 0),
                        end: e.index < widget.navItems.length - 1 &&
                                widget.selectedIndex == e.index
                            ? const BorderSide(
                                width: 2, color: Color(0xFF2B2E10))
                            : const BorderSide(width: 0),
                      ),
                    ),
                    child: BottomBarIcon(
                        index: e.index,
                        label: e.label,
                        icon: e.icon,
                        active: widget.selectedIndex == e.index,
                        onPressed: () {
                          widget.onTap(e.index);
                        }),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class BottomBarIcon extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final bool active;
  final Function() onPressed;
  const BottomBarIcon(
      {required this.index,
      required this.label,
      required this.icon,
      required this.active,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int flex1 = 1, flex2 = 2;
    final total = (flex1 * 4) + flex2;
    final width = MediaQuery.of(context).size.width;
    final defaultWidth = (width * flex1) / total;
    final expandedWidth = (width * flex2) / total;

    return AnimatedContainer(
        width: active ? expandedWidth : defaultWidth,
        height: double.maxFinite,
        duration: const Duration(milliseconds: 150),
        child: SingleChildScrollView(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                // color: Colors.blue,
                child: active
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                                fontFamily: 'CabinetGrotesk',
                                letterSpacing: 0.8,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFD9E74D)),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: onPressed,
                        iconSize: 48,
                        splashRadius: 10,
                        icon: Icon(
                          icon,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ));
  }
}

class NavItem {
  final int index;
  final String label;
  final IconData icon;

  NavItem({required this.index, required this.label, required this.icon});
}
