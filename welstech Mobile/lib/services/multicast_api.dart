import 'dart:io';
import 'package:multicast_dns/multicast_dns.dart';

class EspSync {
  final String serviceType = '_espdata._tcp.local';

  Future<String> fetchHelloWorld() async {
    final MDnsClient client = MDnsClient();
    await client.start();

    try {
      // Look for mDNS PTR records that match the service type
      await for (final ptr in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(serviceType),
      )) {
        // Look for service records for the PTR record
        await for (final srv in client.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName),
        )) {
          // Look for IP address records for the resolved service
          await for (final ip in client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(srv.target),
          )) {
            print("Resolved IP: ${ip.address}"); // Debugging
            // Now connect to the ESP32 using the resolved IP and port
            final socket = await Socket.connect(ip.address, srv.port, timeout: Duration(seconds: 3));
            final data = await socket.first; // Read the first chunk of data
            socket.destroy(); // Clean up the connection

            return String.fromCharCodes(data).trim(); // Return the "Hello World" message
          }
        }
      }
    } catch (e) {
      print("❌ mDNS fetch failed: $e");
      return "no data";
    } finally {
      client.stop();
    }

    return "no data";
  }
}

