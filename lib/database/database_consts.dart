class DatabaseConsts {
  static const String categoryTable = 'CategoryTable';
  static const String categoryPdfTable = 'CategoryPdfTable';
  static const String videoTable = 'VideoTable';
  static const String pdfTable = 'PdfTable';


  static final initialScript = [

    '''CREATE TABLE $categoryTable (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "category_id" TEXT,
      "category_name" TEXT,
      "category_image" TEXT
    );''',

    '''CREATE TABLE $categoryPdfTable (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "pdf_id" TEXT,
      "pdf_name" TEXT,
      "pdf_file" TEXT,
      "category_id" TEXT
    );''',

    '''CREATE TABLE $videoTable (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "video_id" TEXT,
      "video_name" TEXT,
      "video_file" TEXT,
      "video_duration" TEXT,
      "category_id" TEXT
    );''',

    '''CREATE TABLE $pdfTable (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "pdf_id" TEXT,
      "pdf_name" TEXT,
      "pdf_file" TEXT,
      "category_id" TEXT
    );'''
  ];
}