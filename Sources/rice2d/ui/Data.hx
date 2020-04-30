package rice2d.ui;

#if rice_ui

import kha.Color;
import kha.Font;

typedef CanvasData = {
    var name:String;
    var ?x: Null<Int>;
    var ?y: Null<Int>;
    var ?width: Null<Int>;
    var ?height: Null<Int>;
    var font:Font;
    var elements:Array<ElementData>;
}

typedef ElementData = {
    var name: String;
    var text: String;
    var x: Int;
    var y: Int;
    var width: Int;
    var height: Int;
    var type: ElementType;
    var ?visible:Bool;
    var style: StyleData;
    var ?image: kha.Image;
    var ?state: ElementState;
    var ?onHover: ()->Void;
    var ?onClicked: ()->Void;
    var ?onDown: ()->Void;
}

typedef StyleData = {
    var ?textColor:Color;
    var ?textHoverColor:Color;
    var ?textDownColor:Color;

    var ?backgroundColor:Color;
    var ?backgroundHoverColor:Color;
    var ?backgroundDownColor:Color;
    
    var ?borderWidth:Color;
    var ?borderColor:Color;
    var ?borderHoverColor:Color;
    var ?borderDownColor:Color;
}

enum ElementState {
    Hover;
    Clicked;
    Down;
    None;
}

enum abstract ElementType (Int) from Int to Int {
    var Text; // 0
    var Button;// 2
    var Image;// 3
    var Rect;// 4
}

#end
