import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PresentationApp extends StatefulWidget {
  const PresentationApp({super.key});

  @override
  State<PresentationApp> createState() => _PresentationAppState();
}

class _PresentationAppState extends State<PresentationApp> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Define your slides here
  final List<Widget> _slides = [
    const TitleSlide(
      title: "Flutter Presentation",
      subtitle: "Built with Flutter & Dart",
      author: "By CouldAI",
    ),
    const ContentSlide(
      title: "What is this?",
      points: [
        "A fully functional presentation app",
        "Built entirely in Flutter",
        "Runs on Web, Mobile, and Desktop",
        "Customizable slides and transitions",
      ],
    ),
    const ImageSlide(
      title: "Cross Platform Power",
      icon: Icons.devices,
      description: "Write once, run everywhere. Deploy to iOS, Android, Web, Windows, macOS, and Linux from a single codebase.",
    ),
    const CodeSlide(
      title: "Simple Code Structure",
      codeSnippet: """
void main() {
  runApp(const MyApp());
}

// Everything is a Widget
class Slide extends StatelessWidget {
  ...
}
""",
    ),
    const TitleSlide(
      title: "Thank You",
      subtitle: "Any Questions?",
      author: "Build beautiful apps today.",
      isEnd: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextSlide() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousSlide() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight || 
          event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        _nextSlide();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _previousSlide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKey: _handleKeyEvent,
        child: Stack(
          children: [
            // Main Slide View
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _slides,
            ),
            
            // Navigation Controls (Overlay)
            Positioned(
              bottom: 20,
              right: 20,
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: _currentPage > 0 ? _previousSlide : null,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: "Previous",
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${_currentPage + 1} / ${_slides.length}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    onPressed: _currentPage < _slides.length - 1 ? _nextSlide : null,
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: "Next",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Slide Templates ---

class TitleSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String author;
  final bool isEnd;

  const TitleSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.author,
    this.isEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEnd 
              ? [Colors.indigo.shade900, Colors.blue.shade800]
              : [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.slideshow, 
              size: 100, 
              color: isEnd ? Colors.white70 : Colors.indigo,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isEnd ? Colors.white : Colors.indigo.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: isEnd ? Colors.white70 : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            Text(
              author,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isEnd ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentSlide extends StatelessWidget {
  final String title;
  final List<String> points;

  const ContentSlide({
    super.key,
    required this.title,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 2),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: points.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.indigo),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          points[index],
                          style: Theme.of(context).textTheme.headlineSmall,
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
    );
  }
}

class ImageSlide extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const ImageSlide({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigo.shade100),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 150, color: Colors.indigo),
                    const SizedBox(height: 30),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CodeSlide extends StatelessWidget {
  final String title;
  final String codeSnippet;

  const CodeSlide({
    super.key,
    required this.title,
    required this.codeSnippet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  codeSnippet,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 20,
                    color: Color(0xFFD4D4D4),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
