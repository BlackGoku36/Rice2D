package rice2d;

// Editor
import rice2d.files.Path;
import rice2d.data.AssetData;

class Assets {

	public static var assets: Array<AssetData> = [];
	public static var totalAssets:Int = 0;
	public static var totalImages:Int = 0;
	public static var totalFonts:Int = 0;
	public static var totalSounds:Int = 0;
	public static var totalBlobs:Int = 0;

	/**
	 * Get names of assets of type.
	 * @param type type of assets
	 * @return Array<String> list of names
	 */
	public static function getAssetNamesOfType(type:AssetType): Array<String> {
		var names:Array<String> = [];
		for(asset in assets) if(asset.type == type) names.push(asset.name);
		return names;
	}

	@:deprecated
	public static function getAssetLenghtOfType(type:AssetType): Int {
		var len = 0;
		for(asset in assets) if(asset.type == type) len+=1;
		return len;
	}

	/**
	 * Get asset of name and type.
	 * @param name Name of the asset
	 * @param type Type of the asset
	 * @return Dynamic kha.Image/Font/Sound/Blob
	 */
	public static function getAsset(name:String, type:AssetType): Dynamic {
		var value:Dynamic = null;
		for(asset in assets){
			if(asset.type == type && asset.name == name){
				value = asset.value;
			}
		}
		return value;
	}

	/**
	 * Get Asset's data of name and type
	 * @param name Name of the asset
	 * @param type Type of the asset
	 * @return AssetData
	 */
	public static function getAssetData(name:String, type:AssetType):AssetData {
		var data:AssetData = null;
		for (asset in assets) if(asset.type == type && asset.name == name) data = asset;
		return data;
	}

	/**
	 * Load asset from Asset folder.
	 * @param data Assets's Data
	 * @param done Callback function, when the asset is done loading.
	 */
	public static function loadAssets(data:AssetData, done:AssetData->Void = null) {
		switch (data.type){
			case Image:
				kha.Assets.loadImage(data.name, (image) -> {
					var asset = {
						name: data.name,
						type: Image,
						value: image
					};
					assets.push(asset);
					totalAssets += 1;
					totalImages += 1;
					if(done != null) done(asset);
				}, assetError);
			case Font:
				kha.Assets.loadFont(data.name, (font) -> {
					var asset = {
						name: data.name,
						type: Font,
						value: font
					};
					assets.push(asset);
					totalAssets += 1;
					totalFonts += 1;
					if(done != null) done(asset);
				}, assetError);
			case Sound:
				kha.Assets.loadSound(data.name, (sound) -> {
					var asset = {
						name: data.name,
						type: Sound,
						value: sound
					};
					assets.push(asset);
					totalAssets += 1;
					totalSounds += 1;
					if(done != null) done(asset);
				}, assetError);
			case Blob:
				kha.Assets.loadBlob(data.name, (blob) -> {
					var asset = {
						name: data.name,
						type: Blob,
						value: blob
					};
					assets.push(asset);
					totalAssets += 1;
					totalBlobs += 1;
					if(done != null) done(asset);
				}, assetError);
		}
	}

	static function assetError(err:kha.AssetError) {
		trace('Asset failed to load, \'${err}\'');
	}
}
