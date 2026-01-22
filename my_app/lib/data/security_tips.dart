import 'dart:math';

class SecurityTip {
  final String title;
  final String description;

  SecurityTip({required this.title, required this.description});
}

class SecurityTips {
  static final List<SecurityTip> tips = [
    SecurityTip(
      title: 'Use a Password Manager',
      description:
          'Password managers securely store and generate strong passwords for all your accounts.',
    ),
    SecurityTip(
      title: 'Enable Two-Factor Authentication',
      description:
          'Add an extra layer of security by requiring a second verification method when logging in.',
    ),
    SecurityTip(
      title: 'Regular Password Updates',
      description:
          'Change your passwords every 3 months and avoid reusing old passwords.',
    ),
    SecurityTip(
      title: 'Be Cautious with Phishing',
      description:
          'Never click links from unknown senders. Verify sender identity before providing information.',
    ),
    SecurityTip(
      title: 'Keep Software Updated',
      description:
          'Install security patches and updates immediately to fix known vulnerabilities.',
    ),
    SecurityTip(
      title: 'Use Strong Passwords',
      description:
          'Create passwords with at least 12 characters including uppercase, numbers, and symbols.',
    ),
    SecurityTip(
      title: 'Monitor Your Accounts',
      description:
          'Regularly check your account activity for any unauthorized access or suspicious behavior.',
    ),
    SecurityTip(
      title: 'Secure Your Wi-Fi',
      description:
          'Use WPA3 encryption and a strong password for your home network.',
    ),
    SecurityTip(
      title: 'Check Privacy Settings',
      description:
          'Review and limit who can see your personal information on social media.',
    ),
    SecurityTip(
      title: 'Use VPN for Public Wi-Fi',
      description:
          'Connect to a VPN when using public Wi-Fi to encrypt your data.',
    ),
  ];

  static SecurityTip getRandomTip() {
    return tips[Random().nextInt(tips.length)];
  }
}
