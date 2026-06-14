// lib/screens/rsvp_registration_screen.dart
import 'package:flutter/material.dart';
import '../services/rsvp_service.dart';

class RsvpRegistrationScreen extends StatefulWidget {
  final Map<String, String> opportunity;

  const RsvpRegistrationScreen({super.key, required this.opportunity});

  @override
  State<RsvpRegistrationScreen> createState() => _RsvpRegistrationScreenState();
}

class _RsvpRegistrationScreenState extends State<RsvpRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form input controllers and values
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _motivationController = TextEditingController();

  String _selectedCohort = "Bachelor of Software Engineering";
  String _selectedTshirt = "M";
  bool _needsTransport = false;
  bool _isSuccess = false;

  final List<String> _cohorts = [
    "Bachelor of Software Engineering",
    "Bachelor of International Business",
    "Bachelor of Business Leadership",
  ];

  final List<String> _tshirtSizes = ["XS", "S", "M", "L", "XL", "XXL"];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      final registrationData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'cohort': _selectedCohort,
        'tshirtSize': _selectedTshirt,
        'needsTransport': _needsTransport,
        'motivation': _motivationController.text.trim(),
        'opportunityTitle': widget.opportunity['title']!,
        'opportunityDate': widget.opportunity['date']!,
        'opportunityLocation': widget.opportunity['location']!,
        'opportunityOrganizer': widget.opportunity['organizer']!,
        'opportunityCategory': widget.opportunity['category']!,
      };

      // Register the event
      RsvpService.instance.register(
        widget.opportunity['id']!,
        registrationData,
      );

      setState(() {
        _isSuccess = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Registration Successful!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSuccess ? 'Your Ticket' : 'Event Registration'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.withValues(alpha: 0.05), Colors.white],
          ),
        ),
        child: _isSuccess ? _buildSuccessTicket() : _buildRegistrationForm(),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Details Header Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(widget.opportunity['category']!),
                        color: Colors.deepPurple,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.opportunity['category']!.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.opportunity['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.opportunity['date']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Attendee Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Full Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                if (value.trim().split(' ').length < 2) {
                  return 'Please enter both first and last name';
                }
                if (RegExp(r'[0-9]').hasMatch(value)) {
                  return 'Name should not contain numbers';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ALU Email Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'ALU Student Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                helperText: 'Must be a valid ALU email address',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Cohort Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedCohort,
              decoration: InputDecoration(
                labelText: 'Academic Cohort / Programme',
                prefixIcon: const Icon(Icons.school_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _cohorts.map((cohort) {
                return DropdownMenuItem(value: cohort, child: Text(cohort));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCohort = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // T-Shirt Size Dropdown (Special question to showcase interaction)
            DropdownButtonFormField<String>(
              initialValue: _selectedTshirt,
              decoration: InputDecoration(
                labelText: 'T-Shirt Size (for Merch/Swag)',
                prefixIcon: const Icon(Icons.checkroom_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _tshirtSizes.map((size) {
                return DropdownMenuItem(value: size, child: Text(size));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedTshirt = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Transport Toggle
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: SwitchListTile(
                title: const Text('Request Kigali Campus Shuttle'),
                subtitle: const Text(
                  'Check this if you require transport to/from campus',
                ),
                value: _needsTransport,
                activeThumbColor: Colors.deepPurple,
                onChanged: (value) {
                  setState(() => _needsTransport = value);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Motivation/Details Area
            TextFormField(
              controller: _motivationController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Why do you want to attend? / Special requests',
                hintText: 'Share anything...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _submitRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Confirm & Register',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessTicket() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        children: [
          // Animated checkmark decoration
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.green,
            child: Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'You\'re Registered!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your digital ticket has been generated and saved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // Visual Ticket
          Card(
            elevation: 8,
            shadowColor: Colors.deepPurple.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipPath(
              clipper: TicketClipper(),
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ticket Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.deepPurple.withValues(alpha: 0.06),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.opportunity['category']!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.opportunity['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Hosted by ${widget.opportunity['organizer']}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Separator (visual dashes and punch holes)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: List.generate(
                          30,
                          (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Ticket Content
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Details Grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTicketDetail(
                                'DATE',
                                widget.opportunity['date']!,
                              ),
                              _buildTicketDetail(
                                'LOCATION',
                                widget.opportunity['location']!,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTicketDetail(
                                'ATTENDEE',
                                _nameController.text,
                              ),
                              _buildTicketDetail('COHORT', _selectedCohort),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTicketDetail('T-SHIRT', _selectedTshirt),
                              _buildTicketDetail(
                                'SHUTTLE',
                                _needsTransport ? 'Requested' : 'Not Requested',
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Mock QR Code Box
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.qr_code_2,
                                  size: 140,
                                  color: Colors.black87,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'REGID: ALU-CONF-${widget.opportunity['id']}-${1000 + int.parse(widget.opportunity['id']!)}',
                                  style: const TextStyle(
                                    fontFamily: 'Courier',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
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

          const SizedBox(height: 32),

          // Return Home/Dashboard buttons
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to the home stack and trigger the tab switch using our global key/notifier
                Navigator.pop(context); // Pops registration ticket screen
                Navigator.pop(
                  context,
                ); // Pops details screen to return to MainScreen
                // Update selected tab to "My Events" (index 1)
                _switchTab(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View in My Events',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              _switchTab(0); // Go back to feed tab
            },
            child: const Text(
              'Back to Home Feed',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _switchTab(int tabIndex) {
    try {
      _tabNotifier.value = tabIndex;
    } catch (e) {
      debugPrint("Tab notifier error: $e");
    }
  }

  Widget _buildTicketDetail(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Hackathons':
        return Icons.code;
      case 'Clubs':
        return Icons.groups;
      case 'Internships':
        return Icons.work;
      case 'Workshops':
        return Icons.laptop_chromebook;
      default:
        return Icons.event;
    }
  }
}

// Custom Clipper to make a realistic ticket with punch-out holes on the sides
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    // We want side punch holes where the header container ends (approx line height 120)
    double cutPosition = 120.0;
    double cutRadius = 12.0;

    // Right cut-out
    final rightPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, cutPosition),
          radius: cutRadius,
        ),
      );
    // Left cut-out
    final leftPath = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(0.0, cutPosition), radius: cutRadius),
      );

    // Subtract circles from the standard ticket path
    return Path.combine(
      PathOperation.difference,
      path,
      Path.combine(PathOperation.union, rightPath, leftPath),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Global Notifier for main screen tab index navigation
final ValueNotifier<int> _tabNotifier = ValueNotifier<int>(0);
ValueNotifier<int> get mainTabNotifier => _tabNotifier;
