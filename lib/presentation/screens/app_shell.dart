import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/screen_viewer.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Navigation State
  String _currentScreenId = '8c393b9ab4454a65b43d9548a8363f4a'; // Start with Splash screen
  final List<String> _history = [];
  int _selectedTabIndex = 0;
  bool _isOnboarding = true;

  // Metadata list loaded from JSON
  List<dynamic> _screensMetadata = [];
  Map<String, List<dynamic>> _groupedScreens = {};
  bool _isMetadataLoaded = false;
  String _searchQuery = '';

  // Tab Main Screens
  final Map<int, String> _tabScreens = {
    0: '5add398873b243f4bd0f6c59561143e9', // Dashboard -> Landlord Home Dashboard
    1: '34a3e073778249ef9b8d58824708e6f9', // Properties -> Your Properties (Airbnb)
    2: '30d968beb39c4f6093fe7e4d5ba7321c', // Payments -> Payments Dashboard Overview
    3: '51c1a44a567f4545a128fdc146f4d984', // Tenants -> Tenants Management Overview
    4: '129238436f96475c8cb23065de88c5c4', // Settings -> Settings: Pro Manager Landing
  };

  // Onboarding sequence mapping (Screen ID -> Next Screen ID)
  final Map<String, String> _onboardingFlow = {
    '8c393b9ab4454a65b43d9548a8363f4a': 'b9634824a6d249129cf8bf3d96933a37', // Splash -> Language
    'b9634824a6d249129cf8bf3d96933a37': '56c7c5c1909d44c295edd96b6086c9bb', // Language -> Role Selector
    '56c7c5c1909d44c295edd96b6086c9bb': 'd96b4018b6254c8ea790d8e1f7760ae0', // Role Selector -> Phone Auth
    'd96b4018b6254c8ea790d8e1f7760ae0': 'd994b7f1bbe243ec8129c4d3bb3b2c5e', // Phone Auth -> OTP
    'd994b7f1bbe243ec8129c4d3bb3b2c5e': '831cb361530543728f1ef4b72bba6e8a', // OTP -> PIN Setup
    '831cb361530543728f1ef4b72bba6e8a': '6d708a13690241ec8dd3e8bcbb05334c', // PIN Setup -> Biometrics
    '6d708a13690241ec8dd3e8bcbb05334c': 'fb9b59d28d1d4b4b9b19cc63320f59b1', // Biometrics -> Profile Setup
    'fb9b59d28d1d4b4b9b19cc63320f59b1': 'd8e47b6fd9ba4803935d21fb9f90f467', // Profile Setup -> Pricing
    'd8e47b6fd9ba4803935d21fb9f90f467': '65d4ba7aed874563a1d3a20f807fc266', // Pricing -> Consent (A.17)
    '65d4ba7aed874563a1d3a20f807fc266': 'ea21f55d96eb4c1ca44cf041ec6e385b', // Consent -> Offline Promise
    'ea21f55d96eb4c1ca44cf041ec6e385b': 'b8ac47bbb83b42ba939d4cd8a1cdacd3', // Offline -> Welcome Launchpad
    'b8ac47bbb83b42ba939d4cd8a1cdacd3': '5add398873b243f4bd0f6c59561143e9', // Welcome Launchpad -> Home Dashboard
  };

  @override
  void initState() {
    super.initState();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/screens/screens_metadata.json');
      final data = jsonDecode(jsonStr) as List<dynamic>;
      
      // Group screens by flow/module based on their title code or project id
      final Map<String, List<dynamic>> grouped = {};
      for (var s in data) {
        final title = s['title'] as String;
        String flow = "General / Miscellaneous";
        
        // Infer flow group from title patterns
        if (title.contains("Onboarding") || title.contains("Splash") || title.contains("Verification") || title.contains("Language") || title.contains("PIN") || title.contains("Biometric") || title.contains("Consents")) {
          flow = "Flow A: Onboarding & Launch";
        } else if (title.contains("Welcome Launchpad") || title.contains("Add property") || title.contains("Add Unit") || title.contains("Add Tenant") || title.contains("Setup complete")) {
          flow = "Flow B: Landlord First-Run Setup";
        } else if (title.contains("Dashboard") || title.contains("KPI") || title.contains("Notification") || title.contains("Insight") || title.contains("Calendar")) {
          flow = "Flow C: Landlord Dashboard";
        } else if (title.contains("Properties") || title.contains("Property") || title.contains("Unit Detail") || title.contains("New Unit") || title.contains("Inventory")) {
          flow = "Flow D: Properties & Units";
        } else if (title.contains("Tenants") || title.contains("Tenant") || title.contains("Lease") || title.contains("Reminder")) {
          flow = "Flow E: Tenant Management";
        } else if (title.contains("Payment") || title.contains("Receipt") || title.contains("Transaction") || title.contains("Late Fee") || title.contains("Ledger")) {
          flow = "Flow F: Payments";
        } else if (title.contains("Maintenance") || title.contains("Ticket") || title.contains("Repair") || title.contains("Triage")) {
          flow = "Flow G: Maintenance & AI Triage";
        } else if (title.contains("AI Assistant") || title.contains("Claude") || title.contains("Insight") || title.contains("Ask portfolio")) {
          flow = "Flow H: AI Assistant";
        } else if (title.contains("Documents") || title.contains("Document") || title.contains("Signature") || title.contains("OHADA")) {
          flow = "Flow I: Legal & Documents";
        } else if (title.contains("Analytics") || title.contains("Cash Flow") || title.contains("NOI") || title.contains("Vacancy Loss")) {
          flow = "Flow J: Analytics";
        } else if (title.contains("Subscription") || title.contains("Upgrade") || title.contains("Gerant") || title.contains("Plan")) {
          flow = "Flow K: Subscription & Upgrade Triggers";
        } else if (title.contains("Settings") || title.contains("Profile") || title.contains("Help Center") || title.contains("Offline mode")) {
          flow = "Flow L: Settings & Profiles";
        } else if (title.contains("Caretaker") || title.contains("Staff") || title.contains("Agency")) {
          flow = "Flow M/N/O: Agency & Staff";
        } else if (title.contains("Sync") || title.contains("Error") || title.contains("Server")) {
          flow = "Flow P: Edge & System States";
        }

        grouped.putIfAbsent(flow, () => []).add(s);
      }

      setState(() {
        _screensMetadata = data;
        _groupedScreens = grouped;
        _isMetadataLoaded = true;
      });
    } catch (e) {
      debugPrint("Error loading metadata: $e");
    }
  }

  // Navigate to a screen and manage the back stack
  void _navigateToScreen(String screenId, {bool isBack = false}) {
    if (_currentScreenId == screenId) return;

    setState(() {
      if (isBack) {
        if (_history.isNotEmpty) {
          _currentScreenId = _history.removeLast();
        }
      } else {
        _history.add(_currentScreenId);
        _currentScreenId = screenId;
      }

      // Automatically infer if we have completed onboarding
      if (_isOnboarding && _tabScreens.values.contains(_currentScreenId)) {
        _isOnboarding = false;
      }
      
      // Update selected tab index if navigated directly to a main tab screen
      _tabScreens.forEach((index, tabScreenId) {
        if (_currentScreenId == tabScreenId) {
          _selectedTabIndex = index;
        }
      });
    });
  }

  // Bottom Nav Bar click
  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
      _isOnboarding = false;
      final targetScreen = _tabScreens[index];
      if (targetScreen != null) {
        _navigateToScreen(targetScreen);
      }
    });
  }

  // Intercept click signals from JavaScript and route them
  void _handleNavigationEvent(Map<String, dynamic> data) {
    final action = data['action'] as String?;
    final text = data['text'] as String? ?? "";
    
    if (action == 'back') {
      if (_history.isNotEmpty) {
        _navigateToScreen('', isBack: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Already at top of stack.")),
        );
      }
      return;
    }

    // Heuristics navigation mapping based on tapped button text
    String? targetId;

    // 1. Onboarding progression
    if (_isOnboarding && _onboardingFlow.containsKey(_currentScreenId)) {
      targetId = _onboardingFlow[_currentScreenId];
    } 
    // 2. Tab switches
    else if (text.toLowerCase() == "tableau" || text.toLowerCase() == "home" || text.toLowerCase() == "accueil") {
      _onTabSelected(0);
      return;
    } else if (text.toLowerCase() == "propriétés" || text.toLowerCase() == "properties") {
      _onTabSelected(1);
      return;
    } else if (text.toLowerCase() == "paiements" || text.toLowerCase() == "payments" || text.toLowerCase() == "payouts") {
      _onTabSelected(2);
      return;
    } else if (text.toLowerCase() == "locataires" || text.toLowerCase() == "tenants") {
      _onTabSelected(3);
      return;
    } else if (text.toLowerCase() == "paramètres" || text.toLowerCase() == "settings" || text.toLowerCase() == "more") {
      _onTabSelected(4);
      return;
    }
    
    // Heuristic string match transitions
    if (targetId == null) {
      targetId = _inferTargetScreen(text);
    }

    if (targetId != null) {
      _navigateToScreen(targetId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Click intercepted: '$text'. Heuristic match not found, use floating search menu!"),
          backgroundColor: const Color(0xFF142239),
          action: SnackBarAction(
            label: "Open Search",
            textColor: const Color(0xFF1D9A8A),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      );
    }
  }

  // Search logic to heuristically guess what screen title fits the clicked text
  String? _inferTargetScreen(String clickedText) {
    final text = clickedText.toLowerCase();
    
    // Rules matching specific pages
    if (_currentScreenId == '5add398873b243f4bd0f6c59561143e9') { // Dashboard
      if (text.contains("outstanding") || text.contains("loyers en retard") || text.contains("380 000")) {
        return '3b32a8ec2a0e474d83ba5cb75a5489e0'; // Outstanding Rent Dashboard
      }
      if (text.contains("vacancy") || text.contains("vacance")) {
        return '4ca93703c9a84614873c9ea0059e2227'; // Vacancy Loss Dashboard
      }
      if (text.contains("notifications") || text.contains("alert")) {
        return 'd07411906af94012b5fd1f3f304aa368'; // Notifications
      }
    }
    
    if (_currentScreenId == '3b32a8ec2a0e474d83ba5cb75a5489e0') { // Outstanding Rent Dashboard
      if (text.contains("jean talla") || text.contains("jt")) {
        return '07a1def1e95045539f5e417b8a312f81'; // Risk Alert - Jean Talla
      }
      if (text.contains("eric fotso")) {
        return 'bde74b40f92640eb9b0bf8c778a5902c'; // Eric detail/Marie Ngo detail placeholder
      }
      if (text.contains("reminder") || text.contains("rappels")) {
        return 'd5b87e4c972d4f90bc6de30d880b37ed'; // Bulk WhatsApp Reminder
      }
    }

    if (_currentScreenId == '34a3e073778249ef9b8d58824708e6f9') { // Properties list (Airbnb style)
      if (text.contains("bonamoussadi")) {
        return 'a667f8323c544c63a6e22aab732d573b'; // Property Detail
      }
      if (text.contains("add property") || text.contains("ajouter")) {
        return '1e177186f4a940a8b350e257563b945b'; // New Property Form
      }
    }

    if (_currentScreenId == 'a667f8323c544c63a6e22aab732d573b') { // Property Detail
      if (text.contains("unite b-3") || text.contains("b-3")) {
        return 'fbca6a7f85c7400a9b3359e8c3ca17bc'; // Unit Detail
      }
      if (text.contains("docs") || text.contains("documents")) {
        return '3a7dbfec1f5f4794868014035540c680'; // Document Library
      }
    }

    if (_currentScreenId == 'fbca6a7f85c7400a9b3359e8c3ca17bc') { // Unit Detail
      if (text.contains("collect") || text.contains("encaisser") || text.contains("loyer")) {
        return '75e30940e1dd425abbcd791d464f8257'; // Collect Rent - Step 1: Pick Tenant
      }
      if (text.contains("maintenance") || text.contains("réparation") || text.contains("ticket")) {
        return 'cddcc9ece013484f8125da4b3e721588'; // Maintenance Dashboard
      }
    }

    if (_currentScreenId == '51c1a44a567f4545a128fdc146f4d984') { // Tenants List
      if (text.contains("marie ngo") || text.contains("ngo")) {
        return 'bde74b40f92640eb9b0bf8c778a5902c'; // Tenant Detail
      }
      if (text.contains("ajouter") || text.contains("add tenant")) {
        return 'bef22d67702d44e895701ba9c22fd5da'; // Add Tenant
      }
    }

    if (_currentScreenId == 'bde74b40f92640eb9b0bf8c778a5902c') { // Tenant Detail
      if (text.contains("sign") || text.contains("signer")) {
        return 'cb1b7a47ef4545f6a164da5f78613190'; // Sign the Lease
      }
      if (text.contains("whatsapp") || text.contains("message")) {
        return '58e7f4cca545427fb1b198f094b11aa5'; // WhatsApp Composer
      }
    }

    if (_currentScreenId == '30d968beb39c4f6093fe7e4d5ba7321c') { // Payments Dashboard
      if (text.contains("late fee") || text.contains("pénalité")) {
        return '5132ce2a74d84c72b1a11e867dad2ab4'; // Late Fee Insight
      }
      if (text.contains("reconcile") || text.contains("caisse")) {
        return '0f686018cd4f450e954a65fa2046795a'; // Reconcile Cash
      }
    }

    // Generic search in screen titles as fallback
    for (var s in _screensMetadata) {
      final title = s['title'] as String;
      if (text.length > 4 && title.toLowerCase().contains(text)) {
        return s['id'];
      }
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628), // bg-canvas
      // WebView Area
      body: SafeArea(
        top: false, // WebView handles top safe areas inside HTML
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_isOnboarding && _onboardingFlow.containsKey(_currentScreenId)) {
              final nextScreenId = _onboardingFlow[_currentScreenId];
              if (nextScreenId != null) {
                _navigateToScreen(nextScreenId);
              }
            }
          },
          child: ScreenViewer(
            fileName: '${_currentScreenId}.html',
            onNavigate: _handleNavigationEvent,
          ),
        ),
      ),
      
      // Drawer listing all 197 screens for testing
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF142239), // Surface-2
        child: Column(
          children: [
            // Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1A2B45), // bg-surface
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "PropVeil Prototypes",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Select any of the ${_screensMetadata.length} generated screens",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Color(0xFF94A3B8), // text-secondary
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search screens...",
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF1D9A8A)),
                  fillColor: const Color(0xFF0A1628),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E293B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E293B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1D9A8A)),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),
            
            // Screens List
            Expanded(
              child: _isMetadataLoaded
                  ? ListView(
                      children: _groupedScreens.entries.map((entry) {
                        final flowName = entry.key;
                        final screens = entry.value.where((s) {
                          final title = s['title'] as String;
                          return title.toLowerCase().contains(_searchQuery.toLowerCase());
                        }).toList();
                        
                        if (screens.isEmpty) return const SizedBox.shrink();
                        
                        return ExpansionTile(
                          iconColor: const Color(0xFF1D9A8A),
                          collapsedIconColor: const Color(0xFF94A3B8),
                          title: Text(
                            flowName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          children: screens.map((s) {
                            final title = s['title'] as String;
                            final isCurrent = s['id'] == _currentScreenId;
                            return ListTile(
                              dense: true,
                              selected: isCurrent,
                              selectedColor: const Color(0xFF1D9A8A),
                              title: Text(
                                title,
                                style: TextStyle(
                                  color: isCurrent ? const Color(0xFF1D9A8A) : const Color(0xFF94A3B8),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              subtitle: Text(
                                "ID: ${s['id'].toString().substring(0, 8)}...",
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                              ),
                              onTap: () {
                                Navigator.pop(context); // Close drawer
                                _navigateToScreen(s['id']);
                              },
                            );
                          }).toList(),
                        );
                      }).toList(),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1D9A8A)),
                      ),
                    ),
            ),
          ],
        ),
      ),

      // Native Bottom Navigation Bar (Hidden during Onboarding)
      bottomNavigationBar: _isOnboarding
          ? null
          : Container(
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xFF1A2B45), // bg-surface
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF1E293B), // border-subtle
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.dashboard_outlined, "Dashboard"),
                  _buildNavItem(1, Icons.business_outlined, "Properties"),
                  _buildNavItem(2, Icons.payment_outlined, "Payments"),
                  _buildNavItem(3, Icons.people_outline, "Tenants"),
                  _buildNavItem(4, Icons.settings_outlined, "More"),
                ],
              ),
            ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedTabIndex == index;
    final color = isSelected ? const Color(0xFF1D9A8A) : const Color(0xFF94A3B8);
    
    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9A8A),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            const SizedBox(height: 6),
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
