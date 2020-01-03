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

//Engine
import rice2d.data.ShaderData;
import rice2d.data.ShaderData.ConstantData;

class Shader {
	var pipeline:PipelineState;
	public var fragmentShader: FragmentShader;
	public var constants: Array<ConstantData>;
	public var constantsLocations:Array<Map<ConstantLocation, ConstantData>> = [];
	public var textureUnits:Array<Map<TextureUnit, ConstantData>> = [];

	public function new(shaderData: rice2d.data.ShaderData) {
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
		constants = shaderData.constants;
		for (constant in shaderData.constants){
			if(constant.type == Texture){
				textureUnits.push([ pipeline.getTextureUnit(constant.name) => constant]);
			}else{
				constantsLocations.push([ pipeline.getConstantLocation(constant.name) => constant]);
			}
		}
	}

	public function getPipeline() {
		return pipeline;
	}

	public function render(canvas:Canvas, render:Void->Void) {
		begin(canvas);
		render();
		end(canvas);
	}

	public function begin(canvas:Canvas){
		canvas.g2.pipeline = pipeline;
		pipeline.set();
		for (map in constantsLocations) {
			for (cl => cd in map) {
				switch (cd.type){
					case Int: canvas.g4.setInt(cl, Std.int(cd.val[0]));
					case Float: canvas.g4.setFloat(cl, cd.val[0]);
					case Bool: canvas.g4.setBool(cl, cd.bool);
					case Vec2: canvas.g4.setVector2(cl, new FastVector2(cd.val[0], cd.val[1]));
					case _:
				}
			}
		}
		for (map in textureUnits){
			for (texUnit => value in map) {
				canvas.g4.setTexture(texUnit, value.tex);
			}
		}
	}

	public function end(canvas:Canvas){
		canvas.g2.pipeline = null;
	}
}
