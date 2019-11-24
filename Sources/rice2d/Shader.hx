package rice2d;

import kha.Canvas;
import kha.graphics4.PipelineState;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;
import kha.graphics4.BlendingFactor;

class Shader {
    var pipeline:PipelineState;
    public var fragmentShader: FragmentShader;
    public var vertexShader: VertexShader;

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
    }

    public function getPipeline() {
        return pipeline;
    }

    public function begin(canvas:Canvas){
        canvas.g2.pipeline = pipeline;
        pipeline.set();
    }

    public function end(canvas:Canvas){
        canvas.g2.pipeline = null;
    }
}
