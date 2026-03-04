import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int currentIndex;
  final bool isCollapsed;
  final Function(int) onSelect;
  final VoidCallback onToggleCollapse;

  const Sidebar({
    super.key,
    required this.currentIndex,
    required this.isCollapsed,
    required this.onSelect,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed ? 80 : 250,
      color: const Color(0xFF1A1A1A),
      child: Column(
        crossAxisAlignment: isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 36, bottom: 24),
            child: isCollapsed
                ? const Center(child: Icon(Icons.menu, color: Color(0xFF72D565), size: 32))
                : Center(child: Image.asset('assets/logo.png', height: 100, fit: BoxFit.contain)),
          ),
          if (!isCollapsed)
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 12, top: 4),
              child: Text(
                'Menu',
                style: TextStyle(color: Color(0xFF777777), fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem(0, 'Dashboard', Icons.dashboard_outlined),
                const SizedBox(height: 4),
                _buildNavItem(1, 'Manage About', Icons.info_outline_rounded),
                const SizedBox(height: 4),
                _buildNavItem(2, 'Portfolio Gallery', Icons.photo_library_outlined),
                const SizedBox(height: 4),
                _buildNavItem(3, 'Latest Tattoos', Icons.brush_outlined),
                const SizedBox(height: 4),
                _buildNavItem(4, 'Contact Messages', Icons.mail_outline_rounded),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: onToggleCollapse,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: isCollapsed ? MainAxisSize.min : MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isCollapsed ? Icons.chevron_right : Icons.chevron_left, color: const Color(0xFF777777)),
                    if (!isCollapsed) const Flexible(child: Text('  Collapse', style: TextStyle(color: Color(0xFF777777), fontSize: 13))),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    final isSelected = currentIndex == index;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? const Color(0xFF333333) : Colors.transparent),
      ),
      child: isCollapsed ? 
        InkWell(
          onTap: () => onSelect(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Icon(icon, color: isSelected ? const Color(0xFF72D565) : const Color(0xFFAAAAAA), size: 24)
          ),
        )
      : ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: const Color(0xFF2A2A2A).withOpacity(0.5),
        leading: Icon(icon, color: isSelected ? const Color(0xFF72D565) : const Color(0xFFAAAAAA), size: 20),
        minLeadingWidth: 24,
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFAAAAAA),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        onTap: () => onSelect(index),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
