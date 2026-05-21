import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app.dart';
import '../../../core/common_widgets/spine_background.dart';
import 'discover_tab.dart';
import 'market_tab.dart';
import 'wallet_tab.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({Key? key}) : super(key: key);

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _isAmharic = false;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  // Mock data for Top Trending Creators
  final List<Map<String, dynamic>> _creators = [
    {
      'nickname': 'Teddy Afro',
      'avatarUrl': 'assets/images/creator_teddy_afro.jpg',
      'isVerified': true,
      'gradient': [Color(0xFFD4AF37), Color(0xFFFFDF73)],
    },
    {
      'nickname': 'Aster Aweke',
      'avatarUrl': 'assets/images/creator_aster_aweke.jpg',
      'isVerified': true,
      'gradient': [Color(0xFF1D9BF0), Color(0xFF80D0FF)],
    },
    {
      'nickname': 'Rophnan',
      'avatarUrl': 'assets/images/creator_rophnan.jpg',
      'isVerified': true,
      'gradient': [Color(0xFFE040FB), Color(0xFFF3E5F5)],
    },
    {
      'nickname': 'Zeritu Kebede',
      'avatarUrl': 'assets/images/creator_zeritu_kebede.jpg',
      'isVerified': true,
      'gradient': [Color(0xFF00E676), Color(0xFFB9F6CA)],
    },
    {
      'nickname': 'Jah Lude',
      'avatarUrl': 'assets/images/creator_jah_lude.jpg',
      'isVerified': true,
      'gradient': [Color(0xFFFF5252), Color(0xFFFF8A80)],
    },
    {
      'nickname': 'Abinet Agonafer',
      'avatarUrl': 'assets/images/creator_abinet_agonafer.jpg',
      'isVerified': true,
      'gradient': [Color(0xFF00B0FF), Color(0xFF80D8FF)],
    },
    {
      'nickname': 'Abel Birhanu',
      'avatarUrl': 'assets/images/creator_abel_birhanu.jpg',
      'isVerified': true,
      'gradient': [Color(0xFFFF9800), Color(0xFFFFB74D)],
    },
    {
      'nickname': 'Adonay',
      'avatarUrl': 'assets/images/creator_adonay.jpg',
      'isVerified': true,
      'gradient': [Color(0xFFE91E63), Color(0xFFF06292)],
    },
    {
      'nickname': 'Jon Daniel',
      'avatarUrl': 'assets/images/creator_jon_daniel.jpg',
      'isVerified': true,
      'gradient': [Color(0xFF9C27B0), Color(0xFFBA68C8)],
    },
    {
      'nickname': 'Ethio Tech',
      'avatarUrl': 'assets/images/creator_ethio_tech.jpg',
      'isVerified': true,
      'gradient': [Color(0xFF2196F3), Color(0xFF64B5F6)],
    },
    {
      'nickname': 'Miko Mikee',
      'avatarUrl': 'assets/images/creator_miko_mikee.jpg',
      'isVerified': true,
      'gradient': [Color(0xFF4CAF50), Color(0xFF81C784)],
    },
    {
      'nickname': 'Seifu on EBS',
      'avatarUrl': 'assets/images/creator_seifu_ebs.jpg',
      'isVerified': true,
      'gradient': [Color(0xFFF44336), Color(0xFFE57373)],
    },
  ];

  // Mock data for Exclusive First
  final List<Map<String, dynamic>> _exclusiveReleases = [
    {
      'title': 'Sememen (ሰመመን) - Acoustic Session Live',
      'creatorName': 'Teddy Afro',
      'avatarUrl': 'assets/images/creator_teddy_afro.jpg',
      'countdown': '02:14:05',
      'views': '45.2K views',
      'coverUrl': 'assets/images/exclusive_sememen.jpg',
    },
    {
      'title': 'Sidama (ሲዳማ) - Behind the Beats',
      'creatorName': 'Rophnan',
      'avatarUrl': 'assets/images/creator_rophnan.jpg',
      'countdown': '05:32:18',
      'views': '31.8K views',
      'coverUrl': 'assets/images/exclusive_sidama.jpg',
    },
    {
      'title': 'Saba (ሳባ) - Digital Art Exhibition Intro',
      'creatorName': 'Aster Aweke',
      'avatarUrl': 'assets/images/creator_aster_aweke.jpg',
      'countdown': '01:05:42',
      'views': '12.4K views',
      'coverUrl': 'assets/images/exclusive_saba.jpg',
    },
  ];

  // Mock data for Trending Challenges
  final List<Map<String, dynamic>> _challenges = [
    {
      'title': 'Launch a new podcast series about Ethiopian History',
      'titleAmh': 'ስለ ኢትዮጵያ ታሪክ አዲስ ፖድካስት ይጀምሩ',
      'creatorName': 'Teddy Afro',
      'progress': 0.87,
      'participants': '1,740 participants',
      'timeLeft': '12d left',
      'imageUrl': 'assets/images/challenge_podcast.jpg',
    },
    {
      'title': 'Recreate the Saba beat drop using traditional instruments',
      'titleAmh': 'የሳባን የሙዚቃ ቅንብር በባህላዊ መሣሪያዎች ይጫወቱ',
      'creatorName': 'Rophnan',
      'progress': 0.54,
      'participants': '920 participants',
      'timeLeft': '4d left',
      'imageUrl': 'assets/images/challenge_saba_beat.jpg',
    },
    {
      'title': 'Write a 4-line poem inspired by Aster\'s "Kerebta"',
      'titleAmh': 'በአስቴር "ቀረብታ" አነሳሽነት ባለ 4 መስመር ግጥም ይጻፉ',
      'creatorName': 'Aster Aweke',
      'progress': 0.95,
      'participants': '2,410 participants',
      'timeLeft': '2d left',
      'imageUrl': 'assets/images/challenge_poetry.jpg',
    },
  ];

  // Mock data for Hot Charities / GoFundMe
  final List<Map<String, dynamic>> _charities = [
    {
      'title': 'Build a school in rural Ethiopia',
      'titleAmh': 'በገጠር ኢትዮጵያ ትምህርት ቤት እንገንባ',
      'creatorName': 'Abel Birhanu',
      'progress': 0.75,
      'donors': '3,240 donors',
      'timeLeft': '5d left',
      'imageUrl': 'assets/images/charity_school.jpg',
    },
    {
      'title': 'Medical support for artist health fund',
      'titleAmh': 'የህክምና ድጋፍ ለአርቲስቶች',
      'creatorName': 'Seifu on EBS',
      'progress': 0.42,
      'donors': '1,120 donors',
      'timeLeft': '18d left',
      'imageUrl': 'assets/images/charity_medical.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Exact requested theme specifications
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Scaffold Background: Light Mode (#FAFAFA) / Dark Mode (#121212)
    final Color scaffoldBgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
    
    // Primary Branding Highlight: Gold (#D4AF37)
    const Color primaryGold = Color(0xFFD4AF37);
    
    // Trust Badging Asset Fill: Blue (#1D9BF0)
    const Color trustBlue = Color(0xFF1D9BF0);

    // Text & subtle color logic
    final Color primaryTextColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color secondaryTextColor = isDark ? Colors.white.withOpacity(0.7) : const Color(0xFF555555);
    final Color cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color shadowColor = isDark ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.1);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      resizeToAvoidBottomInset: true, // Compile parameter enabled
      
      // PERSISTENT STICKY HEADER FRAME
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: scaffoldBgColor.withOpacity(0.85),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                    width: 1.0,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Far Left: Search Icon Button
                      IconButton(
                        icon: Icon(Icons.search, color: primaryTextColor, size: 26.0),
                        onPressed: () {
                          // Search configuration action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isAmharic ? 'ፍለጋ ገና አልተጀመረም' : 'Search is coming soon!'),
                              backgroundColor: primaryGold,
                            ),
                          );
                        },
                      ),

                      // Perfectly Centered Kerebta Gold Logotype Asset
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 32.0,
                            errorBuilder: (context, error, stackTrace) {
                              // Beautiful fallback in case the image is not ready/loaded
                              return const Icon(Icons.stars_rounded, color: primaryGold, size: 28.0);
                            },
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            _isAmharic ? "ቀረብታ" : "KEREBTA",
                            style: GoogleFonts.poppins(
                              color: primaryGold,
                              fontWeight: FontWeight.w900,
                              fontSize: 22.0,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),

                      // Far Right: Pinned Notifications with a red badge containing the number "1"
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: Icon(Icons.notifications_none, color: primaryTextColor, size: 26.0),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_isAmharic ? 'የቅርብ ጊዜ ማሳወቂያዎች የሉዎትም' : 'You have 1 unread notification!'),
                                  backgroundColor: primaryGold,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16.0,
                                minHeight: 16.0,
                              ),
                              child: const Center(
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // MAIN CONTENT SCROLL FEED
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),

            // SUB-HEADER FINANCIAL & UTILITY ROW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Far Left: Wallet Balance Button
                  GestureDetector(
                    onTap: () {
                      // Tap configurations routing to the app's wallet page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isAmharic ? 'ወደ የኪስ ቦርሳ ገጽ በመሄድ ላይ...' : 'Routing to Wallet page...'),
                          backgroundColor: primaryGold,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: primaryGold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: primaryGold.withOpacity(0.35), width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: primaryGold,
                            size: 18.0,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            "1,250 ETB",
                            style: GoogleFonts.poppins(
                              color: primaryGold,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Far Right: Configuration toggles side-by-side in a tight row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Interactive Theme Swapper button (flipping sun/moon icon imagery)
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: appThemeMode,
                        builder: (context, currentTheme, _) {
                          final isCurrentDark = currentTheme == ThemeMode.dark;
                          return GestureDetector(
                            onTap: () {
                              // Change the global theme notifier value dynamically!
                              appThemeMode.value = isCurrentDark ? ThemeMode.light : ThemeMode.dark;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: cardBgColor,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor,
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                                border: Border.all(
                                  color: isCurrentDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isCurrentDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                    color: primaryGold,
                                    size: 16.0,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    isCurrentDark ? "Light" : "Dark",
                                    style: GoogleFonts.poppins(
                                      color: primaryTextColor,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8.0),

                      // Language drop-pills wrapper on the right displaying Icons.language alongside text "English" or "አማርኛ"
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAmharic = !_isAmharic;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                blurRadius: 8.0,
                                offset: const Offset(0, 2),
                              )
                            ],
                            border: Border.all(
                              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language,
                                color: trustBlue,
                                size: 16.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                _isAmharic ? "አማ" : "Eng",
                                style: GoogleFonts.poppins(
                                  color: primaryTextColor,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            // TOP TRENDING CREATORS SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _isAmharic ? "ከፍተኛ ተወዳጅ ፈጣሪዎች" : "Top Trending Creators",
                style: GoogleFonts.poppins(
                  color: primaryTextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 14.0),
            
            // Scrolling Horizontal ListView of circular avatar profile frames (80x80 dp)
            SizedBox(
              height: 125.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: _creators.length,
                itemBuilder: (context, index) {
                  final creator = _creators[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        // Circular avatar picture frames (80x80 dp)
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: (creator['gradient'] as List<Color>?) ?? [Colors.grey, Colors.grey],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor,
                                    blurRadius: 6.0,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(3.0), // Outer border spacing
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: cardBgColor,
                                ),
                                padding: const EdgeInsets.all(2.0), // Inner border spacing
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: Image.asset(
                                    creator['avatarUrl'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: primaryGold.withOpacity(0.2),
                                        child: const Icon(
                                          Icons.person,
                                          color: primaryGold,
                                          size: 40.0,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            
                            // Distinct Verified Blue round checkmark indicator circle directly over the bottom-right margin boundary
                            Positioned(
                              bottom: 2.0,
                              right: 2.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardBgColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: trustBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        
                        // Nickname below the avatar
                        SizedBox(
                          width: 85.0,
                          child: Text(
                            creator['nickname'],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: primaryTextColor,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12.0),

            // EXCLUSIVE FIRST SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _isAmharic ? "ብቸኛ ቀዳሚዎች" : "Exclusive First",
                style: GoogleFonts.poppins(
                  color: primaryTextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 14.0),

            // Horizontal Viewport running large cinematic cards
            SizedBox(
              height: 240.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: _exclusiveReleases.length,
                itemBuilder: (context, index) {
                  final release = _exclusiveReleases[index];
                  return Container(
                    width: 320.0,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 10.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Cinematic Background Image Cover
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            release['coverUrl'],
                            width: 320.0,
                            height: 240.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.blueGrey[900],
                                child: const Center(
                                  child: Icon(Icons.movie_creation_outlined, color: Colors.white30, size: 60.0),
                                ),
                              );
                            },
                          ),
                        ),

                        // Dark radial/linear gradient panel mask sitting flush over the bottom layout boundary
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),

                        // Bright blue tag block reading "EXCLUSIVE" in bold white lettering inside the top-left boundary
                        Positioned(
                          top: 14.0,
                          left: 14.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                color: trustBlue,
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                child: Text(
                                  "EXCLUSIVE",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // View counter tracking indicator layout at the far right
                        Positioned(
                          top: 14.0,
                          right: 14.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Container(
                              color: Colors.black.withOpacity(0.65),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 12.0),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    release['views'],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Large white Icons.play_circle_filled component precisely at the center
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_isAmharic ? 'ቪዲዮው በቅርቡ ይለቀቃል!' : 'Play cinematic stream!'),
                                  backgroundColor: primaryGold,
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 15.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_circle_filled,
                                color: Colors.white,
                                size: 56.0,
                              ),
                            ),
                          ),
                        ),

                        // Information Overlay at the bottom
                        Positioned(
                          bottom: 12.0,
                          left: 12.0,
                          right: 12.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bold text layer tracking active countdowns reading "02:14:05"
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.timer, color: Colors.white, size: 10.0),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      release['countdown'],
                                      style: GoogleFonts.robotoMono(
                                        color: Colors.white,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6.0),

                              // Main project tracking text name
                              Text(
                                release['title'],
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),

                              // Miniature artist thumbnail, creator name, verified blue checkmark
                              Row(
                                children: [
                                  Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.asset(
                                        release['avatarUrl'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(color: primaryGold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    release['creatorName'],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  const Icon(
                                    Icons.verified,
                                    color: trustBlue,
                                    size: 12.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24.0),

            // TRENDING CHALLENGES SECTION HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 24.0,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        _isAmharic ? "በመታየት ላይ ያሉ ፈተናዎች" : "Trending Challenges",
                        style: GoogleFonts.poppins(
                          color: primaryTextColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isAmharic ? 'ሁሉም ፈተናዎች በቅርቡ ይጫናሉ' : 'Viewing all challenges...'),
                          backgroundColor: primaryGold,
                        ),
                      );
                    },
                    child: Text(
                      _isAmharic ? "ሁሉንም እይ >" : "See All >",
                      style: GoogleFonts.poppins(
                        color: primaryGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),

            // Sequence of elevated list item cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _challenges.length,
              itemBuilder: (context, index) {
                final challenge = _challenges[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14.0),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 8.0,
                        offset: const Offset(0, 3),
                      )
                    ],
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Square challenge image backdrop widget (64x64 dp, borderRadius: 12)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            challenge['imageUrl'],
                            width: 64.0,
                            height: 64.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 64.0,
                                height: 64.0,
                                color: primaryGold.withOpacity(0.2),
                                child: const Icon(Icons.flash_on, color: primaryGold, size: 28.0),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 14.0),

                        // Right expanded column element
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Primary title text row
                              Text(
                                _isAmharic ? challenge['titleAmh'] : challenge['title'],
                                style: GoogleFonts.poppins(
                                  color: primaryTextColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2.0),

                              // Subtitle reading "by [Creator Name]"
                              Text(
                                "by ${challenge['creatorName']}",
                                style: GoogleFonts.poppins(
                                  color: secondaryTextColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10.0),

                              // Custom LinearProgressIndicator (height 6dp) completely filled using Verified Blue set to coefficient 0.87
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3.0),
                                child: LinearProgressIndicator(
                                  value: challenge['progress'] as double,
                                  minHeight: 6.0,
                                  backgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    trustBlue, // Filled using Verified Blue
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),

                              // Baseline row showing "87%" in blue, user group block, and timer layout
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${((challenge['progress'] as double) * 100).toInt()}%",
                                    style: GoogleFonts.poppins(
                                      color: trustBlue,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.people, color: trustBlue, size: 13.0),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        challenge['participants'],
                                        style: GoogleFonts.poppins(
                                          color: secondaryTextColor,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, color: Colors.grey, size: 13.0),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        challenge['timeLeft'],
                                        style: GoogleFonts.poppins(
                                          color: secondaryTextColor,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
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
            const SizedBox(height: 32.0),

            // HOT CHARITIES / GO FUND ME SECTION HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.volunteer_activism,
                        color: Colors.redAccent,
                        size: 24.0,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        _isAmharic ? "ትኩስ የበጎ አድራጎት" : "Hot Charities",
                        style: GoogleFonts.poppins(
                          color: primaryTextColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isAmharic ? 'ሁሉንም በጎ አድራጎት በቅርቡ ይጫናሉ' : 'Viewing all charities...'),
                          backgroundColor: primaryGold,
                        ),
                      );
                    },
                    child: Text(
                      _isAmharic ? "ሁሉንም እይ >" : "See All >",
                      style: GoogleFonts.poppins(
                        color: primaryGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),

            // Sequence of elevated list item cards for charities
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _charities.length,
              itemBuilder: (context, index) {
                final charity = _charities[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14.0),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 8.0,
                        offset: const Offset(0, 3),
                      )
                    ],
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Square charity image backdrop widget (64x64 dp, borderRadius: 12)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            charity['imageUrl'],
                            width: 64.0,
                            height: 64.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 64.0,
                                height: 64.0,
                                color: Colors.redAccent.withOpacity(0.2),
                                child: const Icon(Icons.favorite, color: Colors.redAccent, size: 28.0),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 14.0),

                        // Right expanded column element
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Primary title text row
                              Text(
                                _isAmharic ? charity['titleAmh'] : charity['title'],
                                style: GoogleFonts.poppins(
                                  color: primaryTextColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2.0),

                              // Subtitle reading "by [Creator Name]"
                              Text(
                                "by ${charity['creatorName']}",
                                style: GoogleFonts.poppins(
                                  color: secondaryTextColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10.0),

                              // Custom LinearProgressIndicator (height 6dp)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3.0),
                                child: LinearProgressIndicator(
                                  value: charity['progress'] as double,
                                  minHeight: 6.0,
                                  backgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.green, // Filled using Green for money/charity
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),

                              // Baseline row showing progress, donors, and timer layout
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${((charity['progress'] as double) * 100).toInt()}%",
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.people, color: Colors.green, size: 13.0),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        charity['donors'],
                                        style: GoogleFonts.poppins(
                                          color: secondaryTextColor,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, color: Colors.grey, size: 13.0),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        charity['timeLeft'],
                                        style: GoogleFonts.poppins(
                                          color: secondaryTextColor,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
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
            const SizedBox(height: 32.0),
          ],
        ),
      ),
      DiscoverTab(isAmharic: _isAmharic),
      MarketTab(isAmharic: _isAmharic),
      WalletTab(isAmharic: _isAmharic),
      _buildPlaceholderTab("Profile", "መገለጫ"),
    ],
  ),

      // BASE NAVIGATION MATRIX PANEL (Rigid BottomNavigationBar container sitting flush at base)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
              width: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Rigid navigation bar structure
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          currentIndex: _currentTabIndex,
          selectedItemColor: primaryGold, // Home active color is #D4AF37
          unselectedItemColor: isDark ? Colors.white54 : Colors.black38,
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w900,
            fontSize: 13.0,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 13.0,
          ),
          showUnselectedLabels: true, // Keep labels persistent and completely readable
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
            // Show interactive feedback on tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isAmharic 
                      ? 'ወደ ማውጫ ${_getTabNameAmharic(index)} በመሄድ ላይ...' 
                      : 'Navigating to ${_getTabName(index)}...',
                ),
                duration: const Duration(milliseconds: 500),
                backgroundColor: primaryGold,
              ),
            );
          },
          items: [
            // 1. Home
            BottomNavigationBarItem(
              icon: Icon(
                _currentTabIndex == 0 ? Icons.home_filled : Icons.home_outlined,
              ),
              label: _isAmharic ? "መነሻ" : "Home",
            ),
            // 2. Discover
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: _isAmharic ? "አስስ" : "Discover",
            ),
            // 3. Market
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront),
              label: _isAmharic ? "ገበያ" : "Market",
            ),
            // 4. Wallet
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet),
              label: _isAmharic ? "ኪስ ቦርሳ" : "Wallet",
            ),
            // 5. Profile
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: _isAmharic ? "መገለጫ" : "Profile",
            ),
          ],
        ),
      ),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0: return "Home";
      case 1: return "Discover";
      case 2: return "Market";
      case 3: return "Wallet";
      case 4: return "Profile";
      default: return "";
    }
  }

  String _getTabNameAmharic(int index) {
    switch (index) {
      case 0: return "መነሻ";
      case 1: return "አስስ";
      case 2: return "ገበያ";
      case 3: return "ኪስ ቦርሳ";
      case 4: return "መገለጫ";
      default: return "";
    }
  }

  Widget _buildPlaceholderTab(String title, String titleAmh) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
    const Color primaryGold = Color(0xFFD4AF37);
    final Color primaryTextColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color secondaryTextColor = isDark ? Colors.white.withOpacity(0.7) : const Color(0xFF555555);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              title == "Market" 
                  ? Icons.storefront 
                  : title == "Wallet" 
                      ? Icons.account_balance_wallet 
                      : Icons.person,
              size: 64.0,
              color: primaryGold,
            ),
            const SizedBox(height: 16.0),
            Text(
              _isAmharic ? titleAmh : title,
              style: GoogleFonts.poppins(
                fontSize: 26.0,
                fontWeight: FontWeight.w900,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              _isAmharic ? "ይህ ገጽ በቅርቡ ይለቀቃል!" : "This page is coming soon!",
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
