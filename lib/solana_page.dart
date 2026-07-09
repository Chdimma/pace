import 'package:flutter/material.dart';
import 'solana_service.dart';

class SolanaPage extends StatefulWidget {
  final String userId; // Pass the logged-in user or device ID here
  const SolanaPage({super.key, this.userId = 'default_user'});

  @override
  State<SolanaPage> createState() => _SolanaPageState();
}

class _SolanaPageState extends State<SolanaPage> {
  final SolanaService _solanaService = SolanaService();
  String? _userWalletAddress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWeb3Identity();
  }

  // Triggers automatically on load to link identity to the blockchain
  void _initializeWeb3Identity() async {
    final result = await _solanaService.authenticateUserIdentity(widget.userId);
    if (result != null && result['success'] == true) {
      setState(() {
        _userWalletAddress = result['publicKey'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PACE Web3 Security Center")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CARD 1: Crypto Identity Status
                  Card(
                    color: Colors.blueGrey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("SECURE BLOCKCHAIN IDENTITY", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("Public Key: $_userWalletAddress", style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Verifiable Health Timeline (On-Chain)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  // LIST 2: Real-time Timeline Fetching
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: _solanaService.getVerifiableHealthTimeline(_userWalletAddress!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No health sessions recorded on Devnet yet."));
                        }

                        final history = snapshot.data!;
                        return ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final event = history[index];
                            return ListTile(
                              leading: const Icon(Icons.shield, color: Colors.blue),
                              title: Text("${event['eventType']}".toUpperCase()),
                              subtitle: Text("Score: ${event['postureScore']}% | Duration: ${event['durationSeconds']}s"),
                              trailing: Text(event['date'].toString().substring(0, 10)),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}