package rice2d.ui;

import kha.Color;

class Style {
    public static final light: rice2d.ui.Data.StyleData = {
        textColor:Color.fromBytes(25, 25, 25).value,
        textHoverColor:Color.fromBytes(15, 15, 15).value,
        textDownColor:Color.fromBytes(0, 0, 0).value,
        backgroundColor:Color.fromBytes(255, 255, 255).value,
        backgroundHoverColor:Color.fromBytes(235, 235, 235).value,
        backgroundDownColor:Color.fromBytes(215, 215, 215).value,
        borderWidth: 3,
        borderColor:Color.fromBytes(100, 100, 100).value,
        borderHoverColor:Color.fromBytes(80, 80, 80).value,
        borderDownColor:Color.fromBytes(60, 60, 60).value
    }
}