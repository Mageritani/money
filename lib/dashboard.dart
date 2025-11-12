import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money/model/transaction_model.dart';
import 'package:money/model/transaction_provider.dart';
import 'package:money/settingPage.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _selectedDate = DateTime.now();

  static const Map<String, IconData> categoryIcons = {
    '餐飲': Icons.restaurant_outlined,
    '購物': Icons.shopping_bag_outlined,
    '交通': Icons.directions_bus_outlined,
    '娛樂': Icons.movie_outlined,
    '醫療': Icons.local_hospital_outlined,
    '教育': Icons.school_outlined,
    '加油': Icons.local_gas_station_outlined,
    '咖啡': Icons.local_cafe_outlined,
    '薪資': Icons.account_balance_wallet_outlined,
    '其他': Icons.more_horiz,
  };

  @override
  void initState() {
    super.initState();
    // 首次進入時載入資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat("#,##0", "zh_TW");
    return formatter.format(amount);
  }

  String _getTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return "${difference.inMinutes}分鐘前";
      }
      return "${DateFormat("HH:mm").format(dateTime)}";
    } else if (difference.inDays == 1) {
      return "昨天";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}天前";
    } else {
      return "${DateFormat("MM/dd").format(dateTime)}";
    }
  }

  Color _getCategoryColor(String category) {
    const colorMap = {
      '餐飲': Colors.red,
      '購物': Colors.orange,
      '交通': Colors.blue,
      '娛樂': Colors.purple,
      '醫療': Colors.green,
      '教育': Colors.cyan,
      '加油': Colors.brown,
      '咖啡': Colors.brown,
      '薪資': Colors.green,
      '其他': Colors.grey,
    };
    return colorMap[category] ?? Colors.grey;
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year, 1, 1),
      lastDate: DateTime(now.year, 12, 31),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  // 刪除交易的確認對話框
  Future<void> _confirmDelete(TransactionModel transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認刪除'),
        content: Text('確定要刪除這筆 ${transaction.category} 的交易嗎?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('刪除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<TransactionProvider>().deleteTransaction(
          transaction.id!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('交易已刪除'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('刪除失敗: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final weekday = ['一', '二', '三', '四', '五', '六', '日'][now.weekday - 1];

    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: provider.loadTransactions,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 頂部欄位
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/mm.png', width: 50, height: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Setting()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            backgroundImage: user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : null,
                            child: user?.photoURL == null
                                ? Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 日期區塊
                  Row(
                    children: [
                      Text(
                        DateFormat("yyyy/MM/dd").format(now),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "星期$weekday",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _selectDate,
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 30,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 總額卡片
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                Theme.of(
                                  context,
                                ).colorScheme.secondary.withOpacity(0.2),
                              ]
                            : [
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.2),
                                Theme.of(
                                  context,
                                ).colorScheme.secondary.withOpacity(0.3),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: isDark
                          ? Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "總資產",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\$",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${provider.total.toInt()}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildIncomeExpenseCard(
                                context,
                                Icons.arrow_upward_rounded,
                                "收入",
                                "${provider.totalIncome.toInt()}",
                                Colors.green,
                                isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildIncomeExpenseCard(
                                context,
                                Icons.arrow_downward_rounded,
                                "支出",
                                "${provider.totalExpense.toInt()}",
                                Colors.red,
                                isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 交易明細標題
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "最近交易",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // 查看全部
                        },
                        child: Text(
                          "查看全部",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 交易列表
                  if (provider.isLoading)
                    _buildLoadingState()
                  else if (provider.transactions.isEmpty)
                    _buildEmptyState()
                  else
                    ...provider.transactions.map((transaction) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: _buildTransactionItem(
                          context,
                          transaction,
                          isDark,
                        ),
                      );
                    }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            color: Theme.of(context).colorScheme.secondary,
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            "開始今天的紀錄吧!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "點擊下方 ＋ 開始",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseCard(
    BuildContext context,
    IconData icon,
    String label,
    String amount,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    TransactionModel transaction,
    bool isDark,
  ) {
    final isIncome = transaction.type == 'income';
    final amountColor = isIncome ? Colors.green : Colors.red;
    final categoryColor = _getCategoryColor(transaction.category);
    final icon = categoryIcons[transaction.category] ?? Icons.more_horiz;

    return Dismissible(
      key: Key(transaction.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        await _confirmDelete(transaction);
        return false; // 返回 false 避免自動刪除,我們手動處理
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.05), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.white.withOpacity(0.02)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 圖示
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: categoryColor, size: 24),
            ),
            const SizedBox(width: 12),
            // 類別和描述
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.desciption,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 金額和時間
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${isIncome ? '+' : '-'}${_formatAmount(transaction.amount)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTime(transaction.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
