package rice2d.ui;

#if rice_ui

import rice2d.system.Input;
import kha.graphics2.Graphics;
import kha.Color;
import kha.Canvas;
import kha.System;
import rice2d.Assets;
import kha.Font;

class UI {

	var font:Font;
	var canvasData:rice2d.ui.Data.CanvasData;
	var loaded = false;
	var visible = true;

	var mouse = Input.getMouse();

	public function new(canvasData: rice2d.ui.Data.CanvasData) {
		font = canvasData.font;
		if(canvasData.x == null) canvasData.x = 0;
		if(canvasData.y == null) canvasData.y = 0;
		if(canvasData.width == null) canvasData.width = System.windowWidth();
		if(canvasData.height == null) canvasData.height = System.windowHeight();
		this.canvasData = canvasData;
		loaded = true;
		for(elem in canvasData.elements){
			elem.state = None;
			if(elem.visible == null) elem.visible = true;
		}
		Scene.uis.push(this);
	}

	public function update() {
		if(canvasData.elements == null || canvasData.elements.length == 0) return;
		if(!visible) return;
		for (elem in canvasData.elements){
			if(!elem.visible) continue;
			if(mouse.x >= elem.x && mouse.x <= elem.x + elem.width && mouse.y >= elem.y && mouse.y <= elem.y + elem.height){
				if(mouse.started()){
					elem.state = Clicked;
					if(elem.onClicked != null) elem.onClicked();
				}
				else if(mouse.down()){
					elem.state = Down;
					if(elem.onDown != null) elem.onDown();
				}
				else{
					elem.state = Hover;
					if(elem.onHover != null) elem.onHover();
				}
			}else elem.state = None;
		}
	}

	public function render (canvas:Canvas){
		if(!loaded) return;
		if(canvasData.elements == null || canvasData.elements.length == 0) return;
		if(!visible) return;
		var g = canvas.g2;

		var fnt = g.font;
		g.font = font;
		g.fontSize = 20;
		var col = g.color;

		for (elem in canvasData.elements){
			if(!elem.visible) continue;
			switch (elem.type){
				case Text:
					renderText(g, elem);
				case Button:
					renderButton(g, elem);
				case Image:
					renderImage(g, elem);
				case Rect:
					renderShape(g, elem);
				case _:
			}
		}
		g.font = fnt;
		g.color = col;
	}

	public function show(){
		visible = true;
		return this;
	}

	public function hide(){
		visible = false;
		return this;
	}


	function renderText(g:Graphics, elem:rice2d.ui.Data.ElementData) {
		if(elem.state == None) g.color = elem.style.textColor;
		else if(elem.state == Hover) g.color = elem.style.textHoverColor;
		else if(elem.state == Clicked || elem.state == Down) g.color = elem.style.textDownColor;
		var fntsize = g.fontSize;
		g.fontSize = Std.int(elem.height);
		g.drawString(elem.text, elem.x, elem.y);
		g.fontSize = fntsize;
	}

	function renderButton(g:Graphics, elem:rice2d.ui.Data.ElementData) {
		if(elem.state == None) g.color = elem.style.backgroundColor;
		else if(elem.state == Hover) g.color = elem.style.backgroundHoverColor;
		else if(elem.state == Clicked || elem.state == Down) g.color = elem.style.backgroundDownColor;
		g.fillRect(elem.x, elem.y, elem.width, elem.height);

		if(elem.state == None) g.color = elem.style.textColor;
		else if(elem.state == Hover) g.color = elem.style.textHoverColor;
		else if(elem.state == Clicked || elem.state == Down) g.color = elem.style.textDownColor;
		g.drawString(elem.text, elem.x + (elem.width/2) - (font.width(g.fontSize, elem.text)/2), elem.y + (elem.height/2) - (font.height(g.fontSize)/2));

		if(elem.state == None) g.color = elem.style.borderColor;
		else if(elem.state == Hover) g.color = elem.style.borderHoverColor;
		else if(elem.state == Clicked || elem.state == Down) g.color = elem.style.borderDownColor;
		g.drawRect(elem.x, elem.y, elem.width, elem.height, elem.style.borderWidth);
	}

	function renderImage(g:Graphics, elem:rice2d.ui.Data.ElementData) {
		g.color = 0xffffffff;
		g.drawScaledImage(elem.image, elem.x, elem.y, elem.width, elem.height);
	}

	function renderShape(g:Graphics, elem:rice2d.ui.Data.ElementData) {
		g.color = elem.style.backgroundColor;
		g.fillRect(elem.x, elem.y, elem.width, elem.height);
	}

	public function getElement(name:String) {
		for(elem in canvasData.elements)
			if(elem.name == name)
				return elem;
		return null;
	}

}

#end
