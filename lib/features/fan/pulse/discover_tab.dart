import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Discover Tab for Kerebta platform.
///
/// Implements a production-ready, highly immersive "Discover Tab" view
/// using asymmetric layout structures, horizontal scroll fades, layered depth,
/// and resolved text clipping constraints.
class DiscoverTab extends StatefulWidget {
  final bool isAmharic;
  const DiscoverTab({Key? key, this.isAmharic = false}) : super(key: key);

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab>
    with SingleTickerProviderStateMixin {
  // Animation controller for entry fade‑in effect.
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final TextEditingController _searchController;

  String _selectedContentType = 'All';
  String _selectedGenre = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ---------- Mock Data ----------
  final List<Map<String, dynamic>> _genres = [
    {'label': 'Ethio‑Jazz', 'icon': Icons.music_note, 'colors': [Color(0xFF8A2387), Color(0xFFE94057)]},
    {'label': 'Amapiano Nights', 'icon': Icons.nightlife, 'colors': [Color(0xFF1F1C2C), Color(0xFF928DAB)]},
    {'label': 'Guragigna Fusion', 'icon': Icons.music_video, 'colors': [Color(0xFF00B0FF), Color(0xFF00E676)]},
    {'label': 'Tizita Melodies', 'icon': Icons.library_music, 'colors': [Color(0xFFFF5252), Color(0xFFFF7A00)]},
    {'label': 'ታሪክ / History', 'icon': Icons.history, 'colors': [Color(0xFF7F00FF), Color(0xFFE100FF)]},
  ];

  final List<Map<String, String>> _trending = [
    {'title': 'Rophnan New Album Drop'},
    {'title': 'Teddy Afro Ticket Pre‑sale'},
    {'title': 'Seifu Live Concert Stream'},
  ];

  // ---------- UI Helpers ----------
  Color _gold(BuildContext context) => const Color(0xFFD4AF37);
  Color _neonBlue(BuildContext context) => const Color(0xFF1D9BF0);
  Color _scaffoldBg(bool isDark) =>
      isDark ? const Color(0xFF0B0B0D) : const Color(0xFFF6F6F9);
  Color _surfaceCard(bool isDark) => isDark ? const Color(0xFF141418) : Colors.white;

  TextStyle _sectionHeader(BuildContext context, bool isDark) => GoogleFonts.poppins(
        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.4,
      );

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryGold = _gold(context);
    final Color neonBlue = _neonBlue(context);
    final Color scaffoldBg = _scaffoldBg(isDark);
    final Color surfaceCard = _surfaceCard(isDark);
    final Color primaryText = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color secondaryText = isDark ? Colors.white70 : const Color(0xFF555555);

    // Premium Layered Shadow System (Resolves Overly Stark Light Mode)
    final List<BoxShadow> cardShadow = [
      BoxShadow(
        color: isDark 
            ? Colors.black.withOpacity(0.5) 
            : const Color(0xFFD4AF37).withOpacity(0.04), // Warm gold hue shadow for paper depth in light mode
        blurRadius: 24.0,
        spreadRadius: -2.0,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: isDark 
            ? Colors.black.withOpacity(0.2) 
            : Colors.black.withOpacity(0.03),
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ];

    // Elegant Subtle Border
    final Border cardBorder = Border.all(
      color: isDark 
          ? Colors.white.withOpacity(0.05) 
          : const Color(0xFFD4AF37).withOpacity(0.12), // Premium gold tint border in light mode
      width: 1.0,
    );

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ---- Search Anchor ----
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: surfaceCard,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: cardShadow,
                      border: cardBorder,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: primaryGold),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.poppins(
                              color: primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.isAmharic
                                  ? 'ፍለጋ ፈጣሪዎች፣ ትራክቶች፣ ወይም ክስተቶች…'
                                  : 'Search creators, tracks, or events…',
                              hintStyle: GoogleFonts.poppins(
                                color: secondaryText,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.tune_rounded, color: secondaryText),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _showFilterModal(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ---- Top Spacing ----
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),              // ---- What's Buzzing Section ----
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                  child: Row(
                    children: [
                      Text(widget.isAmharic ? 'በጣም የተወደዱ' : 'What\'s Buzzing', style: _sectionHeader(context, isDark)),
                      const SizedBox(width: 8),
                      Icon(Icons.trending_up_rounded, color: primaryGold, size: 24),
                    ],
                  ),
                ),
              ),

              // ---- Trending Ladder (Layered Depth & Gold tint border) ----
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: surfaceCard,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: cardShadow,
                      border: cardBorder,
                    ),
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: List.generate(_trending.length, (index) {
                        final item = _trending[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${(index + 1).toString().padLeft(2, '0')}',
                                  style: GoogleFonts.poppins(
                                    color: primaryGold,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item['title']!,
                                    style: GoogleFonts.poppins(
                                      color: primaryText,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_upward, color: neonBlue, size: 18),
                              ],
                            ),
                            if (index < _trending.length - 1)
                              Divider(
                                thickness: 1.0,
                                height: 28.0,
                                color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),

              // ---- Explore Visuals & Drops Section Header ----
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 36, 16, 12),
                  child: Text(
                    widget.isAmharic ? 'ተለዋዋጭ ቪዥዋሎች እና ጠብታዎች' : 'Explore Visuals & Drops',
                    style: _sectionHeader(context, isDark),
                  ),
                ),
              ),

              // ---- ASYMMETRIC GRID PART 1: Full-Width Widescreen Hero Banner ----
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: cardShadow,
                      border: cardBorder,
                      gradient: LinearGradient(
                        colors: isDark 
                            ? [const Color(0xFF1B1B22), const Color(0xFF2E2E3A)] 
                            : [const Color(0xFFE2E2E8), const Color(0xFFFFFFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/hero_album.jpg'),
                        fit: BoxFit.cover,
                        onError: _handleImageError,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryGold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: primaryGold, width: 1.0),
                            ),
                            child: Text(
                              'ALBUM PRE‑SALE',
                              style: GoogleFonts.poppins(
                                color: primaryGold,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Aster Aweke - Kerebta Acoustic',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w950,
                              fontSize: 25,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Pre‑order limited edition vinyl and unlock 3 exclusive live tracks.',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: primaryGold,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGold.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Text(
                                  'Pre‑Order',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
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

              // ---- ASYMMETRIC GRID PART 2: Side-by-Side Tall Stories (SliverGrid) ----
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    widget.isAmharic ? 'አጫጭር ቪዲዮዎች' : 'Trending Short Clips',
                    style: GoogleFonts.poppins(
                      color: primaryText,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver:
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final list = [
                        {
                          'title': 'Teddy Afro Live Session',
                          'bg': [const Color(0xFF8A2387), const Color(0xFFE94057)],
                        },
                        {
                          'title': 'Rophnan Concert Vibe',
                          'bg': [const Color(0xFFF27121), const Color(0xFFE94057)],
                        },
                      ];
                      final item = list[index % list.length];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: cardShadow,
                          gradient: LinearGradient(
                            colors: (item['bg'] as List<Color>?) ?? [Colors.grey, Colors.grey],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/vertical_story.jpg'),
                            fit: BoxFit.cover,
                            onError: _handleImageError,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                    child: Text(
                                      'CLIP',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.play_circle_outline, color: Colors.white, size: 28),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['title'] as String,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: 2,
                  ),
                ),
              ),

              // ---- ASYMMETRIC GRID PART 3: Full-Width Standard Rectangular Audio Cards (SliverList) ----
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
                  child: Text(
                    widget.isAmharic ? 'ልዩ የድምፅ ጠብታዎች' : 'Exclusive Audio Drops',
                    style: GoogleFonts.poppins(
                      color: primaryText,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver:
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final podcasts = [
                        {
                          'title': 'Amharic Podcast Episode 24',
                          'subtitle': 'Live interview with Seifu on EBS',
                        },
                        {
                          'title': 'Kerebta Gurage Beats Mix',
                          'subtitle': 'Ethio-Fusion Audio Drop',
                        },
                      ];
                      final item = podcasts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: cardShadow,
                          border: cardBorder,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: isDark 
                                      ? [const Color(0xFF1E1E24), const Color(0xFF2A2A35)]
                                      : [const Color(0xFFEBEBEF), const Color(0xFFFBFBFB)],
                                ),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/podcast_thumb.jpg'),
                                  fit: BoxFit.cover,
                                  onError: _handleImageError,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: GoogleFonts.poppins(
                                        color: primaryText,
                                        fontWeight: FontWeight.w850,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['subtitle']!,
                                      style: GoogleFonts.poppins(
                                        color: secondaryText,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryGold.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.play_arrow_rounded, color: primaryGold, size: 28),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: 2,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Gracefully handles image load issues (e.g. mock assets not in place yet)
  static void _handleImageError(Object exception, StackTrace? stackTrace) {
    // Silent fail in production
  }

  // Show premium filter modal bottom sheet
  void _showFilterModal(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sheetBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final Color primaryText = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color secondaryText = isDark ? Colors.white70 : const Color(0xFF555555);
    final Color primaryGold = const Color(0xFFD4AF37);

    String tempSelectedType = _selectedContentType;
    String tempSelectedGenre = _selectedGenre;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: sheetBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: secondaryText.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isAmharic ? "አጣራ" : "Filters",
                        style: GoogleFonts.poppins(
                          color: primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedContentType = tempSelectedType;
                            _selectedGenre = tempSelectedGenre;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          widget.isAmharic ? "ተግብር" : "Apply",
                          style: GoogleFonts.poppins(
                            color: primaryGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.isAmharic ? "የይዘት ዓይነት" : "Content Type",
                    style: GoogleFonts.poppins(
                      color: primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      "All",
                      "Music",
                      "Podcasts",
                      "Live Events",
                      "Challenge",
                      "Charity",
                    ].map((type) {
                      return _buildFilterChip(
                        type,
                        tempSelectedType == type,
                        primaryGold,
                        isDark,
                        () => setModalState(() => tempSelectedType = type),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.isAmharic ? "ዘውግ" : "Genre",
                    style: GoogleFonts.poppins(
                      color: primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      "All",
                      "Ethio-Jazz",
                      "Amapiano",
                      "Tizita",
                      "Guragigna",
                      "Oromiffa",
                    ].map((genre) {
                      return _buildFilterChip(
                        genre,
                        tempSelectedGenre == genre,
                        primaryGold,
                        isDark,
                        () => setModalState(() => tempSelectedGenre = genre),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Color goldColor, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? goldColor : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? goldColor : (isDark ? Colors.white12 : Colors.black12),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
