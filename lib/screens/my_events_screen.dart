// lib/screens/my_events_screen.dart
import 'package:flutter/material.dart';
import '../services/rsvp_service.dart';
import '../services/mock_data.dart';
import 'rsvp_registration_screen.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Listen to changes in RSVP Service so UI updates dynamically
    RsvpService.instance.addListener(_onRsvpChange);
  }

  @override
  void dispose() {
    RsvpService.instance.removeListener(_onRsvpChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onRsvpChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get registrations map
    final registrations = RsvpService.instance.registrations;
    
    // Find all mock opportunities that user registered for
    final List<Map<String, String>> registeredOpportunities = mockOpportunities.where((opportunity) {
      return registrations.containsKey(opportunity['id']);
    }).toList();

    // Filter by search query if any
    final filteredOpportunities = registeredOpportunities.where((opportunity) {
      final matchesSearch = opportunity['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          opportunity['organizer']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Participation', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.event_available), text: "Active RSVPs"),
            Tab(icon: Icon(Icons.qr_code), text: "Digital Passes"),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.withValues(alpha: 0.02), Colors.white],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Active RSVPs (List/Manage View)
            _buildActiveRsvpsTab(filteredOpportunities, registrations),
            
            // Tab 2: Digital Passes (Visual Ticket View)
            _buildDigitalPassesTab(filteredOpportunities, registrations),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRsvpsTab(List<Map<String, String>> opportunities, Map<String, Map<String, dynamic>> registrations) {
    return Column(
      children: [
        if (registrations.isNotEmpty) _buildSearchBox(),
        Expanded(
          child: opportunities.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    final item = opportunities[index];
                    final regDetails = registrations[item['id']]!;
                    return _buildEventCard(item, regDetails);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDigitalPassesTab(List<Map<String, String>> opportunities, Map<String, Map<String, dynamic>> registrations) {
    if (registrations.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: opportunities.length,
      itemBuilder: (context, index) {
        final item = opportunities[index];
        final regDetails = registrations[item['id']]!;
        return Container(
          width: MediaQuery.of(context).size.width * 0.85,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildPassTicketView(item, regDetails),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showTicketBottomSheet(context, item, regDetails),
                      icon: const Icon(Icons.fullscreen),
                      label: const Text("Fullscreen Ticket"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => _confirmCancellation(context, item['id']!, item['title']!),
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      label: const Text("Cancel RSVP", style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBox() {
    return Container(
      color: Colors.deepPurple,
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search my registrations...',
          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 80,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Events Registered',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Explore and register for upcoming ALU workshops, hackathons, and club sessions to see them here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Switch back to Feed
                mainTabNotifier.value = 0;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Discover Opportunities', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> item, Map<String, dynamic> regDetails) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showTicketBottomSheet(context, item, regDetails),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'REGISTERED',
                          style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item['category']!,
                    style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item['title']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(item['date']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item['location']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => _showTicketBottomSheet(context, item, regDetails),
                    icon: const Icon(Icons.qr_code, size: 18, color: Colors.deepPurple),
                    label: const Text('View Ticket', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  ),
                  TextButton.icon(
                    onPressed: () => _confirmCancellation(context, item['id']!, item['title']!),
                    icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                    label: const Text('Cancel RSVP', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCancellation(BuildContext context, String eventId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Cancel Registration'),
          content: Text('Are you sure you want to cancel your RSVP for "$title"? This action will remove your digital ticket.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Registration', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                RsvpService.instance.cancelRsvp(eventId);
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration cancelled successfully.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text('Yes, Cancel RSVP', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPassTicketView(Map<String, String> item, Map<String, dynamic> regDetails) {
    return Card(
      elevation: 6,
      shadowColor: Colors.deepPurple.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipPath(
        clipper: TicketClipper(),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.deepPurple.withValues(alpha: 0.05),
                child: Column(
                  children: [
                    Text(
                      item['category']!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: List.generate(
                    20,
                    (index) => Expanded(
                      child: Container(
                        color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildPassTicketRow("Attendee", regDetails['name'] ?? 'Jane Doe'),
                    const SizedBox(height: 10),
                    _buildPassTicketRow("Cohort", regDetails['cohort'] ?? 'Software Engineering'),
                    const SizedBox(height: 10),
                    _buildPassTicketRow("Date", item['date']!),
                    const SizedBox(height: 10),
                    _buildPassTicketRow("Location", item['location']!),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade100, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.qr_code_2,
                        size: 110,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ALU-CONF-${item['id']}-${1000 + int.parse(item['id']!)}',
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassTicketRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showTicketBottomSheet(BuildContext context, Map<String, String> item, Map<String, dynamic> regDetails) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pull Bar Indicator
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Digital Boarding Pass',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              
              // Full Ticket Mock
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ClipPath(
                  clipper: TicketClipper(),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.deepPurple.withValues(alpha: 0.06),
                          child: Column(
                            children: [
                              Text(
                                item['title']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Organizer: ${item['organizer']}',
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: List.generate(
                              20,
                              (index) => Expanded(
                                child: Container(
                                  color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              _buildModalDetailRow("STUDENT NAME", regDetails['name'] ?? 'Jane Doe'),
                              const SizedBox(height: 12),
                              _buildModalDetailRow("EMAIL", regDetails['email'] ?? ''),
                              const SizedBox(height: 12),
                              _buildModalDetailRow("COHORT", regDetails['cohort'] ?? ''),
                              const SizedBox(height: 12),
                              _buildModalDetailRow("DATE / TIME", item['date']!),
                              const SizedBox(height: 12),
                              _buildModalDetailRow("LOCATION", item['location']!),
                              const SizedBox(height: 12),
                              _buildModalDetailRow("SHUTTLE REQUEST", (regDetails['needsTransport'] ?? false) ? "Yes" : "No"),
                              const SizedBox(height: 12),
                              _buildModalDetailRow("T-SHIRT SIZE", regDetails['tshirtSize'] ?? 'M'),
                              if (regDetails['motivation'] != null && regDetails['motivation'].toString().isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _buildModalDetailRow("REASON/MOTIVATION", regDetails['motivation']),
                              ],
                              const Divider(height: 30),
                              const Icon(
                                Icons.qr_code_2,
                                size: 130,
                                color: Colors.black87,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'REGID: ALU-CONF-${item['id']}-${1000 + int.parse(item['id']!)}',
                                style: const TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Mock Share action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Ticket details copied to clipboard / shared!"),
                            backgroundColor: Colors.deepPurple,
                          ),
                        );
                      },
                      icon: const Icon(Icons.share, color: Colors.deepPurple),
                      label: const Text("Share Pass", style: TextStyle(color: Colors.deepPurple)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.deepPurple),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
