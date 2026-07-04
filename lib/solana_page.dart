import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/solana_service.dart';

class SolanaPage extends StatefulWidget {
  const SolanaPage({super.key});

  @override
  State<SolanaPage> createState() => _SolanaPageState();
}

class _SolanaPageState extends State<SolanaPage> {
  final TextEditingController _walletController = TextEditingController();
  late Future<Map<String, dynamic>> _healthCheck;
  double? _balance;
  bool _isLoading = false;
  String? _savedWalletAddress;
  String _errorMessage = '';
  String _successMessage = '';
  Map<String, dynamic>? _latestRecord;
  String? _shareLink;

  @override
  void initState() {
    super.initState();
    _healthCheck = SolanaService.checkHealth();
    _loadSavedWallet();
  }

  /// Load saved wallet address from secure storage
  Future<void> _loadSavedWallet() async {
    try {
      final saved = await SolanaService.getSavedWalletAddress();
      if (saved != null) {
        setState(() {
          _savedWalletAddress = saved;
          _walletController.text = saved;
        });
      }
    } catch (error) {
      _showError('Failed to load wallet: $error');
    }
  }

  /// Fetch balance for the entered wallet address
  Future<void> _fetchBalance() async {
    final address = _walletController.text.trim();
    
    if (address.isEmpty) {
      _showError('Please enter a wallet address');
      return;
    }

    if (!SolanaService.isValidSolanaAddress(address)) {
      _showError('Invalid Solana address format');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final balance = await SolanaService.getBalance(address);
      setState(() {
        _balance = balance;
        _successMessage = 'Balance loaded successfully!';
      });
    } catch (error) {
      _showError(error.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Create a wallet-backed activity record for the user's session or workout.
  Future<void> _createSampleRecord() async {
    final address = _walletController.text.trim();

    if (address.isEmpty) {
      _showError('Please enter a wallet address');
      return;
    }

    if (!SolanaService.isValidSolanaAddress(address)) {
      _showError('Invalid Solana address format');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final record = SolanaService.buildActivityRecord(
        address,
        'Workout',
        description: 'Posture session completed',
        durationSeconds: 1800,
      );
      final link = SolanaService.buildShareableLink(walletAddress: address, record: record);
      setState(() {
        _latestRecord = record;
        _shareLink = link;
        _successMessage = 'Blockchain-style record created';
      });
    } catch (error) {
      _showError(error.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Save wallet address to secure storage
  Future<void> _saveWallet() async {
    final address = _walletController.text.trim();
    
    if (address.isEmpty) {
      _showError('Please enter a wallet address');
      return;
    }

    if (!SolanaService.isValidSolanaAddress(address)) {
      _showError('Invalid Solana address format');
      return;
    }

    try {
      await SolanaService.saveWalletAddress(address);
      setState(() {
        _savedWalletAddress = address;
        _successMessage = 'Wallet saved successfully!';
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  /// Clear saved wallet
  Future<void> _clearWallet() async {
    try {
      await SolanaService.clearWallet();
      setState(() {
        _savedWalletAddress = null;
        _walletController.clear();
        _balance = null;
        _successMessage = 'Wallet cleared successfully!';
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _successMessage = '';
    });
  }

  @override
  void dispose() {
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solana Wallet',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Network Health Status
            _buildHealthCheckCard(),
            const SizedBox(height: 24),

            // Wallet Input Section
            _buildWalletInputSection(),
            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 24),

            // Balance Display
            if (_balance != null) _buildBalanceCard(),
            if (_latestRecord != null) _buildRecordCard(),

            // Error/Success Messages
            if (_errorMessage.isNotEmpty)
              _buildMessageCard(_errorMessage, Colors.red, Colors.redAccent),
            if (_successMessage.isNotEmpty)
              _buildMessageCard(_successMessage, Colors.green, Colors.greenAccent),

            const SizedBox(height: 20),

            // Saved Wallet Info
            if (_savedWalletAddress != null) _buildSavedWalletInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCheckCard() {
    return Card(
      elevation: 2,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _healthCheck,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Checking Solana network...',
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
            );
          }

          final isHealthy = snapshot.hasData && snapshot.data!['status'] == 'ok';
          final slot = snapshot.data?['slot'] ?? 'Unknown';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: isHealthy ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isHealthy ? 'Network Online' : 'Network Offline',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: isHealthy ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Slot: $slot',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWalletInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wallet Address',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _walletController,
          decoration: InputDecoration(
            hintText: 'Enter Solana wallet address',
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _fetchBalance,
          icon: const Icon(Icons.account_balance_wallet),
          label: Text(
            _isLoading ? 'Loading...' : 'Check Balance',
            style: GoogleFonts.poppins(),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[800],
            disabledBackgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _saveWallet,
                icon: const Icon(Icons.save),
                label: Text('Save Wallet', style: GoogleFonts.poppins()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _savedWalletAddress != null ? _clearWallet : null,
                icon: const Icon(Icons.delete),
                label: Text('Clear', style: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _createSampleRecord,
            icon: const Icon(Icons.fact_check_outlined),
            label: Text('Create Record', style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple[700],
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Colors.deepPurple[800]!, Colors.deepPurple[600]!],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'SOL Balance',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_balance!.toStringAsFixed(4)} SOL',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard() {
    final record = _latestRecord!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wallet-backed activity record',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${record['activityType']} • ${record['description']}',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              'Hash: ${record['hash']}',
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'Share link: ${_shareLink ?? ''}',
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(String message, Color bgColor, Color borderColor) {
    return Card(
      color: bgColor.withAlpha(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
          style: GoogleFonts.poppins(
            color: borderColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSavedWalletInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved Wallet',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _savedWalletAddress ?? 'None',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
