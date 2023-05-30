enum TweetType {
  text('text'),
  image('image');

  final String type;
  const TweetType(this.type);

  factory TweetType.fromString(String type) {
    return switch (type) {
      'image' => TweetType.image,
      'text' || _ => TweetType.text,
    };
  }
}
