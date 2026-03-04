import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/about_provider.dart';
import '../models/about.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _editingId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AboutProvider>(context, listen: false).fetchAbout();
    });
  }

  void _showFormDialog([About? about]) {
    if (about != null) {
      _titleController.text = about.title;
      _descController.text = about.description;
      _editingId = about.id;
    } else {
      _titleController.clear();
      _descController.clear();
      _editingId = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(about == null ? 'Add About Entry' : 'Edit About Entry'),
          content: Container(
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
                    maxLines: 5,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final provider = Provider.of<AboutProvider>(context, listen: false);
                  bool success;
                  if (_editingId == null) {
                    success = await provider.createAbout(
                        _titleController.text, _descController.text);
                  } else {
                    success = await provider.updateAbout(
                        _editingId!, _titleController.text, _descController.text);
                  }
                  if (success && mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Success!'), backgroundColor: Colors.green));
                  }
                }
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage About Content'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: ElevatedButton.icon(
              onPressed: () => _showFormDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Entry'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<AboutProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.abouts.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF72D565)));
          }
          if (provider.abouts.isEmpty) {
            return const Center(child: Text("No about content found.", style: TextStyle(color: Colors.grey, fontSize: 16)));
          }
          return ListView.builder(
            itemCount: provider.abouts.length,
            padding: const EdgeInsets.all(24),
            itemBuilder: (context, index) {
              final about = provider.abouts[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  border: Border.all(color: const Color(0xFF2E2E2E)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(about.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF72D565).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  iconSize: 18,
                                  icon: const Icon(Icons.edit_rounded, color: Color(0xFF72D565)),
                                  onPressed: () => _showFormDialog(about),
                                  tooltip: 'Edit',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  iconSize: 18,
                                  icon: const Icon(Icons.delete_rounded, color: Color(0xFFEF4444)),
                                  onPressed: () async {
                                    final confirm = await showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Entry?'),
                                        content: const Text('This action cannot be undone.'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
                                            onPressed: () => Navigator.pop(ctx, true), 
                                            child: const Text('Delete')
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await provider.deleteAbout(about.id);
                                    }
                                  },
                                  tooltip: 'Delete',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(about.description, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14, height: 1.5)),
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
