class ApiConstants {
  static const String baseUrl = 'https://stackfood-admin.6amtech.com';
  static const String config = '/api/v1/config';

  static String restaurants(int offset, int limit) =>
      '/api/v1/restaurants/get-restaurants/all?offset=$offset&limit=$limit';

  static Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'zoneId': '[1]',
    'latitude': '23.735129',
    'longitude': '90.425614',
  };

  static const String cacheBanners = 'banners';

}
