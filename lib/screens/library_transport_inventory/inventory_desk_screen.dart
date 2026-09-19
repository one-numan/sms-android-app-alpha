// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 32: Central Inventory & Low Stock Management Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/inventory_all_items_low_stock_desk
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class InventoryDeskScreen extends StatefulWidget {
  const InventoryDeskScreen({super.key});

  @override
  State<InventoryDeskScreen> createState() => _InventoryDeskScreenState();
}

class _InventoryDeskScreenState extends State<InventoryDeskScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  late List<InventoryItem> _items;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _items = List.from(MockData.inventory);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddItemDialog() {
    final nameCtrl = TextEditingController();
    final catCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final reorderCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AcademicColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Inventory Asset',
                    style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Item Name', hintText: 'e.g. Physics Lab Flasks'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: catCtrl,
                decoration: const InputDecoration(labelText: 'Category', hintText: 'e.g. Science Lab'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantity', hintText: '50'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: reorderCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Reorder Level', hintText: '10'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcademicColors.primary,
                    foregroundColor: AcademicColors.surface,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (nameCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        _items.insert(
                          0,
                          InventoryItem(
                            id: 'INV-${DateTime.now().millisecondsSinceEpoch % 1000}',
                            name: nameCtrl.text.trim(),
                            category: catCtrl.text.trim().isEmpty ? 'General Supplies' : catCtrl.text.trim(),
                            unit: 'Units',
                            quantityInStock: int.tryParse(qtyCtrl.text.trim()) ?? 10,
                            reorderLevel: int.tryParse(reorderCtrl.text.trim()) ?? 5,
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AcademicColors.primary,
                          content: Text('Item added to central supplies ledger.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Add to Catalog'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _adjustStock(InventoryItem item, int delta) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        final newQty = (_items[index].quantityInStock + delta).clamp(0, 9999);
        _items[index] = InventoryItem(
          id: item.id,
          name: item.name,
          category: item.category,
          unit: item.unit,
          quantityInStock: newQty,
          reorderLevel: item.reorderLevel,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lowStockItems = _items.where((i) => i.isLowStock).toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Inventory & Stock Desk',
        actions: [
          Center(child: PillBadge.info('2026-27')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AcademicColors.canvas,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AcademicColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AcademicColors.textSecondary,
                  labelStyle: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'All Catalog (${_items.length})'),
                    Tab(text: 'Low Stock (${lowStockItems.length})'),
                  ],
                ),
              ),
            ),

            // Search Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              color: AcademicColors.surface,
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search stock items or categories...',
                  hintStyle: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, size: 20, color: AcademicColors.textSecondary),
                  filled: true,
                  fillColor: AcademicColors.canvas,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: AcademicColors.border),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(_items),
                  _buildList(lowStockItems),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AcademicStickyActionBar(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcademicColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _showAddItemDialog,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: Text(
                    'Add Item',
                    style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AcademicColors.primaryDark,
                    side: const BorderSide(color: AcademicColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AcademicColors.primaryDark,
                        content: Text('Tap + / - on any item card to adjust counts.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tune, size: 18),
                  label: Text(
                    'Adjust Stock',
                    style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<InventoryItem> source) {
    final filtered = source.where((i) {
      return _searchQuery.isEmpty ||
          i.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No inventory items found',
          style: GoogleFonts.newsreader(fontSize: 16, color: AcademicColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InsetCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.isLowStock
                            ? AcademicColors.error.withValues(alpha: 0.12)
                            : AcademicColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.isLowStock ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                        color: item.isLowStock ? AcademicColors.error : AcademicColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.newsreader(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.category} • Reorder threshold: ${item.reorderLevel} ${item.unit}',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AcademicColors.border),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item.isLowStock)
                      PillBadge.danger('Low: ${item.quantityInStock} ${item.unit}')
                    else
                      PillBadge.success('${item.quantityInStock} ${item.unit}'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _adjustStock(item, -1),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AcademicColors.border),
                            ),
                            child: const Icon(Icons.remove, size: 16, color: AcademicColors.textPrimary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '${item.quantityInStock}',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _adjustStock(item, 1),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AcademicColors.primaryDark,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.add, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
