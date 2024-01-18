import 'package:flutter/material.dart';
import 'package:infobip_voice/model/calls.dart';
import 'package:infobip_voice_showcase/core/model.dart';
import 'package:infobip_voice_showcase/ui/pages/active_call/active_call_page.dart';

class IncomingCallPage extends StatelessWidget {
  const IncomingCallPage({super.key, required this.incomingCall});

  final IncomingCall incomingCall;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incoming Call From ${incomingCall.source.displayIdentifier}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ActiveCallPage(CallType.incoming, incomingCall.destination.identifier, null),
                ));
                // Navigator.pop(context);
              },
              child: const Text('Accept'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                incomingCall.reject();
                Navigator.pop(context);
              },
              child: const Text('Decline'),
            ),
          ],
        ),
      ),
    );
  }
}
