import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RusUI extends StatelessWidget {
  const RusUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF383B58), // Dark slate blue
        elevation: 0,
        title: Text(
          'Консультации',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white70),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=1',
              ), // Placeholder avatar
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Toggle (Calendar / List)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF555877), // Active Dark
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Календарь',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Список',
                              style: GoogleFonts.inter(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // View Mode (Month / Week / Day)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildViewModeChip('Месяц', true),
                      _buildViewModeChip('Неделя', false),
                      _buildViewModeChip('День', false),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildLegendItem(Colors.green, 'Оплаченные'),
                      const SizedBox(width: 8),
                      _buildLegendItem(Colors.redAccent, 'Требуется оплата'),
                      const SizedBox(width: 8),
                      // "Завершенные" logic not fully visible but assuming grey
                      _buildLegendItem(Colors.blueGrey[200]!, 'Завершенные'),
                    ],
                  ),
                ],
              ),
            ),

            // Calendar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black12),
                    onPressed: () {},
                  ),
                  Text(
                    'Декабрь 2025',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.green),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Calendar Grid using GridView for better control or just static rows with detailed config
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Days of week
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
                        .map(
                          (day) => SizedBox(
                            width: 44,
                            child: Center(
                              child: Text(
                                day,
                                style: GoogleFonts.inter(
                                  color: const Color(
                                    0xFF9FA5C0,
                                  ), // Lighter blue-grey
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Row 1
                  _buildCalendarRow([
                    DayData(text: '26', type: DayType.prevMonth),
                    DayData(text: '27', type: DayType.prevMonth),
                    DayData(
                      text: '28',
                      type: DayType.prevMonth,
                      badge: BadgeData(
                        count: 1,
                        color: const Color(0xFF7E819E),
                      ),
                    ),
                    DayData(text: '1', type: DayType.weekday),
                    DayData(
                      text: '2',
                      type: DayType.weekday,
                      badge: BadgeData(
                        count: 10,
                        color: const Color(0xFF7E819E),
                      ),
                    ),
                    DayData(text: '3', type: DayType.weekend),
                    DayData(text: '4', type: DayType.weekend),
                  ]),
                  // Row 2
                  _buildCalendarRow([
                    DayData(
                      text: '5',
                      type: DayType.weekday,
                      badge: BadgeData(
                        count: 1,
                        color: const Color(0xFF7E819E),
                      ),
                    ),
                    DayData(text: '6', type: DayType.weekday),
                    DayData(text: '7', type: DayType.today), // Green border
                    DayData(
                      text: '8',
                      type: DayType.weekday,
                      badge: BadgeData(
                        count: 2,
                        color: const Color(0xFF7E819E),
                      ),
                    ),
                    DayData(text: '9', type: DayType.weekday),
                    DayData(text: '10', type: DayType.weekend),
                    DayData(text: '11', type: DayType.weekend),
                  ]),
                  // Row 3
                  _buildCalendarRow([
                    DayData(text: '12', type: DayType.weekday),
                    DayData(
                      text: '13',
                      type: DayType.weekday,
                      badge: BadgeData(
                        count: 1,
                        color: const Color(0xFF66BB6A),
                      ),
                    ), // Green badge
                    DayData(text: '14', type: DayType.weekday),
                    DayData(
                      text: '15',
                      type: DayType.selected,
                      badge: BadgeData(
                        count: 2,
                        color: Colors.white,
                        textColor: Colors.black,
                      ),
                    ), // Selected green, white badge
                    DayData(text: '16', type: DayType.weekday),
                    DayData(text: '17', type: DayType.weekend),
                    DayData(text: '18', type: DayType.weekend),
                  ]),
                  // Row 4
                  _buildCalendarRow([
                    DayData(text: '19', type: DayType.weekday),
                    DayData(text: '20', type: DayType.weekday),
                    DayData(
                      text: '21',
                      type: DayType.weekday,
                      badge: BadgeData(
                        count: 2,
                        color: const Color(0xFFEF5350),
                      ),
                    ), // Red badge
                    DayData(text: '22', type: DayType.weekday),
                    DayData(text: '23', type: DayType.weekday),
                    DayData(text: '24', type: DayType.weekend),
                    DayData(text: '25', type: DayType.weekend),
                  ]),
                  // Row 5
                  _buildCalendarRow([
                    DayData(text: '26', type: DayType.weekday),
                    DayData(text: '27', type: DayType.weekday),
                    DayData(text: '28', type: DayType.weekday),
                    DayData(text: '29', type: DayType.weekday),
                    DayData(
                      text: '30',
                      type: DayType.weekday,
                      badge: BadgeData(
                        count: 4,
                        color: const Color(0xFF66BB6A),
                      ),
                    ),
                    DayData(text: '31', type: DayType.weekend),
                    DayData(
                      text: '1',
                      type: DayType.weekend,
                    ), // Next month weekend? or just weekend
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '15 декабря',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Cards
            _buildAppointmentCard(
              time: '12:00',
              name: 'Александр Александров',
              status: 'неоплачено',
              statusColor: const Color(0xFFFFEBEE), // Light red
              statusTextColor: const Color(0xFFEF5350), // Red 400
              avatarUrl: 'https://i.pravatar.cc/150?img=11',
              showChatBubble: true,
            ),
            _buildAppointmentCard(
              time: '15:00',
              name: 'Мария Кожевникова',
              status: 'оплачено',
              statusColor: const Color(0xFFE8F5E9),
              statusTextColor: const Color(0xFF66BB6A),
              avatarUrl: 'https://i.pravatar.cc/150?img=5',
              showChatBubble: true,
              hasUnread: true,
            ),

            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF383B58),
          unselectedItemColor: const Color(0xFF9FA5C0), // Grey
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          currentIndex: 3,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border),
              label: 'Эксперты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flash_on_outlined),
              label: 'Материалы',
            ),
            BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Консультации',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline),
              label: 'Вопросы',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF383B58),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildViewModeChip(String label, bool isSelected) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 48, // Slightly taller as per ss
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF66BB6A)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: isSelected
            ?
              // Filled Green Button Look or Bordered?
              // SS shows "Месяц" is Green FILLED.
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF66BB6A),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              )
            : Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF555877), // Darker grey text
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarRow(List<DayData> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
      ), // Reduced vertical spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          Color? bgColor;
          Border? border;
          Color textColor = const Color(0xFF2C2F48); // Dark color default

          switch (day.type) {
            case DayType.prevMonth:
            case DayType.weekend:
              bgColor = const Color(0xFFF4F6F8); // Light grey fill
              textColor = const Color(0xFF9FA5C0); // Grey text
              break;
            case DayType.weekday:
              bgColor = Colors.white;
              border = Border.all(
                color: const Color(0xFFE0E0E0),
              ); // Light grey border
              break;
            case DayType.today:
              bgColor = Colors.white;
              border = Border.all(
                color: const Color(0xFF66BB6A),
                width: 1.5,
              ); // Green border
              break;
            case DayType.selected:
              bgColor = const Color(0xFF66BB6A); // Green fill
              textColor = Colors.white;
              break;
          }

          return SizedBox(
            width: 44,
            height: 48, // Taller cells
            child: Stack(
              children: [
                // Cell Background/Border
                Container(
                  width: 44,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: border,
                  ),
                ),

                // Day Number
                Center(
                  child: Text(
                    day.text,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Badge
                // Badge
                if (day.badge != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: day.badge!.color,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      constraints: const BoxConstraints(minWidth: 16),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.badge!.count}',
                        style: GoogleFonts.inter(
                          color: day.badge!.textColor ?? Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String time,
    required String name,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String avatarUrl,
    bool showChatBubble = false,
    bool hasUnread = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // More rounded
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2C2F48),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    color: statusTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, // Medium weight
                    color: const Color(0xFF2C2F48),
                  ),
                ),
              ),
              if (showChatBubble)
                Stack(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: const Color(0xFF9FA5C0),
                      size: 26,
                    ),
                    if (hasUnread)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF5350), // Red
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

enum DayType { weekday, weekend, prevMonth, today, selected }

class DayData {
  final String text;
  final DayType type;
  final BadgeData? badge;

  DayData({required this.text, required this.type, this.badge});
}

class BadgeData {
  final int count;
  final Color color;
  final Color? textColor;

  BadgeData({required this.count, required this.color, this.textColor});
}
