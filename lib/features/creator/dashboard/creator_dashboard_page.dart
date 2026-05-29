import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      _OverviewTab(
        key: const PageStorageKey<String>('studio-overview'),
        palette: palette,
        strings: strings,
      ),
      _ContentLibraryTab(
        key: const PageStorageKey<String>('studio-content'),
        palette: palette,
        strings: strings,
      ),
      _PaidDmInboxTab(
        key: const PageStorageKey<String>('studio-paid-dm'),
        palette: palette,
        strings: strings,
      ),
      _AudienceInsightsTab(
        key: const PageStorageKey<String>('studio-audience'),
        palette: palette,
        strings: strings,
      ),
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
                final Widget content = Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: IndexedStack(
                    index: activeIndex,
                    children: tabs,
                  ),
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

class _StudioRail extends StatelessWidget {
  const _StudioRail({
    required this.palette,
    required this.strings,
    required this.activeIndex,
    required this.onSelect,
  });

  final _StudioPalette palette;
  final _StudioStrings strings;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = _navItems(strings);
    return Container(
      width: 78,
      margin: const EdgeInsets.fromLTRB(12, 12, 0, 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.stroke, width: 1),
      ),
      child: NavigationRail(
        selectedIndex: activeIndex,
        onDestinationSelected: onSelect,
        labelType: NavigationRailLabelType.none,
        backgroundColor: Colors.transparent,
        groupAlignment: -0.7,
        indicatorColor: Colors.transparent,
        selectedIconTheme: IconThemeData(color: palette.primaryAction),
        unselectedIconTheme: IconThemeData(
          color: palette.secondaryText.withValues(alpha: 0.7),
        ),
        destinations: items
            .asMap()
            .entries
            .map(
              (entry) => NavigationRailDestination(
                icon: _NavGlyph(
                  icon: entry.value.icon,
                  active: activeIndex == entry.key,
                  palette: palette,
                ),
                selectedIcon: _NavGlyph(
                  icon: entry.value.icon,
                  active: true,
                  palette: palette,
                ),
                label: Text(entry.value.label),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _StudioBottomNav extends StatelessWidget {
  const _StudioBottomNav({
    required this.palette,
    required this.strings,
    required this.activeIndex,
    required this.onSelect,
  });

  final _StudioPalette palette;
  final _StudioStrings strings;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = _navItems(strings);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.stroke, width: 1),
      ),
      child: Row(
        children: items.asMap().entries.map((entry) {
          final int index = entry.key;
          final _NavItem item = entry.value;
          final bool active = activeIndex == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onSelect(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NavGlyph(
                      icon: item.icon,
                      active: active,
                      palette: palette,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.shortLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: active
                            ? palette.primaryText
                            : palette.secondaryText.withValues(alpha: 0.9),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavGlyph extends StatelessWidget {
  const _NavGlyph({
    required this.icon,
    required this.active,
    required this.palette,
  });

  final IconData icon;
  final bool active;
  final _StudioPalette palette;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            icon,
            size: 21,
            color: active
                ? palette.primaryAction
                : palette.secondaryText.withValues(alpha: 0.8),
          ),
          if (active)
            const Positioned(
              right: 2,
              top: 4,
              child: _NeonDot(),
            ),
        ],
      ),
    );
  }
}

class _NeonDot extends StatelessWidget {
  const _NeonDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFF00E676),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _OverviewTab extends StatefulWidget {
  const _OverviewTab({
    super.key,
    required this.palette,
    required this.strings,
  });

  final _StudioPalette palette;
  final _StudioStrings strings;

  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab>
    with AutomaticKeepAliveClientMixin<_OverviewTab> {
  late final ScrollController _scrollController;

  final List<_LedgerEntry> _ledger = <_LedgerEntry>[
    _LedgerEntry(
      id: 'TX-9042',
      itemLabel: 'VIP Pass Ticket',
      dateTime: '2026-05-26 08:42',
      amountEtb: 1200,
      status: _LedgerStatus.fulfilled,
    ),
    _LedgerEntry(
      id: 'TX-9037',
      itemLabel: 'Paid DM Escrow',
      dateTime: '2026-05-26 07:18',
      amountEtb: 1000,
      status: _LedgerStatus.pending,
    ),
    _LedgerEntry(
      id: 'TX-9026',
      itemLabel: 'Audio Drop Bundle',
      dateTime: '2026-05-25 19:14',
      amountEtb: 8400,
      status: _LedgerStatus.fulfilled,
    ),
    _LedgerEntry(
      id: 'TX-9021',
      itemLabel: 'Backstage Offer',
      dateTime: '2026-05-25 15:02',
      amountEtb: 450,
      status: _LedgerStatus.failed,
    ),
    _LedgerEntry(
      id: 'TX-9008',
      itemLabel: 'Premium Support',
      dateTime: '2026-05-25 10:11',
      amountEtb: 3000,
      status: _LedgerStatus.fulfilled,
    ),
  ];

  final List<double> _revenuePoints = <double>[
    48,
    56,
    52,
    61,
    64,
    70,
    68,
    72,
    86,
    82,
    94,
    101,
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _StudioPalette p = widget.palette;
    final _StudioStrings s = widget.strings;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: _PageHeading(
            title: s.overview,
            subtitle: s.overviewSubtitle,
            palette: p,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _buildVitals(p, s),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _StudioCard(
              palette: p,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.revenuePath,
                    style: GoogleFonts.poppins(
                      color: p.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.revenuePathSub,
                    style: GoogleFonts.poppins(
                      color: p.secondaryText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _RevenueChartPainter(
                          points: _revenuePoints,
                          lineColor: p.primaryAction,
                          gridColor: p.stroke,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: Text(
              s.transactionLedger,
              style: GoogleFonts.poppins(
                color: p.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: _ledger.length,
          itemBuilder: (context, index) {
            final _LedgerEntry entry = _ledger[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StudioCard(
                palette: p,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.id,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoMono(
                              color: p.primaryText,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _ItemBadge(label: entry.itemLabel, palette: p),
                          const SizedBox(height: 5),
                          Text(
                            entry.dateTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: p.secondaryText,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatEtb(entry.amountEtb),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoMono(
                              color: p.primaryText,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _StatusChip(
                            status: entry.status,
                            palette: p,
                            strings: s,
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
      ],
    );
  }

  Widget _buildVitals(_StudioPalette p, _StudioStrings s) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double cardWidth = width >= 980
            ? (width - 16) / 3
            : width >= 660
                ? (width - 8) / 2
                : width;
        final List<Widget> cards = [
          SizedBox(
            width: cardWidth,
            child: _MetricCard(
              palette: p,
              label: s.netVaultBalance,
              value: _formatEtb(142850),
              chipText: '▲ +18.4% ${s.thisWeek}',
              chipColor: p.positive,
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: _MetricCard(
              palette: p,
              label: s.totalActiveBackers,
              value: _formatCompact(4240),
              chipText: s.liveCount,
              chipColor: p.primaryAction,
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: _MetricCard(
              palette: p,
              label: s.dmEscrowVault,
              value: '14 ${s.inboundPaidDm}',
              chipText: '${_formatEtb(7200)} ${s.locked}',
              chipColor: p.pending,
            ),
          ),
        ];
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cards,
        );
      },
    );
  }
}

class _ContentLibraryTab extends StatefulWidget {
  const _ContentLibraryTab({
    super.key,
    required this.palette,
    required this.strings,
  });

  final _StudioPalette palette;
  final _StudioStrings strings;

  @override
  State<_ContentLibraryTab> createState() => _ContentLibraryTabState();
}

class _ContentLibraryTabState extends State<_ContentLibraryTab>
    with AutomaticKeepAliveClientMixin<_ContentLibraryTab> {
  late final ScrollController _scrollController;
  _MediaFilter _filter = _MediaFilter.all;

  final List<_MediaItem> _items = <_MediaItem>[
    _MediaItem(
      id: 'M-1001',
      title: 'Exclusive Behind-the-Scenes Album Documentary',
      visibility: _MediaVisibility.public,
      uploadedAt: '2026-05-22 11:00',
      duration: '18:42',
      views: '14.2K',
      engagement: '11.4%',
      revenueEtb: 28400,
      type: _MediaFilter.videos,
      thumbnail: 'assets/images/logo.png',
    ),
    _MediaItem(
      id: 'M-1002',
      title: 'Acoustic Room Session: Limited Cut',
      visibility: _MediaVisibility.public,
      uploadedAt: '2026-05-20 08:40',
      duration: '04:31',
      views: '8.9K',
      engagement: '9.6%',
      revenueEtb: 12750,
      type: _MediaFilter.audio,
      thumbnail: 'assets/images/logo.png',
    ),
    _MediaItem(
      id: 'M-1003',
      title: 'Live Arena Ticket Batch #3',
      visibility: _MediaVisibility.draft,
      uploadedAt: '2026-05-18 16:21',
      duration: 'N/A',
      views: '2.4K',
      engagement: '6.1%',
      revenueEtb: 9400,
      type: _MediaFilter.tickets,
      thumbnail: 'assets/images/logo.png',
    ),
    _MediaItem(
      id: 'M-1004',
      title: 'Road Journal Episode 07',
      visibility: _MediaVisibility.public,
      uploadedAt: '2026-05-16 09:55',
      duration: '12:09',
      views: '19.5K',
      engagement: '13.8%',
      revenueEtb: 31200,
      type: _MediaFilter.videos,
      thumbnail: 'assets/images/logo.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  List<_MediaItem> get _filtered {
    if (_filter == _MediaFilter.all) return _items;
    return _items.where((item) => item.type == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _StudioPalette p = widget.palette;
    final _StudioStrings s = widget.strings;
    final List<_MediaItem> filtered = _filtered;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: _PageHeading(
            title: s.contentLibrary,
            subtitle: s.contentSubtitle,
            palette: p,
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _PinnedHeaderDelegate(
            minHeight: 56,
            maxHeight: 56,
            child: Container(
              color: p.canvas,
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _MediaFilter.values.map((filter) {
                    final bool active = _filter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() => _filter = filter),
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: active ? p.primaryAction : p.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: active ? p.primaryAction : p.stroke,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            s.mediaFilterLabel(filter),
                            style: GoogleFonts.poppins(
                              color: active ? Colors.black : p.primaryText,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        if (filtered.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _EmptyPanel(
                palette: p,
                title: s.noItems,
                subtitle: s.noItemsSubtitle,
              ),
            ),
          )
        else
          SliverList.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final _MediaItem item = filtered[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StudioCard(
                  palette: p,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double rowWidth = constraints.maxWidth;
                      final double thumbWidth =
                          math.max(100, math.min(156, rowWidth * 0.32));
                      final double metricsWidth =
                          math.max(96, math.min(150, rowWidth * 0.28));
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: thumbWidth,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _StudioImage(source: item.thumbnail),
                                    Positioned(
                                      right: 6,
                                      bottom: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.75,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: p.stroke,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          item.duration,
                                          style: GoogleFonts.robotoMono(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: p.primaryText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    height: 1.28,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: item.visibility ==
                                                _MediaVisibility.public
                                            ? p.positive
                                            : p.secondaryText,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        item.visibility ==
                                                _MediaVisibility.public
                                            ? s.publicLabel
                                            : s.draftLabel,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: p.secondaryText,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.uploadedAt,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.robotoMono(
                                    color: p.secondaryText,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: metricsWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _MiniMetric(
                                  label: s.viewsShort,
                                  value: item.views,
                                  palette: p,
                                ),
                                _MiniMetric(
                                  label: s.likesShort,
                                  value: item.engagement,
                                  palette: p,
                                ),
                                _MiniMetric(
                                  label: 'ETB',
                                  value: _formatCompact(item.revenueEtb),
                                  palette: p,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: s.manageItem,
                            onPressed: () => _showMediaActions(item, p, s),
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: p.secondaryText,
                              size: 18,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showMediaActions(
    _MediaItem item,
    _StudioPalette p,
    _StudioStrings s,
  ) {
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 18),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: p.stroke, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: p.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              _ActionRow(
                palette: p,
                icon: Icons.stacked_bar_chart_outlined,
                label: s.changeMonetization,
              ),
              _ActionRow(
                palette: p,
                icon: Icons.price_change_outlined,
                label: s.adjustPricing,
              ),
              _ActionRow(
                palette: p,
                icon: Icons.visibility_outlined,
                label: s.changeVisibility,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: p.stroke, width: 1),
                    foregroundColor: p.secondaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    s.close,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaidDmInboxTab extends StatefulWidget {
  const _PaidDmInboxTab({
    super.key,
    required this.palette,
    required this.strings,
  });

  final _StudioPalette palette;
  final _StudioStrings strings;

  @override
  State<_PaidDmInboxTab> createState() => _PaidDmInboxTabState();
}

class _PaidDmInboxTabState extends State<_PaidDmInboxTab>
    with AutomaticKeepAliveClientMixin<_PaidDmInboxTab> {
  late final ScrollController _scrollController;
  late final TextEditingController _composerController;
  _DmFilter _filter = _DmFilter.highestValue;
  String? _selectedThreadId;

  final List<_PaidDmThread> _threads = <_PaidDmThread>[
    _PaidDmThread(
      id: 'DM-7001',
      fanName: 'selam.music',
      timeLabel: '09:24',
      preview: 'Need a quick personalized voice note for my sister birthday.',
      tier: _TierLevel.platinum,
      amountEtb: 1000,
      state: _DmState.unanswered,
      unlockFeeEtb: 1000,
      unlocked: false,
      messages: <_ThreadMessage>[
        _ThreadMessage(
          fromCreator: false,
          text: 'Need a quick personalized voice note for my sister birthday.',
          timeLabel: '09:24',
        ),
      ],
    ),
    _PaidDmThread(
      id: 'DM-7002',
      fanName: 'addis.live',
      timeLabel: '08:11',
      preview: 'I sent ticket proof, can you confirm VIP meet slot?',
      tier: _TierLevel.gold,
      amountEtb: 750,
      state: _DmState.unanswered,
      unlockFeeEtb: 750,
      unlocked: false,
      messages: <_ThreadMessage>[
        _ThreadMessage(
          fromCreator: false,
          text: 'I sent ticket proof, can you confirm VIP meet slot?',
          timeLabel: '08:11',
        ),
      ],
    ),
    _PaidDmThread(
      id: 'DM-6990',
      fanName: 'hana.sound',
      timeLabel: 'Yesterday',
      preview: 'Thank you for the reply. Payment completed.',
      tier: _TierLevel.silver,
      amountEtb: 400,
      state: _DmState.completed,
      unlockFeeEtb: 400,
      unlocked: true,
      messages: <_ThreadMessage>[
        _ThreadMessage(
          fromCreator: false,
          text: 'Can I receive the signed poster this week?',
          timeLabel: 'Yesterday',
        ),
        _ThreadMessage(
          fromCreator: true,
          text: 'Yes, confirmed. It will ship this Friday.',
          timeLabel: 'Yesterday',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _composerController = TextEditingController();
    _selectedThreadId = _threads.first.id;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _composerController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  _PaidDmThread? get _selectedThread {
    if (_selectedThreadId == null) return null;
    for (final _PaidDmThread thread in _threads) {
      if (thread.id == _selectedThreadId) return thread;
    }
    return null;
  }

  List<_PaidDmThread> get _visibleThreads {
    final List<_PaidDmThread> list = _threads.where((thread) {
      switch (_filter) {
        case _DmFilter.highestValue:
          return true;
        case _DmFilter.unanswered:
          return thread.state == _DmState.unanswered;
        case _DmFilter.completed:
          return thread.state == _DmState.completed;
      }
    }).toList();
    list.sort((a, b) {
      if (_filter == _DmFilter.highestValue) {
        return b.amountEtb.compareTo(a.amountEtb);
      }
      if (a.state == _DmState.unanswered && b.state != _DmState.unanswered) {
        return -1;
      }
      if (a.state != _DmState.unanswered && b.state == _DmState.unanswered) {
        return 1;
      }
      return b.amountEtb.compareTo(a.amountEtb);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _StudioPalette p = widget.palette;
    final _StudioStrings s = widget.strings;
    final List<_PaidDmThread> visible = _visibleThreads;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool split = constraints.maxWidth >= 980;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PageHeading(
              title: s.paidDmInbox,
              subtitle: s.paidDmSubtitle,
              palette: p,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _DmFilter.values.map((filter) {
                  final bool active = _filter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _filter = filter),
                      borderRadius: BorderRadius.circular(999),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active ? p.primaryAction : p.surface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: active ? p.primaryAction : p.stroke,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          s.dmFilterLabel(filter),
                          style: GoogleFonts.poppins(
                            color: active ? Colors.black : p.primaryText,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: split
                  ? Row(
                      children: [
                        Expanded(
                          flex: 11,
                          child: _buildThreadList(visible, p, s),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 13,
                          child: _buildThreadDetail(_selectedThread, p, s),
                        ),
                      ],
                    )
                  : _buildThreadList(visible, p, s),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThreadList(
    List<_PaidDmThread> visible,
    _StudioPalette p,
    _StudioStrings s,
  ) {
    if (visible.isEmpty) {
      return _EmptyPanel(
        palette: p,
        title: s.noMessages,
        subtitle: s.noMessagesSub,
      );
    }
    return ListView.separated(
      controller: _scrollController,
      itemCount: visible.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final _PaidDmThread thread = visible[index];
        final bool selected = _selectedThreadId == thread.id;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (MediaQuery.sizeOf(context).width >= 980) {
              setState(() => _selectedThreadId = thread.id);
            } else {
              _openDetailSheet(thread, p, s);
            }
          },
          child: _StudioCard(
            palette: p,
            background:
                selected ? p.surfaceAlt.withValues(alpha: 0.9) : p.surfaceAlt,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: [
                _TierRingAvatar(tier: thread.tier, palette: p),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              thread.fanName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: p.primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            thread.timeLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoMono(
                              color: p.secondaryText,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        thread.preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: p.secondaryText,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: BoxDecoration(
                    color: p.primaryAction.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: p.primaryAction.withValues(alpha: 0.45),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _formatEtb(thread.amountEtb),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoMono(
                      color: p.primaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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

  Widget _buildThreadDetail(
    _PaidDmThread? thread,
    _StudioPalette p,
    _StudioStrings s,
  ) {
    if (thread == null) {
      return _EmptyPanel(
        palette: p,
        title: s.selectDmThread,
        subtitle: s.selectDmThreadSub,
      );
    }
    return _StudioCard(
      palette: p,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              _TierRingAvatar(tier: thread.tier, palette: p),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  thread.fanName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: p.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusChip(
                status: thread.state == _DmState.completed
                    ? _LedgerStatus.fulfilled
                    : _LedgerStatus.pending,
                palette: p,
                strings: s,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!thread.unlocked)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: p.pending.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.stroke, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.oneTimeDmFee,
                    style: GoogleFonts.poppins(
                      color: p.primaryText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_formatEtb(thread.unlockFeeEtb)} · ${s.payOnceOnly}',
                    style: GoogleFonts.robotoMono(
                      color: p.secondaryText,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          thread.unlocked = true;
                          thread.messages.add(
                            _ThreadMessage(
                              fromCreator: false,
                              text: s.unlockConfirmed,
                              timeLabel: _timeLabelNow(),
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: p.primaryAction,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        s.unlockThread,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.stroke, width: 1),
              ),
              child: ListView.separated(
                itemCount: thread.messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 7),
                itemBuilder: (context, index) {
                  final _ThreadMessage message = thread.messages[index];
                  return Row(
                    mainAxisAlignment: message.fromCreator
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 7),
                          decoration: BoxDecoration(
                            color: message.fromCreator
                                ? p.primaryAction
                                : p.surfaceAlt,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: message.fromCreator
                                  ? p.primaryAction
                                  : p.stroke,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: GoogleFonts.poppins(
                                  color: message.fromCreator
                                      ? Colors.black
                                      : p.primaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message.timeLabel,
                                style: GoogleFonts.robotoMono(
                                  color: message.fromCreator
                                      ? Colors.black.withValues(alpha: 0.65)
                                      : p.secondaryText,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.stroke, width: 1),
                  ),
                  child: TextField(
                    controller: _composerController,
                    minLines: 1,
                    maxLines: 3,
                    style: GoogleFonts.poppins(
                      color: p.primaryText,
                      fontSize: 12.5,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: s.replyHint,
                      hintStyle: GoogleFonts.poppins(
                        color: p.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 42,
                height: 42,
                child: ElevatedButton(
                  onPressed:
                      thread.unlocked ? () => _sendReply(thread, p, s) : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: p.primaryAction,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: p.stroke,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.send_rounded, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  thread.state = _DmState.completed;
                });
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  SnackBar(content: Text(s.payoutApproved)),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: p.positive,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                s.approveCollect,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendReply(_PaidDmThread thread, _StudioPalette p, _StudioStrings s) {
    final String text = _composerController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      thread.messages.add(
        _ThreadMessage(
          fromCreator: true,
          text: text,
          timeLabel: _timeLabelNow(),
        ),
      );
      thread.preview = text;
      thread.timeLabel = _timeLabelNow();
      if (thread.state != _DmState.completed) {
        thread.state = _DmState.unanswered;
      }
    });
    _composerController.clear();
  }

  void _openDetailSheet(
      _PaidDmThread thread, _StudioPalette p, _StudioStrings s) {
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, controller) {
            return Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                color: p.canvas,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border.all(color: p.stroke, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _buildThreadDetail(thread, p, s),
              ),
            );
          },
        );
      },
    );
  }
}

class _AudienceInsightsTab extends StatefulWidget {
  const _AudienceInsightsTab({
    super.key,
    required this.palette,
    required this.strings,
  });

  final _StudioPalette palette;
  final _StudioStrings strings;

  @override
  State<_AudienceInsightsTab> createState() => _AudienceInsightsTabState();
}

class _AudienceInsightsTabState extends State<_AudienceInsightsTab>
    with AutomaticKeepAliveClientMixin<_AudienceInsightsTab> {
  late final ScrollController _scrollController;
  final Set<String> _expandedTiers = <String>{'tier-1'};
  final List<_LoyaltyTier> _tiers = <_LoyaltyTier>[
    _LoyaltyTier(
      id: 'tier-1',
      name: 'Amba Tier / አምባ ደረጃ',
      monthlyEtb: 300,
      subscriberCount: 1120,
      perks: <String>[
        'Early video drops',
        'Priority DM queue',
        'One backstage pass code/month',
      ],
      enabled: true,
    ),
    _LoyaltyTier(
      id: 'tier-2',
      name: 'Sheger Tier / ሸገር ደረጃ',
      monthlyEtb: 550,
      subscriberCount: 680,
      perks: <String>[
        'All Amba perks',
        'Exclusive rehearsal livestream',
        'Member-only audio archive',
      ],
      enabled: true,
    ),
    _LoyaltyTier(
      id: 'tier-3',
      name: 'Abyss Tier / አቢስ ደረጃ',
      monthlyEtb: 900,
      subscriberCount: 214,
      perks: <String>[
        'All Sheger perks',
        'Quarterly meet-and-greet priority',
        'VIP event discount code',
      ],
      enabled: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _StudioPalette p = widget.palette;
    final _StudioStrings s = widget.strings;
    final int followers = 58240;
    final int paid = 8240;
    final double conversion = paid / followers;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: _PageHeading(
            title: s.audienceInsights,
            subtitle: s.audienceSubtitle,
            palette: p,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _StudioCard(
              palette: p,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.supporterDensity,
                    style: GoogleFonts.poppins(
                      color: p.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _DensityTile(
                          title: s.followersLabel,
                          value: _formatCompact(followers),
                          palette: p,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DensityTile(
                          title: s.paidSupportersLabel,
                          value: _formatCompact(paid),
                          palette: p,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DensityTile(
                          title: s.conversionLabel,
                          value: '${(conversion * 100).toStringAsFixed(1)}%',
                          palette: p,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: Text(
              s.loyaltyTiers,
              style: GoogleFonts.poppins(
                color: p.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: _tiers.length,
          itemBuilder: (context, index) {
            final _LoyaltyTier tier = _tiers[index];
            final bool expanded = _expandedTiers.contains(tier.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StudioCard(
                palette: p,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (expanded) {
                            _expandedTiers.remove(tier.id);
                          } else {
                            _expandedTiers.add(tier.id);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tier.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: p.primaryText,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${_formatEtb(tier.monthlyEtb)} / ${s.monthly}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.robotoMono(
                                    color: p.primaryAction,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatCompact(tier.subscriberCount),
                                style: GoogleFonts.poppins(
                                  color: p.primaryText,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                s.subscribers,
                                style: GoogleFonts.poppins(
                                  color: p.secondaryText,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Switch.adaptive(
                            value: tier.enabled,
                            activeColor: p.positive,
                            onChanged: (value) {
                              setState(() {
                                tier.enabled = value;
                              });
                            },
                          ),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: p.secondaryText,
                          ),
                        ],
                      ),
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 180),
                      crossFadeState: expanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tier.perks
                              .map(
                                (perk) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        margin: const EdgeInsets.only(top: 6),
                                        decoration: BoxDecoration(
                                          color: p.primaryAction,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          perk,
                                          style: GoogleFonts.poppins(
                                            color: p.secondaryText,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PageHeading extends StatelessWidget {
  const _PageHeading({
    required this.title,
    required this.subtitle,
    required this.palette,
  });

  final String title;
  final String subtitle;
  final _StudioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: palette.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: palette.secondaryText,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StudioCard extends StatelessWidget {
  const _StudioCard({
    required this.palette,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.background,
  });

  final _StudioPalette palette;
  final Widget child;
  final EdgeInsets padding;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.stroke, width: 1),
      ),
      child: child,
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.palette,
    required this.label,
    required this.value,
    required this.chipText,
    required this.chipColor,
  });

  final _StudioPalette palette;
  final String label;
  final String value;
  final String chipText;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return _StudioCard(
      palette: palette,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: palette.secondaryText,
              fontSize: 9.8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.9,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.robotoMono(
              color: palette.primaryText,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: chipColor.withValues(alpha: 0.45),
                width: 1,
              ),
            ),
            child: Text(
              chipText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: palette.primaryText,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final _StudioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: palette.secondaryText,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.robotoMono(
              color: palette.primaryText,
              fontSize: 10.8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemBadge extends StatelessWidget {
  const _ItemBadge({
    required this.label,
    required this.palette,
  });

  final String label;
  final _StudioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.stroke, width: 1),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          color: palette.primaryText,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    required this.palette,
    required this.strings,
  });

  final _LedgerStatus status;
  final _StudioPalette palette;
  final _StudioStrings strings;

  @override
  Widget build(BuildContext context) {
    Color fg;
    Color bg;
    String text;
    switch (status) {
      case _LedgerStatus.fulfilled:
        fg = palette.positive;
        bg = palette.positive.withValues(alpha: 0.12);
        text = strings.fulfilled;
      case _LedgerStatus.pending:
        fg = palette.pending;
        bg = palette.pending.withValues(alpha: 0.12);
        text = strings.pending;
      case _LedgerStatus.failed:
        fg = const Color(0xFFFF5252);
        bg = const Color(0xFFFF5252).withValues(alpha: 0.12);
        text = strings.failed;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: fg,
          fontSize: 10.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TierRingAvatar extends StatelessWidget {
  const _TierRingAvatar({
    required this.tier,
    required this.palette,
  });

  final _TierLevel tier;
  final _StudioPalette palette;

  @override
  Widget build(BuildContext context) {
    final Color ringColor = switch (tier) {
      _TierLevel.gold => const Color(0xFFFFD54F),
      _TierLevel.silver => const Color(0xFFCFD8DC),
      _TierLevel.platinum => palette.primaryAction,
    };
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor.withValues(alpha: 0.85), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: palette.surface,
          border: Border.all(color: palette.stroke, width: 1),
        ),
        child: Icon(
          Icons.person_outline_rounded,
          color: palette.primaryText,
          size: 18,
        ),
      ),
    );
  }
}

class _DensityTile extends StatelessWidget {
  const _DensityTile({
    required this.title,
    required this.value,
    required this.palette,
  });

  final String title;
  final String value;
  final _StudioPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.stroke, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.robotoMono(
              color: palette.primaryText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: palette.secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.palette,
    required this.icon,
    required this.label,
  });

  final _StudioPalette palette;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.stroke, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: palette.primaryAction, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: palette.primaryText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.palette,
    required this.title,
    required this.subtitle,
  });

  final _StudioPalette palette;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _StudioCard(
      palette: palette,
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, color: palette.secondaryText, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: palette.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: palette.secondaryText,
              fontSize: 11.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudioImage extends StatelessWidget {
  const _StudioImage({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    if (source.startsWith('http')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return Image.asset(
      source,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFF1A1A1E),
      alignment: Alignment.center,
      child: const Icon(
        Icons.videocam_outlined,
        color: Color(0xFFD500F9),
        size: 20,
      ),
    );
  }
}

class _RevenueChartPainter extends CustomPainter {
  _RevenueChartPainter({
    required this.points,
    required this.lineColor,
    required this.gridColor,
  });

  final List<double> points;
  final Color lineColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (int i = 0; i <= 6; i++) {
      final double x = (size.width / 6) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (int i = 0; i <= 4; i++) {
      final double y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    if (points.isEmpty) return;

    final double minValue = points.reduce(math.min);
    final double maxValue = points.reduce(math.max);
    final double span = math.max(1, maxValue - minValue);
    final double stepX =
        points.length == 1 ? 0 : size.width / (points.length - 1);
    final Path path = Path();
    for (int i = 0; i < points.length; i++) {
      final double normalized = (points[i] - minValue) / span;
      final double x = i * stepX;
      final double y = size.height - (normalized * (size.height - 16)) - 8;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.1
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _RevenueChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gridColor != gridColor;
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}

class _StudioPalette {
  _StudioPalette({required this.isDark});

  final bool isDark;

  Color get canvas =>
      isDark ? const Color(0xFF0B0B0E) : const Color(0xFFF8F9FA);
  Color get surface =>
      isDark ? const Color(0xFF1A1A1E) : const Color(0xFFF1F3F5);
  Color get surfaceAlt =>
      isDark ? const Color(0xFF141418) : const Color(0xFFFFFFFF);
  Color get primaryText => isDark ? Colors.white : const Color(0xFF121214);
  Color get secondaryText =>
      isDark ? Colors.white.withValues(alpha: 0.72) : const Color(0xFF4C4F55);
  Color get stroke =>
      isDark ? const Color(0x1AFFFFFF) : const Color(0x1A000000);
  Color get positive => const Color(0xFF00E676);
  Color get primaryAction => const Color(0xFFD500F9);
  Color get pending => const Color(0xFFFFAB00);
}

class _StudioStrings {
  const _StudioStrings(this.isAmharic);

  final bool isAmharic;

  String get overview => isAmharic ? 'Overview / አጠቃላይ' : 'Overview';
  String get overviewSubtitle => isAmharic
      ? 'Real-time studio health, escrow, and revenue paths.'
      : 'Real-time studio health, escrow, and revenue paths.';
  String get revenuePath =>
      isAmharic ? 'Revenue Path / የገቢ መስመር' : 'Revenue Path';
  String get revenuePathSub => isAmharic
      ? 'Last 12 checkpoints (ETB trend)'
      : 'Last 12 checkpoints (ETB trend)';
  String get transactionLedger =>
      isAmharic ? 'Transaction Ledger / የግብይት መዝገብ' : 'Transaction Ledger';
  String get netVaultBalance =>
      isAmharic ? 'Net Vault Balance' : 'Net Vault Balance';
  String get totalActiveBackers =>
      isAmharic ? 'Total Active Backers / ደጋፊዎች' : 'Total Active Backers';
  String get dmEscrowVault =>
      isAmharic ? 'Monetized DM Escrow Vault' : 'Monetized DM Escrow Vault';
  String get thisWeek => isAmharic ? 'this week' : 'this week';
  String get liveCount => isAmharic ? 'LIVE COUNT' : 'LIVE COUNT';
  String get inboundPaidDm =>
      isAmharic ? 'Inbound Paid DMs' : 'Inbound Paid DMs';
  String get locked => isAmharic ? 'Locked' : 'Locked';
  String get fulfilled => isAmharic ? 'Fulfilled' : 'Fulfilled';
  String get pending => isAmharic ? 'Pending' : 'Pending';
  String get failed => isAmharic ? 'Failed' : 'Failed';

  String get contentLibrary =>
      isAmharic ? 'Content Library / የይዘት ቤተ መዘክር' : 'Content Library';
  String get contentSubtitle => isAmharic
      ? 'Manage releases, pricing, visibility, and performance.'
      : 'Manage releases, pricing, visibility, and performance.';
  String mediaFilterLabel(_MediaFilter filter) {
    switch (filter) {
      case _MediaFilter.all:
        return isAmharic ? 'All / ሁሉም' : 'All';
      case _MediaFilter.videos:
        return isAmharic ? 'Videos / ቪዲዮዎች' : 'Videos';
      case _MediaFilter.audio:
        return isAmharic ? 'Audio / ሙዚቃ' : 'Audio';
      case _MediaFilter.tickets:
        return isAmharic ? 'Tickets / ትኬቶች' : 'Tickets';
    }
  }

  String get publicLabel => isAmharic ? 'Public / ይፋዊ' : 'Public';
  String get draftLabel => isAmharic ? 'Draft / ረቂቅ' : 'Draft';
  String get viewsShort => isAmharic ? 'VIEWS' : 'VIEWS';
  String get likesShort => isAmharic ? 'LIKES' : 'LIKES';
  String get manageItem => isAmharic ? 'Manage item' : 'Manage item';
  String get changeMonetization =>
      isAmharic ? 'Change monetization tier' : 'Change monetization tier';
  String get adjustPricing =>
      isAmharic ? 'Adjust local ETB pricing' : 'Adjust local ETB pricing';
  String get changeVisibility => isAmharic
      ? 'Change visibility permissions'
      : 'Change visibility permissions';
  String get close => isAmharic ? 'Close' : 'Close';
  String get noItems => isAmharic ? 'No items found' : 'No items found';
  String get noItemsSubtitle => isAmharic
      ? 'Try another filter or add a new release.'
      : 'Try another filter or add a new release.';

  String get paidDmInbox =>
      isAmharic ? 'Paid DM Inbox / የክፍያ DM ሳጥን' : 'Paid DM Inbox';
  String get paidDmSubtitle => isAmharic
      ? 'Priority queue for escrow-backed fan messages.'
      : 'Priority queue for escrow-backed fan messages.';
  String dmFilterLabel(_DmFilter filter) {
    switch (filter) {
      case _DmFilter.highestValue:
        return isAmharic ? 'Highest Value / ከፍተኛ ክፍያ' : 'Highest Value';
      case _DmFilter.unanswered:
        return isAmharic ? 'Unanswered / ያልተመለሱ' : 'Unanswered';
      case _DmFilter.completed:
        return isAmharic ? 'Completed / ያለቁ' : 'Completed';
    }
  }

  String get noMessages =>
      isAmharic ? 'No messages in this queue' : 'No messages in this queue';
  String get noMessagesSub => isAmharic
      ? 'New paid messages will appear here.'
      : 'New paid messages will appear here.';
  String get selectDmThread =>
      isAmharic ? 'Select a DM thread' : 'Select a DM thread';
  String get selectDmThreadSub => isAmharic
      ? 'Choose a message to open fulfillment view.'
      : 'Choose a message to open fulfillment view.';
  String get oneTimeDmFee =>
      isAmharic ? 'One-time DM unlock fee' : 'One-time DM unlock fee';
  String get payOnceOnly =>
      isAmharic ? 'pay once, not per text' : 'pay once, not per text';
  String get unlockThread => isAmharic ? 'Unlock Thread' : 'Unlock Thread';
  String get unlockConfirmed => isAmharic
      ? 'Thread unlocked. You can now send unlimited replies.'
      : 'Thread unlocked. You can now send unlimited replies.';
  String get replyHint =>
      isAmharic ? 'Type your response...' : 'Type your response...';
  String get approveCollect =>
      isAmharic ? 'Approve & Collect Payout' : 'Approve & Collect Payout';
  String get payoutApproved =>
      isAmharic ? 'Payout approved and queued.' : 'Payout approved and queued.';

  String get audienceInsights =>
      isAmharic ? 'Audience Insights / የተከታይ ትንታኔ' : 'Audience Insights';
  String get audienceSubtitle => isAmharic
      ? 'Track fan growth, paid conversion, and loyalty tiers.'
      : 'Track fan growth, paid conversion, and loyalty tiers.';
  String get supporterDensity =>
      isAmharic ? 'Supporter Density Breakdown' : 'Supporter Density Breakdown';
  String get followersLabel => isAmharic ? 'Followers / ተከታዮች' : 'Followers';
  String get paidSupportersLabel =>
      isAmharic ? 'Paid Supporters / ደጋፊዎች' : 'Paid Supporters';
  String get conversionLabel => isAmharic ? 'Conversion' : 'Conversion';
  String get loyaltyTiers =>
      isAmharic ? 'Loyalty Tier Configurator' : 'Loyalty Tier Configurator';
  String get monthly => isAmharic ? 'Month' : 'Month';
  String get subscribers => isAmharic ? 'Subscribers' : 'Subscribers';
}

class _LedgerEntry {
  const _LedgerEntry({
    required this.id,
    required this.itemLabel,
    required this.dateTime,
    required this.amountEtb,
    required this.status,
  });

  final String id;
  final String itemLabel;
  final String dateTime;
  final double amountEtb;
  final _LedgerStatus status;
}

class _MediaItem {
  const _MediaItem({
    required this.id,
    required this.title,
    required this.visibility,
    required this.uploadedAt,
    required this.duration,
    required this.views,
    required this.engagement,
    required this.revenueEtb,
    required this.type,
    required this.thumbnail,
  });

  final String id;
  final String title;
  final _MediaVisibility visibility;
  final String uploadedAt;
  final String duration;
  final String views;
  final String engagement;
  final double revenueEtb;
  final _MediaFilter type;
  final String thumbnail;
}

class _PaidDmThread {
  _PaidDmThread({
    required this.id,
    required this.fanName,
    required this.timeLabel,
    required this.preview,
    required this.tier,
    required this.amountEtb,
    required this.state,
    required this.unlockFeeEtb,
    required this.unlocked,
    required this.messages,
  });

  final String id;
  final String fanName;
  String timeLabel;
  String preview;
  final _TierLevel tier;
  final double amountEtb;
  _DmState state;
  final double unlockFeeEtb;
  bool unlocked;
  final List<_ThreadMessage> messages;
}

class _ThreadMessage {
  _ThreadMessage({
    required this.fromCreator,
    required this.text,
    required this.timeLabel,
  });

  final bool fromCreator;
  final String text;
  final String timeLabel;
}

class _LoyaltyTier {
  _LoyaltyTier({
    required this.id,
    required this.name,
    required this.monthlyEtb,
    required this.subscriberCount,
    required this.perks,
    required this.enabled,
  });

  final String id;
  final String name;
  final double monthlyEtb;
  final int subscriberCount;
  final List<String> perks;
  bool enabled;
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.shortLabel,
    required this.icon,
  });

  final String label;
  final String shortLabel;
  final IconData icon;
}

List<_NavItem> _navItems(_StudioStrings s) => <_NavItem>[
      _NavItem(
        label: s.overview,
        shortLabel: 'Overview',
        icon: Icons.grid_view_rounded,
      ),
      _NavItem(
        label: s.contentLibrary,
        shortLabel: 'Library',
        icon: Icons.video_collection_outlined,
      ),
      _NavItem(
        label: s.paidDmInbox,
        shortLabel: 'Paid DM',
        icon: Icons.forum_outlined,
      ),
      _NavItem(
        label: s.audienceInsights,
        shortLabel: 'Audience',
        icon: Icons.groups_outlined,
      ),
    ];

enum _LedgerStatus { fulfilled, pending, failed }

enum _MediaVisibility { public, draft }

enum _MediaFilter { all, videos, audio, tickets }

enum _DmFilter { highestValue, unanswered, completed }

enum _DmState { unanswered, completed }

enum _TierLevel { gold, silver, platinum }

String _formatCompact(num value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(value is int ? 0 : 1);
}

String _formatEtb(num value) {
  final bool negative = value < 0;
  final num absValue = value.abs();
  final int whole = absValue.floor();
  final int cents = ((absValue - whole) * 100).round();
  final String wholeWithComma = _withComma(whole);
  final String centStr = cents.toString().padLeft(2, '0');
  return '${negative ? '-' : ''}ETB $wholeWithComma.$centStr';
}

String _withComma(int value) {
  final String source = value.toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < source.length; i++) {
    final int remaining = source.length - i;
    buffer.write(source[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _timeLabelNow() {
  final DateTime now = DateTime.now();
  final String hour = now.hour.toString().padLeft(2, '0');
  final String minute = now.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
