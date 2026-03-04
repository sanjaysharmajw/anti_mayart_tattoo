import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/portfolio.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _editingId;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PortfolioProvider>(context, listen: false).fetchPortfolio();
    });
  }

  void _showFormDialog([Portfolio? portfolio]) {
    _selectedImageBytes = null;
    _selectedImageName = null;

    if (portfolio != null) {
      _titleController.text = portfolio.title;
      _editingId = portfolio.id;
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
              title: Text(portfolio == null ? 'Upload Portfolio Image' : 'Edit Portfolio Image'),
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
                        decoration: const InputDecoration(labelText: 'Image Title'),
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
                                : (portfolio != null
                                    ? DecorationImage(image: NetworkImage("https://anti-mayart-tattoo.onrender.com${portfolio.image}"), fit: BoxFit.cover)
                                    : null),
                          ),
                          child: (_selectedImageBytes == null && portfolio == null)
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
                      final provider = Provider.of<PortfolioProvider>(context, listen: false);
                      bool success;

                      if (_editingId == null) {
                        if (_selectedImageBytes == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an image', style: TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent));
                          return;
                        }
                        success = await provider.createPortfolio(_titleController.text, _selectedImageBytes!, _selectedImageName!);
                      } else {
                        success = await provider.updatePortfolio(
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
                  child: const Text('Save Portfolio'),
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
        title: const Text('Portfolio Gallery'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: ElevatedButton.icon(
              onPressed: () => _showFormDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Image'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.portfolios.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.portfolios.isEmpty) {
            return const Center(child: Text("No portfolio content found.", style: TextStyle(color: Colors.grey, fontSize: 18)));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 5 : (MediaQuery.of(context).size.width > 800 ? 3 : 2),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemCount: provider.portfolios.length,
            itemBuilder: (context, index) {
              final portfolio = provider.portfolios[index];
              return HoverPortfolioCard(
                portfolio: portfolio,
                onEdit: () => _showFormDialog(portfolio),
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
                    await provider.deletePortfolio(portfolio.id);
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

class HoverPortfolioCard extends StatefulWidget {
  final dynamic portfolio;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HoverPortfolioCard({super.key, required this.portfolio, required this.onEdit, required this.onDelete});

  @override
  State<HoverPortfolioCard> createState() => _HoverPortfolioCardState();
}

class _HoverPortfolioCardState extends State<HoverPortfolioCard> {
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
                    "https://anti-mayart-tattoo.onrender.com${widget.portfolio.image}",
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
                widget.portfolio.title, 
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
