import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MoekyawaungPortfolio());
}

class MoekyawaungPortfolio extends StatelessWidget {
  const MoekyawaungPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moekyawaung | Android Senior Dev',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF667EEA),
          secondary: const Color(0xFF10B981),
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const PortfolioHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> 
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  late AnimationController _controller;
  Map<String, dynamic>? githubData;
  bool isEnglish = true;
  int selectedTab = 0;

  final List<String> voiceScripts = [
    // ENGLISH SCRIPT
    """
Hi, I'm Moekyawaung, Android Senior Developer from Myanmar.
With 7+ years experience and 120+ certifications in Kotlin, Flutter, 
Cyber Security, AI, and full-stack web development.
I've built secure, scalable apps for global clients.
Ready to deliver your next Android masterpiece!
    """,
    // MYANMAR SCRIPT (Burmese)
    """
မင်္ဂလာပါ၊ ကျွန်တော်က Moekyawaung ဖြစ်ပါတယ်။
Android Senior Developer ဖြစ်ပြီး ၇ နှစ်ကျော် အတွေ့အကြုံရှိပါတယ်။
Kotlin, Flutter, Cyber Security, AI နှင့် ၁၂၀ ခုကျော် certification ရထားပါတယ်။
သင့်ရဲ့ Android app ကို ကမ္ဘာ့အဆင့် ဖန်တီးပေးပါမယ်။
    """
  ];

  @override
  void initState() {
    super.initState();
    _initVideo();
    _initAudio();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _loadGithub();
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.asset('assets/video/bg.mp4')
      ..initialize().then((_) => setState(() {}));
    _videoController.setLooping(true);
    _videoController.play();
  }

  Future<void> _initAudio() async {
    _audioPlayer = AudioPlayer();
  }

  Future<void> _loadGithub() async {
    try {
      final response = await http.get(Uri.parse('https://api.github.com/users/Dev-moe-kyawaung'));
      if (response.statusCode == 200) {
        setState(() {
          githubData = json.decode(response.body);
        });
      }
    } catch (e) {
      print('GitHub load failed: $e');
    }
  }

  Future<void> _playVoiceResume() async {
    await _audioPlayer.stop();
    final lang = isEnglish ? 'voice-resume-en.mp3' : 'voice-resume-mm.mp3';
    await _audioPlayer.play(AssetSource(lang));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // VIDEO BACKGROUND
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          
          // OVERLAY + CONTENT
          CustomScrollView(
            slivers: [
              // HERO SECTION
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      // CUSTOM IKON ANIMATION
                      Lottie.asset('assets/lottie/custom-ikon.json', 
                        width: 160, height: 160)
                          .animate(onPlay: (controller) => controller.repeat())
                          .scale(duration: 2000.ms, begin: 0.8, end: 1.0),
                      
                      // PROFILE PHOTO
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 4),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, spreadRadius: 10)
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/moekyawaung.webp',
                            width: 280, height: 360, fit: BoxFit.cover),
                        ),
                      ),
                      
                      // HERO TEXT
                      const Spacer(flex: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text('Mr. Moekyawaung',
                                style: GoogleFonts.inter(
                                  fontSize: 48, fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                )),
                            Text('Android Senior Developer',
                                style: GoogleFonts.inter(
                                  fontSize: 24, fontWeight: FontWeight.w500,
                                  color: Colors.greenAccent,
                                )),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Chip(label: Text('7+ Years'), backgroundColor: Colors.orange),
                                const SizedBox(width: 12),
                                Chip(label: Text('120+ Certs'), backgroundColor: Colors.blue),
                                const SizedBox(width: 12),
                                Chip(label: const Icon(Icons.flag, color: Colors.white), 
                                     backgroundColor: Colors.red),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _scrollTo(0),
                                  icon: const Icon(Icons.code),
                                  label: const Text('Projects'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _playVoiceResume(),
                                  icon: const Icon(Icons.play_arrow),
                                  label: Text(isEnglish ? 'Voice Resume' : 'အသံ ပြန်လည်ဖတ်ပြခ'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // GITHUB STATS
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.all(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(
                        title: 'Repos',
                        value: githubData?['public_repos']?.toString() ?? 'Loading...',
                        icon: Icons.folder,
                      ),
                      StatCard(
                        title: 'Followers',
                        value: githubData?['followers']?.toString() ?? 'Loading...',
                        icon: Icons.people,
                      ),
                      StatCard(
                        title: '7+ Years',
                        value: 'Android Exp',
                        icon: Icons.verified,
                      ),
                    ],
                  ),
                ),
              ),
              
              // CERTIFICATIONS (Staggered Grid)
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverStaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    for (int i = 0; i < 24; i++)
                      CertCard(
                        title: 'Kotlin Advanced',
                        date: 'Feb 2025',
                        id: '1739885336702',
                        icon: Icons.code,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget StatCard({required String title, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, size: 48, color: Colors.greenAccent),
        const SizedBox(height: 12),
        Text(value, style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700)),
        Text(title, style: GoogleFonts.inter(color: Colors.grey)),
      ],
    );
  }

  Widget CertCard({required String title, required String date, required String id, required IconData icon}) {
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Date: $date'),
                Text('ID: $id'),
                ElevatedButton.icon(
                  onPressed: () {}, // Verify API
                  icon: const Icon(Icons.verified),
                  label: const Text('Verify'),
                ),
              ],
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 48, color: Colors.greenAccent),
              const SizedBox(height: 12),
              Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              Text(date, style: GoogleFonts.inter(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollTo(int index) {
    // Scroll to section logic
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }
}
