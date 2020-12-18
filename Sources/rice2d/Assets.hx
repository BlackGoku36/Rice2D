package rice2d;

typedef AssetData = {
    var name: String;
    var type: AssetType;
    var value: Any;
}

enum abstract AssetType(Int) from Int to Int {
	var Image;// = 0;
	var Font;// = 1;
	var Sound;// = 2;
	var Blob;// = 3;
}

class Assets {
    
    public static var preloadTotalAssets = 0;
    public static var preloadAssetsLoaded = 0;

    public static var assets: Array<AssetData> = [];

    public static function preloadAssets(assetList:Array<{name:String, type:AssetType}>, done:AssetData->Void = null) {
        preloadTotalAssets = assetList.length;
        for (data in assetList){
            switch (data.type){
                case Image:
                    kha.Assets.loadImage(data.name, (image) -> {
                        var asset:AssetData = {
                            name: data.name,
                            type: Image,
                            value: image
                        };
                        assets.push(asset);
                        preloadAssetsLoaded += 1;
                        // if(done != null) done(asset);
                    });
                case Font:
                    kha.Assets.loadFont(data.name, (font) -> {
                        var asset:AssetData = {
                            name: data.name,
                            type: Font,
                            value: font
                        };
                        assets.push(asset);
                        preloadAssetsLoaded += 1;
                        // if(done != null) done(asset);
                    });
                case Sound:
                    kha.Assets.loadSound(data.name, (sound) -> {
                        var asset:AssetData = {
                            name: data.name,
                            type: Sound,
                            value: sound
                        };
                        assets.push(asset);
                        preloadAssetsLoaded += 1;
                        // if(done != null) done(asset);
                    });
                case Blob:
                    kha.Assets.loadBlob(data.name, (blob) -> {
                        var asset:AssetData = {
                            name: data.name,
                            type: Blob,
                            value: blob
                        };
                        assets.push(asset);
                        preloadAssetsLoaded += 1;
                        // if(done != null) done(asset);
                    });
            }
		}
    }
    
    public static function getAsset(name:String, type:AssetType): Any {
		var value:Any = null;
		for(asset in assets){
			if(asset.type == type && asset.name == name){
				value = asset.value;
			}
		}
		return value;
	}

}