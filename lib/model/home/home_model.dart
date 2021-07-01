class HomeModel {
  int status;
  List<HomeData> data;

  HomeModel({this.status, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<HomeData>();
      json['data'].forEach((v) {
        data.add(new HomeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeData {
  List<Menubar> menubar;
  List<Sliders> slider;
  List<Offer> offer;
  List<StoreDetail> storeDetail;

  HomeData({this.menubar, this.slider, this.offer, this.storeDetail});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['menubar'] != null) {
      menubar = new List<Menubar>();
      json['menubar'].forEach((v) {
        menubar.add(new Menubar.fromJson(v));
      });
    }
    if (json['slider'] != null) {
      slider = new List<Sliders>();
      json['slider'].forEach((v) {
        slider.add(new Sliders.fromJson(v));
      });
    }
    if (json['offer'] != null) {
      offer = new List<Offer>();
      json['offer'].forEach((v) {
        offer.add(new Offer.fromJson(v));
      });
    }
    if (json['store_detail'] != null) {
      storeDetail = new List<StoreDetail>();
      json['store_detail'].forEach((v) {
        storeDetail.add(new StoreDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.menubar != null) {
      data['menubar'] = this.menubar.map((v) => v.toJson()).toList();
    }
    if (this.slider != null) {
      data['slider'] = this.slider.map((v) => v.toJson()).toList();
    }
    if (this.offer != null) {
      data['offer'] = this.offer.map((v) => v.toJson()).toList();
    }
    if (this.storeDetail != null) {
      data['store_detail'] = this.storeDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menubar {
  String catId;
  String catName;
  String imgLink;
  List<SubCat> subCat;

  Menubar({this.catId, this.catName, this.imgLink, this.subCat});

  Menubar.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
    imgLink = json['img_link'];
    if (json['sub_cat'] != null) {
      subCat = new List<SubCat>();
      json['sub_cat'].forEach((v) {
        subCat.add(new SubCat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.catId;
    data['cat_name'] = this.catName;
    data['img_link'] = this.imgLink;
    if (this.subCat != null) {
      data['sub_cat'] = this.subCat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCat {
  String subcatId;
  String subCatName;
  List<SubCatType> subCatType;

  SubCat({this.subcatId, this.subCatName, this.subCatType});

  SubCat.fromJson(Map<String, dynamic> json) {
    subcatId = json['subcat_id'];
    subCatName = json['sub_cat_name'];
    if (json['sub_cat_type'] != null) {
      subCatType = new List<SubCatType>();
      json['sub_cat_type'].forEach((v) {
        subCatType.add(new SubCatType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcat_id'] = this.subcatId;
    data['sub_cat_name'] = this.subCatName;
    if (this.subCatType != null) {
      data['sub_cat_type'] = this.subCatType.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCatType {
  String subcattypeId;
  String subcattypeName;

  SubCatType({this.subcattypeId, this.subcattypeName});

  SubCatType.fromJson(Map<String, dynamic> json) {
    subcattypeId = json['subcattype_id'];
    subcattypeName = json['subcattype_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcattype_id'] = this.subcattypeId;
    data['subcattype_name'] = this.subcattypeName;
    return data;
  }
}

class Sliders {
  String sliderId;
  String sliderImg;

  Sliders({this.sliderId, this.sliderImg});

  Sliders.fromJson(Map<String, dynamic> json) {
    sliderId = json['slider_id'];
    sliderImg = json['slider_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slider_id'] = this.sliderId;
    data['slider_img'] = this.sliderImg;
    return data;
  }
}

class Offer {
  String bannerId;
  String bannerImg;
  String bannerLink;
  Redirect redirect;

  Offer({this.bannerId, this.bannerImg, this.bannerLink, this.redirect});

  Offer.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    bannerImg = json['banner_img'];
    bannerLink = json['banner_link'];
    redirect = json['redirect'] != null
        ? new Redirect.fromJson(json['redirect'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_id'] = this.bannerId;
    data['banner_img'] = this.bannerImg;
    data['banner_link'] = this.bannerLink;
    if (this.redirect != null) {
      data['redirect'] = this.redirect.toJson();
    }
    return data;
  }
}

class Redirect {
  String type;
  String id;

  Redirect({this.type, this.id});

  Redirect.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class StoreDetail {
  String id;
  String type;
  String value;

  StoreDetail({this.id, this.type, this.value});

  StoreDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
