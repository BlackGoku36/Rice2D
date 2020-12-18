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
                    loadImage(data.name, ()->{
                        preloadAssetsLoaded += 1;
                    });
                case Font:
                    loadFont(data.name, ()->{
                        preloadAssetsLoaded += 1;
                    });
                case Sound:
                    loadSound(data.name, ()->{
                        preloadAssetsLoaded += 1;
                    });
                case Blob:
                    loadBlob(data.name, ()->{
                        preloadAssetsLoaded += 1;
                    });
            }
		}
    }

    public static function loadImage(name:String, done:Void->Void) {
        if(isLoaded(name)) return;
        kha.Assets.loadImage(name, (image) -> {
            assets.push({
                name: name,
                type: Image,
                value: image
            });
            done();
        });
    }

    public static function loadFont(name:String, done:Void->Void) {
        if(isLoaded(name)) return;
        kha.Assets.loadFont(name, (font) -> {
            assets.push({
                name: name,
                type: Font,
                value: font
            });
            done();
        });
    }

    public static function loadSound(name:String, done:Void->Void) {
        if(isLoaded(name)) return;
        kha.Assets.loadSound(name, (sound) -> {
            assets.push({
                name: name,
                type: Sound,
                value: sound
            });
            done();
        });
    }

    public static function loadBlob(name:String, done:Void->Void) {
        if(isLoaded(name)) return;
        kha.Assets.loadBlob(name, (blob) -> {
            assets.push({
                name: name,
                type: Blob,
                value: blob
            });
            done();
        });
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
    
    static function isLoaded(name:String) {
        for(asset in assets) if(asset.name == name) {
            trace('Asset of name: ${asset.name} is already loaded. Aborting..');
            return true;
        }
        return false;
    }

}