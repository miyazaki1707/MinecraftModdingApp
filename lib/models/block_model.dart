class BlockModel {
  String title;
  String imageUrl;
  bool isDestructibleByExplosion;
  double secondsToDestroy;
  BlockModel(this.title, this.imageUrl, this.isDestructibleByExplosion,
      this.secondsToDestroy);
}
