class Config {
  static const baseUrl = String.fromEnvironment(
    'baseUrl',
    defaultValue: 'https://artcorner.jordonlee.com',
  );
}