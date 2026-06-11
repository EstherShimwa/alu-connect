// lib/screens/event_details_screen.dart
import 'package:flutter/material.dart';
import '../services/rsvp_service.dart';
import 'rsvp_registration_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, String> opportunity;

  const EventDetailsScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final eventId = opportunity['id']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: RsvpService.instance,
        builder: (context, _) {
          final isRegistered = RsvpService.instance.isRegistered(eventId);
          final regDetails = RsvpService.instance.getRegistrationDetails(eventId);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        opportunity['category']!.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isRegistered)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.check_circle, color: Colors.green, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'REGISTERED',
                              style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                
                // Title
                Text(
                  opportunity['title']!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                
                // Host Information
                Text(
                  'Hosted by: ${opportunity['organizer']}',
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
                ),
                const Divider(height: 30, thickness: 1),
                
                // Logistics info box
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Text(opportunity['date']!, style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(opportunity['location']!, style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1),
                
                // Description Header
                const Text(
                  'About this Opportunity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                
                // Body Description
                Text(
                  opportunity['description']!,
                  style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // Dynamic Action Buttons based on Registration State
                if (!isRegistered)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RsvpRegistrationScreen(opportunity: opportunity),
                          ),
                        );
                      },
                      icon: const Icon(Icons.event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      label: const Text('RSVP / Register Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else ...[
                  // Registered info card preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.05),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Registration Info",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text("Attendee: ${regDetails?['name'] ?? ''}", style: const TextStyle(fontSize: 14)),
                        Text("Cohort: ${regDetails?['cohort'] ?? ''}", style: const TextStyle(fontSize: 14)),
                        Text("Shuttle Request: ${(regDetails?['needsTransport'] ?? false) ? 'Yes' : 'No'}", style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  
                  // Secondary Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (regDetails != null) {
                              _showTicketBottomSheet(context, opportunity, regDetails);
                            }
                          },
                          icon: const Icon(Icons.qr_code),
                          label: const Text('View Ticket'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmCancellation(context, eventId, opportunity['title']!),
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: const Text('Cancel RSVP', style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmCancellation(BuildContext context, String eventId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Cancel Registration'),
          content: Text('Are you sure you want to cancel your RSVP for "$title"? This action will delete your generated ticket.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Keep Registration', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                RsvpService.instance.cancelRsvp(eventId);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
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
                              _buildModalDetailRow("STUDENT NAME", regDetails['name'] ?? ''),
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
              SizedBox(
                width: double.infinity,
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