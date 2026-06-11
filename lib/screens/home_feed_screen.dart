import 'package:flutter/material.dart';
import '../services/mock_data.dart';
import '../services/post_service.dart';
import '../services/auth_service.dart';
import 'event_details_screen.dart';
import 'post_opportunity_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Clubs', 'Internships', 'Hackathons', 'Workshops'];

  @override
  void initState() {
    super.initState();
    PostService.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    PostService.instance.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List<Map<String, String>> get _allOpportunities {
    final approved = PostService.instance.approvedPosts.map((p) => p.toFeedMap()).toList();
    return [...mockOpportunities, ...approved];
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allOpportunities.where((o) {
      final matchesCategory = _selectedCategory == 'All' || o['category'] == _selectedCategory;
      final matchesSearch = o['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o['organizer']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('The ALU Connect', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PostOpportunityScreen()),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Post'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepPurple,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search events or organizers...',
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = category),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No opportunities found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EventDetailsScreen(opportunity: item)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(item['category']!,
                                          style: const TextStyle(
                                              color: Colors.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                    Text(item['date']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(item['title']!,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.business, size: 16, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(item['organizer']!, style: const TextStyle(color: Colors.grey)),
                                ]),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(item['location']!,
                                        style: const TextStyle(color: Colors.grey),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
