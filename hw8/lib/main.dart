import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'data/mock_data.dart';
import 'models/bottom_nav_item.dart';
import 'models/course_model.dart';
import 'models/subject_model.dart';
import 'models/user_profile_model.dart';

void main() {
  runApp(const MyApp());
}

bool _isWidgetTest() {
  final WidgetsBinding binding = WidgetsBinding.instance;
  return binding.runtimeType.toString().contains('TestWidgetsFlutterBinding');
}

bool _isNetworkImage(String value) {
  return value.startsWith('http://') || value.startsWith('https://');
}

String _normalizeImageUrl(String rawUrl) {
  final Uri? uri = Uri.tryParse(rawUrl);
  if (uri == null) {
    return rawUrl;
  }

  final String? innerImageUrl = uri.queryParameters['imgurl'];
  final bool isGooglePreview = uri.host.contains('google.');

  if (isGooglePreview && innerImageUrl != null && innerImageUrl.isNotEmpty) {
    return Uri.decodeComponent(innerImageUrl);
  }

  return rawUrl;
}

Uint8List? _decodeDataImage(String value) {
  if (!value.startsWith('data:image')) {
    return null;
  }

  final int commaIndex = value.indexOf(',');
  if (commaIndex == -1) {
    return null;
  }

  final String base64Part = value.substring(commaIndex + 1);
  try {
    return base64Decode(base64Part);
  } catch (_) {
    return null;
  }
}

Widget _buildCourseImage(String imagePath) {
  final Uint8List? bytes = _decodeDataImage(imagePath);
  if (bytes != null) {
    return Image.memory(
      bytes,
      height: 40,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 34);
      },
    );
  }

  if (_isNetworkImage(imagePath)) {
    if (_isWidgetTest()) {
      return const Icon(Icons.image, size: 34);
    }

    return Image.network(
      _normalizeImageUrl(imagePath),
      height: 40,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 34);
      },
    );
  }

  return Image.asset(
    imagePath,
    height: 40,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.broken_image, size: 34);
    },
  );
}

ImageProvider<Object>? _buildAvatarProvider(String imagePath) {
  final Uint8List? bytes = _decodeDataImage(imagePath);
  if (bytes != null) {
    return MemoryImage(bytes);
  }

  if (_isNetworkImage(imagePath)) {
    if (_isWidgetTest()) {
      return null;
    }

    return NetworkImage(_normalizeImageUrl(imagePath));
  }

  if (imagePath.isEmpty) {
    return null;
  }

  return AssetImage(imagePath);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _setTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ДЗ 6',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      home: HomePage(
        isDark: _themeMode == ThemeMode.dark,
        onThemeChanged: _setTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;

  late final List<BottomNavItem> navItems;

  @override
  void initState() {
    super.initState();

    navItems = const [
      BottomNavItem(
        title: 'Список с поиском',
        icon: Icons.list,
        page: ListScreen(),
      ),
      BottomNavItem(
        title: 'Сетка элементов',
        icon: Icons.grid_view,
        page: GridScreen(),
      ),
      BottomNavItem(
        title: 'Профиль пользователя',
        icon: Icons.person,
        page: ProfileScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(navItems[selectedTab].title),
        centerTitle: true,
        actions: [
          Switch(
            value: widget.isDark,
            onChanged: (v) {
              widget.onThemeChanged(v);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: selectedTab,
        children: navItems.map((e) => e.buildPage()).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: navItems
            .map(
              (e) => BottomNavigationBarItem(
                icon: Icon(e.icon),
                label: e.title,
              ),
            )
            .toList(),
      ),
    );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final List<SubjectModel> filteredList = AppData.subjects.where((subject) {
      return subject.title.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Введите предмет',
              labelText: 'Поиск',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
          ),
        ),
        Expanded(
          child: filteredList.isEmpty
              ? const Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 36,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.blue.shade50,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Icon(Icons.book, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                filteredList[index].title,
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CourseModel> courses = AppData.courses;

    return LayoutBuilder(
      builder: (context, constraints) {
        const int columns = 2;
        const double spacing = 8;
        final int rows = (courses.length / columns).ceil();

        final double tileWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;
        final double tileHeight =
            (constraints.maxHeight - (spacing * (rows - 1))) / rows;
        final double ratio = tileHeight > 0 ? tileWidth / tileHeight : 1;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: courses.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: ratio,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCourseImage(courses[index].imagePath),
                  const SizedBox(height: 4),
                  Text(
                    courses[index].title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileModel user = AppData.profile;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: Colors.grey.shade200,
            foregroundImage: _buildAvatarProvider(user.avatarPath),
            child: const Icon(Icons.person, size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 18),
          Text(
            user.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Город: ${user.locationLabel}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            'Год рождения: ${user.birthYear}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
