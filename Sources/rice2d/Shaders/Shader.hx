package rice2d.shaders;

//Kha
import kha.Shaders;
import kha.graphics4.TextureUnit;
import kha.Canvas;
import kha.math.FastVector2;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;
import kha.graphics4.BlendingFactor;
import kha.graphics4.ConstantLocation;

class Shader {
	var pipeline:PipelineState;
	public var fragmentShader: FragmentShader;
	public var constants: Array<ConstantData>;
	public var constantsLocations:Array<Map<ConstantLocation, ConstantData>> = [];
	public var textureUnits:Array<Map<TextureUnit, ConstantData>> = [];

	/**
	 * Create new Shader from shader's data
	 * @param shaderData Shader's data
	 */
<<<<<<< HEAD
	public function new(shaderData: ShaderData) {
=======
	public function new(shaderData: rice2d.data.ShaderData) {
>>>>>>> c2b7b1f0429fad1859ebe3353c080c43f56ed35e
		fragmentShader = shaderData.fragmentShader;
		pipeline = new PipelineState();
		pipeline.fragmentShader = fragmentShader;

		var vertexStructure = new VertexStructure();
		vertexStructure.add("vertexPosition", VertexData.Float3);

		if(shaderData.type == Texture){
			pipeline.vertexShader = Shaders.painter_image_vert;
			vertexStructure.add("texPosition", VertexData.Float2);
			vertexStructure.add("vertexColor", VertexData.Float4);
		}else{
			pipeline.vertexShader = Shaders.painter_colored_vert;
			vertexStructure.add("vertexColor", VertexData.Float4);
		}

		pipeline.inputLayout = [vertexStructure];

		pipeline.blendSource = BlendingFactor.SourceAlpha;
		pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
		pipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
		pipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;

		pipeline.compile();
	}

	/**
	 * Get pipeline of shader.
	 */
	public function getPipeline() {
		return pipeline;
	}

	/**
	 * Render the shader.
	 * @param canvas
<<<<<<< HEAD
	 * @param render
=======
	 * @param render 
>>>>>>> c2b7b1f0429fad1859ebe3353c080c43f56ed35e
	 */
	public function render(canvas:Canvas, render:Void->Void) {
		begin(canvas);
		render();
		end(canvas);
	}

	public function begin(canvas:Canvas){
		canvas.g2.pipeline = pipeline;
		pipeline.set();
	}

	public function end(canvas:Canvas){
		canvas.g2.pipeline = null;
	}
}

@:structInit class ShaderData {
	public var fragmentShader: kha.graphics4.FragmentShader;
	public var type: ShaderType;
}

enum abstract ShaderType(Int) from Int to Int {
	var Texture;
	var Color;
}

@:structInit class ConstantData {
	public var name:String;
	public var type:ConstantType;
	@:optional public var val:Array<Float>;
	@:optional public var bool:Bool;
	@:optional public var tex:kha.Image;
}

enum abstract ConstantType(Int) from Int to Int {
	var Int;
	var Float;
	var Bool;
	var Vec2;
	var Texture;
}
