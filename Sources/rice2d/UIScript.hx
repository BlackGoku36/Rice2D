
//Borrowed from https://github.com/armory3d/armory/blob/master/Sources/armory/trait/internal/CanvasScript.hx

package rice2d;

//Zui
#if rice_ui
	import zui.Zui.Handle;
	import zui.Canvas.TCanvas;
	import zui.Canvas.TElement;
#end

class UIScript {

	#if rice_ui

	/**
		* Add element to canvas.
		* @param canvasRef String referenece of canvas.
		* @param elem Element data.
		*/
	public static function addElement(canvasRef: String, elem:TElement) {
		var canvas = getCanvas(canvasRef);
		canvas.elements.push(elem);
	}

	/**
		* Add canvas to scene.
		* @param canvas Canvas Data.
		*/
	public static function addCanvas(canvas:TCanvas) {
		Scene.canvases.push(canvas);
	}

	/**
		* Get canvas from scene.
		* @param name Name of canvas
		* @return TCanvas Canvas data.
		*/
	public static function getCanvas(name:String): TCanvas {
		var canvas:TCanvas = null;
		for (canva in Scene.canvases) if (canva.name == name) canvas = canva;
		return canvas;
	}

	/**
		* Get element form canvas.
		* @param canvasRef String reference of canvas name.
		* @param name Name of element.
		* @return TElement Element data.
		*/
	public static function getElement(canvasRef:String, name:String): TElement {
		var element:TElement = null;
		var canvas = getCanvas(canvasRef);
		for (elem in canvas.elements) if(elem.name == name) element = elem;
		return element;
	}

	/**
		* Set visibility of canvas
		* @param canvasRef String reference of canvas name
		* @param visible Whether it should be visible or not.
		*/
	public static function setCanvasVisibility(canvasRef: String, visible:Bool) {
		var canvas = getCanvas(canvasRef);
		for (elem in canvas.elements) elem.visible = visible;
	}

	/**
		* Get handle of element from canvas
		* @param canvasRef String reference of canvas name
		* @param name Name of element
		* @return Handle
		*/
	@:access(zui.Canvas)
	@:access(zui.Handle)
	public static function getHandle(canvasRef:String, name:String):Handle {
		return zui.Canvas.h.children[getElement(canvasRef, name).id];
	}

	#end
}
