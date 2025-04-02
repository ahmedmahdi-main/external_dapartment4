#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <windows.h>
#include <wia.h> // Windows Image Acquisition API
#include <iostream> // For logging

#include <memory>
#include <string>
#include "standard_method_codec.h"

class ScannerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ScannerPlugin();

  virtual ~ScannerPlugin();

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// Register the plugin
void ScannerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  std::cout << "Registering ScannerPlugin..." << std::endl; // Debug log // Ensure this matches the Dart channel name
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(), "scanner_plugin",
      &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<ScannerPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
  std::cout << "ScannerPlugin registered successfully!" << std::endl; // Debug log
}

ScannerPlugin::ScannerPlugin() {}

ScannerPlugin::~ScannerPlugin() {}

void ScannerPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("scanDocument") == 0) {
    // Implement scanning logic using WIA or TWAIN
    // Example: Use WIA to scan a document and save it as an image file
    // Return the file path of the scanned document
    std::string scanned_file_path = "C:\\path\\to\\scanned_image.jpg";
    result->Success(flutter::EncodableValue(scanned_file_path));
  } else {
    result->NotImplemented();
  }
}
