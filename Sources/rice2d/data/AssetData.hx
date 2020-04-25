package rice2d.data;

typedef AssetData = {
	var name:String;
	var type:AssetType;
	var ?value: Dynamic;
}

enum abstract AssetType(Int) from Int to Int {
	var Image;
	var Font;
	var Sound;
	var Blob;
}
