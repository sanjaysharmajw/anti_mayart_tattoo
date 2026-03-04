import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client Inquiry Messages')),
            body: Consumer<ContactProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.contacts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.contacts.isEmpty) {
            return const Center(child: Text("No contact messages found. You are all caught up!", style: TextStyle(color: Colors.grey, fontSize: 18)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: provider.contacts.length,
            itemBuilder: (context, index) {
              final contact = provider.contacts[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFF72D565).withOpacity(0.2),
                                child: const Icon(Icons.person_rounded, color: Color(0xFF72D565)),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contact.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                                  Text(contact.email, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_rounded, color: Color(0xFFEF4444)),
                            tooltip: 'Delete Message',
                            onPressed: () async {
                              final confirm = await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Message?'),
                                  content: const Text('Are you sure you want to delete this client inquiry?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                      onPressed: () => Navigator.pop(ctx, true), 
                                      child: const Text('Delete')
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await provider.deleteContact(contact.id);
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.phone_rounded, color: Colors.grey, size: 18),
                          const SizedBox(width: 8),
                          Text(contact.phoneNumber, style: const TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(color: Color(0xFF334155)),
                      ),
                      const Text("Message", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(contact.message, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
