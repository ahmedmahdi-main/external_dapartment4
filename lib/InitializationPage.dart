import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Data/InitDatabase.dart';
import 'Pages/Screens/Main/MainPage.dart';
import 'Services/Config/GetStoragePermission.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({super.key});

  @override
  _InitializationPageState createState() {
    return _InitializationPageState();
  }
}

class _InitializationPageState extends State<InitializationPage> {
  bool _isInitializing = true;
  bool _initializationError = false;

  @override
  void initState() {
    super.initState();
    // Defer the initialization process to the next frame to ensure widget stability.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize the database
      await InitDatabase.initDatabase();

      // Get storage permission
      // await getStoragePermission();

      await WindowsStorage.createCustomDirectory('External-Locations');
      // Create necessary folder
      // await createFolderAtRoot('External-Locations');

      // Set initialization to complete state
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _initializationError = false;
        });

        // Perform navigation after the frame completes to ensure stability
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Get.off(() => MainPage());
          }
        });
      }
    } catch (e) {
      // Catch initialization error and set the state to display the error message
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _initializationError = true;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Get.snackbar(
              'Initialization Failed',
              'An error occurred during initialization: $e',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _isInitializing
                ? CircularProgressIndicator() // Show loading during initialization
                : _initializationError
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Initialization failed. Please restart the app.',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _retryInitialization(); // Add a retry button for users
                      },
                      child: Text('Retry'),
                    ),
                  ],
                )
                : Container(), // Empty container during stable transition
      ),
    );
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _initializationError = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }
}
