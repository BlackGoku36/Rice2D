package rice2d.shaders;

#if rice_postprocess
import kha.Canvas;
import kha.graphics4.FragmentShader;
#end

@:allow(rice2d.App)
class Postprocess {

#if rice_postprocess
	function new() {}

	var shader:Shader = new rice2d.shaders.Shader({
		type: Texture,
		fragmentShader: kha.Shaders.postprocess_frag,
		constants: [
			{
				name: "tex",
				type: Texture,
				tex: App.backbuffer
			}
		]
	});

	function start(canvas:Canvas) {
		shader.begin(canvas);
	}

	function end(canvas:Canvas) {
		shader.end(canvas);
	}
#end

}
