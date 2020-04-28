package rice2d.files;

class Path {

    /**
     * Get name from file path.
     * @param path File path 
     * @param ext has extension
     * @return String name of file
     */
    public static function getNameFromPath(path:String, ext:Bool=false):String {
        var outName = "";
        if(ext){
            var nameArr = path.split("/");
            outName = nameArr[nameArr.length-1];
        }else{
            var nameArr = path.split("/");
            var extname = nameArr[nameArr.length-1];
            outName = extname.split(".")[0];
        }
        return outName;
	}
}