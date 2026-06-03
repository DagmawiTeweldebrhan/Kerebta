import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum _CreatorContentType { music, merch, events, dm }

class CreatorHubPage extends StatefulWidget {
  final String creatorId;
  final String creatorName;
  final String avatarUrl;
  final String bannerImageUrl;
  final Color primaryAccent;
  final Color secondaryAccent;
  final int followerCount;
  final int supporterCount;
  final int dmRequestAmount;
  final bool isAmharic;

  const CreatorHubPage({
    Key? key,
    required this.creatorId,
    required this.creatorName,
    required this.avatarUrl,
    required this.bannerImageUrl,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.followerCount,
    required this.supporterCount,
    required this.dmRequestAmount,
    this.isAmharic = false,
  }) : super(key: key);

  @override
  State<CreatorHubPage> createState() => _CreatorHubPageState();
}

class _CreatorHubPageState extends State<CreatorHubPage> {
  _CreatorContentType _selectedType = _CreatorContentType.music;
  bool _dmUnlocked = false;
  late final List<Map<String, dynamic>> _dmHistory;
  final TextEditingController _dmComposerController = TextEditingController();

  final List<Map<String, dynamic>> _musicDrops = [
    {
      'title': 'Sememen Acoustic (Live Cut)',
      'titleAmh': 'áˆ°áˆ˜áˆ˜áŠ• áŠ áŠ®áˆµá‰²áŠ­ (á‰€áŒ¥á‰³)',
      'meta': 'Single Â· 3m 44s',
      'metaAmh': 'áŠáŒ áˆ‹ Â· 3á‹° 44áˆ°',
      'price': 150,
      'thumb': 'assets/images/exclusive_sememen.jpg',
    },
    {
      'title': 'Sidama Deep Mix',
      'titleAmh': 'áˆ²á‹³áˆ› á‹²á• áˆšáŠ­áˆµ',
      'meta': 'EP Â· 5 tracks',
      'metaAmh': 'EP Â· 5 á‰µáˆ«áŠ®á‰½',
      'price': 220,
      'thumb': 'assets/images/exclusive_sidama.jpg',
    },
    {
      'title': 'Kerebta Session Pack',
      'titleAmh': 'á‰€áˆ¨á‰¥á‰³ áˆ´áˆ½áŠ• á“áŠ­',
      'meta': 'Studio Bundle',
      'metaAmh': 'á‹¨áˆµá‰±á‹²á‹® áŒ¥á‰…áˆ',
      'price': 300,
      'thumb': 'assets/images/exclusive_saba.jpg',
    },
  ];

  final List<Map<String, dynamic>> _merchDrops = [
    {
      'name': 'Signature Tour Hoodie',
      'nameAmh': 'á‹¨á‰±áˆ­ áˆá‹²',
      'price': 'ETB 2,450',
      'image': 'assets/images/merch_hoodie.jpg',
    },
    {
      'name': 'Gold Line Cap',
      'nameAmh': 'á‹ˆáˆ­á‰… áŠ«á•',
      'price': 'ETB 1,200',
      'image': 'assets/images/merch_cap.jpg',
    },
    {
      'name': 'Collectors Vinyl',
      'nameAmh': 'á‹¨áˆ°á‰¥áˆ³á‰¢ á‰ªáŠ’áˆ',
      'price': 'ETB 3,800',
      'image': 'assets/images/merch_vinyl.jpg',
    },
    {
      'name': 'Pulse Tee',
      'nameAmh': 'á“áˆáˆµ á‰²áˆ¸áˆ­á‰µ',
      'price': 'ETB 950',
      'image': 'assets/images/merch_cap.jpg',
    },
  ];

  final List<Map<String, dynamic>> _eventRoster = [
    {
      'title': 'Addis Arena: Night Session',
      'titleAmh': 'áŠ á‹²áˆµ áŠ áˆ¬áŠ“: á‹¨áˆáˆ½á‰µ áˆ´áˆ½áŠ•',
      'meta': 'Jun 14 Â· 8:00 PM',
      'metaAmh': 'áˆ°áŠ” 14 Â· 2:00 áˆ›á‰³',
      'price': 'ETB 800',
    },
    {
      'title': 'VIP Meet & Soundcheck',
      'titleAmh': 'VIP á‰†á‹­á‰³ áŠ¥áŠ“ áˆ³á‹áŠ•á‹µá‰¼áŠ­',
      'meta': 'Jun 22 Â· 6:00 PM',
      'metaAmh': 'áˆ°áŠ” 22 Â· 12:00 áŠ¨áˆ°á‹“á‰µ',
      'price': 'ETB 1,650',
    },
    {
      'title': 'Open-Air Creator Festival',
      'titleAmh': 'áŠ­áá‰µ áŠ á‹¨áˆ­ á‹¨áˆáŒ£áˆªá‹Žá‰½ áŒáˆµá‰²á‰«áˆ',
      'meta': 'Jul 03 Â· 4:00 PM',
      'metaAmh': 'áˆáˆáˆŒ 03 Â· 10:00 áŠ¨áˆ°á‹“á‰µ',
      'price': 'ETB 1,100',
    },
  ];

  Color _canvas(bool isDark) =>
      isDark ? const Color(0xFF0B0B0E) : const Color(0xFFF8F9FA);
  Color _surface(bool isDark) =>
      isDark ? const Color(0xFF1A1A1E) : const Color(0xFFF1F3F5);
  Color _primaryText(bool isDark) =>
      isDark ? Colors.white : const Color(0xFF121214);
  Color _secondaryText(bool isDark) =>
      isDark ? Colors.white70 : const Color(0xFF4A4A52);
  Color _stroke(bool isDark) => isDark ? Colors.white10 : Colors.black12;

  String _compactCount(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '$value';
  }

  @override
  void initState() {
    super.initState();
    _dmHistory = <Map<String, dynamic>>[
      {
        'isMe': false,
        'text': widget.isAmharic
            ? 'áˆ°áˆ‹áˆ! á‹¨á‹šáˆ… áˆ³áˆáŠ•á‰µ á‹¨áŒˆáŠ•á‹˜á‰¥ á‹µáŒ‹á áŒá‰¥ ETB ${widget.dmRequestAmount} áŠá‹á¢'
            : 'Hey! My support target for this week is ETB ${widget.dmRequestAmount}.',
        'time': '09:12',
      },
      {
        'isMe': true,
        'text': widget.isAmharic
            ? 'áŠ á‹Žá£ áŠ¥á‹°áŒá‹áˆˆáˆá¢ áŠ¥á‰£áŠ­áˆ… á‹áˆ­á‹áˆ©áŠ• áˆ‹áŠ­áˆáŠá¢'
            : 'Great, I can support. Please share the details.',
        'time': '09:14',
      },
      {
        'isMe': false,
        'text': widget.isAmharic
            ? 'áŠ¥áŒ…áŒ áŠ áˆ˜áˆ°áŒáŠ“áˆˆáˆ ðŸ™ á‰ á‹šáˆ… DM á‹áˆµáŒ¥ áŠ¥áŠ“á‰€áŒ¥áˆ‹áˆˆáŠ•á¢'
            : 'Thank you so much. We can continue right here in DM.',
        'time': '09:16',
      },
    ];
  }

  @override
  void dispose() {
    _dmComposerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color canvas = _canvas(isDark);
    final Color surface = _surface(isDark);
    final Color primaryText = _primaryText(isDark);
    final Color secondaryText = _secondaryText(isDark);

    return Scaffold(
      backgroundColor: canvas,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(isDark, canvas, primaryText, secondaryText),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _buildMetricsStrip(
                  isDark, surface, primaryText, secondaryText),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _buildFilterPills(isDark, surface, primaryText),
            ),
          ),
          _buildDynamicContentSliver(
              isDark, surface, primaryText, secondaryText),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _buildLoyaltyGateway(
                  isDark, surface, primaryText, secondaryText),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child:
                  _buildDmGateway(isDark, surface, primaryText, secondaryText),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(
    bool isDark,
    Color canvas,
    Color primaryText,
    Color secondaryText,
  ) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 300,
      backgroundColor: canvas,
      elevation: 0,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Material(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.12),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _stroke(isDark), width: 1),
                  ),
                  child: Icon(Icons.arrow_back_rounded,
                      color: primaryText, size: 20),
                ),
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(widget.bannerImageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.35),
                    canvas,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [widget.primaryAccent, widget.secondaryAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _stroke(isDark),
                          width: 1.2,
                        ),
                      ),
                      child: ClipOval(
                        child: _buildImage(widget.avatarUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.creatorName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: primaryText,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.primaryAccent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: widget.primaryAccent.withOpacity(0.45),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded,
                                  size: 13, color: widget.primaryAccent),
                              const SizedBox(width: 5),
                              Text(
                                widget.isAmharic
                                    ? 'á‰µáŠ­áŠ­áˆˆáŠ›'
                                    : 'Verified',
                                style: GoogleFonts.poppins(
                                  color: widget.primaryAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.isAmharic
                                  ? '${widget.creatorName} áˆˆáˆ˜á‹°áŒˆá áŠ¥á‹¨á‰°á‹˜áŒ‹áŒ€...'
                                  : 'Preparing support flow for ${widget.creatorName}...',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: widget.primaryAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: _stroke(isDark), width: 0.8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: Text(
                        widget.isAmharic ? 'á‹°áŒá' : 'Support',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
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
    );
  }

  Widget _buildMetricsStrip(
    bool isDark,
    Color surface,
    Color primaryText,
    Color secondaryText,
  ) {
    final int hash = widget.creatorId.hashCode.abs();
    final int followers = widget.followerCount;
    final int supporters = widget.supporterCount;
    final int rank = 1 + (hash % 99);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _stroke(isDark), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Row(
        children: [
          _metricCell(
            value: _compactCount(followers),
            label: widget.isAmharic ? 'Followers' : 'FOLLOWERS',
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
          _divider(isDark),
          _metricCell(
            value: _compactCount(supporters),
            label: widget.isAmharic ? 'Supporters' : 'SUPPORTERS',
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
          _divider(isDark),
          _metricCell(
            value: '#$rank',
            label: widget.isAmharic
                ? 'á‹¨áˆ˜á‹µáˆ¨áŠ­ á‹°áˆ¨áŒƒ'
                : 'PLATFORM RANK',
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
        ],
      ),
    );
  }

  Expanded _metricCell({
    required String value,
    required String label,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: primaryText,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: secondaryText,
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Container(
      width: 1,
      height: 50,
      color: _stroke(isDark),
    );
  }

  Widget _buildFilterPills(bool isDark, Color surface, Color primaryText) {
    final pills = <Map<String, dynamic>>[
      {
        'type': _CreatorContentType.music,
        'label': widget.isAmharic ? 'Music' : 'Music'
      },
      {
        'type': _CreatorContentType.merch,
        'label': widget.isAmharic ? 'Merch' : 'Merch'
      },
      {
        'type': _CreatorContentType.events,
        'label': widget.isAmharic ? 'Events' : 'Events'
      },
      {'type': _CreatorContentType.dm, 'label': widget.isAmharic ? 'DM' : 'DM'},
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pills.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = pills[index]['type'] as _CreatorContentType;
          final bool active = _selectedType == type;
          return InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => setState(() => _selectedType = type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: active ? widget.primaryAccent : surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? widget.primaryAccent : _stroke(isDark),
                  width: 1,
                ),
              ),
              child: Text(
                pills[index]['label'] as String,
                style: GoogleFonts.poppins(
                  color: active ? Colors.black : primaryText,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDynamicContentSliver(
    bool isDark,
    Color surface,
    Color primaryText,
    Color secondaryText,
  ) {
    switch (_selectedType) {
      case _CreatorContentType.music:
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = _musicDrops[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _stroke(isDark), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 74,
                          height: 74,
                          child: _buildImage(item['thumb'] as String,
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isAmharic
                                  ? item['titleAmh'] as String
                                  : item['title'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.isAmharic
                                  ? item['metaAmh'] as String
                                  : item['meta'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: secondaryText,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 112,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                widget.secondaryAccent.withOpacity(0.2),
                            foregroundColor: widget.secondaryAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: widget.secondaryAccent.withOpacity(0.55),
                                width: 0.8,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.isAmharic
                                  ? 'ETB ${item['price']} / á‹¨á‹›áˆ¬'
                                  : 'ETB ${item['price']} / Today',
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: _musicDrops.length),
          ),
        );
      case _CreatorContentType.merch:
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = _merchDrops[index];
                return Container(
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _stroke(isDark), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(17)),
                          child: SizedBox.expand(
                            child: _buildImage(item['image'] as String,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isAmharic
                                  ? item['nameAmh'] as String
                                  : item['name'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item['price'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.robotoMono(
                                color: widget.primaryAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: _merchDrops.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.62,
            ),
          ),
        );
      case _CreatorContentType.events:
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = _eventRoster[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _stroke(isDark), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: widget.primaryAccent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.primaryAccent.withOpacity(0.45),
                            width: 0.8,
                          ),
                        ),
                        child: Icon(Icons.event,
                            color: widget.primaryAccent, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isAmharic
                                  ? item['titleAmh'] as String
                                  : item['title'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: primaryText,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isAmharic
                                  ? item['metaAmh'] as String
                                  : item['meta'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: secondaryText,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['price'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.robotoMono(
                          color: widget.secondaryAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: _eventRoster.length),
          ),
        );
      case _CreatorContentType.dm:
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              children: [
                // Minimal header
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: widget.primaryAccent.withOpacity(0.2),
                        child: ClipOval(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: _buildImage(widget.avatarUrl, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.creatorName,
                        style: GoogleFonts.poppins(
                          color: primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_dmUnlocked)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: widget.secondaryAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _stroke(isDark), width: 1),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.lock_outline, size: 40, color: widget.secondaryAccent),
                        const SizedBox(height: 12),
                        Text(
                          widget.isAmharic
                              ? 'የDM ክፍያ (አንድ ጊዜ ብቻ)'
                              : 'DM Access (One-Time Fee)',
                          style: GoogleFonts.poppins(
                            color: secondaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ETB ${widget.dmRequestAmount}',
                          style: GoogleFonts.robotoMono(
                            color: primaryText,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _dmUnlocked = true);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: widget.primaryAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              widget.isAmharic
                                  ? 'አንድ ጊዜ ክፈል እና DM ክፈት'
                                  : 'Pay Once & Unlock DM',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dmHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _dmHistory[index];
                      final bool isMe = item['isMe'] as bool? ?? false;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: NetworkImage(widget.avatarUrl),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? const Color(0xFF3797F0) // Instagram Blue
                                      : (isDark ? const Color(0xFF262626) : const Color(0xFFEFEFEF)),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                    bottomLeft: Radius.circular(isMe ? 20 : 4),
                                    bottomRight: Radius.circular(isMe ? 4 : 20),
                                  ),
                                ),
                                child: Text(
                                  item['text'] as String? ?? '',
                                  style: GoogleFonts.poppins(
                                    color: isMe ? Colors.white : primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_emotions_outlined, color: secondaryText, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _dmComposerController,
                            minLines: 1,
                            maxLines: 4,
                            style: GoogleFonts.poppins(
                              color: primaryText,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.isAmharic ? 'መልዕክት...' : 'Message...',
                              hintStyle: GoogleFonts.poppins(color: secondaryText, fontSize: 14),
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _sendComposerMessage,
                          icon: const Icon(Icons.send, color: Color(0xFF3797F0)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        );
    }
  }

  Widget _buildLoyaltyGateway(
    bool isDark,
    Color surface,
    Color primaryText,
    Color secondaryText,
  ) {
    const double progress = 0.73;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _stroke(isDark), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isAmharic
                ? 'á‹¨áŠ¥áˆ­áˆµá‹Ž á‹¨ááŒ¥áŠá‰µ á‹°áˆ¨áŒƒ'
                : 'Your Fan Loyalty',
            style: GoogleFonts.poppins(
              color: secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            widget.isAmharic ? 'áˆá‹© áŠ á‹µáŠ“á‰‚ Â· Top 5%' : 'Top 5% Fan',
            style: GoogleFonts.poppins(
              color: primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor:
                  (isDark ? Colors.white : Colors.black).withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(widget.primaryAccent),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isAmharic
                ? 'áŠ¨áˆšá‰€áŒ¥áˆˆá‹ áˆ½áˆáˆ›á‰µ 27% á‰€áˆ­á‰¶á‰³áˆ'
                : '27% away from your next exclusive reward unlock',
            style: GoogleFonts.poppins(
              color: secondaryText,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDmGateway(
    bool isDark,
    Color surface,
    Color primaryText,
    Color secondaryText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _stroke(isDark), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isAmharic
                      ? 'Creator Money Request'
                      : 'Creator Money Request',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _dmUnlocked
                      ? (widget.isAmharic ? 'DM Unlocked' : 'DM Unlocked')
                      : 'ETB ${widget.dmRequestAmount}',
                  style: GoogleFonts.robotoMono(
                    color: primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 38,
            child: OutlinedButton.icon(
              onPressed: () {
                if (_dmUnlocked) {
                  setState(() => _selectedType = _CreatorContentType.dm);
                } else {
                  _showDmRequestSheet();
                }
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
              label: Text(
                _dmUnlocked
                    ? (widget.isAmharic ? 'Open DM' : 'Open DM')
                    : (widget.isAmharic ? 'Unlock Once' : 'Unlock Once'),
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.secondaryAccent,
                side: BorderSide(
                  color: widget.secondaryAccent.withOpacity(0.55),
                  width: 0.9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDmRequestSheet() {
    if (!mounted) return;
    final BuildContext hostContext = context;
    final bool isDark = Theme.of(hostContext).brightness == Brightness.dark;
    final Color sheetBg = isDark ? const Color(0xFF141418) : Colors.white;
    final Color primaryText = _primaryText(isDark);
    final Color secondaryText = _secondaryText(isDark);
    final ScaffoldMessengerState? messenger =
        ScaffoldMessenger.maybeOf(hostContext);
    final TextEditingController messageController = TextEditingController(
      text: widget.isAmharic
          ? 'Hey ${widget.creatorName}, I want to support your ETB ${widget.dmRequestAmount} request.'
          : 'Hey ${widget.creatorName}, I want to support your ETB ${widget.dmRequestAmount} request.',
    );
    showModalBottomSheet(
      context: hostContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _stroke(isDark), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isAmharic ? 'Unlock DM Access' : 'Unlock DM Access',
                  style: GoogleFonts.poppins(
                    color: primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.isAmharic
                      ? 'One-time fee: ETB ${widget.dmRequestAmount}'
                      : 'One-time fee: ETB ${widget.dmRequestAmount}',
                  style: GoogleFonts.robotoMono(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController,
                  maxLines: 4,
                  style: GoogleFonts.poppins(color: primaryText, fontSize: 13),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: (isDark ? Colors.white : Colors.black)
                        .withOpacity(0.04),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _stroke(isDark), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: widget.primaryAccent, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      final String message = messageController.text.trim();
                      final String time = TimeOfDay.now().format(hostContext);
                      Navigator.of(sheetContext).pop();
                      if (!mounted) return;
                      setState(() {
                        _dmUnlocked = true;
                        if (message.isNotEmpty) {
                          _dmHistory.add({
                            'isMe': true,
                            'text': message,
                            'time': time,
                          });
                        }
                        _selectedType = _CreatorContentType.dm;
                      });
                      messenger?.showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.isAmharic
                                ? 'DM unlocked for ${widget.creatorName}.'
                                : 'DM unlocked for ${widget.creatorName}.',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: widget.primaryAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.isAmharic ? 'Pay & Unlock DM' : 'Pay & Unlock DM',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(messageController.dispose);
  }

  void _sendComposerMessage() {
    if (!_dmUnlocked || !mounted) return;
    final String message = _dmComposerController.text.trim();
    if (message.isEmpty) return;
    final String time = TimeOfDay.now().format(context);
    setState(() {
      _dmHistory.add({
        'isMe': true,
        'text': message,
        'time': time,
      });
    });
    _dmComposerController.clear();
  }

  Widget _buildImage(String source, {required BoxFit fit}) {
    if (source.startsWith('http')) {
      return Image.network(
        source,
        fit: fit,
        errorBuilder: (_, __, ___) => _imageFallback(),
      );
    }
    return Image.asset(
      source,
      fit: fit,
      errorBuilder: (_, __, ___) => _imageFallback(),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: widget.primaryAccent.withOpacity(0.15),
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        color: widget.primaryAccent,
        size: 24,
      ),
    );
  }
}
