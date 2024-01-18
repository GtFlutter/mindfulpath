class DatabaseConsts {
  static const String categoryTable = 'CategoryTable';
  static const String videoTable = 'VideoTable';


  static final initialScript = [

    '''CREATE TABLE $categoryTable (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "category_id" TEXT,
      "category_name" TEXT,
      "category_image" TEXT
    );''',

    '''CREATE TABLE $videoTable (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "video_id" TEXT,
      "video_name" TEXT,
      "video_file" TEXT,
      "video_duration" TEXT,
      "category_id" TEXT
    );'''
  ];
}