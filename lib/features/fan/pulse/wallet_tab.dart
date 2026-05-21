import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Wallet Tab for the Kerebta (ቀረብታ) platform.
///
/// Premium ultra-dark digital asset & vault financial ecosystem with
/// high-fidelity interactive animations, responsive bilingual support,
/// and bulletproof layout constraints.
class WalletTab extends StatefulWidget {
  final bool isAmharic;
  const WalletTab({Key? key, this.isAmharic = false}) : super(key: key);

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  // Balance visibility toggle state
  bool _isBalanceVisible = true;

  // State variable for scanning simulation
  bool _isScanningCode = false;

  bool get _isLight => Theme.of(context).brightness == Brightness.light;
  Color get _surfaceCard => _isLight ? _surfaceCardLight : _surfaceCardDark;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Color Design System Constants ──
  // Dark mode colors
  static const Color _scaffoldBgDark = Color(0xFF0B0B0D);
  static const Color _goldAccent = Color(0xFFD4AF37);
  static const Color _emeraldGreen = Color(0xFF00E676);
  static const Color _neonBlue = Color(0xFF1D9BF0);
  static const Color _surfaceCardDark = Color(0xFF141418);
  static const Color _velvetSlate = Color(0xFF1F1F25);
  // Light mode colors
  static const Color _scaffoldBgLight = Color(0xFFF6F6F9);
  static const Color _surfaceCardLight = Colors.white;


  // ── Mock Ledger Data ──
  final List<Map<String, dynamic>> _ledger = [
    {
      'title': 'Top-Up via Telebirr',
      'titleAmh': 'በቴሌብር የተሞላ',
      'time': 'Today, 1:45 PM',
      'timeAmh': 'ዛሬ, 1:45 ከሰዓት',
      'amount': 500.00,
      'isCredit': true,
    },
    {
      'title': 'Abeni Tour Tee Purchase',
      'titleAmh': 'የአቤኒ ቱር ቲሸርት ግዢ',
      'time': 'Yesterday, 8:12 PM',
      'timeAmh': 'ትላንት, 8:12 ምሽት',
      'amount': -1200.00,
      'isCredit': false,
    },
    {
      'title': 'Ad-Revenue Payout',
      'titleAmh': 'የማስታወቂያ ክፍያ ገቢ',
      'time': 'May 20, 10:30 AM',
      'timeAmh': 'ግንቦት 12, 10:30 ጠዋት',
      'amount': 2850.50,
      'isCredit': true,
    },
    {
      'title': 'Challenge Entry: Fund My EP',
      'titleAmh': 'የፈተና ተሳትፎ: ለEP ማሰባሰቢያ',
      'time': 'May 18, 4:15 PM',
      'timeAmh': 'ግንቦት 10, 4:15 ከሰዓት',
      'amount': -350.00,
      'isCredit': false,
    },
    {
      'title': 'Aster Aweke Live Ticket',
      'titleAmh': 'የአስቴር አወቀ ቀጥታ ትኬት',
      'time': 'May 15, 2:00 PM',
      'timeAmh': 'ግንቦት 7, 2:00 ከሰዓት',
      'amount': -800.00,
      'isCredit': false,
    },
    {
      'title': 'Vault Top-Up (CBE Transfer)',
      'titleAmh': 'የኪስ ቦርሳ ሙሌት (CBE ማስተላለፍ)',
      'time': 'May 12, 9:00 AM',
      'timeAmh': 'ግንቦት 4, 9:00 ጠዋት',
      'amount': 5000.00,
      'isCredit': true,
    },
  ];

  // ── Helper to format balance with privacy mask ──
  String _formatBalance(double value) {
    if (!_isBalanceVisible) {
      return '••••••';
    }
    return 'ETB ${value.toStringAsFixed(2)}';
  }

  // ── Bottom sheet action gates ──
  void _showTopUpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildActionModalWrapper(
          title: widget.isAmharic ? 'የኪስ ቦርሳ ሙላ' : 'Top-Up Wallet',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isAmharic ? 'የመሙያ ዘዴ ይምረጡ' : 'Select deposit method',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              _buildModalListOption(
                icon: Icons.phone_android_rounded,
                iconColor: const Color(0xFFE21A83),
                title: 'Telebirr',
                subtitle: widget.isAmharic ? 'ቅጽበታዊ የሞባይል ክፍያ' : 'Instant mobile money',
                onTap: () => _handleMockPaymentSubmit(context, 'Telebirr'),
              ),
              _buildModalListOption(
                icon: Icons.account_balance_rounded,
                iconColor: Colors.purple,
                title: 'CBE Birr / Bank Transfer',
                subtitle: widget.isAmharic ? 'ከባንክ ሂሳብዎ በቀጥታ' : 'Directly from bank account',
                onTap: () => _handleMockPaymentSubmit(context, 'CBE'),
              ),
              _buildModalListOption(
                icon: Icons.credit_card_rounded,
                iconColor: _goldAccent,
                title: 'Chapa (Card / International)',
                subtitle: widget.isAmharic ? 'ቪዛ፣ ማስተርካርድ፣ አፕል ፔይ' : 'Visa, Mastercard, Apple Pay',
                onTap: () => _handleMockPaymentSubmit(context, 'Chapa'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSendSheet(BuildContext context) {
    final searchController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCreator = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _buildActionModalWrapper(
              title: widget.isAmharic ? 'ለፈጣሪ ይላኩ' : 'Send to Creator',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isAmharic ? 'የፈጣሪ ስም ወይም መለያ ያስገቡ' : 'Search creator handle',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      controller: searchController,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      onChanged: (val) {
                        setModalState(() {
                          selectedCreator = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: const Icon(Icons.search_rounded, color: _goldAccent, size: 20),
                        hintText: '@handle',
                        hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 14),
                      ),
                    ),
                  ),
                  if (selectedCreator.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      widget.isAmharic ? 'የመላኪያ መጠን (ETB)' : 'Amount to Send (ETB)',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _goldAccent.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.robotoMono(
                          color: _emeraldGreen,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixText: 'ETB ',
                          prefixStyle: TextStyle(color: _emeraldGreen, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
                        onPressed: () {
                          Navigator.pop(context);
                          _showSuccessBanner(
                            context,
                            widget.isAmharic
                                ? 'ETB ${amountController.text} ለ $selectedCreator በተሳካ ሁኔታ ተልኳል!'
                                : 'Successfully sent ETB ${amountController.text} to $selectedCreator!',
                          );
                        },
                        child: Text(
                          widget.isAmharic ? 'ማስተላለፍ አረጋግጥ' : 'Confirm Transfer',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCashOutSheet(BuildContext context) {
    final amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildActionModalWrapper(
          title: widget.isAmharic ? 'ወጪ አድርግ' : 'Cash Out Payout',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isAmharic ? 'ወደ ባንክ ሂሳብ ማስተላለፊያ' : 'Transfer straight to your local bank account',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // Linked Bank Module Indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Commercial Bank of Ethiopia (CBE)',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Abeni - Checking (1000****4321)',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.isAmharic ? 'የገንዘብ መጠን (ETB)' : 'Amount to Cash Out (ETB)',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _neonBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.robotoMono(
                    color: _neonBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixText: 'ETB ',
                    prefixStyle: TextStyle(color: _neonBlue, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _emeraldGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showSuccessBanner(
                      context,
                      widget.isAmharic
                          ? 'ETB ${amountController.text} ወጪ ማድረግ ተጀምሯል! በ 1 ሰዓት ውስጥ ይገባል።'
                          : 'Payout of ETB ${amountController.text} initiated! Arriving within 1 hour.',
                    );
                  },
                  child: Text(
                    widget.isAmharic ? 'አሁን ወጪ አድርግ' : 'Initiate Payout Now',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showVoucherSheet(BuildContext context) {
    setState(() {
      _isScanningCode = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _buildActionModalWrapper(
              title: widget.isAmharic ? 'ኮድ ስካን ያድርጉ' : 'Scan Code Voucher',
              child: Column(
                children: [
                  Text(
                    widget.isAmharic
                        ? 'የቀረብታ ልዩ ኮድ ወይም የፕሪሚየም ማለፊያ ስካን ያድርጉ'
                        : 'Align creator voucher code or ticket pass within frame',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Mock glowing scanner viewport
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _goldAccent, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glassy camera simulation background
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                        // Reticle Corners
                        _buildScannerCorner(Alignment.topLeft),
                        _buildScannerCorner(Alignment.topRight),
                        _buildScannerCorner(Alignment.bottomLeft),
                        _buildScannerCorner(Alignment.bottomRight),
                        // Scanner Icon
                        const Icon(Icons.qr_code_scanner_rounded, color: Colors.white24, size: 80),
                        // Pulsing neon line
                        _buildPulsingScanLine(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
                      onPressed: () {
                        Navigator.pop(context);
                        _showSuccessBanner(
                          context,
                          widget.isAmharic
                              ? 'ቫውቸር ኮድ "KRB-GOLD-99" በድል ተሞልቷል! (ETB +350.00)'
                              : 'Voucher "KRB-GOLD-99" successfully redeemed! (ETB +350.00)',
                        );
                      },
                      child: Text(
                        widget.isAmharic ? 'የማሳያ ኮድ ተጠቀም' : 'Redeem Demo Voucher',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        _isScanningCode = false;
      });
    });
  }

  // ── Helper builders for sheets ──
  Widget _buildActionModalWrapper({required String title, required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141418),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: _goldAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildModalListOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: _isLight ? Colors.black54 : Colors.white54,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }

  void _handleMockPaymentSubmit(BuildContext context, String gateway) {
    Navigator.pop(context);
    _showSuccessBanner(
      context,
      widget.isAmharic
          ? 'በ $gateway በኩል ETB 1,000.00 በተሳካ ሁኔታ ተሞልቷል!'
          : 'Successfully credited ETB 1,000.00 via $gateway!',
    );
  }

  void _showSuccessBanner(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _emeraldGreen,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.black, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Scanner corner builder
  Widget _buildScannerCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: alignment == Alignment.topLeft || alignment == Alignment.topRight
                ? const BorderSide(color: _goldAccent, width: 3)
                : BorderSide.none,
            bottom: alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight
                ? const BorderSide(color: _goldAccent, width: 3)
                : BorderSide.none,
            left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft
                ? const BorderSide(color: _goldAccent, width: 3)
                : BorderSide.none,
            right: alignment == Alignment.topRight || alignment == Alignment.bottomRight
                ? const BorderSide(color: _goldAccent, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Scanner line animation
  Widget _buildPulsingScanLine() {
    return _ScannerLineAnim();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      backgroundColor: _isLight ? _scaffoldBgLight : _scaffoldBgDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ═══════════════════════════════════════════════════════════
              // 1. BASE CANVAS & SECURE HEADER ARCHITECTURE
              // ═══════════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Localized heavy weight title
                      Text(
                        widget.isAmharic ? 'ኪስ ቦርሳ' : 'Wallet',
                        style: GoogleFonts.poppins(
                          color: _isLight ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 34,
                          letterSpacing: 0.5,
                        ),
                      ),
                      // Statement analytical toggle trigger
                      Container(
                        decoration: const BoxDecoration(
                          color: _velvetSlate,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 20),
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _showSuccessBanner(
                              context,
                              widget.isAmharic
                                  ? 'የክፍያ ታሪክ መዝገብ በተሳካ ሁኔታ ተጭኗል!'
                                  : 'Analytical transaction history loaded successfully!',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════════════
              // 2. FEATURE 1: THE GLASSMORPHIC "VAULT MASTER" CARD
              // ═══════════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        // Ultra-thin Gold & Neon Blue Gradient border outline
                        gradient: const LinearGradient(
                          colors: [_goldAccent, _neonBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(1.5), // Multi-layered border thickness
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isLight ? _surfaceCardLight : _surfaceCardDark,
                          borderRadius: BorderRadius.circular(22.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.5),
                          child: Stack(
                            children: [
                              // Glassmorphic translucent mesh highlights
                              Positioned(
                                top: -80,
                                right: -80,
                                child: Container(
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                      color: _goldAccent.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _goldAccent.withOpacity(0.4),
                                          blurRadius: 60,
                                          spreadRadius: 0,
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                ),
                              ),
                              Positioned(
                                bottom: -100,
                                left: -60,
                                child: Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                        color: _neonBlue.withOpacity(0.08),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: _neonBlue.withOpacity(0.4),
                                            blurRadius: 60,
                                            spreadRadius: 0,
                                            offset: Offset.zero,
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                              // Core content layout
                              Padding(
                                padding: const EdgeInsets.all(22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Top Cluster: Fingerprint & Label
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.fingerprint_rounded,
                                          color: _goldAccent,
                                          size: 28,
                                        ),
                                        Text(
                                          'KEREBTA VAULT',
                                          style: GoogleFonts.poppins(
                                            color: _isLight ? Colors.black54 : Colors.white54,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 10,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Center Balance Area with security eye toggle
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.isAmharic ? 'የኪስ ሂሳብ ቀሪ' : 'Available Balance',
                                          style: GoogleFonts.poppins(
                                            color: _isLight ? Colors.black38 : Colors.white38,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _formatBalance(1250.00),
                                                style: GoogleFonts.robotoMono(
                                                  color: _isLight ? Colors.black : Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 26,
                                                  letterSpacing: -0.5,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            // Eye toggle protection trigger
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isBalanceVisible = !_isBalanceVisible;
                                                });
                                              },
                                              child: AnimatedSwitcher(
                                                duration: const Duration(milliseconds: 200),
                                                child: Icon(
                                                  _isBalanceVisible
                                                      ? Icons.visibility_rounded
                                                      : Icons.visibility_off_rounded,
                                                  key: ValueKey(_isBalanceVisible),
                                                  color: _goldAccent,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Bottom Card Profile Cluster
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '@abeni_music',
                                            style: GoogleFonts.poppins(
                                              color: _isLight ? Colors.black87 : Colors.white70,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _emeraldGreen.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: _emeraldGreen.withOpacity(0.25), width: 1),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                widget.isAmharic ? 'የተረጋገጠ ፈጣሪ' : 'Verified Creator',
                                                style: GoogleFonts.poppins(
                                                  color: _emeraldGreen,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 9,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(Icons.verified_rounded, color: _emeraldGreen, size: 10),
                                            ],
                                          ),
                                        ),
                                      ],
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
              ),

              // ═══════════════════════════════════════════════════════════
              // 3. FEATURE 2: FRICTIONLESS ACTION GATEWAY TRANSFERS
              // ═══════════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionButton(
                        context: context,
                        icon: Icons.add_rounded,
                        title: widget.isAmharic ? 'ሙላ' : 'Top-Up',
                        onTap: () => _showTopUpSheet(context),
                      ),
                      _buildActionButton(
                        context: context,
                        icon: Icons.send_rounded,
                        title: widget.isAmharic ? 'ላክ' : 'Send',
                        onTap: () => _showSendSheet(context),
                      ),
                      _buildActionButton(
                        context: context,
                        icon: Icons.account_balance_rounded,
                        title: widget.isAmharic ? 'ወጪ አድርግ' : 'Cash Out',
                        onTap: () => _showCashOutSheet(context),
                      ),
                      _buildActionButton(
                        context: context,
                        icon: Icons.qr_code_scanner_rounded,
                        title: widget.isAmharic ? 'ቫውቸር' : 'Voucher',
                        onTap: () => _showVoucherSheet(context),
                      ),
                    ],
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════════════
              // 4. FEATURE 3: LOCAL PAYMENT RAILS CONNECTED CAROUSEL
              // ═══════════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        widget.isAmharic ? 'የተገናኙ ሂሳቦች' : 'Linked Accounts',
                        style: GoogleFonts.poppins(
                          color: _isLight ? Colors.black87 : Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20, right: 8),
                        children: [
                          // Telebirr Link Module
                          _buildLinkedAccountCard(
                            logoColor: const Color(0xFFE21A83),
                            gradientColors: [const Color(0xFF3A0D25), const Color(0xFF1F0815)],
                            brandName: 'Telebirr',
                            accountMask: '09****4321',
                          ),
                          // Commercial Bank of Ethiopia (CBE) Module
                          _buildLinkedAccountCard(
                            logoColor: Colors.purple,
                            gradientColors: [const Color(0xFF220835), const Color(0xFF140520)],
                            brandName: 'CBE Bank',
                            accountMask: 'Abeni - Checking',
                          ),
                          // Add Account Module
                          GestureDetector(
                            onTap: () {
                              _showSuccessBanner(
                                context,
                                widget.isAmharic
                                    ? 'አዲስ የክፍያ አካውንት ማገናኛ ገፅ በቅርቡ ይከፈታል!'
                                    : 'Adding new payment channels will be available soon!',
                              );
                            },
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white12,
                                  width: 1.5,
                                  style: BorderStyle.solid, // Simulated dotted look with clean borders
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.add_rounded, color: _goldAccent, size: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ═══════════════════════════════════════════════════════════
              // 5. FEATURE 4: COMBINED PERFORMANCE TRANSACTION LEDGER
              // ═══════════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isAmharic ? 'የቅርብ ጊዜ እንቅስቃሴዎች' : 'Recent Activity',
                        style: GoogleFonts.poppins(
                          color: _isLight ? Colors.black87 : Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showSuccessBanner(
                            context,
                            widget.isAmharic
                                ? 'ሁሉንም የግብይት ታሪክ ማሳያ ገፅ በቅርቡ ይከፈታል!'
                                : 'Entire ledger view system will be loaded soon!',
                          );
                        },
                        child: Text(
                          widget.isAmharic ? 'ሁሉንም አሳይ' : 'View All',
                          style: GoogleFonts.poppins(
                            color: _goldAccent,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ledger list stack items
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = _ledger[index];
                      final bool isCredit = item['isCredit'] as bool;
                      final double amount = item['amount'] as double;
                      final String title = widget.isAmharic ? item['titleAmh'] as String : item['title'] as String;
                      final String time = widget.isAmharic ? item['timeAmh'] as String : item['time'] as String;

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _isLight 
                                  ? Colors.black.withOpacity(0.06) 
                                  : Colors.white.withOpacity(0.06), 
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Far Left Flank (Visual Identifier)
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isLight ? Colors.black.withOpacity(0.04) : _velvetSlate,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCredit ? Icons.south_west_rounded : Icons.north_east_rounded,
                                color: isCredit ? _emeraldGreen : (_isLight ? Colors.black54 : Colors.white60),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Center Stack Area (Metadata)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: GoogleFonts.poppins(
                                      color: _isLight ? Colors.black87 : Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    time,
                                    style: GoogleFonts.poppins(
                                      color: _isLight ? Colors.black54 : Colors.white38,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Far Right Flank (Numeric value)
                            Container(
                              constraints: const BoxConstraints(minWidth: 100),
                              alignment: Alignment.centerRight,
                              child: Text(
                                isCredit
                                    ? '+${_formatBalance(amount)}'
                                    : '-${_formatBalance(amount.abs())}',
                                style: GoogleFonts.robotoMono(
                                  color: isCredit 
                                      ? _emeraldGreen 
                                      : (_isLight ? Colors.black87 : Colors.white),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: _ledger.length,
                  ),
                ),
              ),

              // Bottom safe gap spacer
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper builds for action gateway items ──
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool _isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _velvetSlate,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.04),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: _isLight ? Colors.black : Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper builders for Payment modules ──
  Widget _buildLinkedAccountCard({
    required Color logoColor,
    required List<Color> gradientColors,
    required String brandName,
    required String accountMask,
  }) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: logoColor.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  brandName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: logoColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              accountMask,
              style: GoogleFonts.robotoMono(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private stateful widget to support scan line pulsing simulation ──
class _ScannerLineAnim extends StatefulWidget {
  @override
  State<_ScannerLineAnim> createState() => _ScannerLineAnimState();
}

class _ScannerLineAnimState extends State<_ScannerLineAnim> with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  late final Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scanAnimation = Tween<double>(begin: -100.0, end: 100.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
    _scanController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _scanAnimation.value),
          child: Container(
            width: 220,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
