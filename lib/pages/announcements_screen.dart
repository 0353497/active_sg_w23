import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:active_sg/services/json_reader.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  static final DateFormat _monthFormat = DateFormat('MMM yyyy');

  List<Announcement> _announcements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    final announcements = await JsonReader.readAnnouncements();
    if (!mounted) {
      return;
    }

    setState(() {
      _announcements = announcements;
      _isLoading = false;
    });
  }

  List<Announcement> _announcementsForType(String type) {
    final filtered = _announcements.where((item) => item.type == type).toList();
    filtered.sort((left, right) => right.dateTime.compareTo(left.dateTime));
    return filtered;
  }

  Map<DateTime, List<Announcement>> _groupByMonth(List<Announcement> items) {
    final groups = SplayTreeMap<DateTime, List<Announcement>>(
      (left, right) => right.compareTo(left),
    );

    for (final announcement in items) {
      final monthKey = DateTime(
        announcement.dateTime.year,
        announcement.dateTime.month,
      );
      groups.putIfAbsent(monthKey, () => <Announcement>[]).add(announcement);
    }

    return groups;
  }

  String _monthLabel(DateTime month) {
    return _monthFormat.format(month);
  }

  void _setReadStatus(Announcement announcement, bool read) {
    setState(() {
      announcement.read = read;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (final announcement in _announcements) {
        announcement.read = true;
      }
    });
  }

  Widget _buildAnnouncementTab(String type) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = _announcementsForType(type);
    if (items.isEmpty) {
      return const Center(child: Text('No announcements yet.'));
    }

    final grouped = _groupByMonth(items);
    final monthEntries = grouped.entries.toList();

    return ListView(
      children: monthEntries.asMap().entries.map((indexedEntry) {
        final entry = indexedEntry.value;
        final showMarkAll = indexedEntry.key == 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _monthLabel(entry.key),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (showMarkAll)
                      TextButton(
                        onPressed: _markAllAsRead,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Mark all as read'),
                      ),
                  ],
                ),
              ),
              ...entry.value.map(
                (announcement) => AnnouncementSwipeCard(
                  announcement: announcement,
                  onMarkAsRead: () => _setReadStatus(announcement, true),
                  onMarkAsUnread: () => _setReadStatus(announcement, false),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Announcements",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "What's Happening"),
                Tab(text: "System Updates"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAnnouncementTab('happening'),
                  _buildAnnouncementTab('system'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementSwipeCard extends StatefulWidget {
  const AnnouncementSwipeCard({
    super.key,
    required this.announcement,
    required this.onMarkAsRead,
    required this.onMarkAsUnread,
  });

  final Announcement announcement;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnread;

  @override
  State<AnnouncementSwipeCard> createState() => _AnnouncementSwipeCardState();
}

class _AnnouncementSwipeCardState extends State<AnnouncementSwipeCard> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _resetToCenter() {
    if (!_pageController.hasClients) {
      return;
    }

    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  Widget _actionPage({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required Alignment alignment,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextButton.icon(
            onPressed: onTap,
            icon: Icon(icon),
            label: Text(label),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contentPage(BuildContext context) {
    final announcement = widget.announcement;
    final backgroundColor = announcement.read
        ? Colors.white
        : const Color(0xFFFFE4E4);

    return Material(
      color: backgroundColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        title: Text(
          announcement.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(announcement.content),
              const SizedBox(height: 10),
              Text(
                announcement.date,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: PageView(
        controller: _pageController,
        children: [
          _actionPage(
            label: 'Mark as unread',
            icon: Icons.mark_email_unread_outlined,
            color: const Color(0xFFFFF0C7),
            alignment: Alignment.centerLeft,
            onTap: () {
              widget.onMarkAsUnread();
              _resetToCenter();
            },
          ),
          _contentPage(context),
          _actionPage(
            label: 'Mark as read',
            icon: Icons.mark_email_read_outlined,
            color: const Color(0xFFDDF3E4),
            alignment: Alignment.centerRight,
            onTap: () {
              widget.onMarkAsRead();
              _resetToCenter();
            },
          ),
        ],
      ),
    );
  }
}
