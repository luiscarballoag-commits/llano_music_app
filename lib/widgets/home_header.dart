import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/discovery.dart';
import 'package:flutter_chrome_cast/entities.dart';
import 'package:flutter_chrome_cast/session.dart';

import '../screens/novedades_screen.dart';
import '../services/novedades_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  Future<void> _mostrarDispositivosCast(BuildContext context) async {
    GoogleCastDiscoveryManager.instance.startDiscovery();

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StreamBuilder<List<GoogleCastDevice>>(
          stream: GoogleCastDiscoveryManager.instance.devicesStream,
          builder: (context, snapshot) {
            final devices = snapshot.data ?? [];

            if (devices.isEmpty) {
              return const SafeArea(
                child: SizedBox(
                  height: 180,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cast, size: 40),
                        SizedBox(height: 12),
                        Text(
                          'Buscando dispositivos...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const ListTile(
                    leading: Icon(Icons.cast),
                    title: Text('Transmitir a'),
                  ),
                  ...devices.map(
                    (device) => ListTile(
                      leading: const Icon(Icons.tv),
                      title: Text(device.friendlyName),
                      subtitle: Text(device.modelName ?? 'Google Cast'),
                      onTap: () async {
                        Navigator.pop(context);

                        try {
                          await GoogleCastSessionManager.instance
                              .startSessionWithDevice(device);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Conectado a ${device.friendlyName}',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No se pudo conectar al dispositivo',
                                ),
                              ),
                            );
                          }
                        }
                      },
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

  @override
  Widget build(BuildContext context) {
    final cantidad =
        NovedadesService.instance.cantidadNoLeidas;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0B5D3B),
            Color(0xFF2E8B57),
            Color(0xFF66BB6A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 38),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Text(
                "LLANO MUSIC",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Producciones Lcarballog",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
                Text(
                  "El sonido auténtico del llano venezolano",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Transmitir',
                  onPressed: () => _mostrarDispositivosCast(context),
                  icon: const Icon(
                    Icons.cast,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const NovedadesScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                    if (cantidad > 0)
                      Positioned(
                        right: 4,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            cantidad > 99
                                ? '99+'
                                : cantidad.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
