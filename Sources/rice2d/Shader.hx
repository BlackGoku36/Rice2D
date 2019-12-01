package rice2d;

//Kha
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
    public var vertexShader: VertexShader;
    public var constants: Array<ConstantData>;
    public var constantsLocations:Array<Map<ConstantLocation, ConstantData>> = [];

    public function new(shaderData: rice2d.data.ShaderData) {
        fragmentShader = shaderData.fragmentShader;
        vertexShader = shaderData.vertexShader;
        pipeline = new PipelineState();
        pipeline.fragmentShader = fragmentShader;
        pipeline.vertexShader = vertexShader;

        var vertexStructure = new VertexStructure();
        vertexStructure.add("vertexPosition", VertexData.Float3);
        vertexStructure.add('vertexColor', VertexData.Float4);
        vertexStructure.add('texturePosition', VertexData.Float2);

        pipeline.inputLayout = [vertexStructure];

        pipeline.blendSource = BlendingFactor.SourceAlpha;
        pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
        pipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
        pipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;

        pipeline.compile();
        constants = shaderData.constants;
        for (constant in shaderData.constants){
            constantsLocations.push([ pipeline.getConstantLocation(constant.name) => constant]);
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

    function begin(canvas:Canvas){
        canvas.g2.pipeline = pipeline;
        pipeline.set();
        for (map in constantsLocations) {
            for (cl => cd in map) {
                switch (cd.type){
                    case Int: canvas.g4.setInt(cl, Std.int(cd.val[0]));
                    case Float: canvas.g4.setFloat(cl, cd.val[0]);
                    case Bool: canvas.g4.setBool(cl, cd.bool);
                    case Vec2: canvas.g4.setVector2(cl, new FastVector2(cd.val[0], cd.val[1]));
                }
            }
        }
    }

    function end(canvas:Canvas){
        canvas.g2.pipeline = null;
    }
}
