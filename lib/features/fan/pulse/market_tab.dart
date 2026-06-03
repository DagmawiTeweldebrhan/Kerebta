import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/state/wallet_state.dart';

/// Market Tab for the Kerebta (ቀረብታ) platform.
///
/// Premium ultra-dark aesthetic marketplace with asymmetric layouts,
/// strict text truncation, high-contrast components, and full
/// light/dark mode responsiveness.
class MarketTab extends StatefulWidget {
  final bool isAmharic;
  const MarketTab({Key? key, this.isAmharic = false}) : super(key: key);

  @override
  State<MarketTab> createState() => _MarketTabState();
}

class _MarketTabState extends State<MarketTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // Segment selector state
  int _selectedSegment = 0;

  // Countdown timer state
  late Timer _countdownTimer;
  Duration _countdownDuration =
      const Duration(days: 2, hours: 14, minutes: 5, seconds: 0);

  // Search state
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Map<String, dynamic>>> userPurchasedProducts =
      ValueNotifier<List<Map<String, dynamic>>>(<Map<String, dynamic>>[]);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();

    // Live countdown clock
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdownDuration.inSeconds > 0) {
        setState(() {
          _countdownDuration -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _fadeController.dispose();
    _searchController.dispose();
    userPurchasedProducts.dispose();
    super.dispose();
  }

  // ── Design System Constants ──
  static const Color _goldAccent = Color(0xFFD4AF37);
  static const Color _neonBlue = Color(0xFF1D9BF0);
  Color _scaffoldBg(bool isDark) =>
      isDark ? const Color(0xFF0B0B0D) : const Color(0xFFF6F6F9);
  Color _surfaceCard(bool isDark) =>
      isDark ? const Color(0xFF141418) : Colors.white;
  Color _primaryText(bool isDark) =>
      isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color _secondaryText(bool isDark) =>
      isDark ? Colors.white70 : const Color(0xFF555555);

  // ── Mock Product Data ──
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Rophnan "III" Tour Hoodie',
      'nameAmh': 'ሮፍናን "III" ቱር ሁዲ',
      'price': '2,450 ETB',
      'priceValue': 2450,
      'category': 'merch',
      'image': 'assets/images/merch_hoodie.jpg',
      'tag': 'MERCH',
    },
    {
      'name': 'Teddy Afro Live - Addis Arena',
      'nameAmh': 'ቴዲ አፍሮ ቀጥታ - አዲስ አረና',
      'price': '800 ETB',
      'priceValue': 800,
      'category': 'ticket',
      'subtitle': 'Addis Ababa, Dec 25',
      'subtitleAmh': 'አዲስ አበባ, ታህሳስ 25',
      'image': 'assets/images/ticket_teddy.jpg',
      'tag': 'TICKET',
    },
    {
      'name': 'Kerebta Gold Cap',
      'nameAmh': 'ቀረብታ ወርቃማ ኮፍያ',
      'price': '1,200 ETB',
      'priceValue': 1200,
      'category': 'merch',
      'image': 'assets/images/merch_cap.jpg',
      'tag': 'MERCH',
    },
    {
      'name': 'Aster Aweke - Acoustic EP (Digital)',
      'nameAmh': 'አስቴር አወቀ - አኮስቲክ EP (ዲጂታል)',
      'price': '350 ETB',
      'priceValue': 350,
      'category': 'digital',
      'subtitle': 'FLAC · Lossless Audio',
      'subtitleAmh': 'FLAC · ያልተጨመቀ ኦዲዮ',
      'image': 'assets/images/digital_aster.jpg',
      'tag': 'DIGITAL',
    },
    {
      'name': 'Ethio-Jazz Vinyl Collection',
      'nameAmh': 'ኢትዮ-ጃዝ ቪኒል ስብስብ',
      'price': '3,800 ETB',
      'priceValue': 3800,
      'category': 'merch',
      'image': 'assets/images/merch_vinyl.jpg',
      'tag': 'MERCH',
    },
    {
      'name': 'Rophnan "III" Digital Album',
      'nameAmh': 'ሮፍናን "III" ዲጂታል አልበም',
      'price': '250 ETB',
      'priceValue': 250,
      'category': 'digital',
      'subtitle': 'MP3 320kbps · 14 tracks',
      'subtitleAmh': 'MP3 320kbps · 14 ትራኮች',
      'image': 'assets/images/digital_rophnan.jpg',
      'tag': 'DIGITAL',
    },
  ];

  final List<Map<String, String>> _segments = [
    {'en': 'All', 'amh': 'ሁሉንም'},
    {'en': 'Tickets', 'amh': 'ትኬቶች'},
    {'en': 'Merchandise', 'amh': 'አልባሳት'},
    {'en': 'Digital Audio', 'amh': 'ዲጂታል'},
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> res = _products;
    if (_selectedSegment != 0) {
      final categories = ['', 'ticket', 'merch', 'digital'];
      final selected = categories[_selectedSegment];
      res = res.where((p) => p['category'] == selected).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      res = res.where((p) {
        final name = (p['name'] as String).toLowerCase();
        final nameAmh = (p['nameAmh'] as String).toLowerCase();
        final subtitle = (p['subtitle'] as String? ?? '').toLowerCase();
        final subtitleAmh = (p['subtitleAmh'] as String? ?? '').toLowerCase();
        return name.contains(query) ||
            nameAmh.contains(query) ||
            subtitle.contains(query) ||
            subtitleAmh.contains(query);
      }).toList();
    }
    return res;
  }

  // ── Shadow System ──
  List<BoxShadow> _cardShadow(bool isDark) => [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.5)
              : _goldAccent.withOpacity(0.04),
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

  Border _cardBorder(bool isDark) => Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : _goldAccent.withOpacity(0.12),
        width: 1.0,
      );

  // ── Graceful Image Error Handler ──
  static void _handleImageError(Object exception, StackTrace? stackTrace) {
    // Silent fail — fallback UI handles it
  }

  String _formatCountdown() {
    final d = _countdownDuration.inDays;
    final h =
        _countdownDuration.inHours.remainder(24).toString().padLeft(2, '0');
    final m =
        _countdownDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s =
        _countdownDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.toString().padLeft(2, '0')}d : ${h}h : ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBg = _scaffoldBg(isDark);
    final Color surfaceCard = _surfaceCard(isDark);
    final Color primaryText = _primaryText(isDark);
    final Color secondaryText = _secondaryText(isDark);
    final List<BoxShadow> shadow = _cardShadow(isDark);
    final Border border = _cardBorder(isDark);
    final filtered = _filteredProducts;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ═══════════════════════════════════════════════════════════
              // 1. PREMIUM INTEGRATED HEADER
              // ═══════════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSearching
                        ? Container(
                            key: const ValueKey('search_active'),
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF141418)
                                  : const Color(0xFFEBEAE4),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: _goldAccent.withOpacity(0.3),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                // Back/Cancel icon
                                IconButton(
                                  icon: Icon(Icons.arrow_back_rounded,
                                      color: _goldAccent, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _isSearching = false;
                                      _searchQuery = '';
                                      _searchController.clear();
                                    });
                                  },
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    autofocus: true,
                                    onChanged: (val) {
                                      setState(() {
                                        _searchQuery = val;
                                      });
                                    },
                                    style: GoogleFonts.poppins(
                                      color: Colors.white38,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: widget.isAmharic
                                          ? 'ዕቃዎችን ይፈልጉ...'
                                          : 'Search products...',
                                      hintStyle: GoogleFonts.poppins(
                                        color: secondaryText.withOpacity(0.6),
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                    ),
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  IconButton(
                                    icon: Icon(Icons.close_rounded,
                                        color: secondaryText, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _searchQuery = '';
                                        _searchController.clear();
                                      });
                                    },
                                  ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          )
                        : Row(
                            key: const ValueKey('search_inactive'),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left — Market brand title
                              Text(
                                widget.isAmharic ? 'ገበያ' : 'Market',
                                style: GoogleFonts.poppins(
                                  color: _goldAccent,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                  letterSpacing: 2.0,
                                ),
                              ),

                              // Right — Vault Balance + Search + Cart
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Vault Balance Pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1C1C20)
                                          : const Color(0xFFF0EDE6),
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: _goldAccent.withOpacity(0.25),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                            Icons
                                                .account_balance_wallet_rounded,
                                            color: _goldAccent,
                                            size: 16),
                                        const SizedBox(width: 6),
                                        ValueListenableBuilder<double>(
                                            valueListenable: WalletState.balance,
                                            builder: (context, balance, _) {
                                              return Text(
                                                '${balance.toStringAsFixed(0)} ETB',
                                                style: GoogleFonts.poppins(
                                                  color: primaryText,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Search Button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1C1C20)
                                          : const Color(0xFFF0EDE6),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _goldAccent.withOpacity(0.15),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.search_rounded,
                                          color: primaryText, size: 20),
                                      padding: const EdgeInsets.all(8),
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        setState(() {
                                          _isSearching = true;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Cart icon button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1C1C20)
                                          : const Color(0xFFF0EDE6),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _goldAccent.withOpacity(0.15),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.shopping_bag_outlined,
                                          color: primaryText, size: 20),
                                      padding: const EdgeInsets.all(8),
                                      constraints: const BoxConstraints(),
                                      onPressed: () =>
                                          _showPurchasedSheet(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════════════
              // 2. HIGH-URGENCY PROMOTIONAL BILLBOARD
              // ═══════════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: shadow,
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF1B1B22),
                                  const Color(0xFF2A2535)
                                ]
                              : [
                                  const Color(0xFFE8E0D0),
                                  const Color(0xFFFFF8EE)
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/drop_billboard.jpg'),
                          fit: BoxFit.cover,
                          onError: _handleImageError,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.35),
                              Colors.black.withOpacity(0.85),
                            ],
                            stops: const [0.0, 0.45, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // ── Top-Left: LIVE DROP glassmorphic tag ──
                            Positioned(
                              top: 14,
                              left: 14,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.white24, width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFF4444),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'LIVE DROP',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 11,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // ── Top-Right: Countdown clock ──
                            Positioned(
                              top: 14,
                              right: 14,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: Text(
                                      _formatCountdown(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // ── Bottom content: Title + CTA ──
                            Positioned(
                              bottom: 18,
                              left: 18,
                              right: 18,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Left column: Title + artist
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.isAmharic
                                              ? 'ሮፍናን "III" ሊሚትድ ቪኒል ሴት'
                                              : 'Rophnan "III" Limited Vinyl Set',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20,
                                            height: 1.2,
                                            letterSpacing: -0.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.isAmharic
                                              ? 'በሮፍናን · ልዩ ስብስብ'
                                              : 'by Rophnan · Exclusive Collection',
                                          style: GoogleFonts.poppins(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Right: CTA Button
                                  GestureDetector(
                                    onTap: () {
                                      _showCheckoutSheet(context, {
                                        'name':
                                            'Rophnan "III" Limited Vinyl Set',
                                        'nameAmh':
                                            'ሮፍናን "III" Limited Vinyl Set',
                                        'price': '3,800 ETB',
                                        'priceValue': 3800,
                                        'category': 'merch',
                                        'image':
                                            'assets/images/drop_billboard.jpg',
                                        'tag': 'EXCLUSIVE DROP',
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: _goldAccent,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                _goldAccent.withOpacity(0.35),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        widget.isAmharic ? 'ይያዙ' : 'Claim Drop',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════════════
              // 3. HORIZONTAL SEGMENT SELECTOR RAIL
              // ═══════════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20, right: 8),
                      itemCount: _segments.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedSegment == index;
                        final label = widget.isAmharic
                            ? _segments[index]['amh']!
                            : _segments[index]['en']!;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSegment = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _goldAccent
                                    : (isDark
                                        ? const Color(0xFF1E1E24)
                                        : const Color(0xFFE8E5E0)),
                                borderRadius: BorderRadius.circular(22),
                                border: isSelected
                                    ? null
                                    : Border.all(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.06)
                                            : Colors.black.withOpacity(0.06),
                                        width: 1.0,
                                      ),
                              ),
                              child: Center(
                                child: Text(
                                  label,
                                  style: GoogleFonts.poppins(
                                    color: isSelected
                                        ? Colors.black
                                        : (isDark
                                            ? Colors.white
                                            : const Color(0xFF444444)),
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════════════
              // 4. ALTERNATING DUAL-FORMAT ASYMMETRIC GRID / EMPTY STATE
              // ═══════════════════════════════════════════════════════════
              if (filtered.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 20),
                      decoration: BoxDecoration(
                        color: surfaceCard,
                        borderRadius: BorderRadius.circular(24),
                        border: border,
                        boxShadow: shadow,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _goldAccent.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_off_rounded,
                              color: _goldAccent,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.isAmharic ? 'ምንም አልተገኘም' : 'No items found',
                            style: GoogleFonts.poppins(
                              color: primaryText,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.isAmharic
                                ? 'የፍለጋ ቃሉን አስተካክለው ይሞክሩ'
                                : 'Try adjusting your keywords or category filter',
                            style: GoogleFonts.poppins(
                              color: secondaryText.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_searchQuery.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _goldAccent,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: Text(
                                widget.isAmharic
                                    ? 'የፍለጋ ቃሉን አጽዳ'
                                    : 'Clear Search',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.62,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= filtered.length) return null;
                        final item = filtered[index];
                        final isMerch = item['category'] == 'merch';

                        if (isMerch) {
                          // ── Style A: Physical Merchandise Card ──
                          return _buildMerchCard(item, isDark, surfaceCard,
                              primaryText, secondaryText, shadow, border);
                        } else {
                          // ── Style B: Digital / Ticket Card ──
                          return _buildDigitalCard(item, isDark, surfaceCard,
                              primaryText, secondaryText, shadow, border);
                        }
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),

              // Bottom safe area
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STYLE A — PHYSICAL MERCHANDISE CARD (Tall portrait)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildMerchCard(
    Map<String, dynamic> item,
    bool isDark,
    Color surfaceCard,
    Color primaryText,
    Color secondaryText,
    List<BoxShadow> shadow,
    Border border,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: shadow,
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area (flex top portion)
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Product image with fallback
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF1A1A20), const Color(0xFF252530)]
                          : [const Color(0xFFEEECE8), const Color(0xFFF8F6F2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    image: DecorationImage(
                      image: AssetImage(item['image'] as String),
                      fit: BoxFit.cover,
                      onError: _handleImageError,
                    ),
                  ),
                  // Fallback content when image fails
                  child: Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: _goldAccent.withOpacity(0.15),
                      size: 48,
                    ),
                  ),
                ),
                // Tag — top left
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['tag'] as String,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product name
                  Flexible(
                    child: Text(
                      widget.isAmharic
                          ? (item['nameAmh'] as String)
                          : (item['name'] as String),
                      style: GoogleFonts.poppins(
                        color: primaryText,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price row + cart button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item['price'] as String,
                          style: GoogleFonts.poppins(
                            color: _neonBlue,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _showCheckoutSheet(context, item),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _goldAccent.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _goldAccent.withOpacity(0.3), width: 1),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            color: _goldAccent,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STYLE B — DIGITAL / TICKET CARD (Landscape-ish with details)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildDigitalCard(
    Map<String, dynamic> item,
    bool isDark,
    Color surfaceCard,
    Color primaryText,
    Color secondaryText,
    List<BoxShadow> shadow,
    Border border,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: shadow,
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Square artwork area
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF1A1422), const Color(0xFF221830)]
                          : [const Color(0xFFE8E0F0), const Color(0xFFF2EEF8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    image: DecorationImage(
                      image: AssetImage(item['image'] as String),
                      fit: BoxFit.cover,
                      onError: _handleImageError,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      item['category'] == 'ticket'
                          ? Icons.confirmation_number_outlined
                          : Icons.music_note_rounded,
                      color: _goldAccent.withOpacity(0.15),
                      size: 48,
                    ),
                  ),
                ),
                // Tag
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _neonBlue.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['tag'] as String,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name
                  Flexible(
                    child: Text(
                      widget.isAmharic
                          ? (item['nameAmh'] as String)
                          : (item['name'] as String),
                      style: GoogleFonts.poppins(
                        color: primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Subtitle
                  if (item['subtitle'] != null)
                    Flexible(
                      child: Text(
                        widget.isAmharic
                            ? (item['subtitleAmh'] as String? ??
                                item['subtitle'] as String)
                            : (item['subtitle'] as String),
                        style: GoogleFonts.poppins(
                          color: secondaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 4),
                  // Buy Now pill
                  GestureDetector(
                    onTap: () => _showCheckoutSheet(context, item),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: _goldAccent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _goldAccent.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.isAmharic
                              ? 'ግዛ · ${item['price']}'
                              : 'Buy · ${item['price']}',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutSheet(BuildContext context, Map<String, dynamic> product) {
    final BuildContext hostContext = context;
    final ScaffoldMessengerState? hostMessenger =
        ScaffoldMessenger.maybeOf(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sheetBg = isDark ? const Color(0xFF141418) : Colors.white;
    final Color primaryText = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color secondaryText =
        isDark ? Colors.white70 : const Color(0xFF555555);

    final String name = widget.isAmharic
        ? (product['nameAmh'] ?? product['name'])
        : product['name'];
    final double price = (product['priceValue'] ?? 0).toDouble();
    final String priceStr =
        product['price'] ?? '${price.toStringAsFixed(0)} ETB';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              border: isDark
                  ? Border(
                      top: BorderSide(
                          color: Colors.white.withOpacity(0.08), width: 1.0))
                  : null,
            ),
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isAmharic ? 'የክፍያ ማረጋገጫ' : 'Confirm Checkout',
                      style: GoogleFonts.poppins(
                        color: _goldAccent,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded,
                          color: secondaryText, size: 20),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.withOpacity(0.1),
                        image: DecorationImage(
                          image: AssetImage(product['image'] as String),
                          fit: BoxFit.cover,
                          onError: (e, s) {},
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          product['category'] == 'ticket'
                              ? Icons.confirmation_number_outlined
                              : (product['category'] == 'digital'
                                  ? Icons.music_note_rounded
                                  : Icons.shopping_bag_outlined),
                          color: _goldAccent.withOpacity(0.3),
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              color: primaryText,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _neonBlue.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              (product['tag'] as String? ?? 'ITEM')
                                  .toUpperCase(),
                              style: GoogleFonts.poppins(
                                color: _neonBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(
                    color: isDark ? Colors.white10 : Colors.black12,
                    thickness: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isAmharic ? 'የኪስ ሂሳብ ቀሪ' : 'Your Wallet Balance',
                      style: GoogleFonts.poppins(
                        color: secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ValueListenableBuilder<double>(
                        valueListenable: WalletState.balance,
                        builder: (valueContext, balance, _) {
                          return Text(
                            'ETB ${balance.toStringAsFixed(2)}',
                            style: GoogleFonts.robotoMono(
                              color: primaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          );
                        }),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isAmharic ? 'ዋጋ' : 'Total Price',
                      style: GoogleFonts.poppins(
                        color: secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      priceStr,
                      style: GoogleFonts.robotoMono(
                        color: _neonBlue,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<double>(
                    valueListenable: WalletState.balance,
                    builder: (valueContext, balance, _) {
                      final bool hasEnough = balance >= price;
                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                hasEnough ? _goldAccent : Colors.redAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (!hasEnough) {
                              hostMessenger?.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.isAmharic
                                        ? 'ይቅርታ፣ ክፍያ ለመፈጸም በቂ የኪስ ሂሳብ ቀሪ የለዎትም!'
                                        : 'Insufficient wallet balance! Please top up.',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }
                            WalletState.addTransaction({
                              'title': 'Purchase: ${product['name']}',
                              'titleAmh': 'ግዢ: ${product['nameAmh'] ?? product['name']}',
                              'time': 'Just now',
                              'timeAmh': 'አሁን',
                              'amount': -price,
                              'isCredit': false,
                            });
                            userPurchasedProducts.value =
                                List.from(userPurchasedProducts.value)
                                  ..add({
                                    'name': product['name'],
                                    'nameAmh':
                                        product['nameAmh'] ?? product['name'],
                                    'price': product['price'],
                                    'priceValue': product['priceValue'],
                                    'category': product['category'],
                                    'image': product['image'],
                                    'tag': product['tag'],
                                    'purchaseDate':
                                        DateTime.now().toIso8601String(),
                                  });

                            Navigator.pop(sheetContext);
                            if (mounted) {
                              _showSuccessPurchaseSheet(hostContext, product);
                            }
                          },
                          child: Text(
                            hasEnough
                                ? (widget.isAmharic
                                    ? 'ግዢውን አረጋግጥ'
                                    : 'Confirm Purchase')
                                : (widget.isAmharic
                                    ? 'በቂ ሂሳብ የለም'
                                    : 'Insufficient Funds'),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessPurchaseSheet(
      BuildContext context, Map<String, dynamic> product) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sheetBg = isDark ? const Color(0xFF141418) : Colors.white;
    final Color primaryText = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color secondaryText =
        isDark ? Colors.white70 : const Color(0xFF555555);

    final String name = widget.isAmharic
        ? (product['nameAmh'] ?? product['name'])
        : product['name'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              border: isDark
                  ? Border(
                      top: BorderSide(
                          color: Colors.white.withOpacity(0.08), width: 1.0))
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676).withOpacity(0.12),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF00E676), width: 2),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF00E676),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.isAmharic ? 'ግዢው ተሳክቷል!' : 'Purchase Successful!',
                  style: GoogleFonts.poppins(
                    color: primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.isAmharic
                      ? '“$name” በተሳካ ሁኔታ ገዝተዋል። በፕሮፋይልዎ ላይ ማግኘት ይችላሉ።'
                      : 'You have successfully purchased "$name". Find it inside your Profile tab.',
                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _goldAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      widget.isAmharic ? 'እሺ' : 'Awesome',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPurchasedSheet(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sheetBg = isDark ? const Color(0xFF141418) : Colors.white;
    final Color primaryText = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color secondaryText =
        isDark ? Colors.white70 : const Color(0xFF555555);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28.0)),
              border: isDark
                  ? Border(
                      top: BorderSide(
                          color: Colors.white.withOpacity(0.08), width: 1.0))
                  : null,
            ),
            padding: const EdgeInsets.all(24),
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: userPurchasedProducts,
                builder: (context, purchased, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.isAmharic
                                ? 'የእኔ ትዕዛዞች / ትኬቶች'
                                : 'My Orders & Tickets',
                            style: GoogleFonts.poppins(
                              color: _goldAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded,
                                color: secondaryText, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (purchased.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 36.0),
                            child: Column(
                              children: [
                                Icon(Icons.shopping_bag_outlined,
                                    color: secondaryText.withOpacity(0.3),
                                    size: 48),
                                const SizedBox(height: 12),
                                Text(
                                  widget.isAmharic
                                      ? 'ምንም ግዢ የለም'
                                      : 'No purchases yet',
                                  style: GoogleFonts.poppins(
                                    color: secondaryText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.4),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: purchased.length,
                            separatorBuilder: (context, index) => Divider(
                                color: isDark ? Colors.white10 : Colors.black12,
                                height: 1),
                            itemBuilder: (context, index) {
                              final item = purchased[index];
                              final String name = widget.isAmharic
                                  ? (item['nameAmh'] ?? item['name'])
                                  : item['name'];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item['image'] as String,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 44,
                                      height: 44,
                                      color: Colors.grey.withOpacity(0.1),
                                      child: Icon(Icons.shopping_bag_outlined,
                                          color: _goldAccent, size: 20),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  name,
                                  style: GoogleFonts.poppins(
                                    color: primaryText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  item['price'] as String? ?? '',
                                  style: GoogleFonts.robotoMono(
                                    color: _neonBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.isAmharic ? 'የተገዛ' : 'PURCHASED',
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
          ),
        );
      },
    );
  }
}
