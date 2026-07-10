import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

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

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Çözülen Sorular Geçmişi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: currentUserId == null
          ? const Center(child: Text('Lütfen giriş yapın.'))
          : StreamBuilder<QuerySnapshot>(
              // Firestore composite index istemesin diye sıralamayı yerelde yapıyoruz.
              stream: FirebaseFirestore.instance
                  .collection('solved_questions')
                  .where('userId', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.indigo));
                }

                final docs = List<QueryDocumentSnapshot>.from(snapshot.data?.docs ?? []);
                docs.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aTimestamp = aData['timestamp'];
                  final bTimestamp = bData['timestamp'];

                  if (aTimestamp == null && bTimestamp == null) return 0;
                  if (aTimestamp == null) return 1;
                  if (bTimestamp == null) return -1;

                  return (bTimestamp as Timestamp).compareTo(aTimestamp as Timestamp);
                });

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_toggle_off_rounded, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text('Henüz çözülmüş bir soru bulunmuyor.', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final String ocrText = data['ocrText'] ?? 'Fotoğraflı Soru';
                    final String solution = data['solution'] ?? '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      shadowColor: Colors.black12,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade50,
                          child: const Icon(Icons.menu_book_rounded, color: Colors.indigo),
                        ),
                        title: Text(
                          ocrText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        subtitle: const Text('Çözümü Görüntüle', style: TextStyle(color: Colors.indigo, fontSize: 13)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black38),
                        onTap: () {
                          // 💡 Kart tıklandığında alt sayfada detayı açacağız
                          _showSolutionDetail(context, ocrText, solution);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  // 💡 Tıklanan sorunun çözümünü tam ekran/modal olarak gösteren yardımcı fonksiyon
  void _showSolutionDetail(BuildContext context, String title, String solution) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  MarkdownBody(
                    data: solution,
                    selectable: true,
                    inlineSyntaxes: [LatexInlineSyntax()],
                    blockSyntaxes: [LatexBlockSyntax()],
                    builders: {
                      'latex': SafeLatexElementBuilder(
                        textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
                        textScaleFactor: 1.0,
                      ),
                    },

                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}