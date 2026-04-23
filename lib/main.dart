import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';


// ─────────────────────────────────────────────
// GLOBAL THEME STATE — DARK BY DEFAULT
// ─────────────────────────────────────────────
final ValueNotifier<bool> isDarkMode = ValueNotifier(true);
final ValueNotifier<bool> isDoctorMode = ValueNotifier(false);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const PremiumDoctorApp());
}

// ─────────────────────────────────────────────
// PREMIUM THEME & COLORS
// ─────────────────────────────────────────────
class AppColors {
  static bool get _dark => isDarkMode.value;

  // Core backgrounds
  static Color get background => _dark ? const Color(0xFF080C18) : const Color(0xFFF1F4F9);
  static Color get surface => _dark ? const Color(0xFF121929) : Colors.white;
  static Color get surfaceLight => _dark ? const Color(0xFF1A2237) : const Color(0xFFF8FAFC);

  // Text
  static Color get textPrimary => _dark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B);
  static Color get textSecondary => _dark ? const Color(0xFF7B8BA5) : const Color(0xFF64748B);

  // Accent system
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4F46E5);
  static Color get primaryLight => _dark ? const Color(0xFF1A1740) : const Color(0xFFEEF2FF);
  static const Color accent = Color(0xFF00D1FF);
  static const Color accentGreen = Color(0xFF22D38F);
  static const Color rating = Color(0xFFFFB800);
  static Color get border => _dark ? const Color(0xFF1E2A3F) : const Color(0xFFE2E8F0);
  static const Color danger = Color(0xFFFF4757);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00D1FF)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static LinearGradient get surfaceGradient => LinearGradient(
    colors: _dark
      ? [const Color(0xFF121929), const Color(0xFF1A2237)]
      : [Colors.white, const Color(0xFFF8FAFC)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  // Glow shadow for neon effects
  static List<BoxShadow> primaryGlow({double opacity = 0.3, double blur = 20}) => [
    BoxShadow(color: primary.withValues(alpha: opacity), blurRadius: blur, offset: const Offset(0, 8)),
  ];
  static List<BoxShadow> accentGlow({double opacity = 0.25, double blur = 16}) => [
    BoxShadow(color: accent.withValues(alpha: opacity), blurRadius: blur, offset: const Offset(0, 6)),
  ];
}

class AppStyles {
  static TextStyle get h1 => TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.8, height: 1.2);
  static TextStyle get h2 => TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5);
  static TextStyle get h3 => TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static TextStyle get body => TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5);
  static TextStyle get caption => TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
}

// ─────────────────────────────────────────────
// DATA MODELS & MOCK DATA
// ─────────────────────────────────────────────
class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int reviews;
  final int experience;
  final int patients;
  final String imageUrl;
  final String about;

  Doctor({
    required this.id, required this.name, required this.specialty, required this.hospital,
    required this.rating, required this.reviews, required this.experience, required this.patients,
    required this.imageUrl, required this.about,
  });
}

class Appointment {
  final Doctor doctor;
  final String date;
  final String time;
  final String status;

  Appointment({required this.doctor, required this.date, required this.time, required this.status});
}

class ChatConversation {
  final Doctor doctor;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatConversation({required this.doctor, required this.lastMessage, required this.time, required this.unreadCount, required this.isOnline});
}

final List<Doctor> mockDoctors = [
  Doctor(
    id: '1', name: 'Dr. Sarah Jenkins', specialty: 'Cardiologist', hospital: 'Mount Sinai Medical Center',
    rating: 4.9, reviews: 324, experience: 12, patients: 2400,
    imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=300&h=300',
    about: 'Dr. Sarah is a highly experienced cardiologist specializing in advanced heart failure, echocardiography, and preventive cardiology. She is dedicated to providing compassionate, comprehensive care to her patients.',
  ),
  Doctor(
    id: '2', name: 'Dr. Michael Chen', specialty: 'Neurologist', hospital: 'Johns Hopkins Hospital',
    rating: 4.8, reviews: 198, experience: 15, patients: 1800,
    imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=300&h=300',
    about: 'Dr. Chen brings 15 years of clinical expertise in neurology, focusing on stroke prevention, headache management, and movement disorders. He utilizes state-of-the-art diagnostic tools.',
  ),
  Doctor(
    id: '3', name: 'Dr. Emily Carter', specialty: 'Dermatologist', hospital: 'Mayo Clinic Health',
    rating: 4.7, reviews: 410, experience: 8, patients: 3200,
    imageUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&q=80&w=300&h=300',
    about: 'Dr. Carter specializes in medical and cosmetic dermatology, offering cutting-edge treatments for acne, eczema, and skin cancer screenings. Her approach is patient-centered and holistic.',
  ),
  Doctor(
    id: '4', name: 'Dr. James Wilson', specialty: 'Orthopedics', hospital: 'Cleveland Clinic',
    rating: 4.9, reviews: 345, experience: 20, patients: 5000,
    imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=300&h=300',
    about: 'Dr. Wilson is a board-certified orthopedic surgeon who specializes in joint replacement and sports injuries. He has helped thousands of athletes return to their peak performance.',
  ),
];

final List<Map<String, dynamic>> categories = [
  {'icon': Icons.favorite, 'label': 'Cardiology', 'color': Colors.redAccent},
  {'icon': Icons.psychology, 'label': 'Neurology', 'color': Colors.purpleAccent},
  {'icon': Icons.face, 'label': 'Dermatology', 'color': Colors.orangeAccent},
  {'icon': Icons.accessibility_new, 'label': 'Orthopedics', 'color': Colors.blueAccent},
  {'icon': Icons.child_care, 'label': 'Pediatrics', 'color': Colors.greenAccent},
];

final List<Appointment> mockAppointments = [
  Appointment(doctor: mockDoctors[0], date: 'Oct 24, 2023', time: '10:00 AM', status: 'Upcoming'),
  Appointment(doctor: mockDoctors[1], date: 'Oct 18, 2023', time: '02:30 PM', status: 'Completed'),
  Appointment(doctor: mockDoctors[3], date: 'Sep 10, 2023', time: '11:15 AM', status: 'Cancelled'),
  Appointment(doctor: mockDoctors[2], date: 'Sep 05, 2023', time: '09:00 AM', status: 'Completed'),
];

final List<ChatConversation> mockChats = [
  ChatConversation(doctor: mockDoctors[0], lastMessage: 'Your test results look great, nothing to worry about!', time: '10:30 AM', unreadCount: 2, isOnline: true),
  ChatConversation(doctor: mockDoctors[1], lastMessage: 'Please remember to take the prescribed medication.', time: 'Yesterday', unreadCount: 0, isOnline: false),
  ChatConversation(doctor: mockDoctors[3], lastMessage: 'See you next week for the follow-up.', time: 'Mon', unreadCount: 0, isOnline: true),
];

final List<Map<String, dynamic>> mockChatMessages = [
  {'isMe': false, 'text': 'Hello Sanya, how are you feeling today?', 'time': '10:00 AM'},
  {'isMe': true, 'text': 'Hi Doctor, I am feeling much better now. The new medication is helping a lot.', 'time': '10:05 AM'},
  {'isMe': false, 'text': 'That is wonderful to hear! Please continue the course for another week.', 'time': '10:06 AM'},
  {'isMe': false, 'text': 'Let me know if you experience any side effects.', 'time': '10:06 AM'},
  {'isMe': true, 'text': 'Will do. Thank you so much!', 'time': '10:10 AM'},
];

// ─────────────────────────────────────────────
// APP ROOT
// ─────────────────────────────────────────────
class PremiumDoctorApp extends StatelessWidget {
  const PremiumDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, dark, _) {
        return MaterialApp(
          title: 'Aura Health',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: dark ? Brightness.dark : Brightness.light,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: dark ? Brightness.dark : Brightness.light),
            fontFamily: 'Inter',
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.textPrimary),
              titleTextStyle: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
              systemOverlayStyle: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            ),
          ),
          home: const MainNavigationWrapper(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// MAIN NAVIGATION (BOTTOM NAV)
// ─────────────────────────────────────────────
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDoctorMode,
      builder: (context, docMode, _) {
        final pages = docMode
          ? const [DoctorDashboardScreen(), ScheduleScreen(), ChatListScreen(), ProfileScreen()]
          : const [HomeScreen(), ScheduleScreen(), ChatListScreen(), ProfileScreen()];
        if (_currentIndex >= pages.length) _currentIndex = 0;
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 10)),
                    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 5)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_rounded, 'Home', 0),
                    _buildNavItem(Icons.calendar_month_rounded, 'Schedule', 1),
                    _buildNavItem(Icons.chat_bubble_rounded, 'Chat', 2),
                    _buildNavItem(Icons.person_rounded, 'Profile', 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected ? AppColors.primaryGlow(opacity: 0.25, blur: 12) : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary, size: 22),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.3)),
            ]
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAGE 1: HOME SCREEN — PREMIUM
// ─────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildHeader(),
        const SizedBox(height: 28),
        _buildSearchBar(),
        const SizedBox(height: 28),
        _buildFeaturedBanner(),
        const SizedBox(height: 20),
        _buildSymptomCheckerCard(context),
        const SizedBox(height: 36),
        _buildSectionHeader('Specialties', 'See All'),
        const SizedBox(height: 16),
        _buildCategories(),
        const SizedBox(height: 36),
        _buildSectionHeader('Top Doctors', 'See All'),
        const SizedBox(height: 16),
        ...mockDoctors.map((doc) => _buildDoctorCard(context, doc)),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning,', style: AppStyles.body.copyWith(fontSize: 15)),
            const SizedBox(height: 4),
            ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
              child: Text('Sanya 👋', style: AppStyles.h1.copyWith(color: Colors.white)),
            ),
          ],
        ),
        Row(
          children: [
            _buildThemeToggle(),
            const SizedBox(width: 12),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: AppColors.primaryGlow(opacity: 0.2, blur: 12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=150&h=150'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeToggle() {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, dark, _) {
        return GestureDetector(
          onTap: () => isDarkMode.value = !isDarkMode.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: dark ? AppColors.surfaceLight : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(color: (dark ? AppColors.rating : AppColors.primary).withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(
              dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: dark ? AppColors.rating : AppColors.primary,
              size: 22,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
          ),
          child: TextField(
            decoration: InputDecoration(
              icon: ShaderMask(
                shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                child: const Icon(Icons.search_rounded, color: Colors.white, size: 24),
              ),
              hintText: 'Search doctors, conditions...',
              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.primaryGlow(opacity: 0.35, blur: 24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text('New Feature', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Online\nConsultation', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, height: 1.2, letterSpacing: -0.5)),
                const SizedBox(height: 8),
                Text('Get checked from home', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 44),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppStyles.h3),
        ShaderMask(
          shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
          child: Text(action, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final color = cat['color'] as Color;
          return Column(
            children: [
              Container(
                width: 66, height: 66,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 6)),
                  ],
                ),
                child: Icon(cat['icon'], color: color, size: 28),
              ),
              const SizedBox(height: 10),
              Text(cat['label'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctor: doctor)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.surfaceGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'doc_img_${doctor.id}',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(doctor.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name, style: AppStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('${doctor.specialty} • ${doctor.hospital}', style: AppStyles.body.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.rating.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.rating, size: 14),
                            const SizedBox(width: 3),
                            Text('${doctor.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.rating)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${doctor.reviews} reviews', style: AppStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomCheckerCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SymptomCheckerScreen())),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.warmGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFFFF6B6B).withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: const Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Symptom Checker', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                  const SizedBox(height: 4),
                  Text('Feeling unwell? Find the right specialist', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: Colors.white.withValues(alpha: 0.7), size: 22),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAGE 2: SCHEDULE / APPOINTMENTS SCREEN
// ─────────────────────────────────────────────
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedTab = 'Upcoming';
  final List<String> _tabs = ['Upcoming', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final filteredAppts = mockAppointments.where((a) => a.status == _selectedTab).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text('My Schedule', style: AppStyles.h1),
          ),
          _buildSegmentControl(),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              itemCount: filteredAppts.length,
              itemBuilder: (context, index) => _buildAppointmentCard(filteredAppts[index]),
            ),
          ),
          const SizedBox(height: 80), // for bottom nav spacing
        ],
      ),
    );
  }

  Widget _buildSegmentControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: _tabs.map((tab) => Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTab = tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _selectedTab == tab ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(tab, style: TextStyle(
                  color: _selectedTab == tab ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13
                )),
              )
            )
          )
        )).toList()
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(appt.doctor.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appt.doctor.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(appt.doctor.specialty, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: AppColors.border),
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(appt.date, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(appt.time, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(appt.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(appt.status, style: TextStyle(color: _getStatusColor(appt.status), fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          if (appt.status == 'Upcoming') ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Reschedule', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ] else if (appt.status == 'Completed') ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Book Again', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ]
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch(status) {
      case 'Upcoming': return AppColors.primary;
      case 'Completed': return AppColors.accent;
      case 'Cancelled': return AppColors.danger;
      default: return AppColors.textSecondary;
    }
  }
}

// ─────────────────────────────────────────────
// PAGE 3: CHAT LIST SCREEN
// ─────────────────────────────────────────────
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text('Messages', style: AppStyles.h1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: AppColors.textSecondary),
                  hintText: 'Search chats...',
                  hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: mockChats.length,
              separatorBuilder: (context, index) => Divider(height: 1, indent: 90, color: AppColors.border),
              itemBuilder: (context, index) {
                final chat = mockChats[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(doctor: chat.doctor)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(chat.doctor.imageUrl),
                            ),
                            if (chat.isOnline)
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  width: 14, height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(chat.doctor.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  Text(chat.time, style: TextStyle(fontSize: 12, color: chat.unreadCount > 0 ? AppColors.primary : AppColors.textSecondary, fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      chat.lastMessage,
                                      style: TextStyle(fontSize: 14, color: chat.unreadCount > 0 ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (chat.unreadCount > 0)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                      child: Text('${chat.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

// ─────────────────────────────────────────────
// PAGE 4: PROFILE SCREEN — PREMIUM
// ─────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildProfileHeader(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHealthStats(),
                const SizedBox(height: 32),
                _buildMenuOptionNav(Icons.medical_information_rounded, 'Medical Records', const Color(0xFF6C63FF), const MedicalRecordsScreen()),
                _buildMenuOptionNav(Icons.search_rounded, 'Find Doctors', AppColors.accent, const DoctorSearchScreen()),
                _buildMenuOption(Icons.payment_rounded, 'Payment Methods', const Color(0xFF9C27B0)),
                _buildDoctorModeSwitch(),
                _buildMenuOption(Icons.settings_rounded, 'Settings', const Color(0xFFFF8E53)),
                _buildMenuOption(Icons.help_center_rounded, 'Help Center', AppColors.accentGreen),
                _buildMenuOption(Icons.logout_rounded, 'Logout', AppColors.danger, isLast: true),
                const SizedBox(height: 100),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 36),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: AppColors.primaryGlow(opacity: 0.3, blur: 24),
      ),
      child: Column(
        children: [
          const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.3)),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 105, height: 105,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 3),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                    ],
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=300&h=300'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2, right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentGreen]),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: AppColors.accentGlow(opacity: 0.4, blur: 10),
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Sanya Sharma', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text('sanya.sharma@example.com', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildHealthStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('Heart rate', '72 bpm', Icons.favorite_rounded, const Color(0xFFFF4757)),
        _buildStatCard('Calories', '756 cal', Icons.local_fire_department_rounded, const Color(0xFFFF8E53)),
        _buildStatCard('Weight', '65 kg', Icons.monitor_weight_rounded, AppColors.accent),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: AppColors.surfaceGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(label, style: AppStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, Color color, {bool isLast = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isLast ? color.withValues(alpha: 0.2) : AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isLast ? color : AppColors.textPrimary)),
        trailing: isLast ? null : Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }

  Widget _buildMenuOptionNav(IconData icon, String title, Color color, Widget screen) {
    return Builder(builder: (context) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 22)),
        title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      ),
    ));
  }

  Widget _buildDoctorModeSwitch() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9C27B0)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 22)),
        title: const Text('Switch to Doctor Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white70),
        onTap: () => isDoctorMode.value = true,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CHAT DETAIL SCREEN (MESSAGING INTERFACE)
// ─────────────────────────────────────────────
class ChatDetailScreen extends StatelessWidget {
  final Doctor doctor;
  const ChatDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            CircleAvatar(radius: 20, backgroundImage: NetworkImage(doctor.imageUrl)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Online', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            )
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.videocam_rounded, color: AppColors.primary), onPressed: () {}),
          IconButton(icon: Icon(Icons.call_rounded, color: AppColors.primary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              itemCount: mockChatMessages.length,
              itemBuilder: (context, index) {
                final msg = mockChatMessages[index];
                final isMe = msg['isMe'] as bool;
                return _buildMessageBubble(msg['text'], msg['time'], isMe);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, String time, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 20),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Text(text, style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary, fontSize: 15, height: 1.4)),
            ),
            const SizedBox(height: 6),
            Text(time, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: Icon(Icons.add, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(30)),
                child: const TextField(
                  decoration: InputDecoration(hintText: 'Type a message...', border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAGE 5 & 6: DOCTOR DETAILS & BOOKING SCREEN
// ─────────────────────────────────────────────
class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;
  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(child: _buildDetailsContent(context)),
            ],
          ),
          _buildBottomBookBar(context),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _glassButton(context, Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _glassButton(context, Icons.favorite_border_rounded, () {}),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'doc_img_${doctor.id}',
          child: Image.network(doctor.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _glassButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40, height: 40,
            color: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name, style: AppStyles.h1.copyWith(fontSize: 26)),
                      const SizedBox(height: 8),
                      Text(doctor.specialty, style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.rating.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.rating, size: 20),
                      const SizedBox(width: 4),
                      Text('${doctor.rating}', style: const TextStyle(color: AppColors.rating, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBox(Icons.people_alt_rounded, '${doctor.patients}+', 'Patients'),
                _statBox(Icons.work_history_rounded, '${doctor.experience} Yrs', 'Experience'),
                _statBox(Icons.reviews_rounded, '${doctor.reviews}', 'Reviews'),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorReviewsScreen(doctor: doctor))),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(16)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star_rounded, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text('See All ${doctor.reviews} Reviews', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 12),
                ])),
            ),
            const SizedBox(height: 32),
            Text('About Doctor', style: AppStyles.h3),
            const SizedBox(height: 12),
            Text(doctor.about, style: AppStyles.body),
            const SizedBox(height: 32),
            Text('Working Location', style: AppStyles.h3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(16)),
                    child: Icon(Icons.location_on_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.hospital, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('New York, NY 10029', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(IconData icon, String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildBottomBookBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consultation Price', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text('\$120', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(doctor: doctor))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text('Book Appointment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  final Doctor doctor;
  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDateIndex = 2;
  int _selectedTimeIndex = -1;
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> _dates = ['12', '13', '14', '15', '16', '17'];
  final List<String> _times = ['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:30 PM', '04:00 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Schedule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('October 2023', style: AppStyles.h2),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedDateIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDateIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 70, margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                      boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_days[index], style: TextStyle(color: isSelected ? Colors.white70 : AppColors.textSecondary, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(_dates[index], style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Available Time', style: AppStyles.h3),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              spacing: 12, runSpacing: 16,
              children: List.generate(_times.length, (index) {
                final isSelected = _selectedTimeIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTimeIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: (MediaQuery.of(context).size.width - 48 - 24) / 3,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                      boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
                    ),
                    child: Center(child: Text(_times[index], style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13))),
                  ),
                );
              }),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity, height: 60,
                child: ElevatedButton(
                  onPressed: _selectedTimeIndex != -1 ? () => _showSuccessDialog() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.border,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: const Text('Confirm Appointment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          backgroundColor: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 64),
                ),
                const SizedBox(height: 24),
                Text('Booking Successful!', style: AppStyles.h2),
                const SizedBox(height: 8),
                Text('Your appointment has been successfully scheduled. You will receive a notification shortly.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity, height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: const Text('Go to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// SYMPTOM CHECKER SCREEN (3-STEP WIZARD)
// ─────────────────────────────────────────────
class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  int _step = 0; // 0 = symptoms, 1 = severity, 2 = result
  final Set<String> _selectedSymptoms = {};
  int _severityLevel = 2; // 0-4
  String _resultSpecialty = '';

  static const Map<String, List<String>> _symptomGroups = {
    'Head & Mind': ['Headache', 'Dizziness', 'Memory issues', 'Seizures'],
    'Heart & Chest': ['Chest pain', 'Shortness of breath', 'Palpitations', 'Fatigue'],
    'Skin': ['Rashes', 'Acne', 'Itching', 'Hair loss'],
    'Bones & Joints': ['Joint pain', 'Back pain', 'Swelling', 'Fracture'],
    'General': ['Fever', 'Nausea', 'Weight loss', 'Insomnia'],
  };

  static const Map<String, String> _symptomToSpecialty = {
    'Headache': 'Neurologist', 'Dizziness': 'Neurologist', 'Memory issues': 'Neurologist', 'Seizures': 'Neurologist',
    'Chest pain': 'Cardiologist', 'Shortness of breath': 'Cardiologist', 'Palpitations': 'Cardiologist', 'Fatigue': 'Cardiologist',
    'Rashes': 'Dermatologist', 'Acne': 'Dermatologist', 'Itching': 'Dermatologist', 'Hair loss': 'Dermatologist',
    'Joint pain': 'Orthopedics', 'Back pain': 'Orthopedics', 'Swelling': 'Orthopedics', 'Fracture': 'Orthopedics',
    'Fever': 'General Physician', 'Nausea': 'General Physician', 'Weight loss': 'General Physician', 'Insomnia': 'Neurologist',
  };

  void _analyzeSymptoms() {
    final Map<String, int> votes = {};
    for (final s in _selectedSymptoms) {
      final spec = _symptomToSpecialty[s] ?? 'General Physician';
      votes[spec] = (votes[spec] ?? 0) + 1;
    }
    final sorted = votes.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    _resultSpecialty = sorted.isNotEmpty ? sorted.first.key : 'General Physician';
    setState(() => _step = 2);
  }

  Doctor? _getRecommendedDoctor() {
    try {
      return mockDoctors.firstWhere((d) => d.specialty == _resultSpecialty);
    } catch (_) {
      return mockDoctors.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (_step > 0) { setState(() => _step--); } else { Navigator.pop(context); }
          },
        ),
        title: const Text('Symptom Checker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _step == 0 ? _buildStep1() : _step == 1 ? _buildStep2() : _buildStep3(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (i) {
          return Expanded(
            child: Container(
              height: 5,
              margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
              decoration: BoxDecoration(
                color: i <= _step ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── STEP 1: Select Symptoms ──
  Widget _buildStep1() {
    return Column(
      key: const ValueKey('step1'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('What symptoms are you experiencing?', style: AppStyles.h2),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Select all that apply', style: AppStyles.body),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: _symptomGroups.entries.map((group) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.key, style: AppStyles.h3.copyWith(fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10, runSpacing: 10,
                    children: group.value.map((symptom) {
                      final isSelected = _selectedSymptoms.contains(symptom);
                      return GestureDetector(
                        onTap: () => setState(() {
                          isSelected ? _selectedSymptoms.remove(symptom) : _selectedSymptoms.add(symptom);
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                            boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))] : [],
                          ),
                          child: Text(symptom, style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        ),
        _buildNextButton('Continue', _selectedSymptoms.isNotEmpty ? () => setState(() => _step = 1) : null),
      ],
    );
  }

  // ── STEP 2: Severity ──
  Widget _buildStep2() {
    final labels = ['Very Mild', 'Mild', 'Moderate', 'Severe', 'Very Severe'];
    final colors = [Colors.green, Colors.lightGreen, Colors.orange, Colors.deepOrange, Colors.red];
    return Column(
      key: const ValueKey('step2'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('How severe are your symptoms?', style: AppStyles.h2),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Selected: ${_selectedSymptoms.join(", ")}', style: AppStyles.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        const Spacer(),
        Text(labels[_severityLevel], style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: colors[_severityLevel])),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          width: 100, height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors[_severityLevel].withOpacity(0.1),
            border: Border.all(color: colors[_severityLevel], width: 4),
          ),
          child: Center(
            child: Text(_severityEmoji(_severityLevel), style: const TextStyle(fontSize: 48)),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: colors[_severityLevel],
              inactiveTrackColor: AppColors.border,
              thumbColor: colors[_severityLevel],
              overlayColor: colors[_severityLevel].withOpacity(0.15),
              trackHeight: 6,
            ),
            child: Slider(
              value: _severityLevel.toDouble(),
              min: 0, max: 4, divisions: 4,
              onChanged: (v) => setState(() => _severityLevel = v.round()),
            ),
          ),
        ),
        const Spacer(),
        _buildNextButton('Analyze Symptoms', () => _analyzeSymptoms()),
      ],
    );
  }

  String _severityEmoji(int level) {
    const emojis = ['😊', '🙂', '😐', '😣', '🤒'];
    return emojis[level];
  }

  // ── STEP 3: Result ──
  Widget _buildStep3(BuildContext context) {
    final doc = _getRecommendedDoctor();
    return SingleChildScrollView(
      key: const ValueKey('step3'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 56),
                const SizedBox(height: 16),
                const Text('Analysis Complete', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Based on your symptoms, we recommend:', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text(_resultSpecialty, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Align(alignment: Alignment.centerLeft, child: Text('Your Symptoms', style: AppStyles.h3)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _selectedSymptoms.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
              child: Text(s, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
            )).toList(),
          ),
          if (doc != null) ...[
            const SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: Text('Recommended Doctor', style: AppStyles.h3)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctor: doc))),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface, borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(doc.imageUrl, width: 72, height: 72, fit: BoxFit.cover)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc.name, style: AppStyles.h3.copyWith(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(doc.specialty, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.star_rounded, color: AppColors.rating, size: 16),
                            const SizedBox(width: 4),
                            Text('${doc.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(' • ${doc.experience} yrs exp', style: AppStyles.body.copyWith(fontSize: 12)),
                          ]),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (doc != null) Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(doctor: doc)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0),
              child: const Text('Book This Specialist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, height: 56,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.border, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNextButton(String label, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.border,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NEW MODELS FOR EXPANDED FEATURES
// ─────────────────────────────────────────────
class MedicalRecord {
  final String id, title, category, date, doctorName, description, fileType;
  MedicalRecord({required this.id, required this.title, required this.category, required this.date, required this.doctorName, required this.description, this.fileType = 'pdf'});
}

class Review {
  final String id, patientName, patientImage, comment, date;
  final double rating;
  Review({required this.id, required this.patientName, required this.patientImage, required this.rating, required this.comment, required this.date});
}

class PatientRecord {
  final String id, name, age, gender, imageUrl, lastVisit, condition, bloodType;
  final List<String> allergies;
  PatientRecord({required this.id, required this.name, required this.age, required this.gender, required this.imageUrl, required this.lastVisit, required this.condition, this.allergies = const [], this.bloodType = 'O+'});
}

class EarningsData {
  final String month; final double amount; final int consultations;
  EarningsData({required this.month, required this.amount, required this.consultations});
}

class PrescriptionMedicine {
  final String name, dosage, frequency, duration, instructions;
  PrescriptionMedicine({required this.name, required this.dosage, required this.frequency, required this.duration, this.instructions = ''});
}

class PrescriptionData {
  final String id, patientName, diagnosis, date, doctorName, notes;
  final List<PrescriptionMedicine> medicines;
  PrescriptionData({required this.id, required this.patientName, required this.diagnosis, required this.medicines, required this.date, required this.doctorName, this.notes = ''});
}

// ── Mock Data ──
final List<MedicalRecord> mockRecords = [
  MedicalRecord(id: 'r1', title: 'Complete Blood Count', category: 'Lab Report', date: 'Oct 15, 2023', doctorName: 'Dr. Sarah Jenkins', description: 'All values normal. WBC: 7.2, RBC: 4.8, Hb: 14.2'),
  MedicalRecord(id: 'r2', title: 'Chest X-Ray', category: 'Imaging', date: 'Oct 10, 2023', doctorName: 'Dr. Sarah Jenkins', description: 'No abnormalities detected.', fileType: 'image'),
  MedicalRecord(id: 'r3', title: 'Skin Care Rx', category: 'Prescription', date: 'Sep 05, 2023', doctorName: 'Dr. Emily Carter', description: 'Tretinoin 0.025%, Niacinamide. 3 months.'),
  MedicalRecord(id: 'r4', title: 'COVID-19 Vaccine', category: 'Vaccine', date: 'Aug 20, 2023', doctorName: 'Dr. James Wilson', description: 'Covishield Dose 2 administered.'),
  MedicalRecord(id: 'r5', title: 'Lipid Profile', category: 'Lab Report', date: 'Jul 12, 2023', doctorName: 'Dr. Sarah Jenkins', description: 'Cholesterol: 185, HDL: 52, LDL: 108'),
  MedicalRecord(id: 'r6', title: 'MRI Brain', category: 'Imaging', date: 'Jun 28, 2023', doctorName: 'Dr. Michael Chen', description: 'Normal morphology.', fileType: 'image'),
];
final List<Review> mockReviews = [
  Review(id: 'v1', patientName: 'Ananya Gupta', patientImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100', rating: 5, comment: 'Wonderful doctor! Explained everything clearly.', date: 'Oct 20, 2023'),
  Review(id: 'v2', patientName: 'Rahul Verma', patientImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=100', rating: 5, comment: 'Best doctor ever. Thorough examination.', date: 'Oct 15, 2023'),
  Review(id: 'v3', patientName: 'Meera Patel', patientImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=100', rating: 4, comment: 'Great experience overall.', date: 'Oct 8, 2023'),
  Review(id: 'v4', patientName: 'Vikram Singh', patientImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=100', rating: 5, comment: 'Very knowledgeable and caring.', date: 'Sep 28, 2023'),
];
final List<PatientRecord> mockPatients = [
  PatientRecord(id: 'p1', name: 'Sanya Sharma', age: '24', gender: 'Female', imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=150', lastVisit: 'Oct 24', condition: 'Hypertension', allergies: ['Penicillin'], bloodType: 'B+'),
  PatientRecord(id: 'p2', name: 'Arjun Mehta', age: '35', gender: 'Male', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150', lastVisit: 'Oct 20', condition: 'Arrhythmia', bloodType: 'O+'),
  PatientRecord(id: 'p3', name: 'Priya Nair', age: '42', gender: 'Female', imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150', lastVisit: 'Oct 18', condition: 'Atrial Fibrillation', allergies: ['Aspirin'], bloodType: 'A+'),
  PatientRecord(id: 'p4', name: 'Karan Johar', age: '55', gender: 'Male', imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=150', lastVisit: 'Oct 10', condition: 'Heart Failure', allergies: ['Ibuprofen'], bloodType: 'AB+'),
];
final List<EarningsData> mockEarnings = [
  EarningsData(month: 'May', amount: 18500, consultations: 142), EarningsData(month: 'Jun', amount: 22300, consultations: 168),
  EarningsData(month: 'Jul', amount: 19800, consultations: 155), EarningsData(month: 'Aug', amount: 25600, consultations: 192),
  EarningsData(month: 'Sep', amount: 28400, consultations: 210), EarningsData(month: 'Oct', amount: 31200, consultations: 238),
];
final List<PrescriptionData> mockRx = [
  PrescriptionData(id: 'px1', patientName: 'Sanya Sharma', diagnosis: 'Hypertension Stage 1', date: 'Oct 24, 2023', doctorName: 'Dr. Sarah Jenkins', notes: 'Reduce sodium.',
    medicines: [PrescriptionMedicine(name: 'Amlodipine', dosage: '5mg', frequency: 'Once daily', duration: '30 days', instructions: 'Morning'), PrescriptionMedicine(name: 'Losartan', dosage: '50mg', frequency: 'Once daily', duration: '30 days')]),
  PrescriptionData(id: 'px2', patientName: 'Arjun Mehta', diagnosis: 'Cardiac Arrhythmia', date: 'Oct 20, 2023', doctorName: 'Dr. Sarah Jenkins', notes: 'ECG follow-up in 2 weeks.',
    medicines: [PrescriptionMedicine(name: 'Metoprolol', dosage: '25mg', frequency: 'Twice daily', duration: '14 days'), PrescriptionMedicine(name: 'Aspirin', dosage: '75mg', frequency: 'Once daily', duration: '30 days')]),
];

// ─────────────────────────────────────────────
// DOCTOR SEARCH SCREEN
// ─────────────────────────────────────────────
class DoctorSearchScreen extends StatefulWidget {
  final String? initialSpecialty;
  const DoctorSearchScreen({super.key, this.initialSpecialty});
  @override State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}
class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  String _q = ''; String? _spec; double _minR = 0; String _sort = 'Rating';
  final _specs = ['All','Cardiologist','Neurologist','Dermatologist','Orthopedics'];
  @override void initState() { super.initState(); _spec = widget.initialSpecialty; }
  List<Doctor> get _res {
    var l = mockDoctors.where((d) {
      if (_q.isNotEmpty && !d.name.toLowerCase().contains(_q.toLowerCase()) && !d.specialty.toLowerCase().contains(_q.toLowerCase())) return false;
      if (_spec != null && _spec != 'All' && d.specialty != _spec) return false;
      if (d.rating < _minR) return false; return true;
    }).toList();
    if (_sort == 'Rating') l.sort((a, b) => b.rating.compareTo(a.rating));
    if (_sort == 'Experience') l.sort((a, b) => b.experience.compareTo(a.experience));
    return l;
  }
  @override Widget build(BuildContext context) {
    final r = _res;
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Find Doctors', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {
          showModalBottomSheet(context: context, backgroundColor: AppColors.surface, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            builder: (_) => StatefulBuilder(builder: (c, sS) => Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20), Text('Filters', style: AppStyles.h2), const SizedBox(height: 16),
              Text('Min Rating: ${_minR.toStringAsFixed(1)}', style: AppStyles.h3.copyWith(fontSize: 14)),
              Slider(value: _minR, min: 0, max: 5, divisions: 10, activeColor: AppColors.rating, onChanged: (v) => sS(() => _minR = v)),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { setState(() {}); Navigator.pop(c); },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
              const SizedBox(height: 16),
            ]))));
        })]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(24, 8, 24, 0), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withValues(alpha: 0.5))),
          child: TextField(onChanged: (v) => setState(() => _q = v), decoration: InputDecoration(icon: Icon(Icons.search, color: AppColors.textSecondary), hintText: 'Search doctors...', hintStyle: TextStyle(color: AppColors.textSecondary), border: InputBorder.none)))),
        const SizedBox(height: 12),
        SizedBox(height: 40, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 24), scrollDirection: Axis.horizontal, itemCount: _specs.length, separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) { final s = _specs[i]; final sel = (_spec ?? 'All') == s;
            return GestureDetector(onTap: () => setState(() => _spec = s == 'All' ? null : s),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: sel ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: sel ? AppColors.primary : AppColors.border)),
                child: Center(child: Text(s, style: TextStyle(color: sel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13))))); })),
        Padding(padding: const EdgeInsets.all(24), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${r.length} found', style: AppStyles.caption),
          GestureDetector(onTap: () => setState(() => _sort = _sort == 'Rating' ? 'Experience' : 'Rating'),
            child: Row(children: [const Icon(Icons.sort, size: 16, color: AppColors.primary), const SizedBox(width: 4), Text(_sort, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13))]))])),
        Expanded(child: r.isEmpty ? Center(child: Text('No doctors found', style: AppStyles.h3))
          : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 24), itemCount: r.length, itemBuilder: (_, i) {
            final d = r[i];
            return GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctor: d))),
              child: Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
                child: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.network(d.imageUrl, width: 75, height: 75, fit: BoxFit.cover)), const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.name, style: AppStyles.h3.copyWith(fontSize: 16)), const SizedBox(height: 4),
                    Text('${d.specialty} • ${d.hospital}', style: AppStyles.body.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 8),
                    Row(children: [const Icon(Icons.star_rounded, color: AppColors.rating, size: 14), Text(' ${d.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.rating)),
                      const SizedBox(width: 8), Text('${d.experience} yrs', style: AppStyles.caption)])
                  ]))])));
          })),
      ]));
  }
}

// ─────────────────────────────────────────────
// MEDICAL RECORDS VAULT
// ─────────────────────────────────────────────
class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});
  @override State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}
class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  String _selCat = 'All';
  final _cats = ['All', 'Lab Report', 'Imaging', 'Prescription', 'Vaccine'];
  List<MedicalRecord> get _filtered => _selCat == 'All' ? mockRecords : mockRecords.where((r) => r.category == _selCat).toList();

  IconData _catIcon(String c) => switch (c) { 'Lab Report' => Icons.science_rounded, 'Imaging' => Icons.image_rounded, 'Prescription' => Icons.receipt_long_rounded, 'Vaccine' => Icons.vaccines_rounded, _ => Icons.folder_rounded };
  Color _catColor(String c) => switch (c) { 'Lab Report' => AppColors.primary, 'Imaging' => AppColors.accent, 'Prescription' => AppColors.accentGreen, 'Vaccine' => const Color(0xFFFF8E53), _ => AppColors.textSecondary };

  @override Widget build(BuildContext context) {
    final recs = _filtered;
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Medical Records', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.upload_file_rounded), onPressed: () => _showUploadDialog())]),
      body: Column(children: [
        // Vault status
        Container(margin: const EdgeInsets.fromLTRB(24, 8, 24, 16), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF22D38F), Color(0xFF00D1FF)]), borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 24)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Encrypted Vault', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              Text('${mockRecords.length} documents stored securely', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
            ])),
          ])),
        // Category chips
        SizedBox(height: 40, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 24), scrollDirection: Axis.horizontal, itemCount: _cats.length, separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) { final c = _cats[i]; final sel = _selCat == c;
            return GestureDetector(onTap: () => setState(() => _selCat = c),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: sel ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: sel ? AppColors.primary : AppColors.border)),
                child: Center(child: Text(c, style: TextStyle(color: sel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13))))); })),
        const SizedBox(height: 16),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 24), physics: const BouncingScrollPhysics(), itemCount: recs.length,
          itemBuilder: (_, i) { final r = recs[i]; final col = _catColor(r.category);
            return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: col.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                  child: Icon(_catIcon(r.category), color: col, size: 24)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(r.description, style: AppStyles.body.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Text(r.date, style: AppStyles.caption),
                    const SizedBox(width: 12), Icon(Icons.person, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Text(r.doctorName, style: AppStyles.caption)]),
                ])),
                Column(children: [
                  Icon(r.fileType == 'image' ? Icons.image_rounded : Icons.picture_as_pdf_rounded, color: col, size: 20),
                  const SizedBox(height: 8),
                  Icon(Icons.share_rounded, color: AppColors.textSecondary, size: 18),
                ]),
              ])); })),
      ]),
    );
  }
  void _showUploadDialog() {
    showDialog(context: context, builder: (_) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)), backgroundColor: AppColors.surface,
      child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.cloud_upload_rounded, color: AppColors.primary, size: 48)),
        const SizedBox(height: 20), Text('Upload Document', style: AppStyles.h2), const SizedBox(height: 8),
        Text('Select a file to upload to your vault', style: AppStyles.body, textAlign: TextAlign.center), const SizedBox(height: 24),
        Row(children: [
          _uploadOption(Icons.camera_alt_rounded, 'Camera', AppColors.primary),
          const SizedBox(width: 16),
          _uploadOption(Icons.photo_library_rounded, 'Gallery', AppColors.accent),
          const SizedBox(width: 16),
          _uploadOption(Icons.insert_drive_file_rounded, 'Files', AppColors.accentGreen),
        ]),
        const SizedBox(height: 20),
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
      ]))));
  }
  Widget _uploadOption(IconData icon, String label, Color color) {
    return Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(children: [Icon(icon, color: color, size: 28), const SizedBox(height: 8), Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12))])));
  }
}

// ─────────────────────────────────────────────
// DOCTOR REVIEWS SCREEN
// ─────────────────────────────────────────────
class DoctorReviewsScreen extends StatefulWidget {
  final Doctor doctor;
  const DoctorReviewsScreen({super.key, required this.doctor});
  @override State<DoctorReviewsScreen> createState() => _DoctorReviewsScreenState();
}
class _DoctorReviewsScreenState extends State<DoctorReviewsScreen> {
  bool _showWriteReview = false;
  int _userRating = 0;
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Reviews (${widget.doctor.reviews})', style: const TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), physics: const BouncingScrollPhysics(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Rating summary
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
          child: Row(children: [
            Column(children: [
              Text('${widget.doctor.rating}', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Row(children: List.generate(5, (i) => Icon(i < widget.doctor.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded, color: AppColors.rating, size: 20))),
              const SizedBox(height: 4), Text('${widget.doctor.reviews} reviews', style: AppStyles.caption),
            ]),
            const SizedBox(width: 24),
            Expanded(child: Column(children: [
              _ratingBar(5, 0.7), _ratingBar(4, 0.2), _ratingBar(3, 0.05), _ratingBar(2, 0.03), _ratingBar(1, 0.02),
            ])),
          ])),
        const SizedBox(height: 24),
        // Write review button
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(
          onPressed: () => setState(() => _showWriteReview = !_showWriteReview),
          icon: const Icon(Icons.edit_rounded, size: 18), label: const Text('Write a Review', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
        if (_showWriteReview) ...[
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Your Rating', style: AppStyles.h3.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              Row(children: List.generate(5, (i) => GestureDetector(onTap: () => setState(() => _userRating = i + 1),
                child: Padding(padding: const EdgeInsets.only(right: 4), child: Icon(i < _userRating ? Icons.star_rounded : Icons.star_outline_rounded, color: AppColors.rating, size: 32))))),
              const SizedBox(height: 12),
              TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Share your experience...', hintStyle: TextStyle(color: AppColors.textSecondary), filled: true, fillColor: AppColors.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, height: 44, child: ElevatedButton(onPressed: () => setState(() => _showWriteReview = false),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Submit Review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            ])),
        ],
        const SizedBox(height: 24),
        Text('All Reviews', style: AppStyles.h3),
        const SizedBox(height: 16),
        ...mockReviews.map((r) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(r.patientImage)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.patientName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                Text(r.date, style: AppStyles.caption),
              ])),
              Row(children: List.generate(5, (i) => Icon(i < r.rating ? Icons.star_rounded : Icons.star_outline_rounded, color: AppColors.rating, size: 14))),
            ]),
            const SizedBox(height: 12),
            Text(r.comment, style: AppStyles.body),
          ]))),
      ])),
    );
  }
  Widget _ratingBar(int star, double pct) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
    Text('$star', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
    const SizedBox(width: 8),
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, backgroundColor: AppColors.border, valueColor: AlwaysStoppedAnimation(AppColors.rating), minHeight: 6))),
  ]));
}

// ─────────────────────────────────────────────
// DOCTOR DASHBOARD
// ─────────────────────────────────────────────
class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});
  @override Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(24, 60, 24, 120), physics: const BouncingScrollPhysics(), children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome back,', style: AppStyles.body.copyWith(fontSize: 15)),
          const SizedBox(height: 4),
          ShaderMask(shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
            child: Text('Dr. Sarah 👩‍⚕️', style: AppStyles.h1.copyWith(color: Colors.white))),
        ]),
        GestureDetector(onTap: () { isDoctorMode.value = false; },
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.accentGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.swap_horiz, color: AppColors.accentGreen, size: 16), SizedBox(width: 4), Text('Patient', style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 12))]))),
      ]),
      const SizedBox(height: 24),
      // Stats row
      Row(children: [
        _statCard('Today', '8', Icons.calendar_today_rounded, AppColors.primary),
        const SizedBox(width: 12),
        _statCard('Patients', '${mockPatients.length}', Icons.people_rounded, AppColors.accent),
        const SizedBox(width: 12),
        _statCard('Revenue', '\$31.2K', Icons.trending_up_rounded, AppColors.accentGreen),
      ]),
      const SizedBox(height: 28),
      // Quick actions
      Text('Quick Actions', style: AppStyles.h3), const SizedBox(height: 16),
      Row(children: [
        _actionBtn(context, Icons.receipt_long_rounded, 'Prescribe', AppColors.primary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EPrescriptionScreen()))),
        const SizedBox(width: 12),
        _actionBtn(context, Icons.people_alt_rounded, 'Patients', AppColors.accent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientHistoryScreen()))),
        const SizedBox(width: 12),
        _actionBtn(context, Icons.bar_chart_rounded, 'Earnings', const Color(0xFFFF8E53), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningsScreen()))),
        const SizedBox(width: 12),
        _actionBtn(context, Icons.event_busy_rounded, 'Schedule', AppColors.danger, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorScheduleMgmtScreen()))),
      ]),
      const SizedBox(height: 28),
      Text("Today's Appointments", style: AppStyles.h3), const SizedBox(height: 16),
      ...mockPatients.take(3).map((p) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
        child: Row(children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(p.imageUrl)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
            Text(p.condition, style: AppStyles.caption),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(10)),
            child: const Text('Start', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
        ]))),
    ]);
  }
  static Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(child: Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 12),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        Text(label, style: AppStyles.caption),
      ])));
  }
  static Widget _actionBtn(BuildContext ctx, IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
      child: Column(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 8), Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ]))));
  }
}

// ─────────────────────────────────────────────
// PATIENT HISTORY SCREEN (Doctor side)
// ─────────────────────────────────────────────
class PatientHistoryScreen extends StatelessWidget {
  const PatientHistoryScreen({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Patients', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context))),
      body: ListView.builder(padding: const EdgeInsets.all(24), physics: const BouncingScrollPhysics(), itemCount: mockPatients.length,
        itemBuilder: (_, i) { final p = mockPatients[i];
          return GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PatientDetailScreen(patient: p))),
            child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(gradient: AppColors.surfaceGradient, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
              child: Row(children: [
                CircleAvatar(radius: 28, backgroundImage: NetworkImage(p.imageUrl)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('${p.age} yrs • ${p.gender} • ${p.bloodType}', style: AppStyles.caption),
                  const SizedBox(height: 4),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(p.condition, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600))),
                ])),
                Column(children: [
                  Text('Last visit', style: AppStyles.caption),
                  Text(p.lastVisit, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textPrimary)),
                ]),
              ])));
        }),
    );
  }
}

class PatientDetailScreen extends StatelessWidget {
  final PatientRecord patient;
  const PatientDetailScreen({super.key, required this.patient});
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), physics: const BouncingScrollPhysics(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Patient card
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(24)),
          child: Row(children: [
            CircleAvatar(radius: 36, backgroundImage: NetworkImage(patient.imageUrl)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(patient.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('${patient.age} yrs • ${patient.gender}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
              const SizedBox(height: 8),
              Row(children: [
                _tag('Blood: ${patient.bloodType}'), const SizedBox(width: 8),
                _tag(patient.condition),
              ]),
            ])),
          ])),
        const SizedBox(height: 20),
        if (patient.allergies.isNotEmpty) ...[
          Text('Allergies', style: AppStyles.h3), const SizedBox(height: 8),
          Wrap(spacing: 8, children: patient.allergies.map((a) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 14), const SizedBox(width: 4),
              Text(a, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600, fontSize: 12))]))).toList()),
          const SizedBox(height: 20),
        ],
        Text('Clinical Notes', style: AppStyles.h3), const SizedBox(height: 8),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: TextField(maxLines: 4, decoration: InputDecoration(hintText: 'Add notes for this patient...', hintStyle: TextStyle(color: AppColors.textSecondary), border: InputBorder.none))),
        const SizedBox(height: 20),
        Text('Visit History', style: AppStyles.h3), const SizedBox(height: 12),
        ...List.generate(3, (i) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.event_note_rounded, color: AppColors.primary, size: 18)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Visit ${3 - i}', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text('Oct ${10 + i * 5}, 2023 • ${patient.condition}', style: AppStyles.caption),
            ])),
          ]))),
      ])));
  }
  static Widget _tag(String t) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
    child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)));
}

// ─────────────────────────────────────────────
// E-PRESCRIPTION GENERATOR
// ─────────────────────────────────────────────
class EPrescriptionScreen extends StatefulWidget {
  const EPrescriptionScreen({super.key});
  @override State<EPrescriptionScreen> createState() => _EPrescriptionScreenState();
}
class _EPrescriptionScreenState extends State<EPrescriptionScreen> {
  final _patientCtrl = TextEditingController();
  final _diagnosisCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final List<Map<String, String>> _meds = [{'name': '', 'dosage': '', 'freq': '', 'dur': ''}];

  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('e-Prescription', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), physics: const BouncingScrollPhysics(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('New Prescription', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              Text('Dr. Sarah Jenkins', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
            ]),
          ])),
        const SizedBox(height: 24),
        _field('Patient Name', _patientCtrl, Icons.person_rounded),
        const SizedBox(height: 16),
        _field('Diagnosis', _diagnosisCtrl, Icons.medical_information_rounded),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Medications', style: AppStyles.h3),
          GestureDetector(onTap: () => setState(() => _meds.add({'name': '', 'dosage': '', 'freq': '', 'dur': ''})),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.accentGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add, color: AppColors.accentGreen, size: 16), SizedBox(width: 4), Text('Add', style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 12))]))),
        ]),
        const SizedBox(height: 12),
        ...List.generate(_meds.length, (i) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text('Medicine ${i + 1}', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const Spacer(), if (_meds.length > 1) GestureDetector(onTap: () => setState(() => _meds.removeAt(i)), child: const Icon(Icons.close, color: AppColors.danger, size: 18))]),
            const SizedBox(height: 10),
            _miniField('Name', 'e.g., Amlodipine'),
            const SizedBox(height: 8),
            Row(children: [Expanded(child: _miniField('Dosage', '5mg')), const SizedBox(width: 8), Expanded(child: _miniField('Frequency', 'Once daily'))]),
            const SizedBox(height: 8),
            _miniField('Duration', '30 days'),
          ]))),
        const SizedBox(height: 16),
        Text('Additional Notes', style: AppStyles.h3), const SizedBox(height: 8),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: TextField(controller: _notesCtrl, maxLines: 3, decoration: InputDecoration(hintText: 'Instructions, follow-up...', hintStyle: TextStyle(color: AppColors.textSecondary), border: InputBorder.none))),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.preview_rounded), label: const Text('Preview'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton.icon(onPressed: () => _showSentDialog(), icon: const Icon(Icons.send_rounded, size: 18), label: const Text('Send', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
        ]),
      ])));
  }
  Widget _field(String label, TextEditingController ctrl, IconData icon) => Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
    child: TextField(controller: ctrl, decoration: InputDecoration(icon: Icon(icon, color: AppColors.primary), labelText: label, labelStyle: TextStyle(color: AppColors.textSecondary), border: InputBorder.none)));
  Widget _miniField(String label, String hint) => TextField(decoration: InputDecoration(labelText: label, hintText: hint, labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12), hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 13),
    isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), filled: true, fillColor: AppColors.background, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)));
  void _showSentDialog() {
    showDialog(context: context, builder: (_) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)), backgroundColor: AppColors.surface,
      child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.accentGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 56)),
        const SizedBox(height: 20), Text('Prescription Sent!', style: AppStyles.h2), const SizedBox(height: 8),
        Text('The prescription has been sent to the patient.', style: AppStyles.body, textAlign: TextAlign.center), const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
      ]))));
  }
}

// ─────────────────────────────────────────────
// EARNINGS / ANALYTICS DASHBOARD
// ─────────────────────────────────────────────
class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});
  @override Widget build(BuildContext context) {
    final total = mockEarnings.fold<double>(0, (s, e) => s + e.amount);
    final totalC = mockEarnings.fold<int>(0, (s, e) => s + e.consultations);
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Earnings', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), physics: const BouncingScrollPhysics(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Total earnings card
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(24), boxShadow: AppColors.primaryGlow(opacity: 0.3)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Total Earnings', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
            const SizedBox(height: 8),
            Text('\$${(total / 1000).toStringAsFixed(1)}K', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.trending_up, color: Colors.white, size: 14), SizedBox(width: 4), Text('+12.5%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))])),
              const SizedBox(width: 12), Text('$totalC consultations', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
            ]),
          ])),
        const SizedBox(height: 24),
        // Chart
        Text('Monthly Revenue', style: AppStyles.h3), const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(20), height: 200, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: mockEarnings.map((e) {
            final pct = e.amount / 35000;
            return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('\$${(e.amount / 1000).toStringAsFixed(1)}K', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              AnimatedContainer(duration: const Duration(milliseconds: 500), height: 120 * pct, decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 8),
              Text(e.month, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ])));
          }).toList())),
        const SizedBox(height: 24),
        Text('Breakdown', style: AppStyles.h3), const SizedBox(height: 12),
        _breakdownItem('In-Person', 156, AppColors.primary, 0.6),
        _breakdownItem('Video Call', 62, AppColors.accent, 0.24),
        _breakdownItem('Chat', 20, AppColors.accentGreen, 0.16),
        const SizedBox(height: 24),
        Text('Monthly Details', style: AppStyles.h3), const SizedBox(height: 12),
        ...mockEarnings.reversed.map((e) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.month, style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('${e.consultations} consultations', style: AppStyles.caption),
            ])),
            Text('\$${e.amount.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.primary)),
          ]))),
      ])));
  }
  Widget _breakdownItem(String label, int count, Color color, double pct) => Container(margin: const EdgeInsets.only(bottom: 8), child: Row(children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
    const SizedBox(width: 8), Expanded(child: Text(label, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13))),
    Text('$count', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    const SizedBox(width: 8), Text('${(pct * 100).toInt()}%', style: AppStyles.caption),
  ]));
}

// ─────────────────────────────────────────────
// DOCTOR SCHEDULE MANAGEMENT
// ─────────────────────────────────────────────
class DoctorScheduleMgmtScreen extends StatefulWidget {
  const DoctorScheduleMgmtScreen({super.key});
  @override State<DoctorScheduleMgmtScreen> createState() => _DoctorScheduleMgmtScreenState();
}
class _DoctorScheduleMgmtScreenState extends State<DoctorScheduleMgmtScreen> {
  final _slots = ['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:30 PM', '04:00 PM'];
  final Set<String> _blocked = {'11:00 AM'};
  final _leaves = <Map<String, String>>[
    {'date': 'Nov 14, 2023', 'reason': 'Personal Leave', 'type': 'Full Day'},
    {'date': 'Dec 25, 2023', 'reason': 'Christmas', 'type': 'Holiday'},
    {'date': 'Jan 26, 2024', 'reason': 'Republic Day', 'type': 'Holiday'},
  ];

  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Schedule Management', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), physics: const BouncingScrollPhysics(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Time Slots', style: AppStyles.h3), const SizedBox(height: 4),
        Text('Toggle slots on/off for availability', style: AppStyles.body), const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: _slots.map((s) {
          final blocked = _blocked.contains(s);
          return GestureDetector(onTap: () => setState(() => blocked ? _blocked.remove(s) : _blocked.add(s)),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: (MediaQuery.of(context).size.width - 58) / 3, padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: blocked ? AppColors.danger.withValues(alpha: 0.1) : AppColors.accentGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14), border: Border.all(color: blocked ? AppColors.danger : AppColors.accentGreen)),
              child: Column(children: [
                Icon(blocked ? Icons.block_rounded : Icons.check_circle_rounded, color: blocked ? AppColors.danger : AppColors.accentGreen, size: 20),
                const SizedBox(height: 6),
                Text(s, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: blocked ? AppColors.danger : AppColors.accentGreen)),
              ])));
        }).toList()),
        const SizedBox(height: 28),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Leaves & Holidays', style: AppStyles.h3),
          GestureDetector(onTap: _addLeave, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add, color: AppColors.primary, size: 16), SizedBox(width: 4), Text('Add', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12))]))),
        ]),
        const SizedBox(height: 12),
        ..._leaves.map((l) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
              color: (l['type'] == 'Holiday' ? AppColors.rating : AppColors.danger).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(l['type'] == 'Holiday' ? Icons.celebration_rounded : Icons.event_busy_rounded, color: l['type'] == 'Holiday' ? AppColors.rating : AppColors.danger, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l['reason']!, style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('${l['date']} • ${l['type']}', style: AppStyles.caption),
            ])),
            GestureDetector(onTap: () => setState(() => _leaves.remove(l)),
              child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20)),
          ]))),
      ])));
  }
  void _addLeave() {
    showDialog(context: context, builder: (_) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), backgroundColor: AppColors.surface,
      child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Add Leave', style: AppStyles.h2), const SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: 'Reason', filled: true, fillColor: AppColors.background, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: 'Date (e.g., Nov 20, 2023)', filled: true, fillColor: AppColors.background, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: () { setState(() => _leaves.add({'date': 'Nov 20, 2023', 'reason': 'Personal', 'type': 'Full Day'})); Navigator.pop(context); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          child: const Text('Add Leave', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
      ]))));
  }
}
