let project = new Project('Rice2D');
project.addSources('Sources');
project.addAssets('Assets/**');
project.addShaders('Shaders/**', { defines: ['decoy'] });
project.addLibrary('zui');
project.addParameter('-dce no');
project.addDefine('rice_postprocess');
resolve(project);