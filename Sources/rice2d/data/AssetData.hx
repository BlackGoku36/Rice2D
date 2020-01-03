package rice2d.data;

typedef AssetData = {
	var name:String;
	var type:AssetType;
	var ?value: Dynamic;
	var path:String;
}

@:enum abstract AssetType(Int) from Int to Int {
	var Image = 0;
	var Font = 1;
	var Sound = 2;
	var Blob = 3;
}
