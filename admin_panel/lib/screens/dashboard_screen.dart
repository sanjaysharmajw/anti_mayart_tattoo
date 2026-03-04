import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/portfolio_provider.dart';
import '../providers/tattoo_provider.dart';
import '../providers/contact_provider.dart';
import '../providers/about_provider.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const DashboardScreen({super.key, this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PortfolioProvider>(context, listen: false).fetchPortfolio();
      Provider.of<TattooProvider>(context, listen: false).fetchTattoo();
      Provider.of<ContactProvider>(context, listen: false).fetchContacts();
      Provider.of<AboutProvider>(context, listen: false).fetchAbout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
            body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildStatsRow(),
                      const SizedBox(height: 24),
                      _buildTattoosCard(),
                      const SizedBox(height: 24),
                      _buildPortfolioCard(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _buildAboutCard(),
                      const SizedBox(height: 24),
                      _buildContactCard(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Dashboard'),
      actions: const [],
    );
  }

  Widget _buildCardHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('Dashboard Screen'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Consumer<TattooProvider>(
                  builder: (context, provider, _) => _buildSmallStatCard(
                    'Total Tattoos', '${provider.tattoos.length} active tattoos\nin gallery',
                    const Icon(Icons.star_border, color: Color(0xFF72D565), size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Consumer<PortfolioProvider>(
                  builder: (context, provider, _) => _buildSmallStatCard(
                    'Total Portfolio Items', '${provider.portfolios.length} items\nin portfolio',
                    const Icon(Icons.check_box_rounded, color: Color(0xFF72D565), size: 28),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Consumer<ContactProvider>(
                  builder: (context, provider, _) => _buildSmallStatCard(
                    'Total Messages', '${provider.contacts.length} total messages\nreceived',
                    const Icon(Icons.access_time_rounded, color: Color(0xFF4A90E2), size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Consumer<ContactProvider>(
                  builder: (context, provider, _) {
                    final recent = provider.contacts.isNotEmpty ? provider.contacts.first : null;
                    return _buildSmallStatCard(
                      'Recent messages preview', recent != null ? '${recent.fullName}\n${recent.message}' : 'No recent messages\navailable',
                      const Icon(Icons.local_play_outlined, color: Color(0xFF4A90E2), size: 28),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(String title, String subtitle, Widget icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E2E2E)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF777777), fontSize: 11, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGraphCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('Sidefolio Management ouit'),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 150,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: const Color(0xFF2E2E2E), strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: const TextStyle(color: Color(0xFF777777), fontSize: 10)),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0, maxX: 4, minY: 0, maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [FlSpot(0, 20), FlSpot(1, 80), FlSpot(2, 40), FlSpot(3, 90), FlSpot(4, 30)],
                          isCurved: true,
                          color: const Color(0xFF72D565),
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildSettingsDropdown('Creative gallery grid', 'Large preview cards'),
                    const SizedBox(height: 16),
                    _buildSettingsDropdown('Smooth hover animation', 'Modern card layout'),
                    const SizedBox(height: 16),
                    const Text('Graph / chart section', style: TextStyle(color: Color(0xFF777777), fontSize: 12)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSettingsDropdown(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2E2E2E)), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFF777777), fontSize: 11), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFAAAAAA), size: 16),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('Portfolio Management', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<PortfolioProvider>(
            builder: (context, provider, _) {
              if (provider.portfolios.isEmpty) {
                return const Text('No portfolio items found', style: TextStyle(color: Color(0xFF777777)));
              }
              return Row(
                children: provider.portfolios.take(2).map((p) => Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF2A2A2A))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(p.id, style: const TextStyle(color: Color(0xFF777777), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle, color: Color(0xFF72D565), size: 20),
                      ],
                    ),
                  ),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTattoosCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('Latest Tattoos Management', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Create a clear cards\nvery attractive and modern Tattoo list', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 13, height: 1.4)),
          const SizedBox(height: 24),
          Consumer<TattooProvider>(
            builder: (context, provider, _) {
              if (provider.tattoos.isEmpty) {
                return const Text('No recent tattoos available', style: TextStyle(color: Color(0xFF777777)));
              }
              return Column(
                children: provider.tattoos.take(3).map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 8, color: Color(0xFF72D565)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(t.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(t.id, style: const TextStyle(color: Color(0xFF777777), fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF72D565), size: 20),
                            const SizedBox(width: 16),
                            InkWell(
                              onTap: () => widget.onNavigate?.call(3),
                              child: Container(
                                width: 60,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF72D565),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Edit', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => widget.onNavigate?.call(3), 
                child: const Text('View All')
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('About Management', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 24),
          Consumer<AboutProvider>(
            builder: (context, provider, _) {
              if (provider.abouts.isEmpty) {
                return const Text('No about entries available', style: TextStyle(color: Color(0xFF777777)));
              }
              return Column(
                children: provider.abouts.take(2).map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1),
                            const SizedBox(height: 4),
                            Text(a.description, style: const TextStyle(color: Color(0xFF777777), fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Color(0xFF72D565), size: 20), onPressed: () => widget.onNavigate?.call(1)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20), onPressed: () => provider.deleteAbout(a.id)),
                        ],
                      )
                    ],
                  ),
                )).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Manage entries globally', style: TextStyle(color: Color(0xFF777777), fontSize: 13)),
              ElevatedButton(onPressed: () => widget.onNavigate?.call(1), child: const Text('View All About')),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('Contact Messages', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              Container(
                width: 200,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    fillColor: const Color(0xFF1A1A1A),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    suffixIcon: const Icon(Icons.search, size: 18, color: Color(0xFFAAAAAA)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF2E2E2E))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF2E2E2E))),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(flex: 2, child: Text('Full Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              Expanded(flex: 2, child: Text('Email', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              Expanded(flex: 2, child: Text('Phone Number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              Expanded(flex: 2, child: Text('Design', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.right)),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<ContactProvider>(
            builder: (context, provider, _) {
              if (provider.contacts.isEmpty) {
                return const Padding(padding: EdgeInsets.only(top: 20), child: Text("No messages found", style: TextStyle(color: Color(0xFFAAAAAA))));
              }
              return Column(
                children: provider.contacts.take(3).map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(c.fullName, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 2, child: Text(c.email, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 2, child: Text(c.message, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 70,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: const Color(0xFF1A1A1A), border: Border.all(color: const Color(0xFF2E2E2E)), borderRadius: BorderRadius.circular(8)),
                                child: const Text('View', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
