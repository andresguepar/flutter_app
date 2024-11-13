import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:math' as math;

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  // Definición de colores
  static const Color primaryColor = Color(0xFFA0522D);
  static const Color secondaryColor = Color(0xFF2E8B57);
  static const Color accentColor = Color(0xFFD4A368);
  static const Color errorColor = Color(0xFFCD5C5C);
  static const Color lightColor = Color(0xFFE6D5AC);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoverT-App',
      theme: ThemeData(
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: lightColor, // Color de fondo de las tarjetas
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: secondaryColor,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: secondaryColor),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

// Resto del código anterior se mantiene igual hasta HomePage

Widget buildPageHeader(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium,
    ),
  );
}

class DashboardPage extends StatelessWidget {

  static const Color primaryColor = Color(0xFFA0522D);
  static const Color secondaryColor = Color(0xFF2E8B57);
  static const Color accentColor = Color(0xFFD4A368);
  static const Color errorColor = Color(0xFFCD5C5C);
  static const Color lightColor = Color(0xFFE6D5AC);

  final Map<String, double> sensorData;

  DashboardPage({required this.sensorData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildPageHeader(context, 'Dashboard'),
          AspectRatio(
            aspectRatio: 1.5,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: RadarChart(
                sensorData: sensorData,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atajos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ShortcutCard(
                      icon: Icons.note_add,
                      title: 'Registro',
                      color: lightColor,
                      onTap: () {},
                    ),
                    ShortcutCard(
                      icon: Icons.devices,
                      title: 'Dispositivo',
                      color: lightColor,
                      onTap: () {},
                    ),
                    ShortcutCard(
                      icon: Icons.book,
                      title: 'Manual',
                      color: lightColor,
                      onTap: () {},
                    ),
                    ShortcutCard(
                      icon: Icons.help,
                      title: 'Soporte',
                      color: lightColor,
                      onTap: () {},
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

class DetailsPage extends StatelessWidget {

  static const Color primaryColor = Color(0xFFA0522D);
  static const Color secondaryColor = Color(0xFF2E8B57);
  static const Color accentColor = Color(0xFFD4A368);
  static const Color errorColor = Color(0xFFCD5C5C);
  static const Color lightColor = Color(0xFFE6D5AC);

  final Map<String, double> sensorData;

  DetailsPage({required this.sensorData});

  @override 
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildPageHeader(context, 'Detalles de Sensores'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (var entry in sensorData.entries)
                Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: entry.value / 100,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _formatSensorValue(entry.key, entry.value),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatSensorValue(String sensor, double value) {
    switch (sensor) {
      case 'Temperature':
        return '${value.toStringAsFixed(1)} °C';
      case 'Humidity':
      case 'Soil Humidity':
        return '${value.toStringAsFixed(0)}%';
      case 'Light':
        return '${value.toStringAsFixed(0)} lux';
      case 'Pressure':
        return '${value.toStringAsFixed(2)} kPa';
      default:
        return value.toString();
    }
  }
}

class ControlsPage extends StatelessWidget {
  final bool isConnected;
  final bool isScreenOn;
  final bool isSensorOn;
  final int moveSpeed;
  final int turnSpeed;
  final Function(bool) toggleScreen;
  final Function(bool) toggleSensor;
  final Function(int) updateMoveSpeed;
  final Function(int) updateTurnSpeed;

  ControlsPage({
    required this.isConnected,
    required this.isScreenOn,
    required this.isSensorOn,
    required this.moveSpeed,
    required this.turnSpeed,
    required this.toggleScreen,
    required this.toggleSensor,
    required this.updateMoveSpeed,
    required this.updateTurnSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildPageHeader(context, 'Controles'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuración',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SwitchListTile(
                        title: Text('Pantalla'),
                        subtitle: Text(isScreenOn ? 'Encendida' : 'Apagada'),
                        value: isScreenOn,
                        onChanged: isConnected ? toggleScreen : null,
                      ),
                      SwitchListTile(
                        title: Text('Sensor'),
                        subtitle: Text(isSensorOn ? 'Activo' : 'Inactivo'),
                        value: isSensorOn,
                        onChanged: isConnected ? toggleSensor : null,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Control de Movimiento',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16),
                      Text('Velocidad de Avance: ${moveSpeed.round()}'),
                      Slider(
                        value: moveSpeed.toDouble(),
                        min: -255,
                        max: 255,
                        divisions: 510,
                        label: moveSpeed.round().toString(),
                        onChanged: isConnected 
                          ? (value) => updateMoveSpeed(value.round())
                          : null,
                      ),
                      SizedBox(height: 16),
                      Text('Velocidad de Giro: ${turnSpeed.round()}'),
                      Slider(
                        value: turnSpeed.toDouble(),
                        min: -255,
                        max: 255,
                        divisions: 510,
                        label: turnSpeed.round().toString(),
                        onChanged: isConnected
                          ? (value) => updateTurnSpeed(value.round())
                          : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildPageHeader(context, 'Ajustes'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Acerca de'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text('Buscar actualizaciones'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Ayuda'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RadarChart extends StatelessWidget {
  final Map<String, double> sensorData;

  RadarChart({required this.sensorData});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadarChartPainter(sensorData),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final Map<String, double> sensorData;

  RadarChartPainter(this.sensorData);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    drawBackground(canvas, center, radius);
    drawData(canvas, center, radius);
    drawLabels(canvas, center, radius);
  }

  void drawBackground(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 5; i++) {
      final path = Path();
      final currentRadius = radius * i / 5;

      for (int j = 0; j < 5; j++) {
        final angle = j * 2 * math.pi / 5 - math.pi / 2;
        final point = Offset(
          center.dx + currentRadius * math.cos(angle),
          center.dy + currentRadius * math.sin(angle),
        );

        if (j == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }

      path.close();
      canvas.drawPath(path, paint);
    }
  }

  void drawData(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path();
    final values = [
      sensorData['Temperature'] ?? 0,
      sensorData['Pressure'] ?? 0,
      sensorData['Humidity'] ?? 0,
      sensorData['Soil Humidity'] ?? 0,
      sensorData['Light'] ?? 0,
    ];

    for (int i = 0; i < 5; i++) {
      final value = values[i].clamp(0, 100) / 100;
      final angle = i * 2 * math.pi / 5 - math.pi / 2;
      final point = Offset(
        center.dx + radius * value * math.cos(angle),
        center.dy + radius * value * math.sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void drawLabels(Canvas canvas, Offset center, double radius) {
    final labels = [
      'Temperatura',
      'Presión\nAtmosférica',
      'Humedad\nen el Aire',
      'Humedad\nen el Suelo',
      'Luminosidad',
    ];

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * math.pi / 5 - math.pi / 2;
      final point = Offset(
        center.dx + (radius + 30) * math.cos(angle),
        center.dy + (radius + 30) * math.sin(angle),
      );

      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12,
        ),
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          point.dx - textPainter.width / 2,
          point.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
 
}

class ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  ShortcutCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BluetoothDevice? device;
  Map<String, BluetoothCharacteristic> characteristics = {};
  Map<String, double> sensorData = {
    'Temperature': 0,
    'Humidity': 0,
    'Light': 0,
    'Pressure': 0,
    'Soil Humidity': 0,
  };
  bool isScreenOn = false;
  bool isSensorOn = false;
  int moveSpeed = 0;
  int turnSpeed = 0;
  bool isScanning = false;
  bool isConnected = false;
  Timer? reconnectTimer;
  int _selectedIndex = 0;

  // Constantes para UUIDs
  final Map<String, String> CHARACTERISTIC_UUIDS = {
    'Light': '00002BE2-0000-1000-8000-00805F9B34FB',
    'Temperature': '00002A6E-0000-1000-8000-00805F9B34FB',
    'Humidity': '00002A6F-0000-1000-8000-00805F9B34FB',
    'Soil Humidity': '00002AB2-0000-1000-8000-00805F9B34FB',
    'Pressure': '00002AA3-0000-1000-8000-00805F9B34FB',
    'Screen': '0000FCB3-0000-1000-8000-00805F9B34FB',
    'Sensor': '00002A5D-0000-1000-8000-00805F9B34FB',
    'Move': '000005E6-0000-1000-8000-00805F9B34FB',
    'Turn': '00000C93-0000-1000-8000-00805F9B34FB',
  };

  @override
  void initState() {
    super.initState();
    print('Iniciando aplicación...');
    initBleConnection();
  }

  @override
  void dispose() {
    disconnectDevice();
    reconnectTimer?.cancel();
    super.dispose();
  }

  Future<void> initBleConnection() async {
    try {
      print('Inicializando conexión BLE...');
      await requestPermissions();

      if (await FlutterBluePlus.isSupported == false) {
        print('Bluetooth no disponible');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Bluetooth no está disponible en este dispositivo'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      }

      await FlutterBluePlus.turnOn();
      scanAndConnect();
    } catch (e, stackTrace) {
      print('Error en initBleConnection: $e');
      print('StackTrace: $stackTrace');
    }
  }

  Future<void> requestPermissions() async {
    print('Solicitando permisos...');
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      bool allGranted = statuses.values.every((status) => status.isGranted);

      if (!allGranted) {
        print('No se otorgaron todos los permisos necesarios');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permisos necesarios'),
            content: Text('La aplicación necesita todos los permisos solicitados para funcionar correctamente.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      } else {
        print('Todos los permisos otorgados');
      }
    } catch (e, stackTrace) {
      print('Error al solicitar permisos: $e');
      print('StackTrace: $stackTrace');
    }
  }

  void scanAndConnect 
() async {
    print('Iniciando escaneo de dispositivos...');
    setState(() {
      isScanning = true;
    });

    try {
      await FlutterBluePlus.stopScan();

      FlutterBluePlus.scanResults.listen(
        (results) {
          for (ScanResult r in results) {
            print('Dispositivo encontrado: ${r.device.name} (${r.device.id})');
            if (r.device.name == 'MKR WiFi 1010') {
              print('Dispositivo Arduino encontrado');
              stopScan();
              connect(r.device);
              break;
            }
          }
        },
        onError: (error) {
          print('Error en scanResults.listen: $error');
        },
      );

      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 10),
        androidUsesFineLocation: true,
      );
    } catch (e, stackTrace) {
      print('Error al escanear dispositivos: $e');
      print('StackTrace: $stackTrace');
    } finally {
      setState(() {
        isScanning = false;
      });
    }
  }

  void stopScan() {
    print('Deteniendo escaneo...');
    try {
      FlutterBluePlus.stopScan();
    } catch (e, stackTrace) {
      print('Error al detener el escaneo: $e');
      print('StackTrace: $stackTrace');
    }
  }

  void connect(BluetoothDevice d) async {
    print('Conectando a dispositivo: ${d.name}');
    try {
      device = d;

      device!.state.listen((state) {
        print('Estado de conexión cambiado a: $state');
        setState(() {
          isConnected = state == BluetoothConnectionState.connected;

          if (!isConnected) {
            characteristics.clear();
            sensorData.forEach((key, value) {
              sensorData[key] = 0;
            });
            isScreenOn = false;
            isSensorOn = false;
            moveSpeed = 0;
            turnSpeed = 0;
          }
        });

        if (state == BluetoothConnectionState.disconnected) {
          print('Dispositivo desconectado');
          handleDisconnection();
        }
      });

      await device!.connect(
        timeout: Duration(seconds: 10),
        autoConnect: false,
      );

      print('Conectado exitosamente');
      discoverServices();
    } catch (e, stackTrace) {
      print('Error al conectar con el dispositivo: $e');
      print('StackTrace: $stackTrace');
      handleDisconnection();
    }
  }

  void handleDisconnection() {
    print('Manejando desconexión...');
    setState(() {
      isConnected = false;
      characteristics.clear();
    });

    reconnectTimer?.cancel();
    reconnectTimer = Timer(Duration(seconds: 3), () {
      if (device != null && !isConnected) {
        print('Intentando reconexión...');
        connect(device!);
      }
    });
  }

  void disconnectDevice() async {
    print('Desconectando dispositivo...');
    try {
      if (device != null) {
        await device!.disconnect();
      }
    } catch (e, stackTrace) {
      print('Error al desconectar: $e');
      print('StackTrace: $stackTrace');
    }
  }

  void discoverServices() async {
    print('Descubriendo servicios...');
    try {
      List<BluetoothService> services = await device!.discoverServices();
      print('Servicios encontrados: ${services.length}');

      for (BluetoothService service in services) {
        print('Analizando servicio: ${service.uuid}');

        for (BluetoothCharacteristic characteristic in service.characteristics) {
          String uuid = characteristic.uuid.toString().toUpperCase();
          print('Característica encontrada: $uuid');

          CHARACTERISTIC_UUIDS.forEach((key, value) {
            if (uuid.contains(value.substring(4, 8))) {
              print('Característica "$key" identificada');
              characteristics[key] = characteristic;
            }
          });
        }
      }

      print('Características encontradas: ${characteristics.length}');
      print('Características: ${characteristics.keys.join(', ')}');

      if (characteristics.isNotEmpty) {
        startNotifications();
      } else {
        print('No se encontraron características');
      }
    } catch (e, stackTrace) {
      print('Error al descubrir servicios: $e');
      print('StackTrace: $stackTrace');
    }
  }

  void startNotifications() {
    print('Iniciando notificaciones...');
    try {
      characteristics.forEach((key, characteristic) {
        if (['Temperature', 'Humidity', 'Light', 'Pressure', 'Soil Humidity'].contains(key)) {
          print('Configurando notificaciones para $key');

          if (characteristic.properties.notify ) {
            characteristic.setNotifyValue(true).then((_) {
              characteristic.value.listen(
                (value) {
                  print('Valor recibido para $key: $value');
                  if (value.isNotEmpty) {
                    setState(() {
                      try {
                        if (key == 'Pressure') {
                          double pressureValue = value[0].toDouble();
                          print('Presión procesada: $pressureValue kPa');
                          sensorData[key] = pressureValue;
                        } else {
                          sensorData[key] = value[0].toDouble();
                        }
                      } catch (e) {
                        print('Error procesando el valor de $key: $e');
                        print(value);
                      }
                    });
                  }
                },
                onError: (error) {
                  print('Error en la notificación de $key: $error');
                },
              );
            });
          }
        }
      });
    } catch (e) {
      print('Error al iniciar notificaciones: $e');
    }
  }

  void toggleScreen(bool value) {
    print('Cambiando estado de pantalla a: $value');
    try {
      setState(() {
        isScreenOn = value;
      });
      if (characteristics['Screen'] != null) {
        characteristics['Screen']!.write([value ? 1 : 0]);
      } else {
        print('Característica Screen no encontrada');
      }
    } catch (e, stackTrace) {
      print('Error al cambiar el estado de la pantalla: $e');
      print('StackTrace: $stackTrace');
    }
  }

  void toggleSensor(bool value) {
    print('Cambiando estado del sensor a: $value');
    try {
      setState(() {
        isSensorOn = value;
      });
      if (characteristics['Sensor'] != null) {
        characteristics['Sensor']!.write([value ? 1 : 0]);
      } else {
        print('Característica Sensor no encontrada');
      }
    } catch (e, stackTrace) {
      print('Error al cambiar el estado del sensor: $e');
      print('StackTrace: $stackTrace');
    }
  }

  void updateMoveSpeed(int speed) {
    print('Actualizando velocidad de movimiento a: $speed');
    try {
      setState(() {
        moveSpeed = speed;
      });
      if (characteristics['Move'] != null) {
        var bytes = [speed & 0xFF];
        characteristics['Move']!.write(bytes);
      } else {
        print('Característica Move no encontrada');
      }
    } catch (e, stackTrace) {
      print('Error al actualizar la velocidad de movimiento: $e');
      print('StackTrace: $stackTrace');
    }
  }

  void updateTurnSpeed(int speed) {
    print('Actualizando velocidad de giro a: $speed');
    try {
      setState(() {
        turnSpeed = speed;
      });
      if (characteristics['Turn'] != null) {
        var bytes = [speed & 0xFF];
        characteristics['Turn']!.write(bytes);
      } else {
        print('Característica Turn no encontrada');
      }
    } catch (e, stackTrace) {
      print('Error al actualizar la velocidad de giro: $e');
      print('StackTrace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RoverT-App'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardPage(sensorData: sensorData),
          DetailsPage(sensorData: sensorData),
          ControlsPage(
            isConnected: isConnected,
            isScreenOn: isScreenOn,
            isSensorOn: isSensorOn,
            moveSpeed: moveSpeed,
            turnSpeed: turnSpeed,
            toggleScreen: toggleScreen,
            toggleSensor: toggleSensor,
            updateMoveSpeed: updateMoveSpeed,
            updateTurnSpeed: updateTurnSpeed,
          ),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Detalles'),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Controles'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}