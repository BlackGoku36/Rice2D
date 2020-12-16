let project = new Project('Rice2D');
project.addSources('Sources');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addDefine('analyzer-optimize');
resolve(project);