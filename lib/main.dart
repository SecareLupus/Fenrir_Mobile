import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fenrir_mobile/blocs/auth_bloc.dart';
import 'package:fenrir_mobile/services/auth_service.dart';
import 'package:fenrir_mobile/blocs/dashboard_bloc.dart';
import 'package:fenrir_mobile/blocs/inventory_bloc.dart';
import 'package:fenrir_mobile/widgets/stats_card.dart';
import 'package:fenrir_mobile/models/search_result.dart';

void main() {
  final authService = AuthService();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authService)..add(AppStarted())),
        BlocProvider(create: (context) => DashboardBloc(authService)),
        BlocProvider(create: (context) => InventoryBloc(authService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fenrir Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFF0052CC), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052CC),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        } else if (state is AuthBiometricRequired) {
          return const BiometricLockScreen();
        } else if (state is AuthAuthenticated) {
          return const MainNavigationScreen();
        } else if (state is AuthFailure) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AuthBloc>().add(AppStarted()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: Text('Unknown State')));
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fenrir Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 80, color: Color(0xFF0052CC)),
            const SizedBox(height: 32),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Issuer URL',
                hintText: 'https://fenrir.example.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Client ID',
                hintText: 'fenrir-mobile',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LoginRequested("https://oidc.example.com", "fenrir-mobile"));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Login with OIDC', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class BiometricLockScreen extends StatelessWidget {
  const BiometricLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 100, color: Color(0xFF0052CC)),
            const SizedBox(height: 32),
            const Text(
              'Biometric Unlock Required',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Please authenticate to access Fenrir Admin'),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(BiometricAuthRequested());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Unlock Now'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const InventoryTab(),
    const Center(child: Text('Approvals (Phase 3)')),
    const Center(child: Text('Settings (Phase 4)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Fenrir NOC' : _currentIndex == 1 ? 'Host Inventory' : 'Fenrir Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'NOC'),
          NavigationDestination(icon: Icon(Icons.dns_outlined), selectedIcon: Icon(Icons.dns), label: 'Fleet'),
          NavigationDestination(icon: Icon(Icons.verified_user_outlined), selectedIcon: Icon(Icons.verified_user), label: 'Approvals'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(FetchDashboardMetrics());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          return RefreshIndicator(
            onRefresh: () async => context.read<DashboardBloc>().add(FetchDashboardMetrics()),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSecurityStatus(state.securityPosture),
                const SizedBox(height: 24),
                const Text('Fleet Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    StatsCard(
                      title: 'HEARTBEATS',
                      value: state.metrics.heartbeats.toString(),
                      icon: Icons.favorite,
                      color: Colors.redAccent,
                    ),
                    StatsCard(
                      title: 'ACTIVE SSH',
                      value: state.metrics.activeSsh.toString(),
                      icon: Icons.terminal,
                      color: Colors.greenAccent,
                    ),
                    StatsCard(
                      title: 'LOAD (1M)',
                      value: state.metrics.load1.toStringAsFixed(2),
                      icon: Icons.speed,
                      color: Colors.orangeAccent,
                    ),
                    StatsCard(
                      title: 'LOAD (15M)',
                      value: state.metrics.load15.toStringAsFixed(2),
                      icon: Icons.timeline,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is DashboardError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Initializing Dashboard...'));
      },
    );
  }

  Widget _buildSecurityStatus(Map<String, dynamic> posture) {
    final status = posture['status'] ?? 'unknown';
    final color = status == 'healthy' ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Security Posture: ${status.toUpperCase()}',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'KRL Last Updated: ${posture['last_krl_update']?.split('T')[0] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color),
        ],
      ),
    );
  }
}

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(SearchInventory(""));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchBar(
            controller: _searchController,
            hintText: 'Search hosts, users...',
            onChanged: (value) => context.read<InventoryBloc>().add(SearchInventory(value)),
            leading: const Icon(Icons.search),
            trailing: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<InventoryBloc>().add(SearchInventory(""));
                  },
                )
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<InventoryBloc, InventoryState>(
            builder: (context, state) {
              if (state is InventoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is InventoryLoaded) {
                if (state.results.isEmpty) {
                  return const Center(child: Text('No results found'));
                }
                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    final item = state.results[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.type == 'host' ? Colors.blueGrey : Colors.deepPurple,
                        child: Icon(item.type == 'host' ? Icons.dns : Icons.person, size: 20, color: Colors.white),
                      ),
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item.info),
                      trailing: const Icon(Icons.chevron_right, size: 16),
                      onTap: () {
                        // Phase 4: Host Detail View
                      },
                    );
                  },
                );
              } else if (state is InventoryError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

