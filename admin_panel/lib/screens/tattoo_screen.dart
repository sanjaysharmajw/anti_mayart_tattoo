import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/tattoo_provider.dart';
import '../models/tattoo.dart';

class TattooScreen extends StatefulWidget {
  const TattooScreen({super.key});

  @override
  State<TattooScreen> createState() => _TattooScreenState();
}

class _TattooScreenState extends State<TattooScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _editingId;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TattooProvider>(context, listen: false).fetchTattoo();
    });
  }

  void _showFormDialog([Tattoo? tattoo]) {
    _selectedImageBytes = null;
    _selectedImageName = null;

    if (tattoo != null) {
      _titleController.text = tattoo.title;
      _editingId = tattoo.id;
    } else {
      _titleController.clear();
      _editingId = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return AlertDialog(
              title: Text(tattoo == null ? 'Upload Tattoo Image' : 'Edit Tattoo Image'),
              content: SizedBox(
                width: 450,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Tattoo Title'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            final bytes = await pickedFile.readAsBytes();
                            setStateBuilder(() {
                              _selectedImageBytes = bytes;
                              _selectedImageName = pickedFile.name;
                            });
                          }
                        },
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF121212),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF334155), width: 2, style: BorderStyle.solid),
                            image: _selectedImageBytes != null
                                ? DecorationImage(image: MemoryImage(_selectedImageBytes!), fit: BoxFit.cover)
                                : (tattoo != null
                                    ? DecorationImage(image: NetworkImage("http://localhost:5000${tattoo.image}"), fit: BoxFit.cover)
                                    : null),
                          ),
                          child: (_selectedImageBytes == null && tattoo == null)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.cloud_upload_rounded, size: 48, color: Colors.grey),
                                    const SizedBox(height: 8),
                                    Text('Click to browse image', style: TextStyle(color: Colors.grey.shade400)),
                                  ],
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.edit, color: Colors.white, size: 36),
                                ),
                        ),
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
                      final provider = Provider.of<TattooProvider>(context, listen: false);
                      bool success;

                      if (_editingId == null) {
                        if (_selectedImageBytes == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an image', style: TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent));
                          return;
                        }
                        success = await provider.createTattoo(_titleController.text, _selectedImageBytes!, _selectedImageName!);
                      } else {
                        success = await provider.updateTattoo(
                          _editingId!,
                          _titleController.text,
                          imageBytes: _selectedImageBytes,
                          filename: _selectedImageName,
                        );
                      }
                      
                      if (success && mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved successfully!'), backgroundColor: Colors.green));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage), backgroundColor: Colors.redAccent));
                      }
                    }
                  },
                  child: const Text('Save Tattoo'),
                )
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest Tattoos Gallery'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: ElevatedButton.icon(
              onPressed: () => _showFormDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Upload New'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<TattooProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.tattoos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.tattoos.isEmpty) {
            return const Center(child: Text("No tattoo content found.", style: TextStyle(color: Colors.grey, fontSize: 18)));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 5 : (MediaQuery.of(context).size.width > 800 ? 3 : 2),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemCount: provider.tattoos.length,
            itemBuilder: (context, index) {
              final tattoo = provider.tattoos[index];
              return HoverTattooCard(
                tattoo: tattoo,
                onEdit: () => _showFormDialog(tattoo),
                onDelete: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Image?'),
                      content: const Text('Are you sure you want to permanently delete this image?'),
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
                    await provider.deleteTattoo(tattoo.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class HoverTattooCard extends StatefulWidget {
  final dynamic tattoo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HoverTattooCard({super.key, required this.tattoo, required this.onEdit, required this.onDelete});

  @override
  State<HoverTattooCard> createState() => _HoverTattooCardState();
}

class _HoverTattooCardState extends State<HoverTattooCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: isHovered ? const Color(0xFF72D565).withOpacity(0.5) : const Color(0xFF2A2A2A), width: 1),
          boxShadow: isHovered ? [BoxShadow(color: const Color(0xFF72D565).withOpacity(0.15), blurRadius: 20, spreadRadius: 2)] : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "http://localhost:5000${widget.tattoo.image}",
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isHovered ? 1.0 : 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                        )
                      ),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFF1A1A1A).withOpacity(0.8),
                            child: IconButton(
                              iconSize: 16,
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.edit_rounded, color: Colors.white),
                              onPressed: widget.onEdit,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFF1A1A1A).withOpacity(0.8),
                            child: IconButton(
                              iconSize: 16,
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.delete_rounded, color: Color(0xFFEF4444)),
                              onPressed: widget.onDelete,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFF1A1A1A),
              child: Text(
                widget.tattoo.title, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white), 
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
