import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NativePropertiesScreen extends StatefulWidget {
  const NativePropertiesScreen({super.key});

  @override
  State<NativePropertiesScreen> createState() => _NativePropertiesScreenState();
}

class _NativePropertiesScreenState extends State<NativePropertiesScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Tous', 'Occupés', 'Vacants', 'Retard'];

  // Mock property data matching Airbnb spec
  final List<Map<String, dynamic>> _properties = [
    {
      'name': 'Résidence Bonamoussadi',
      'city': 'Douala',
      'units': 6,
      'occupied': 5,
      'rent': 'XAF 450,000',
      'status': 'partial', // full, partial, vacant
      'imageUrl': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=500&auto=format&fit=crop&q=60',
      'isFlagged': true,
    },
    {
      'name': 'Villa Akwa Climatise',
      'city': 'Douala',
      'units': 1,
      'occupied': 1,
      'rent': 'XAF 600,000',
      'status': 'full',
      'imageUrl': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=500&auto=format&fit=crop&q=60',
      'isFlagged': false,
    },
    {
      'name': 'Immeuble Bastos Center',
      'city': 'Yaoundé',
      'units': 12,
      'occupied': 10,
      'rent': 'XAF 1,800,000',
      'status': 'partial',
      'imageUrl': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=500&auto=format&fit=crop&q=60',
      'isFlagged': false,
    },
    {
      'name': 'Appartement Kribi Plage',
      'city': 'Kribi',
      'units': 4,
      'occupied': 0,
      'rent': 'XAF 350,000',
      'status': 'vacant',
      'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=500&auto=format&fit=crop&q=60',
      'isFlagged': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter properties based on selection
    List<Map<String, dynamic>> filteredProperties = _properties;
    if (_selectedFilterIndex == 1) {
      filteredProperties = _properties.where((p) => p['occupied'] > 0).toList();
    } else if (_selectedFilterIndex == 2) {
      filteredProperties = _properties.where((p) => p['occupied'] == 0).toList();
    } else if (_selectedFilterIndex == 3) {
      filteredProperties = _properties.where((p) => p['isFlagged']).toList();
    }

    return Scaffold(
      backgroundColor: PropveilTheme.canvasNavy,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sticky Top Search Pill (Airbnb Hallmark)
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28, top: 16, bottom: 8),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: PropveilTheme.surface2,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: PropveilTheme.borderSubtle),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: PropveilTheme.tealAccent, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search properties...',
                          hintStyle: TextStyle(color: PropveilTheme.textTertiary, fontSize: 15),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(color: PropveilTheme.textPrimary, fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: PropveilTheme.textSecondary, size: 20),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),

            // Horizontal Scroll Filter Chips
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? PropveilTheme.tealAccent : PropveilTheme.surfaceNavy,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : PropveilTheme.borderSubtle,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : PropveilTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Property Catalogue Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Divider(color: PropveilTheme.borderSubtle, height: 1),
            ),
            
            const SizedBox(height: 16),

            // Properties list/grid scrollable section
            Expanded(
              child: filteredProperties.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      itemCount: filteredProperties.length,
                      itemBuilder: (context, index) {
                        final p = filteredProperties[index];
                        return _buildPropertyCard(context, p);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context, Map<String, dynamic> p) {
    final theme = Theme.of(context);
    final statusColor = p['status'] == 'full'
        ? PropveilTheme.success
        : p['status'] == 'partial'
            ? PropveilTheme.warning
            : PropveilTheme.textTertiary;
            
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1:1 Square Photo Container with rounded corners
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    color: PropveilTheme.surfaceNavy,
                    width: double.infinity,
                    child: Image.network(
                      p['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: PropveilTheme.surfaceNavy,
                          child: const Icon(
                            Icons.home_work_outlined,
                            size: 64,
                            color: PropveilTheme.textTertiary,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(PropveilTheme.tealAccent),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Translucent Heart Flag Icon top-right
                Positioned(
                  top: 16,
                  right: 16,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        p['isFlagged'] = !p['isFlagged'];
                      });
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Icon(
                        p['isFlagged'] ? Icons.favorite : Icons.favorite_border,
                        color: p['isFlagged'] ? PropveilTheme.coralAccent : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                
                // Photo dots at bottom center
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (dotIndex) {
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: dotIndex == 0 ? Colors.white : Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 14),
          
          // Title Row: Property Name + Occupancy Dot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                p['name'],
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: PropveilTheme.textPrimary,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Sub-row: Location · Units · Rent Total
          Text(
            '${p['city']} · ${p['units']} unités',
            style: const TextStyle(
              fontSize: 13,
              color: PropveilTheme.textSecondary,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Star Occupancy Ratio + Price Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${p['rent']} /mois',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: PropveilTheme.tealAccent,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: PropveilTheme.goldAccent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '★ ${p['occupied']}/${p['units']} occupées',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: PropveilTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_work_outlined,
              size: 80,
              color: PropveilTheme.textTertiary,
            ),
            const SizedBox(height: 20),
            const Text(
              'No properties match filters',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: PropveilTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try changing your filter options to view other properties in your portfolio.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: PropveilTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedFilterIndex = 0;
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: PropveilTheme.tealAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Reset Filters',
                style: TextStyle(color: PropveilTheme.tealAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
