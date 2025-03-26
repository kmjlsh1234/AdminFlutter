class ServerConfig {
  static const baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:38084');
  static const fileServerUrl = String.fromEnvironment('FILE_SERVER_URL', defaultValue: 'http://localhost:38082');
  static const admin_file_server_key = String.fromEnvironment('ADMIN_FILE_SERVER_KEY', defaultValue: 'myadmin');
}