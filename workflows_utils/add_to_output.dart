import 'dart:io';

Future<void> setOutput(String item) async {
  Map<String, String> envVars = Platform.environment;

  // Write to GITHUB_ENV if available
  String? envPath = envVars["GITHUB_ENV"];
  if (envPath != null && envPath.isNotEmpty) {
    File ghEnv = File(envPath);
    String currentContent = await ghEnv.exists() ? await ghEnv.readAsString() : "";
    if (currentContent.isNotEmpty) {
      currentContent += "\n$item";
    } else {
      currentContent = item;
    }
    await ghEnv.writeAsString(currentContent);
  }

  // Write to GITHUB_OUTPUT if available
  String? outputPath = envVars["GITHUB_OUTPUT"];
  if (outputPath != null && outputPath.isNotEmpty) {
    File ghOutput = File(outputPath);
    String currentContent = await ghOutput.exists() ? await ghOutput.readAsString() : "";
    if (currentContent.isNotEmpty) {
      currentContent += "\n$item";
    } else {
      currentContent = item;
    }
    await ghOutput.writeAsString(currentContent);
  }
}
