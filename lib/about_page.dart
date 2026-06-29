import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 20.0, bottom: 10.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "About PACE",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Our Story Section
                      _buildSectionTitle("Our Story"),
                      _buildParagraph(
                        "PACE began with a simple, frustrating realization: we were all slowly wrecking our bodies, one slouched hour at a time. "
                        "As students, we spent entire days hunched over laptops and desks, half-aware that our posture was getting worse and fully aware that nothing existing made it easy to actually fix."
                      ),
                      _buildParagraph(
                        "We tried the usual things — reminder apps that got ignored, wearables that sat in a drawer, ergonomic advice that required more discipline than any of us had on a deadline. "
                        "Nothing stuck, because nothing met us where we actually were: at our desks, distracted, and not thinking about our spines."
                      ),
                      _buildParagraph(
                        "So we built PACE — a desk companion that does the noticing for you. It watches your posture in real time, nudges you the moment things slip, and quietly tracks your progress so you don't have to rely on memory or willpower."
                      ),
                      _buildParagraph(
                        "What started as a hackathon idea between four people who kept complaining about back pain has grown into something we genuinely believe could help people far beyond our own desks."
                      ),

                      const SizedBox(height: 30),

                      // Mission Section
                      _buildSectionTitle("Our Mission"),
                      _buildParagraph(
                        "To make good posture effortless — not through guilt or discipline, but through gentle, real-time support that fits naturally into your day.",
                        isItalic: true,
                      ),

                      const SizedBox(height: 30),

                      // Beliefs Section
                      _buildSectionTitle("What We Believe"),
                      _buildBeliefItem("Wellness should feel like a companion, not a chore.", "PACE is built to feel personal and encouraging, never clinical or naggy."),
                      _buildBeliefItem("Your health data belongs to you.", "Every posture session and workout is verified and secured using blockchain technology, not locked away in a company database."),
                      _buildBeliefItem("Small nudges beat big willpower.", "Real change happens through consistent, low-effort habits — not radical discipline."),
                      _buildBeliefItem("Technology should adapt to people.", "From personality themes to family profiles, PACE is built to fit into real, different lives."),

                      const SizedBox(height: 30),

                      // Team Section
                      _buildSectionTitle("The Team"),
                      _buildTeamMember("Collins-Peter Amarachi S.", "Backend Engineer", "Built the systems running quietly behind the scenes — the server, database, and the logic that connects your PACE bot to the app in real time."),
                      _buildTeamMember("Maduji Chidimma J.", "Frontend Engineer", "Designed and built the Flutter app you interact with every day — making sure it feels simple, fast, and genuinely easy to use."),
                      _buildTeamMember("Otti Mary-Kimberly K.", "CAD Designer", "Designed PACE's physical form — shaping a device that feels like a calm, welcome presence on your desk rather than another gadget competing for attention."),
                      _buildTeamMember("Anyanwu Joy C.", "Hardware Engineer", "Brought PACE's hardware to life together with Kalu Esther — wiring, assembling, and testing the ESP32, camera, and sensors that make real-time posture detection possible."),
                      _buildTeamMember("Kalu Esther", "Hardware Engineer", "Brought PACE's hardware to life together with Anyanwu Joy C. — wiring, assembling, and testing the ESP32, camera, and sensors that make real-time posture detection possible."),


                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          "We hope it ends up helping you too.",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF4F0382),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text, {bool isItalic = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 15,
          height: 1.6,
          color: Colors.black87,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }

  Widget _buildBeliefItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• $title",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String bio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EEF7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD8BFE5).withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              role,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4F0382),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bio,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
