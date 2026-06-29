import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeFontPage extends StatefulWidget {
  const ThemeFontPage({super.key});

  @override
  State<ThemeFontPage> createState() => _ThemeFontPageState();
}

class _ThemeFontPageState extends State<ThemeFontPage> {
  String selectedTheme = "Classic Purple";
  String selectedFont = "Poppins";

  final List<String> themes = ["Classic Purple", "Deep Velvet", "Soft Orchid", "Nordic Blue"];
  final List<String> fonts = ["Poppins", "Inter", "Roboto", "Open Sans"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8D45B2),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD8BFE5),
              Color(0xFF8D45B2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Zone
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 16.0, bottom: 24.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Icon(Icons.stars, size: 32, color: Colors.black),
                    const SizedBox(width: 12),
                    Text(
                      "Theme & Font",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Customization List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  children: [
                    Text(
                      "CHOOSE THEME",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...themes.map((theme) => _buildSelectionTile(
                          title: theme,
                          isSelected: selectedTheme == theme,
                          onTap: () {
                            setState(() {
                              selectedTheme = theme;
                            });
                          },
                        )),
                    const SizedBox(height: 32),
                    Text(
                      "CHOOSE FONT",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...fonts.map((font) => _buildSelectionTile(
                          title: font,
                          isSelected: selectedFont == font,
                          onTap: () {
                            setState(() {
                              selectedFont = font;
                            });
                          },
                        )),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF270530),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Applied $selectedTheme with $selectedFont font style!"),
                            backgroundColor: const Color(0xFF270530),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Apply Changes",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildSelectionTile({required String title, required bool isSelected, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isSelected ? 0.9 : 0.4),
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: const Color(0xFF270530), width: 2) : null,
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Color(0xFF270530))
            : const Icon(Icons.circle_outlined, color: Colors.black26),
        onTap: onTap,
      ),
    );
  }
}
