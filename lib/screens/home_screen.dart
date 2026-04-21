import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../sections/about_section.dart';
import '../sections/approach_section.dart';
import '../sections/cta_section.dart';
import '../sections/footer_section.dart';
import '../sections/hero_section.dart';
import '../sections/services_section.dart';
import '../widgets/nav_bar.dart';

const double _navHeight = 76;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scroll = ScrollController();
  final _servicesKey = GlobalKey();
  final _approachKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _contactKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    final object = ctx.findRenderObject();
    if (object is! RenderBox || !object.attached) return;
    final viewport = RenderAbstractViewport.of(object);
    final reveal = viewport.getOffsetToReveal(object, 0.0);
    final target = (reveal.offset - _navHeight)
        .clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                children: [
                  const SizedBox(height: _navHeight),
                  HeroSection(
                    onServices: () => _scrollTo(_servicesKey),
                    onContact: () => _scrollTo(_contactKey),
                  ),
                  KeyedSubtree(
                    key: _servicesKey,
                    child: const ServicesSection(),
                  ),
                  KeyedSubtree(
                    key: _approachKey,
                    child: const ApproachSection(),
                  ),
                  KeyedSubtree(
                    key: _aboutKey,
                    child: const AboutSection(),
                  ),
                  KeyedSubtree(
                    key: _contactKey,
                    child: const CtaSection(),
                  ),
                  FooterSection(
                    onServices: () => _scrollTo(_servicesKey),
                    onApproach: () => _scrollTo(_approachKey),
                    onAbout: () => _scrollTo(_aboutKey),
                  ),
                ],
              ),
            ),
          ),
          NavBar(
            onServices: () => _scrollTo(_servicesKey),
            onApproach: () => _scrollTo(_approachKey),
            onAbout: () => _scrollTo(_aboutKey),
            onContact: () => _scrollTo(_contactKey),
          ),
        ],
      ),
    );
  }
}
