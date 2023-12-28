IS_SINGLETON
sprite_index = -1;
receiver = new Receiver(["systems"]);
particle_controller = new ParticleController();
particle_controller.add_particle(init_particle(PARTICLES.TEST));

var _box = CAMERA.edges;
pt = load_particle(PARTICLES.TEST);
ps = new ParticleSystem( -100 );
emitter = ps.create_emitter(_box[X1], _box[Y1], _box[X2], _box[Y2], ps_shape_rectangle, ps_distr_linear);
emitter.set_stream(pt, 10);