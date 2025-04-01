class Book {
  int? id;
  String? title;
  String? number;
  DateTime? date;
  String? aminMargin;
  String? mutawalliMargin;
  String? followup;
  String? procedure;
  String? notes;
  List<String> imagePaths; // List to store multiple image paths
  String? pdfPath; // New property to store the PDF file path

  // Updated constructor with named parameters and default values.
  Book({
    this.id,
    this.title,
    this.number,
    this.date,
    this.aminMargin,
    this.mutawalliMargin,
    this.followup,
    this.procedure,
    this.notes,
    this.imagePaths = const [],
    this.pdfPath, // Add pdfPath to constructor
  });

  // Convert Book instance to a JSON-like Map for database storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'number': number,
      'date': date?.toIso8601String(),
      'aminMargin': aminMargin,
      'mutawalliMargin': mutawalliMargin,
      'followup': followup,
      'procedure': procedure,
      'notes': notes,
      'pdfPath': pdfPath, // Include pdfPath when converting to JSON
    };
  }

  // Create a Book instance from a JSON-like Map.
  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        number = json['number'],
        date = json['date'] != null ? DateTime.parse(json['date']) : null,
        aminMargin = json['aminMargin'],
        mutawalliMargin = json['mutawalliMargin'],
        followup = json['followup'],
        procedure = json['procedure'],
        notes = json['notes'],
        pdfPath = json['pdfPath'], // Extract pdfPath from JSON
        imagePaths = []; // Initialize imagePaths as empty

  // A method to add an image path.
  void addImagePath(String path) {
    imagePaths.add(path);
  }
}
