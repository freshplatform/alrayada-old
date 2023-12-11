abstract class UrlLauncher {
  Future<bool> canLaunchStringUrl(String url);
  Future<void> launchStringUrl(String url);
}
