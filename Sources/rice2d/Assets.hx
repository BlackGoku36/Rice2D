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
	 * Get names of assets of type
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
	 * Get asset
	 * @param name Name of the asset
	 * @param type Type of the asset
	 * @return Dynamic
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
	 * Get Asset's data
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
	 * Load asset from path
	 * @param path Path to asset (path start from `Assets` folder)
	 * @param type Type of asset
	 */
	public static function loadAssetFromPath(path:String, type:AssetType, done:AssetData->Void = null) {
		switch (type){
			case Image:
				kha.Assets.loadImageFromPath(path, true, function(image){
					assets.push({
						name: Path.getNameFromPath(path),
						type: Image,
						value: image,
						path: path
					});
					totalAssets += 1;
					totalImages += 1;
				});
				if(done != null) done(getAssetData(Path.getNameFromPath(path), Image));
			case Font:
				kha.Assets.loadFontFromPath(path, function(font){
					assets.push({
						name: Path.getNameFromPath(path),
						type: Font,
						value: font,
						path: path
					});
					totalAssets += 1;
					totalFonts += 1;
				});
				if(done != null) done(getAssetData(Path.getNameFromPath(path), Font));
			case Sound:
				kha.Assets.loadSoundFromPath(path, function(sound){
					assets.push({
						name: Path.getNameFromPath(path),
						type: Sound,
						value: sound,
						path: path
					});
					totalAssets += 1;
					totalSounds += 1;
				});
				if(done != null) done(getAssetData(Path.getNameFromPath(path), Sound));
			case Blob:
				kha.Assets.loadBlobFromPath(path, function(blob){
					assets.push({
						name: Path.getNameFromPath(path),
						type: Blob,
						value: blob,
						path: path
					});
					totalAssets += 1;
					totalBlobs += 1;
				});
				if(done != null) done(getAssetData(Path.getNameFromPath(path), Blob));
		}
	}
}
