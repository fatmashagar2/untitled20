class BannerModel{
  int? id;
  String? url;

  BannerModel.fromJson({required Map<String,dynamic> data}){
    id = data['id'];
    url = data['image'];
  }
}