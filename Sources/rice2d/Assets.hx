package rice2d;

class Assets {

    public static var images: Array<Map<String, kha.Image>> = [];
    public static var fonts: Array<Map<String, kha.Font>> = [];
    public static var sounds: Array<Map<String, kha.Sound>> = [];

    public static var doneLoading:Bool = false;

    public static var imageDone:Bool = false;
    public static var fontDone:Bool = false;
    public static var soundDone:Bool = false;

    public static function getImage(imageRef:String) {
        var newImage:kha.Image = null;
        for (image in images){
            if(image.exists(imageRef)) newImage = image.get(imageRef);
        }
        return newImage;
    }

    public static function getFont(fontRef:String) {
        var newFont:kha.Font = null;
        for (font in fonts){
            if(font.exists(fontRef)) newFont = font.get(fontRef);
        }
        return newFont;
    }
    
    public static function loadImagesFromScene(imagesRef:Array<String>, done: Void->Void){
        for (image in imagesRef){
            kha.Assets.loadImageFromPath(image, true, function (img){
                images.push([image.split(".")[0] => img]);
                if(images.length == imagesRef.length){
                    imageDone = true;
                    done();
                }
            }, function (error){
                throw error + 'Can`t find image $image, make sure path is correct and image is in `Assets` folder';
            });
        }
    }

    public static function loadFontsFromScene(fontsRef:Array<String>, done:Void->Void){
        for (font in fontsRef){
            kha.Assets.loadFontFromPath(font, function (fnt){
                fonts.push([font.split(".")[0] => fnt]);
                if(fonts.length == fontsRef.length){
                    fontDone = true;
                    done();
                } 
            }, function (error){
                throw error + 'Can`t find font $font, make sure path is correct and font is in `Assets` folder';
            });
        }
    }

    public static function loadSoundsFromScene(soundsRef:Array<String>, done:Void->Void){
        if(soundsRef != null) for (sound in soundsRef){
            kha.Assets.loadSoundFromPath(sound, function (snd){
                sounds.push([sound.split(".")[0] => snd]);
                if(fonts.length == soundsRef.length){
                    soundDone = true;
                    done();
                }
            }, function (error){
                throw error + 'Can`t find sound $sound, make sure path is correct and sound is in `Assets` folder';
            });
        }
    }
}