class UserData {
  String name;
  String username;
  String password;
  String phoneNumber;
  String email;
  String location;
  int slouchingSeconds;
  int goodPostureSeconds;
  DateTime lastSynced;
  DateTime joinDate;
  DateTime lastLoginDate;
  int streak;
  int postureScore; // Real-time posture score (0-100)
  bool isBotConnected; // New field for connection status
  DateTime nextStretch;
  String? activeExerciseTitle; // Track what the user is currently doing

  UserData({
    required this.name,
    this.username = "User",
    this.password = "password123",
    required this.phoneNumber,
    required this.email,
    required this.location,
    this.slouchingSeconds = 35,
    this.goodPostureSeconds = 55,
    required this.lastSynced,
    required this.joinDate,
    required this.lastLoginDate,
    this.streak = 1,
    this.postureScore = 85,
    this.isBotConnected = false,
    required this.nextStretch,
  });

  // Logic to update or reset streak based on a rolling 24-hour window
  void updateStreak() {
    final now = DateTime.now();
    final hoursSinceLastLogin = now.difference(lastLoginDate).inHours;

    if (hoursSinceLastLogin < 24) {
      return;
    }

    if (hoursSinceLastLogin < 48) {
      streak += 1;
    } else {
      streak = 1;
    }

    lastLoginDate = now;
  }
  // Check if enough days have passed to show a timeframe
  bool isTimeframeUnlocked(String timeframe) {
    int daysActive = DateTime.now().difference(joinDate).inDays;
    switch (timeframe) {
      case "Weekly": return daysActive >= 7;
      case "Monthly": return daysActive >= 30;
      case "Yearly": return daysActive >= 365;
      default: return true; // Daily is always unlocked
    }
  }

  // Get days remaining until unlock
  int daysUntilUnlock(String timeframe) {
    int daysActive = DateTime.now().difference(joinDate).inDays;
    switch (timeframe) {
      case "Weekly": return 7 - daysActive;
      case "Monthly": return 30 - daysActive;
      case "Yearly": return 365 - daysActive;
      default: return 0;
    }
  }

  // Helper to format seconds into a full duration string
  String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m ${seconds}s";
    } else if (minutes > 0) {
      return "${minutes}m ${seconds}s";
    }
    return "$seconds";
  }

  // Helper to get the unit labels
  String getDurationUnit(int totalSeconds) {
    if (totalSeconds < 60) return "seconds";
    if (totalSeconds < 3600) return "min : sec";
    return "hr : min : sec";
  }

  // Getters for Timeframe-specific data
  int getSlouchingFor(String timeframe) {
    switch (timeframe) {
      case "Weekly": return slouchingSeconds * 7;
      case "Monthly": return slouchingSeconds * 30;
      case "Yearly": return slouchingSeconds * 365;
      default: return slouchingSeconds;
    }
  }

  int getGoodPostureFor(String timeframe) {
    switch (timeframe) {
      case "Weekly": return goodPostureSeconds * 7;
      case "Monthly": return goodPostureSeconds * 30;
      case "Yearly": return goodPostureSeconds * 365;
      default: return goodPostureSeconds;
    }
  }

  List<double> getGoodHistoryFor(String timeframe) {
    switch (timeframe) {
      case "Weekly": return [40, 55, 30, 80, 65, 90, 85];
      case "Monthly": return [30, 45, 60, 50, 70, 85, 90, 75, 80, 95];
      case "Yearly": return [20, 40, 55, 60, 75, 80, 85, 90, 95, 92, 88, 96];
      default: return [10, 20, 45, 30, 60, 80, 70, 90, 85, 95];
    }
  }

  List<double> getSlouchHistoryFor(String timeframe) {
    switch (timeframe) {
      case "Weekly": return [20, 15, 40, 10, 25, 5, 10];
      case "Monthly": return [50, 40, 30, 35, 20, 15, 10, 20, 15, 5];
      case "Yearly": return [60, 50, 40, 35, 25, 20, 15, 10, 8, 5, 10, 4];
      default: return [5, 15, 10, 40, 50, 20, 30, 10, 5, 2];
    }
  }

  String getSyncStatus() {
    final now = DateTime.now();
    final difference = now.difference(lastSynced);

    if (difference.inSeconds < 60) {
      return "Last synced: Just now";
    } else if (difference.inMinutes < 60) {
      return "Last synced: ${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "Last synced: ${difference.inHours}h ago";
    } else {
      return "Last synced: ${difference.inDays}d ago";
    }
  }

  String getDailyInsight() {
    if (!isBotConnected) {
      return "PACE bot is offline. Connect your device to start receiving real-time posture insights.";
    }

    if (postureScore < 50) {
      return "Your posture score is a bit low today. Try raising your laptop to eye level to reduce neck strain.";
    }

    if (slouchingSeconds > 300) {
      return "You've been slouching for over 5 minutes. Time to stand up and do a quick 30-second chest stretch!";
    }

    if (streak > 5) {
      return "Amazing consistency! You've kept your streak alive for $streak days. Your spine will thank you.";
    }

    // Default Ergonomic Tip
    return "Remember the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds to reduce eye strain.";
  }

  // Helper to get formatted remaining time for next stretch
  String getNextStretchTimer() {
    final duration = nextStretch.difference(DateTime.now());
    if (duration.isNegative) return "Ready!";

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${minutes}min ${seconds}secs";
  }

  String get connectionStatusText => isBotConnected ? 'Online' : 'Offline';

  void setConnectionStatus(bool connected) {
    isBotConnected = connected;
  }
}

// Global instance to simulate "Current Logged In User"
UserData currentUser = UserData(
  name: "User", // Default for now
  phoneNumber: "+234 812 345 6789",
  email: "user@pace.app",
  location: "Lagos, Nigeria",
  slouchingSeconds: 35,
  goodPostureSeconds: 3665, // 1h 1m 5s
  lastSynced: DateTime.now(),
  joinDate: DateTime.now().subtract(const Duration(days: 3)), // Joined 3 days ago for testing
  lastLoginDate: DateTime.now().subtract(const Duration(days: 1)), // Last login was yesterday
  streak: 3,
  postureScore: 85,
  isBotConnected: false,
  nextStretch: DateTime.now().add(const Duration(minutes: 19, seconds: 20)),
);

bool isLoggedIn = false; // Add this to track login status