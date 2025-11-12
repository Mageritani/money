import 'package:flutter/material.dart';
import 'package:money/database/databaseHelper.dart';
import 'package:money/model/transaction_model.dart';
import 'package:money/model/transaction_provider.dart';
import 'package:provider/provider.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final db = Databasehelper.instance;

  String _displayAmount = '0';
  String _selectType = "expense";
  String _selectCategory = "餐飲";
  String _selectIcon = 'restaurant';
  String _selectColor = '#F44336';
  DateTime _dateTime = DateTime.now();
  bool _isSaving = false;
  bool _hasDecimal = false;

  // 動畫控制器
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const Map<String, Map<String, dynamic>> _categories = {
    '餐飲': {'icon': Icons.restaurant_outlined, 'color': '#F44336'},
    '購物': {'icon': Icons.shopping_bag_outlined, 'color': '#FF9800'},
    '交通': {'icon': Icons.directions_bus_outlined, 'color': '#2196F3'},
    '娛樂': {'icon': Icons.movie_outlined, 'color': '#9C27B0'},
    '醫療': {'icon': Icons.local_hospital_outlined, 'color': '#4CAF50'},
    '教育': {'icon': Icons.school_outlined, 'color': '#00BCD4'},
    '加油': {'icon': Icons.local_gas_station_outlined, 'color': '#795548'},
    '咖啡': {'icon': Icons.local_cafe_outlined, 'color': '#8D6E63'},
    '薪資': {'icon': Icons.account_balance_wallet_outlined, 'color': '#4CAF50'},
    '其他': {'icon': Icons.more_horiz, 'color': '#9E9E9E'},
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    setState(() {
      if (_displayAmount == '0') {
        _displayAmount = number;
      } else {
        // 限制小數點後兩位
        if (_hasDecimal) {
          final parts = _displayAmount.split('.');
          if (parts.length > 1 && parts[1].length >= 2) {
            return;
          }
        }
        _displayAmount += number;
      }
    });
  }

  void _onDecimalPressed() {
    if (!_hasDecimal) {
      setState(() {
        _displayAmount += '.';
        _hasDecimal = true;
      });
    }
  }

  void _onDeletePressed() {
    setState(() {
      if (_displayAmount.length > 1) {
        if (_displayAmount.endsWith('.')) {
          _hasDecimal = false;
        }
        _displayAmount = _displayAmount.substring(0, _displayAmount.length - 1);
      } else {
        _displayAmount = '0';
        _hasDecimal = false;
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _displayAmount = '0';
      _hasDecimal = false;
    });
  }

  Future<void> _saveTransaction() async {
    if (_displayAmount == '0' || _displayAmount.isEmpty) {
      _showErrorSnackBar('請輸入金額');
      return;
    }

    if (_displayAmount.endsWith('.')) {
      _displayAmount = _displayAmount.substring(0, _displayAmount.length - 1);
    }

    setState(() => _isSaving = true);

    try {
      final amount = double.parse(_displayAmount);

      if (amount <= 0) {
        _showErrorSnackBar('金額必須大於 0');
        setState(() => _isSaving = false);
        return;
      }

      final transaction = TransactionModel(
        type: _selectType,
        amount: amount,
        category: _selectCategory,
        desciption: _descriptionController.text,
        date: _dateTime,
        iconName: _selectIcon,
        iconHax: _selectColor,
      );

      // 🌟 使用 Provider 新增交易
      await context.read<TransactionProvider>().addTransaction(transaction);

      if (mounted) {
        await _scaleController.reverse();
        await _scaleController.forward();

        _showSuccessSnackBar();
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('交易已成功儲存！'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('錯誤: $error')),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _resetForm() {
    _descriptionController.clear();
    setState(() {
      _displayAmount = '0';
      _hasDecimal = false;
      _dateTime = DateTime.now();
      _selectCategory = '餐飲';
      _selectIcon = 'restaurant';
      _selectColor = '#F44336';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final high = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 20),
                // Stack 佈局：上層計算機，下層收入支出和類別
                Expanded(
                  child: Stack(
                    children: [
                      // 下層：收入支出和類別選擇
                      Column(
                        children: [
                          _buildTypeSelector(isDark),
                          const SizedBox(height: 12),
                          _buildCategoryGrid(isDark),
                        ],
                      ),
                      // 上層：金額顯示 + 描述欄 + 計算機
                      Column(
                        children: [
                          SizedBox(height: high * 0.25),
                          Row(
                            children: [
                              Expanded(flex: 2, child: _buildDisplay(isDark)),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 3,
                                child: _buildDescriptionField(isDark),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(child: _buildCalculator(isDark)),
                          SizedBox(height: 70),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        "新增交易",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTypeSelector(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _buildTypeButton(
              type: "expense",
              label: "支出",
              color: Colors.red.shade400,
              isDark: isDark,
            ),
            _buildTypeButton(
              type: "income",
              label: "收入",
              color: Colors.green.shade400,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String type,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    final isSelected = _selectType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isDark) {
    return SizedBox(
      height: 100,
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: _categories.entries.map((entry) {
          final index = _categories.keys.toList().indexOf(entry.key);
          return _buildCategoryChip(entry, index, isDark);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChip(
    MapEntry<String, Map<String, dynamic>> entry,
    int index,
    bool isDark,
  ) {
    final isSelected = _selectCategory == entry.key;
    final color = Color(
      int.parse(entry.value['color'].replaceFirst('#', '0xFF')),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 50)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectCategory = entry.key;
              _selectColor = entry.value['color'];
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color
                  : isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              entry.key,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: TextFormField(
        controller: _descriptionController,
        maxLength: 100,
        decoration: InputDecoration(
          labelText: '描述（選填）',
          hintText: '例如：午餐、購物、薪水等...',
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _selectType == 'income' ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '\$ $_displayAmount',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: _selectType == 'income' ? Colors.green : Colors.red,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCalculator(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildCalcButton('7', isDark),
                  _buildCalcButton('8', isDark),
                  _buildCalcButton('9', isDark),
                  _buildCalcButton('C', isDark, isSpecial: true),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildCalcButton('4', isDark),
                  _buildCalcButton('5', isDark),
                  _buildCalcButton('6', isDark),
                  _buildCalcButton('⌫', isDark, isSpecial: true),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildCalcButton('1', isDark),
                  _buildCalcButton('2', isDark),
                  _buildCalcButton('3', isDark),
                  _buildCalcButton('.', isDark, isSpecial: true),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildCalcButton('0', isDark),
                  _buildCalcButton('00', isDark),
                  // 儲存按鈕（打勾圖示）
                  _buildSaveButton(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalcButton(String label, bool isDark, {bool isSpecial = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (label == 'C') {
                _onClearPressed();
              } else if (label == '⌫') {
                _onDeletePressed();
              } else if (label == '.') {
                _onDecimalPressed();
              } else {
                _onNumberPressed(label);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: BoxDecoration(
                color: isSpecial
                    ? (_selectType == 'income' ? Colors.green : Colors.red)
                          .withOpacity(isDark ? 0.2 : 0.15)
                    : isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: label == '⌫' ? 28 : 24,
                    fontWeight: FontWeight.w600,
                    color: isSpecial
                        ? (_selectType == 'income' ? Colors.green : Colors.red)
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isSaving ? null : _saveTransaction,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _selectType == 'income'
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : [Colors.red.shade400, Colors.red.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (_selectType == 'income' ? Colors.green : Colors.red)
                        .withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.check, color: Colors.white, size: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
