import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;
import 'dart:io';
import 'chat_service.dart'; 
class SafeLatexElementBuilder extends MarkdownElementBuilder {
  final TextStyle? textStyle;
  final double? textScaleFactor;

  SafeLatexElementBuilder({this.textStyle, this.textScaleFactor});

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final String text = element.textContent;
    if (text.isEmpty) {
      return const SizedBox();
    }

    final mathStyle = element.attributes['MathStyle'] == 'display'
        ? MathStyle.display
        : MathStyle.text;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.antiAlias,
      child: Math.tex(
        text,
        textStyle: textStyle,
        mathStyle: mathStyle,
        textScaleFactor: textScaleFactor,
        onErrorFallback: (error) => Text(
          text,
          style: textStyle ?? const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}

String _normalizeLatexDelimiters(String input) {
  final normalized = input
      .replaceAllMapped(RegExp(r'(?<!\\)\$\$([\s\S]+?)(?<!\\)\$\$'), (match) {
        return '\\[${match.group(1)}\\]';
      })
      .replaceAllMapped(RegExp(r'(?<!\\)\$([^\n\$]+?)(?<!\\)\$'), (match) {
        return '\\(${match.group(1)}\\)';
      });

  return normalized.replaceAll(r'\$', r'$');
}

class PhotoSolutionPage extends StatefulWidget {
  const PhotoSolutionPage({super.key});

  @override
  State<PhotoSolutionPage> createState() => _PhotoSolutionPageState();
}

class _PhotoSolutionPageState extends State<PhotoSolutionPage> {
  final ChatService _chatService = ChatService();
  File? _selectedImage; 
  bool _isLoading = false; 
  String _solutionResult = ""; 

  // Galeriden fotoğraf seçme fonksiyonu
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _solutionResult = ""; // Yeni fotoğraf seçilince eski çözümü temizle
      });
    }
  }

  // Fotoğrafı backend'e gönderen fonksiyon
  Future<void> _solveQuestion() async {
    if (_selectedImage == null) 
    return; 

    setState(() {
      _isLoading = true;
      _solutionResult = "";
    });

    try {
      final response = await _chatService.sendPhotoToAI(_selectedImage!);
      List<dynamic> steps = response['solution_steps'] ?? [];
      
      setState(() {
        _solutionResult = _normalizeLatexDelimiters(steps.join("\n\n")); 
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Çözüm alınamadı: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Fotoğraflı Soru Çözümü', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. FOTOĞRAF ÖNİZLEME ALANI
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  boxShadow: [
                    const BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.02), blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_selectedImage!, fit: BoxFit.contain),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_rounded, size: 50, color: Colors.indigo.shade400),
                          const SizedBox(height: 12),
                          const Text('Soru Fotoğrafı Seçmek İçin Dokun', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. ÇÖZÜMÜ BAŞLAT BUTONU
            if (_selectedImage != null)
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _solveQuestion,
                icon: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(_isLoading ? 'Sorun Analiz Ediliyor...' : 'Yapay Zekâ ile Çözümü Başlat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 25),
          

            // 3. ADIM ADIM ÇÖZÜM ÇIKTI ALANI
            if (_solutionResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_rounded, color: Colors.amber),
                        SizedBox(width: 8),
                        Text('Adım Adım Çözüm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 24),
                    MarkdownBody(
                      data: _solutionResult,
                      selectable: true,
                      inlineSyntaxes: [LatexInlineSyntax()],
                      blockSyntaxes: [LatexBlockSyntax()],
                      builders: {
                        'latex': SafeLatexElementBuilder(
                          textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
                          textScaleFactor: 1.0,
                        ),
                      },
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),

),

],

),

),
// 3. ADIM ADIM ÇÖZÜM ÇIKTI ALANI'nın bittiği yerin hemen altı:
              if (_solutionResult.isNotEmpty) ...[
  const SizedBox(height: 16),
  OutlinedButton.icon(
    onPressed: () {
      setState(() {
        _selectedImage = null; // Fotoğrafı kaldırır
        _solutionResult = "";  // Çözümü temizler
      });
    },
    icon: const Icon(Icons.refresh_rounded, color: Colors.indigo),
    label: const Text('Başka Bir Soru Çöz', style: TextStyle(color: Colors.indigo)),
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.indigo, width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
]

],

),  
      ),
);

}

} 