package rice2d;

import kha.graphics4.VertexShader;
import kha.Scheduler;
import kha.Canvas;
import kha.graphics4.ConstantLocation;
import kha.math.Vector4;
import kha.math.Vector2;
import kha.graphics4.BlendingFactor;
import kha.Shaders;
import kha.graphics4.VertexStructure;
import kha.graphics4.FragmentShader;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;

class Shader {
    var pipeline:PipelineState;
    var fragmentShader: FragmentShader;
    var vertexShader: VertexShader;
    public var timeID: ConstantLocation;

    var constantFloat: Array<Map<String,Float>> = [];
    var constantInt: Array<Map<String,Int>> = [];
    var constantVec2: Array<Map<String,Vector2>> = [];
    var constantVec3: Array<Map<String,Vector4>> = [];
    var constantVec4: Array<Map<String,Vector4>> = [];

    public function new(shaderData: rice2d.data.ShaderData) {
        fragmentShader = shaderData.fragmentShader;
        vertexShader = shaderData.vertexShader;
        pipeline = new PipelineState();
        pipeline.fragmentShader = fragmentShader;
        pipeline.vertexShader = vertexShader;

        var vertexStructure = new VertexStructure();
        vertexStructure.add("vertexPosition", VertexData.Float3);
        vertexStructure.add('vertexColor', VertexData.Float4);
        // vertexStructure.add('texturePosition', VertexData.Float2);

        pipeline.inputLayout = [vertexStructure];

        pipeline.blendSource = BlendingFactor.SourceAlpha;
        pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
        pipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
        pipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;

        pipeline.compile();

        // for (constant in shaderData.constants){
        //     switch (constant.type){
        //         case Float: constantFloat.push([constant.name => constant.value[0]]);
        //         case Int: constantInt.push([constant.name => Std.int(constant.value[0])]);
        //         case Vec2: constantVec2.push([constant.name => new Vector2(constant.value[0], constant.value[1])]);
        //         case Vec3: constantVec3.push([constant.name => new Vector4(constant.value[0], constant.value[1], constant.value[2])]);
        //         case Vec4: constantVec4.push([constant.name => new Vector4(constant.value[0], constant.value[1], constant.value[2], constant.value[3])]);
        //     }
        // }
        timeID = pipeline.getConstantLocation("time");
    }

    public function begin(canvas:Canvas){
        canvas.g2.pipeline = pipeline;
        pipeline.set();
        canvas.g4.setFloat(timeID, Scheduler.time());
    }

    public function end(canvas:Canvas){
        canvas.g2.pipeline = null;
    }
}