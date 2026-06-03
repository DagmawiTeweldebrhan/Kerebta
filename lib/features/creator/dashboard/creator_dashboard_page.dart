import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CreatorDashboardPage extends StatefulWidget {
  const CreatorDashboardPage({
    super.key,
    this.isAmharic = false,
  });

  final bool isAmharic;

  @override
  State<CreatorDashboardPage> createState() => _CreatorDashboardPageState();
}

class _CreatorDashboardPageState extends State<CreatorDashboardPage> {
  final ValueNotifier<int> _activeIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _activeIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final _StudioPalette palette = _StudioPalette(isDark: isDark);
    final _StudioStrings strings = _StudioStrings(widget.isAmharic);

    final List<Widget> tabs = <Widget>[
      _OverviewAnalyticsTab(palette: palette, strings: strings),
      _MediaCatalogTab(palette: palette, strings: strings),
      _MerchandiseTab(palette: palette, strings: strings),
      _PaidDmInboxTab(palette: palette, strings: strings),
      _PayoutSettlementsTab(palette: palette, strings: strings),
    ];

    return Scaffold(
      backgroundColor: palette.canvas,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool useRail = constraints.maxWidth >= 600;
            return ValueListenableBuilder<int>(
              valueListenable: _activeIndex,
              builder: (context, activeIndex, _) {
                final Widget content = IndexedStack(
                  index: activeIndex,
                  children: tabs,
                );

                if (useRail) {
                  return Row(
                    children: [
                      _StudioRail(
                        palette: palette,
                        strings: strings,
                        activeIndex: activeIndex,
                        onSelect: (value) => _activeIndex.value = value,
                      ),
                      Expanded(child: content),
                    ],
                  );
                }

                return Column(
                  children: [
                    Expanded(child: content),
                    _StudioBottomNav(
                      palette: palette,
                      strings: strings,
                      activeIndex: activeIndex,
                      onSelect: (value) => _activeIndex.value = value,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _StudioPalette {
  final bool isDark;
  _StudioPalette({required this.isDark});

  Color get canvas => isDark ? const Color(0xFF0B0B0E) : const Color(0xFFF8F9FA);
  Color get card => isDark ? const Color(0xFF1A1A1E) : const Color(0xFFF1F3F5);
  Color get green => const Color(0xFF00E676);
  Color get purple => const Color(0xFFD500F9);
  Color get amber => const Color(0xFFFFAB00);
  Color get textPrimary => isDark ? Colors.white : Colors.black87;
  Color get textSecondary => isDark ? Colors.white70 : Colors.black54;
  Color get border => isDark ? const Color.fromRGBO(255, 255, 255, 0.06) : const Color.fromRGBO(0, 0, 0, 0.06);
}

class _StudioStrings {
  final bool isAmharic;
  _StudioStrings(this.isAmharic);

  String get tabOverview => isAmharic ? 'አጠቃላይ' : 'Overview';
  String get tabMedia => isAmharic ? 'ሚዲያ' : 'Media';
  String get tabMerch => isAmharic ? 'ምርቶች' : 'Merch';
  String get tabInbox => isAmharic ? 'መልዕክት' : 'Inbox';
  String get tabPayouts => isAmharic ? 'ክፍያዎች' : 'Payouts';
}

class _StudioRail extends StatelessWidget {
  final _StudioPalette palette;
  final _StudioStrings strings;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const _StudioRail({
    required this.palette,
    required this.strings,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: palette.card,
        border: Border(right: BorderSide(color: palette.border, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _RailItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: strings.tabOverview, isActive: activeIndex == 0, onTap: () => onSelect(0), palette: palette),
          _RailItem(icon: Icons.video_library_outlined, activeIcon: Icons.video_library, label: strings.tabMedia, isActive: activeIndex == 1, onTap: () => onSelect(1), palette: palette),
          _RailItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: strings.tabMerch, isActive: activeIndex == 2, onTap: () => onSelect(2), palette: palette),
          _RailItem(icon: Icons.message_outlined, activeIcon: Icons.message, label: strings.tabInbox, isActive: activeIndex == 3, onTap: () => onSelect(3), palette: palette),
          _RailItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, label: strings.tabPayouts, isActive: activeIndex == 4, onTap: () => onSelect(4), palette: palette),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final _StudioPalette palette;

  const _RailItem({required this.icon, required this.activeIcon, required this.label, required this.isActive, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(isActive ? activeIcon : icon, color: isActive ? palette.textPrimary : palette.textSecondary, size: 28),
                if (isActive)
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: palette.green, shape: BoxShape.circle),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.poppins(fontSize: 10, color: isActive ? palette.textPrimary : palette.textSecondary, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _StudioBottomNav extends StatelessWidget {
  final _StudioPalette palette;
  final _StudioStrings strings;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const _StudioBottomNav({
    required this.palette,
    required this.strings,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        border: Border(top: BorderSide(color: palette.border, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: activeIndex,
        onTap: onSelect,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: palette.textPrimary,
        unselectedItemColor: palette.textSecondary,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard_outlined), activeIcon: const Icon(Icons.dashboard), label: strings.tabOverview),
          BottomNavigationBarItem(icon: const Icon(Icons.video_library_outlined), activeIcon: const Icon(Icons.video_library), label: strings.tabMedia),
          BottomNavigationBarItem(icon: const Icon(Icons.shopping_bag_outlined), activeIcon: const Icon(Icons.shopping_bag), label: strings.tabMerch),
          BottomNavigationBarItem(icon: const Icon(Icons.message_outlined), activeIcon: const Icon(Icons.message), label: strings.tabInbox),
          BottomNavigationBarItem(icon: const Icon(Icons.account_balance_wallet_outlined), activeIcon: const Icon(Icons.account_balance_wallet), label: strings.tabPayouts),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: OVERVIEW ANALYTICS
// -----------------------------------------------------------------------------
class _OverviewAnalyticsTab extends StatelessWidget {
  final _StudioPalette palette;
  final _StudioStrings strings;

  const _OverviewAnalyticsTab({required this.palette, required this.strings});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Vitals Matrix
        Container(
          decoration: BoxDecoration(
            color: palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.border, width: 1),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Settleable Revenue', style: GoogleFonts.poppins(fontSize: 12, color: palette.textSecondary)),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text('ETB 142,850.00', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: palette.textPrimary)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: palette.green.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                            child: Text('▲ +18.4% this week', style: GoogleFonts.poppins(fontSize: 10, color: palette.green, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 60, color: palette.border),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(strings.isAmharic ? 'ተከታዮች / ደጋፊዎች' : 'Followers / Supporters', style: GoogleFonts.poppins(fontSize: 10, color: palette.textSecondary)),
                            const SizedBox(height: 8),
                            Text('45.2K / 1.2K', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: palette.textPrimary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: palette.border),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.lock_clock, color: palette.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('14 Actionable Inbound Paid DMs', style: GoogleFonts.poppins(fontSize: 12, color: palette.textSecondary)),
                    ),
                    Text('ETB 7,200 Locked', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: palette.amber)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Chart placeholder
        Text('Revenue Trends', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: palette.textPrimary)),
        const SizedBox(height: 12),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.border, width: 1),
          ),
          child: CustomPaint(
            painter: _GridChartPainter(palette: palette),
          ),
        ),
        const SizedBox(height: 24),
        // Ledger
        Text('Recent Transactions', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: palette.textPrimary)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.border, width: 1),
          ),
          child: Column(
            children: [
              _LedgerRow(id: '#ORD-991', item: 'VIP Ticket Pass', amount: 'ETB 1,500', status: 'Fulfilled', palette: palette),
              Divider(height: 1, color: palette.border),
              _LedgerRow(id: '#ORD-990', item: 'Digital Track 01', amount: 'ETB 50', status: 'Processing', palette: palette),
              Divider(height: 1, color: palette.border),
              _LedgerRow(id: '#ORD-989', item: 'Exclusive Hoodie', amount: 'ETB 2,400', status: 'Failed', palette: palette),
            ],
          ),
        ),
      ],
    );
  }
}

class _LedgerRow extends StatelessWidget {
  final String id;
  final String item;
  final String amount;
  final String status;
  final _StudioPalette palette;

  const _LedgerRow({required this.id, required this.item, required this.amount, required this.status, required this.palette});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (status == 'Fulfilled') statusColor = palette.green;
    else if (status == 'Processing') statusColor = palette.amber;
    else statusColor = Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: GoogleFonts.robotoMono(fontSize: 12, color: palette.textSecondary)),
                Text(item, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: palette.textPrimary)),
              ],
            ),
          ),
          Expanded(
            child: Text(amount, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: palette.textPrimary)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withAlpha(50), width: 1),
            ),
            child: Text(status, style: GoogleFonts.poppins(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _GridChartPainter extends CustomPainter {
  final _StudioPalette palette;
  _GridChartPainter({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()..color = palette.border..strokeWidth = 1;
    final double stepX = size.width / 6;
    for (double i = 0; i <= size.width; i += stepX) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paintGrid);
    }
    final double stepY = size.height / 4;
    for (double i = 0; i <= size.height; i += stepY) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paintGrid);
    }

    final paintLine = Paint()
      ..color = palette.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.9, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.1, size.width * 0.8, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width, size.height * 0.2);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// TAB 2: MEDIA CATALOG
// -----------------------------------------------------------------------------
class _MediaCatalogTab extends StatefulWidget {
  final _StudioPalette palette;
  final _StudioStrings strings;
  const _MediaCatalogTab({required this.palette, required this.strings});

  @override
  State<_MediaCatalogTab> createState() => _MediaCatalogTabState();
}

class _MediaCatalogTabState extends State<_MediaCatalogTab> {
  int _selectedFilter = 0;
  
  final List<Map<String, dynamic>> _videos = [
    {
      'title': 'Behind The Scenes Part 1',
      'titleAmh': 'ከጀርባ ያሉ ትዕይንቶች ክፍል 1',
      'description': 'Exclusive look at how we shot the music video in Addis Ababa.',
      'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'duration': '10:42',
      'views': '45K Views',
      'earnings': 'ETB 24,150.00',
      'isPublic': true,
    },
    {
      'title': 'Addis Vibe Studio Session',
      'titleAmh': 'የአዲስ ቫይብ ስቱዲዮ ዝግጅት',
      'description': 'Studio recording session for our new single album.',
      'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'duration': '08:15',
      'views': '32K Views',
      'earnings': 'ETB 18,200.00',
      'isPublic': true,
    },
    {
      'title': 'Traditional Fusion Dance Intro',
      'titleAmh': 'ባህላዊ ውዝዋዜ መግቢያ',
      'description': 'Behind-the-scenes choreography training sessions.',
      'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'duration': '05:30',
      'views': '12K Views',
      'earnings': 'ETB 5,400.00',
      'isPublic': false,
    },
  ];

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch YouTube link: $urlString')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching link: $e')),
      );
    }
  }

  void _showAddVideoSheet() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController urlController = TextEditingController();
    bool isPublicVal = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.palette.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: widget.palette.border, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.strings.isAmharic ? 'አዲስ ቪዲዮ አክል' : 'Add New Video',
                      style: GoogleFonts.poppins(
                        color: widget.palette.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                      decoration: InputDecoration(
                        labelText: widget.strings.isAmharic ? 'ርዕስ' : 'Title',
                        labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.palette.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.palette.purple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: widget.strings.isAmharic ? 'መግለጫ' : 'Description',
                        labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.palette.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.palette.purple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: urlController,
                      style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        labelText: widget.strings.isAmharic ? 'የዩቲዩብ ሊንክ' : 'YouTube Link',
                        labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                        hintText: 'https://www.youtube.com/watch?...',
                        hintStyle: GoogleFonts.poppins(color: widget.palette.textSecondary.withOpacity(0.5)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.palette.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.palette.purple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.strings.isAmharic ? 'ለሁሉም የሚታይ (Public)' : 'Make Public',
                          style: GoogleFonts.poppins(color: widget.palette.textPrimary, fontSize: 14),
                        ),
                        Switch(
                          value: isPublicVal,
                          activeColor: widget.palette.purple,
                          onChanged: (val) {
                            setStateSheet(() => isPublicVal = val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.palette.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final title = titleController.text.trim();
                          final desc = descController.text.trim();
                          final url = urlController.text.trim();
                          if (title.isEmpty || url.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(widget.strings.isAmharic ? 'እባክዎ ርዕስ እና የዩቲዩብ ሊንክ ያስገቡ' : 'Please enter title and YouTube link')),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          setState(() {
                            _videos.insert(0, {
                              'title': title,
                              'titleAmh': title,
                              'description': desc,
                              'url': url,
                              'duration': '03:45',
                              'views': '0 Views',
                              'earnings': 'ETB 0.00',
                              'isPublic': isPublicVal,
                            });
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(widget.strings.isAmharic ? 'ቪዲዮ በተሳካ ሁኔታ ተጭኗል' : 'Video uploaded successfully')),
                          );
                        },
                        child: Text(
                          widget.strings.isAmharic ? 'ቪዲዮ አክል' : 'Add Video',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filters = widget.strings.isAmharic 
      ? ['ሁሉም', 'ሙሉ ቪዲዮዎች', 'ታሪኮች', 'ሙዚቃ']
      : ['All', 'Full Videos', 'Shorts', 'Audio Tracks'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.palette.purple,
        onPressed: _showAddVideoSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Filter Strip
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final bool isSelected = _selectedFilter == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? widget.palette.purple : widget.palette.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? widget.palette.purple : widget.palette.border, width: 1),
                    ),
                    child: Text(
                      filters[index],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : widget.palette.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _selectedFilter == 2 
              ? _buildShortsGrid() 
              : _buildLongFormList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLongFormList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        return GestureDetector(
          onTap: () => _launchURL(video['url'] as String),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.palette.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.palette.border, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    child: Text(video['duration'] as String, style: GoogleFonts.robotoMono(fontSize: 10, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.strings.isAmharic ? video['titleAmh'] as String : video['title'] as String, 
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: widget.palette.textPrimary), 
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8, 
                            height: 8, 
                            decoration: BoxDecoration(
                              color: (video['isPublic'] as bool? ?? true) ? widget.palette.green : widget.palette.amber, 
                              shape: BoxShape.circle
                            )
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (video['isPublic'] as bool? ?? true) 
                              ? (widget.strings.isAmharic ? 'የህዝብ (Public)' : 'Public')
                              : (widget.strings.isAmharic ? 'የግል (Private)' : 'Private'), 
                            style: GoogleFonts.poppins(fontSize: 10, color: widget.palette.textSecondary)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(video['views'] as String, style: GoogleFonts.poppins(fontSize: 12, color: widget.palette.textSecondary)),
                    Text(video['earnings'] as String, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: widget.palette.green)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShortsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 9 / 16,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(50),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.palette.border, width: 1),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 8, left: 8, right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('85K Views', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, size: 12, color: widget.palette.green),
                        const SizedBox(width: 4),
                        Expanded(child: Text('Monetized', style: GoogleFonts.poppins(fontSize: 10, color: widget.palette.green), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: MERCHANDISE
// -----------------------------------------------------------------------------
class _MerchandiseTab extends StatefulWidget {
  final _StudioPalette palette;
  final _StudioStrings strings;
  const _MerchandiseTab({required this.palette, required this.strings});

  @override
  State<_MerchandiseTab> createState() => _MerchandiseTabState();
}

class _MerchandiseTabState extends State<_MerchandiseTab> {
  final List<Map<String, dynamic>> _merchItems = [
    {
      'name': 'Streetwear Hoodie 1',
      'nameAmh': 'የጎዳና ላይ ሁዲ 1',
      'price': 'ETB 2,500.00',
      'stock': 'Only 5 Left',
      'stockAmh': '5 ብቻ ቀሪ',
    },
    {
      'name': 'Streetwear Hoodie 2',
      'nameAmh': 'የጎዳና ላይ ሁዲ 2',
      'price': 'ETB 2,500.00',
      'stock': 'Only 5 Left',
      'stockAmh': '5 ብቻ ቀሪ',
    },
    {
      'name': 'Kerebta Classic Cap',
      'nameAmh': 'ክላሲክ ቆብ',
      'price': 'ETB 850.00',
      'stock': 'In Stock',
      'stockAmh': 'በክምችት ላይ',
    },
    {
      'name': 'Limited Signature Mug',
      'nameAmh': 'የፊርማ ጽዋ',
      'price': 'ETB 600.00',
      'stock': 'Only 2 Left',
      'stockAmh': '2 ብቻ ቀሪ',
    },
  ];

  void _showAddMerchSheet() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController stockController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.palette.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.palette.border, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.strings.isAmharic ? 'አዲስ ምርት አክል' : 'Add New Merchandise',
                  style: GoogleFonts.poppins(
                    color: widget.palette.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                  decoration: InputDecoration(
                    labelText: widget.strings.isAmharic ? 'የምርት ስም' : 'Item Name',
                    labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.palette.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.palette.purple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: widget.strings.isAmharic ? 'ዋጋ (ETB)' : 'Price (ETB)',
                    labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                    hintText: 'e.g. 1500',
                    hintStyle: GoogleFonts.poppins(color: widget.palette.textSecondary.withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.palette.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.palette.purple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockController,
                  style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                  decoration: InputDecoration(
                    labelText: widget.strings.isAmharic ? 'ክምችት / መጠን' : 'Stock Quantity',
                    labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                    hintText: 'e.g. 10 items left, In Stock',
                    hintStyle: GoogleFonts.poppins(color: widget.palette.textSecondary.withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.palette.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.palette.purple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.palette.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final name = nameController.text.trim();
                      final price = priceController.text.trim();
                      final stock = stockController.text.trim();
                      if (name.isEmpty || price.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(widget.strings.isAmharic ? 'እባክዎ የምርት ስም እና ዋጋ ያስገቡ' : 'Please enter item name and price')),
                        );
                        return;
                      }
                      Navigator.pop(context);
                      setState(() {
                        _merchItems.insert(0, {
                          'name': name,
                          'nameAmh': name,
                          'price': 'ETB $price.00',
                          'stock': stock.isEmpty ? 'In Stock' : stock,
                          'stockAmh': stock.isEmpty ? 'በክምችት ላይ' : stock,
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(widget.strings.isAmharic ? 'ምርት በተሳካ ሁኔታ ታክሏል' : 'Merchandise added successfully')),
                      );
                    },
                    child: Text(
                      widget.strings.isAmharic ? 'ምርት አክል' : 'Add Item',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Inventory', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: widget.palette.textPrimary)),
            IconButton(
              icon: Icon(Icons.add_circle, color: widget.palette.purple),
              onPressed: _showAddMerchSheet,
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _merchItems.length,
          itemBuilder: (context, index) {
            final item = _merchItems[index];
            return Container(
              decoration: BoxDecoration(
                color: widget.palette.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.palette.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(30),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.shopping_bag, size: 40, color: widget.palette.textSecondary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.strings.isAmharic ? item['nameAmh'] as String : item['name'] as String, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: widget.palette.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(item['price'] as String, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: widget.palette.purple)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: widget.palette.amber.withAlpha(20), borderRadius: BorderRadius.circular(4)),
                          child: Text(widget.strings.isAmharic ? item['stockAmh'] as String : item['stock'] as String, style: GoogleFonts.poppins(fontSize: 10, color: widget.palette.amber, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text('Fulfillment Pipeline', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: widget.palette.textPrimary)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: widget.palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.palette.border, width: 1),
          ),
          child: ListTile(
            leading: Icon(Icons.local_shipping, color: widget.palette.textSecondary),
            title: Text('#ORD-991 - Abebe K.', style: GoogleFonts.poppins(fontSize: 14, color: widget.palette.textPrimary)),
            subtitle: Text('Pending Shipment', style: GoogleFonts.poppins(fontSize: 12, color: widget.palette.amber)),
            trailing: Icon(Icons.chevron_right, color: widget.palette.textSecondary),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: PAID DM INBOX
// -----------------------------------------------------------------------------
class _PaidDmInboxTab extends StatefulWidget {
  final _StudioPalette palette;
  final _StudioStrings strings;
  const _PaidDmInboxTab({required this.palette, required this.strings});

  @override
  State<_PaidDmInboxTab> createState() => _PaidDmInboxTabState();
}

class _PaidDmInboxTabState extends State<_PaidDmInboxTab> {
  int? _selectedChatIndex;
  double _minDmFee = 500.00;
  final TextEditingController _dmReplyController = TextEditingController();

  final List<Map<String, dynamic>> _chats = [
    {
      'user': 'Alex T.',
      'amount': 'ETB 1,000.00',
      'tier': const Color(0xFFFFAB00), // Amber
      'messages': [
        {'isMe': false, 'text': 'Hey! Love your new video, can I ask you a question about the guitar tutorial?', 'time': '10:30 AM'},
        {'isMe': true, 'text': 'Hey Alex! Thanks for the support. Sure, ask away!', 'time': '10:32 AM'},
        {'isMe': false, 'text': 'What settings did you use for the reverb on the solo track?', 'time': '10:35 AM'},
      ],
    },
    {
      'user': 'Betty M.',
      'amount': 'ETB 500.00',
      'tier': Colors.grey,
      'messages': [
        {'isMe': false, 'text': 'Requesting a quick shoutout for my friend. His name is Dawit, it is his birthday tomorrow!', 'time': 'Yesterday'},
      ],
    },
  ];

  void _showEditGateDialog() {
    final TextEditingController feeController = TextEditingController(text: _minDmFee.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: widget.palette.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            widget.strings.isAmharic ? 'የዲኤም መግቢያ ክፍያ ያስተካክሉ' : 'Edit Minimum DM Fee',
            style: GoogleFonts.poppins(color: widget.palette.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: feeController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(color: widget.palette.textPrimary),
            decoration: InputDecoration(
              suffixText: 'ETB',
              suffixStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.palette.border)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.palette.purple)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(widget.strings.isAmharic ? 'አትርሳ' : 'Cancel', style: GoogleFonts.poppins(color: widget.palette.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                final fee = double.tryParse(feeController.text.trim());
                if (fee != null) {
                  setState(() => _minDmFee = fee);
                }
                Navigator.pop(context);
              },
              child: Text(widget.strings.isAmharic ? 'አስቀምጥ' : 'Save', style: GoogleFonts.poppins(color: widget.palette.purple, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage() {
    final text = _dmReplyController.text.trim();
    if (text.isEmpty || _selectedChatIndex == null) return;

    final String time = TimeOfDay.now().format(context);
    setState(() {
      _chats[_selectedChatIndex!]['messages'].add({
        'isMe': true,
        'text': text,
        'time': time,
      });
    });
    _dmReplyController.clear();
  }

  @override
  void dispose() {
    _dmReplyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedChatIndex != null) {
      return _buildChatDetailView();
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Gate Control
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.palette.border, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Minimum DM Fee', style: GoogleFonts.poppins(fontSize: 12, color: widget.palette.textSecondary)),
                    Text('ETB ${_minDmFee.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: widget.palette.textPrimary)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _showEditGateDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.palette.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Edit Gate', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Filter
        Row(
          children: [
            _DmFilterChip(label: widget.strings.isAmharic ? 'ከፍተኛ ክፍያ' : 'Highest Value', isActive: true, palette: widget.palette),
            const SizedBox(width: 8),
            _DmFilterChip(label: widget.strings.isAmharic ? 'ያልተመለሱ' : 'Unanswered', isActive: false, palette: widget.palette),
          ],
        ),
        const SizedBox(height: 16),
        // Messages
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _chats.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final chat = _chats[index];
            final latestMsg = (chat['messages'] as List).last;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChatIndex = index;
                });
              },
              child: _PaidDmRow(
                user: chat['user'] as String,
                message: latestMsg['text'] as String,
                amount: chat['amount'] as String,
                tier: chat['tier'] as Color,
                palette: widget.palette,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChatDetailView() {
    final chat = _chats[_selectedChatIndex!];
    final messages = chat['messages'] as List;

    return Column(
      children: [
        // Chat Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: widget.palette.card,
            border: Border(bottom: BorderSide(color: widget.palette.border)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: widget.palette.textPrimary),
                onPressed: () => setState(() => _selectedChatIndex = null),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: widget.palette.purple.withAlpha(40),
                child: Text(
                  (chat['user'] as String).substring(0, 1),
                  style: GoogleFonts.poppins(color: widget.palette.purple, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat['user'] as String,
                      style: GoogleFonts.poppins(color: widget.palette.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      widget.strings.isAmharic ? 'የሚከፈልበት ዲኤም' : 'Paid DM',
                      style: GoogleFonts.poppins(color: widget.palette.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.palette.purple.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  chat['amount'] as String,
                  style: GoogleFonts.robotoMono(color: widget.palette.purple, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        // Messages list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final bool isMe = msg['isMe'] as bool;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe 
                        ? widget.palette.purple 
                        : widget.palette.card,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    border: isMe ? null : Border.all(color: widget.palette.border),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        msg['text'] as String,
                        style: GoogleFonts.poppins(
                          color: isMe ? Colors.white : widget.palette.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg['time'] as String,
                        style: GoogleFonts.poppins(
                          color: isMe ? Colors.white70 : widget.palette.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Composer Input Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.palette.card,
            border: Border(top: BorderSide(color: widget.palette.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dmReplyController,
                  style: GoogleFonts.poppins(color: widget.palette.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: widget.strings.isAmharic ? 'መልስ ይጻፉ...' : 'Reply to fan...',
                    hintStyle: GoogleFonts.poppins(color: widget.palette.textSecondary.withOpacity(0.6)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: widget.palette.purple),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DmFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final _StudioPalette palette;
  const _DmFilterChip({required this.label, required this.isActive, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? palette.purple.withAlpha(30) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? palette.purple : palette.border, width: 1),
      ),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? palette.purple : palette.textSecondary)),
    );
  }
}

class _PaidDmRow extends StatelessWidget {
  final String user;
  final String message;
  final String amount;
  final Color tier;
  final _StudioPalette palette;

  const _PaidDmRow({required this.user, required this.message, required this.amount, required this.tier, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: tier, width: 2),
            ),
            child: CircleAvatar(radius: 20, backgroundColor: Colors.grey.withAlpha(50), child: const Icon(Icons.person, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: palette.textPrimary)),
                Text(message, style: GoogleFonts.poppins(fontSize: 12, color: palette.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: palette.purple.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(amount, style: GoogleFonts.robotoMono(fontSize: 12, fontWeight: FontWeight.bold, color: palette.purple)),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 5: PAYOUTS & SETTLEMENTS
// -----------------------------------------------------------------------------
class _PayoutSettlementsTab extends StatefulWidget {
  final _StudioPalette palette;
  final _StudioStrings strings;
  const _PayoutSettlementsTab({required this.palette, required this.strings});

  @override
  State<_PayoutSettlementsTab> createState() => _PayoutSettlementsTabState();
}

class _PayoutSettlementsTabState extends State<_PayoutSettlementsTab> {
  String _cbeAccount = '**** **** 1234';
  String _cbeHolder = 'Commercial Bank of Ethiopia (CBE)';
  bool _cbeVerified = true;

  String _telebirrAccount = '+251 911 *** ***';
  bool _telebirrVerified = false;

  void _showEditAccountSheet(bool isCbe) {
    final TextEditingController field1Controller = TextEditingController(
      text: isCbe ? '' : _telebirrAccount.replaceAll('*** ***', '').replaceAll('+251 911', '').trim(),
    );
    final TextEditingController holderController = TextEditingController(
      text: isCbe ? '' : '',
    );
    
    int sheetStep = 0;
    final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
    final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());
    bool isVerifying = false;
    bool hasOtpError = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            if (sheetStep == 0) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: widget.palette.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: widget.palette.border, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCbe 
                          ? (widget.strings.isAmharic ? 'የCBE አካውንት አስተካክል' : 'Edit CBE Account')
                          : (widget.strings.isAmharic ? 'የቴሌብር አካውንት አስተካክል' : 'Edit Telebirr Account'),
                        style: GoogleFonts.poppins(
                          color: widget.palette.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isCbe) ...[
                        TextField(
                          controller: holderController,
                          style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                          decoration: InputDecoration(
                            labelText: widget.strings.isAmharic ? 'የአካውንት ባለቤት ስም' : 'Account Holder Name',
                            labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: widget.palette.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: widget.palette.purple),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: field1Controller,
                          style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: widget.strings.isAmharic ? 'የአካውንት ቁጥር' : 'Account Number',
                            labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: widget.palette.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: widget.palette.purple),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ] else ...[
                        TextField(
                          controller: field1Controller,
                          style: GoogleFonts.poppins(color: widget.palette.textPrimary),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: widget.strings.isAmharic ? 'የቴሌብር ስልክ ቁጥር' : 'Telebirr Phone Number',
                            labelStyle: GoogleFonts.poppins(color: widget.palette.textSecondary),
                            prefixText: '+251 ',
                            prefixStyle: GoogleFonts.poppins(color: widget.palette.textPrimary),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: widget.palette.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: widget.palette.purple),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.palette.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            final val1 = field1Controller.text.trim();
                            final holderVal = holderController.text.trim();
                            if (isCbe) {
                              if (val1.isEmpty || holderVal.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(widget.strings.isAmharic ? 'እባክዎ ሁሉንም መስኮች ያስገቡ' : 'Please fill in all fields')),
                                );
                                return;
                              }
                            } else {
                              if (val1.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(widget.strings.isAmharic ? 'እባክዎ የስልክ ቁጥር ያስገቡ' : 'Please enter phone number')),
                                );
                                return;
                              }
                            }
                            
                            setStateSheet(() {
                              sheetStep = 1;
                            });
                          },
                          child: Text(
                            widget.strings.isAmharic ? 'ማረጋገጫ ኮድ ጠይቅ' : 'Request Verification Code',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.palette.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: widget.palette.border, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: widget.palette.textPrimary),
                          onPressed: () => setStateSheet(() => sheetStep = 0),
                        ),
                        Expanded(
                          child: Text(
                            widget.strings.isAmharic ? 'ማንነትዎን ያረጋግጡ' : 'Verify Account Change',
                            style: GoogleFonts.poppins(
                              color: widget.palette.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.strings.isAmharic 
                        ? 'ወደ ስልክ ቁጥርዎ የተላከውን 6 አሃዝ ኮድ ያስገቡ'
                        : 'Enter the 6-digit verification code sent to your phone',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: widget.palette.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (i) {
                        final hasValue = otpControllers[i].text.isNotEmpty;
                        return Container(
                          width: 40,
                          height: 48,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: hasOtpError
                                ? Colors.redAccent
                                : (hasValue ? widget.palette.purple : widget.palette.border),
                              width: hasValue ? 1.5 : 1.0,
                            ),
                          ),
                          child: TextField(
                            controller: otpControllers[i],
                            focusNode: otpFocusNodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: GoogleFonts.poppins(
                              color: widget.palette.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              if (val.length == 1 && i < 5) {
                                otpFocusNodes[i + 1].requestFocus();
                              }
                              if (val.isEmpty && i > 0) {
                                otpFocusNodes[i - 1].requestFocus();
                              }
                              final code = otpControllers.map((c) => c.text).join();
                              if (code.length == 6) {
                                setStateSheet(() {
                                  isVerifying = true;
                                });
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  setState(() {
                                    if (isCbe) {
                                      final rawAcct = field1Controller.text.trim();
                                      _cbeAccount = rawAcct.length > 4 
                                        ? '**** **** ${rawAcct.substring(rawAcct.length - 4)}'
                                        : rawAcct;
                                      _cbeHolder = holderController.text.trim();
                                      _cbeVerified = true;
                                    } else {
                                      final rawPhone = field1Controller.text.trim();
                                      _telebirrAccount = '+251 9$rawPhone';
                                      _telebirrVerified = true;
                                    }
                                  });
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        widget.strings.isAmharic 
                                          ? 'የክፍያ አካውንት በተሳካ ሁኔታ ተቀይሯል' 
                                          : 'Payout account updated and verified successfully!'
                                      ),
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    if (isVerifying)
                      CircularProgressIndicator(color: widget.palette.purple)
                    else
                      Text(
                        widget.strings.isAmharic ? 'ኮድ ለማግኘት በመጠባበቅ ላይ...' : 'Waiting for code...',
                        style: GoogleFonts.poppins(color: widget.palette.textSecondary, fontSize: 11),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Settled Balance
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: widget.palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.palette.border, width: 1),
          ),
          child: Column(
            children: [
              Text('Ready for Cash-out', style: GoogleFonts.poppins(fontSize: 14, color: widget.palette.textSecondary)),
              const SizedBox(height: 8),
              Text('ETB 84,200.00', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: widget.palette.textPrimary)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.palette.green,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Withdraw Funds', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Banks
        Text('Local Bank Routing', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: widget.palette.textPrimary)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: widget.palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.palette.border, width: 1),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.account_balance, color: widget.palette.purple),
                title: Text(_cbeHolder, style: GoogleFonts.poppins(fontSize: 14, color: widget.palette.textPrimary)),
                subtitle: Text(_cbeAccount, style: GoogleFonts.robotoMono(fontSize: 12, color: widget.palette.textSecondary)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_cbeVerified) Icon(Icons.check_circle, color: widget.palette.green, size: 20),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.edit, color: widget.palette.purple, size: 20),
                      onPressed: () => _showEditAccountSheet(true),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: widget.palette.border),
              ListTile(
                leading: Icon(Icons.phone_android, color: widget.palette.purple),
                title: Text('Telebirr', style: GoogleFonts.poppins(fontSize: 14, color: widget.palette.textPrimary)),
                subtitle: Text(_telebirrAccount, style: GoogleFonts.robotoMono(fontSize: 12, color: widget.palette.textSecondary)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_telebirrVerified) Icon(Icons.check_circle, color: widget.palette.green, size: 20),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.edit, color: widget.palette.purple, size: 20),
                      onPressed: () => _showEditAccountSheet(false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Historical Settlement Stream
        Text('Historical Settlements', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: widget.palette.textPrimary)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: widget.palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.palette.border, width: 1),
          ),
          child: Column(
            children: [
              _SettlementRow(id: '#SET-041', account: 'CBE **** 1234', status: widget.strings.isAmharic ? 'ገቢ ሆኗል' : 'Settled', palette: widget.palette),
              Divider(height: 1, color: widget.palette.border),
              _SettlementRow(id: '#SET-040', account: 'Telebirr ****', status: widget.strings.isAmharic ? 'በመጠባበቅ ላይ' : 'Processing', palette: widget.palette),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettlementRow extends StatelessWidget {
  final String id;
  final String account;
  final String status;
  final _StudioPalette palette;

  const _SettlementRow({required this.id, required this.account, required this.status, required this.palette});

  @override
  Widget build(BuildContext context) {
    Color statusColor = (status == 'Settled' || status == 'ገቢ ሆኗል') ? palette.green : palette.amber;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: GoogleFonts.robotoMono(fontSize: 12, color: palette.textSecondary)),
                Text(account, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: palette.textPrimary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withAlpha(50), width: 1),
            ),
            child: Text(status, style: GoogleFonts.poppins(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
