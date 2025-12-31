class Project {
final String title;
final String subtitle;
final String description;
final List<String> screenshots; // пути к assets или URL
final Map<String, String> techUsage; // ключ - технология, значение - использование/роль


Project({
required this.title,
required this.subtitle,
required this.description,
required this.screenshots,
required this.techUsage,
});
}