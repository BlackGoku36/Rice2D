package rice2d.files;

class Path {
    
    public static function getNameFromPath(name:String, ext:Bool=false):String {
        var outName = "";
        if(ext){
            var nameArr = name.split("/");
            outName = nameArr[nameArr.length-1];
        }else{
            var nameArr = name.split("/");
            var extname = nameArr[nameArr.length-1];
            outName = extname.split(".")[0];
        }
        return outName;
	}
}