import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fan Profile Tab (መገለጫ) for the Kerebta (ቀረብታ) platform.
///
/// Production-ready, highly responsive, bilingually localized, and theme-adaptive.
/// Built with strict anti-collision layout constraints and premium aesthetics.
class ProfileTab extends StatefulWidget {
  final bool isAmharic;
  const ProfileTab({Key? key, this.isAmharic = false}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  // Active interaction states
  int? _hoveredStatIndex;
  int? _hoveredNavIndex;
  bool _isLogOutHovered = false;
  bool _isSettingsHovered = false;

  // Bilingual strings map
  String get _textProfile => widget.isAmharic ? 'መገለጫ' : 'Profile';
  String get _textSettings => widget.isAmharic ? 'ማስተካከያ' : 'Settings';
  String get _textFanAccount =>
      widget.isAmharic ? 'የአድናቂ አካውንት' : 'Fan Account';
  String get _textContributed => widget.isAmharic ? 'ለደገፉት' : 'CONTRIBUTED';
  String get _textChallenges => widget.isAmharic ? 'ውድድሮች' : 'CHALLENGES';
  String get _textBadges => widget.isAmharic ? 'ባጆች' : 'BADGES';
  String get _textEquippedBadges =>
      widget.isAmharic ? 'የታጠቁ ባጆች / የእኔ ባጆች' : 'Equipped Badges / የእኔ ባጆች';
  String get _textLogOut => widget.isAmharic ? 'ውጣ' : 'Log Out';
  String get _textLogOutSub => widget.isAmharic
      ? 'ከመለያዎ ለመውጣት እርግጠኛ ነዎት?'
      : 'Are you sure you want to log out?';

  // Navigation Stack translations
  String get _navSupportedCreators =>
      widget.isAmharic ? 'የደገፏቸው ፈጣሪዎች' : 'Supported Creators';
  String get _navMyBadges => widget.isAmharic ? 'የእኔ ባጆች' : 'My Badges';
  String get _navMyOrders => widget.isAmharic ? 'የእኔ ትዕዛዞች' : 'My Orders';
  String get _navMyTickets => widget.isAmharic ? 'የእኔ ትኬቶች' : 'My Tickets';
  String get _navPaymentMethods =>
      widget.isAmharic ? 'የክፍያ ዘዴዎች' : 'Payment Methods';

  // State colors helper
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _colorScaffoldBg =>
      _isDark ? const Color(0xFF0B0B0D) : const Color(0xFFF6F6F9);
  Color get _colorCardSurface =>
      _isDark ? const Color(0xFF141418) : const Color(0xFFFFFFFF);
  Color get _colorSecondaryContainer =>
      _isDark ? const Color(0xFF1F1F25) : const Color(0xFFEFEFEF);
  Color get _colorPrimaryText =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A1A);
  Color get _colorSecondaryText =>
      _isDark ? const Color(0xFF999999) : const Color(0xFF666666);

  // Constants
  static const Color _colorGoldAccent = Color(0xFFD4AF37);
  static const Color _colorNeonBlue = Color(0xFF1D9BF0);
  static const Color _colorVividRed = Color(0xFFFF5252);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorScaffoldBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. BASE CANVAS & THEME-ADAPTIVE HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _textProfile,
                          style: GoogleFonts.poppins(
                            color: _colorPrimaryText,
                            fontSize: 32.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) =>
                            setState(() => _isSettingsHovered = true),
                        onTapUp: (_) =>
                            setState(() => _isSettingsHovered = false),
                        onTapCancel: () =>
                            setState(() => _isSettingsHovered = false),
                        onTap: () => _showSettingsSheet(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: _isSettingsHovered
                                ? _colorNeonBlue.withOpacity(0.15)
                                : _colorSecondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.settings_outlined,
                            color: _isSettingsHovered
                                ? _colorNeonBlue
                                : _colorPrimaryText,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. FEATURE 1: THE DUAL-THEME FAN IDENTITY CARD
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: _colorCardSurface,
                      borderRadius: BorderRadius.circular(24.0),
                      border: _isDark
                          ? Border.all(
                              color: Colors.white.withOpacity(0.06), width: 1.0)
                          : null,
                      boxShadow: !_isDark
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 16.0,
                                offset: const Offset(0, 8),
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // High-contrast profile avatar enclosed in a Neon Blue & Gold dynamic gradient ring
                        Container(
                          width: 76,
                          height: 76,
                          padding: const EdgeInsets.all(3.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                _colorNeonBlue,
                                _colorGoldAccent,
                                _colorNeonBlue,
                              ],
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _colorCardSurface,
                            ),
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                'assets/images/fan_avatar.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Stunning placeholder using gradient & initials
                                  return Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF2C3E50),
                                          Color(0xFF3498DB)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'YA',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18.0),
                        // Profile text info column with anti-collision rules
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yonas Abebe',
                                style: GoogleFonts.poppins(
                                  color: _colorPrimaryText,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '+251 91 *** 5678',
                                style: GoogleFonts.poppins(
                                  color: _colorSecondaryText,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8.0),
                              // Neon Blue micro-pill badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: _colorNeonBlue
                                      .withOpacity(_isDark ? 0.15 : 0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  _textFanAccount,
                                  style: GoogleFonts.poppins(
                                    color: _colorNeonBlue,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
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

              // 3. FEATURE 2: GEOMETRIC IMPACT SCOREBOARD GRID
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Row(
                    children: [
                      _buildScoreboardCard(
                          0, 'ETB 2.4K', _textContributed, false),
                      const SizedBox(width: 12.0),
                      _buildScoreboardCard(1, '12', _textChallenges, false),
                      const SizedBox(width: 12.0),
                      _buildScoreboardCard(2, '3', _textBadges, true),
                    ],
                  ),
                ),
              ),

              // 4. FEATURE 3: DIGITAL TROPHY CASE HORIZONTAL TRACK
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 22.0, bottom: 8.0),
                  child: Text(
                    _textEquippedBadges,
                    style: GoogleFonts.poppins(
                      color: _colorPrimaryText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 96,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 6.0),
                    children: [
                      // Badge Asset Module 1: Teddy Afro Early Supporter mic emblem
                      _buildTrophyBadge(
                        emblemIcon: Icons.mic_external_on_rounded,
                        bgColor: const Color(0xFFFFF9E6),
                        ringColor: _colorGoldAccent,
                        iconColor: _colorGoldAccent,
                        label: widget.isAmharic ? 'ቴዲ አፍሮ ደጋፊ' : 'Teddy Fan',
                      ),
                      const SizedBox(width: 14.0),
                      // Badge Asset Module 2: Rophnan wave completion emblem
                      _buildTrophyBadge(
                        emblemIcon: Icons.audiotrack_rounded,
                        bgColor: const Color(0xFFE8F4FD),
                        ringColor: _colorNeonBlue,
                        iconColor: _colorNeonBlue,
                        label: widget.isAmharic ? 'ሮፍናን ሞገድ' : 'Rophnan Wave',
                      ),
                      const SizedBox(width: 14.0),
                      // Badge Asset Module 3: Event pass vector
                      _buildTrophyBadge(
                        emblemIcon: Icons.confirmation_number_rounded,
                        bgColor: const Color(0xFFEBFDF3),
                        ringColor: const Color(0xFF00E676),
                        iconColor: const Color(0xFF00E676),
                        label: widget.isAmharic ? 'ተሳታፊ' : 'Concert Pass',
                      ),
                    ],
                  ),
                ),
              ),

              // 5. FEATURE 4: HIGH-CONTRAST UNIFIED UTILITY NAVIGATION STACK (Bordlerless divider-based minimalist layout)
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildNavigationRow(
                        index: 0,
                        icon: Icons.favorite_rounded,
                        title: _navSupportedCreators,
                        badgeCount: 8,
                        onTap: () =>
                            _showNavigationFeedback(_navSupportedCreators),
                      ),
                      _buildDivider(),
                      _buildNavigationRow(
                        index: 1,
                        icon: Icons.verified_rounded,
                        title: _navMyBadges,
                        badgeCount: 3,
                        onTap: () => _showNavigationFeedback(_navMyBadges),
                      ),
                      _buildDivider(),
                      _buildNavigationRow(
                        index: 2,
                        icon: Icons.local_shipping_rounded,
                        title: _navMyOrders,
                        badgeCount: 2,
                        onTap: () => _showNavigationFeedback(_navMyOrders),
                      ),
                      _buildDivider(),
                      _buildNavigationRow(
                        index: 3,
                        icon: Icons.confirmation_number_rounded,
                        title: _navMyTickets,
                        badgeCount: 1,
                        onTap: () => _showNavigationFeedback(_navMyTickets),
                      ),
                      _buildDivider(),
                      _buildNavigationRow(
                        index: 4,
                        icon: Icons.credit_card_rounded,
                        title: _navPaymentMethods,
                        isChevron: true,
                        onTap: () =>
                            _showNavigationFeedback(_navPaymentMethods),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. FEATURE 5: SECURE ACCOUNT TERMINATION BASE FOOTER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 24.0, bottom: 48.0),
                  child: Center(
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => _isLogOutHovered = true),
                      onTapUp: (_) => setState(() => _isLogOutHovered = false),
                      onTapCancel: () =>
                          setState(() => _isLogOutHovered = false),
                      onTap: () => _showLogOutDialog(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                        decoration: BoxDecoration(
                          color: _isLogOutHovered
                              ? _colorVividRed.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _colorVividRed
                                .withOpacity(_isLogOutHovered ? 0.4 : 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: _colorVividRed,
                              size: 20,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              '$_textLogOut / ውጣ',
                              style: GoogleFonts.poppins(
                                color: _colorVividRed,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Scoreboard statistics card module using Secondary Container background
  Widget _buildScoreboardCard(
      int index, String value, String label, bool isGoldAccent) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _hoveredStatIndex = index),
        onTapUp: (_) => setState(() => _hoveredStatIndex = null),
        onTapCancel: () => setState(() => _hoveredStatIndex = null),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isAmharic
                    ? '$label የዝርዝር መግለጫ በቅርቡ ይቀርባል!'
                    : 'Detailed insights for $label coming soon!',
              ),
              backgroundColor: _colorGoldAccent,
              duration: const Duration(milliseconds: 1000),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          decoration: BoxDecoration(
            color: _hoveredStatIndex == index
                ? (isGoldAccent
                    ? _colorGoldAccent.withOpacity(0.12)
                    : _colorNeonBlue.withOpacity(0.12))
                : _colorSecondaryContainer,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: _hoveredStatIndex == index
                  ? (isGoldAccent ? _colorGoldAccent : _colorNeonBlue)
                  : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: isGoldAccent ? _colorGoldAccent : _colorPrimaryText,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6.0),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: _colorSecondaryText,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Trophy badge generator logic
  Widget _buildTrophyBadge({
    required IconData emblemIcon,
    required Color bgColor,
    required Color ringColor,
    required Color iconColor,
    required String label,
  }) {
    return Tooltip(
      message: label,
      triggerMode: TooltipTriggerMode.tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: _colorCardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.04),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: _isDark ? ringColor.withOpacity(0.15) : bgColor,
                shape: BoxShape.circle,
                border:
                    Border.all(color: ringColor.withOpacity(0.5), width: 1.5),
              ),
              child: Center(
                child: Icon(
                  emblemIcon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: _colorPrimaryText,
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Unified minimalist navigation list item tile
  Widget _buildNavigationRow({
    required int index,
    required IconData icon,
    required String title,
    int? badgeCount,
    bool isChevron = false,
    required VoidCallback onTap,
  }) {
    final bool isHovered = _hoveredNavIndex == index;

    return GestureDetector(
      onTapDown: (_) => setState(() => _hoveredNavIndex = index),
      onTapUp: (_) => setState(() => _hoveredNavIndex = null),
      onTapCancel: () => setState(() => _hoveredNavIndex = null),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: isHovered
              ? _colorNeonBlue.withOpacity(_isDark ? 0.08 : 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            // Left flank: Neon Blue icon inside a circular container
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: _isDark
                    ? _colorNeonBlue.withOpacity(0.12)
                    : const Color(0xFFE8F4FD),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: _colorNeonBlue,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            // Central core: Expanded text layout handling title cleanly
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: _colorPrimaryText,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Right flank: Trailing interaction pill counter or simple Chevron
            if (badgeCount != null)
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: _isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badgeCount.toString(),
                    style: GoogleFonts.poppins(
                      color: _colorNeonBlue,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
            else if (isChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: _colorSecondaryText,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  // Thin clean separator lines instead of heavy box cards
  Widget _buildDivider() {
    return Divider(
      color: _isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.04),
      height: 1,
      thickness: 1,
      indent: 12,
      endIndent: 12,
    );
  }

  // Show standard interactive dialog for Logout termination
  void _showLogOutDialog() {
    final ScaffoldMessengerState? messenger =
        ScaffoldMessenger.maybeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: _colorCardSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: _isDark
                  ? BorderSide(
                      color: Colors.white.withOpacity(0.08), width: 1.0)
                  : BorderSide.none,
            ),
            title: Row(
              children: [
                const Icon(Icons.logout_rounded,
                    color: _colorVividRed, size: 24),
                const SizedBox(width: 10),
                Text(
                  _textLogOut,
                  style: GoogleFonts.poppins(
                    color: _colorPrimaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            content: Text(
              _textLogOutSub,
              style: GoogleFonts.poppins(
                color: _colorSecondaryText,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  widget.isAmharic ? 'ሰርዝ' : 'Cancel',
                  style: GoogleFonts.poppins(
                    color: _colorSecondaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colorVividRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 8.0),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  messenger?.showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.isAmharic
                            ? 'ደህና ሁኑ! በመውጣት ላይ...'
                            : 'Goodbye! Logging out...',
                      ),
                      backgroundColor: _colorVividRed,
                    ),
                  );
                },
                child: Text(
                  _textLogOut,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Interactive Bottom Sheet settings panel
  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: _colorCardSurface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28.0),
                topRight: Radius.circular(28.0),
              ),
              border: _isDark
                  ? Border(
                      top: BorderSide(
                          color: Colors.white.withOpacity(0.08), width: 1.0))
                  : null,
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 10,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Notch handle decoration
                Container(
                  width: 40,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: _isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.settings, color: _colorGoldAccent, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      _textSettings,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _colorPrimaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Premium setting items
                _buildSettingsOption(
                  icon: Icons.person_outline_rounded,
                  title: widget.isAmharic
                      ? 'የመለያ መረጃ ማስተካከያ'
                      : 'Edit Account Details',
                ),
                _buildDivider(),
                _buildSettingsOption(
                  icon: Icons.notifications_none_rounded,
                  title: widget.isAmharic
                      ? 'የማሳወቂያ ምርጫዎች'
                      : 'Notification Preferences',
                ),
                _buildDivider(),
                _buildSettingsOption(
                  icon: Icons.security_rounded,
                  title: widget.isAmharic
                      ? 'ደህንነት እና ግላዊነት'
                      : 'Security & Privacy',
                ),
                _buildDivider(),
                _buildSettingsOption(
                  icon: Icons.help_outline_rounded,
                  title: widget.isAmharic ? 'እገዛ እና ድጋፍ' : 'Help & Support',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Interactive settings items builder
  Widget _buildSettingsOption({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon, color: _colorNeonBlue),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: _colorPrimaryText,
          fontSize: 14.0,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: _colorSecondaryText),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isAmharic
                  ? '$title በቅርቡ ይቀርባል!'
                  : '$title is coming soon!',
            ),
            backgroundColor: _colorNeonBlue,
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  // Show dynamic toast for custom actions
  void _showNavigationFeedback(String routeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isAmharic
              ? 'ወደ $routeName በመሄድ ላይ...'
              : 'Routing to $routeName...',
        ),
        backgroundColor: _colorNeonBlue,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
