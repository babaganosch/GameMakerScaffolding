<h1 align="center">GMS 2.3+ GameMaker Scaffolding | v1.0.0</h1>
<p align="center"><a href="https://twitter.com/Babaganosch">@babaganosch</a></p>
<p align="center">Download: <a href=".">latest</a></p>

---

**GameMaker Scaffolding** is a template project for GameMaker Studio 2.3, focusing on 2D low-res tile-based games. The reason for this template is to facilitate new projects for me, and possibly others, as I grew tierd of simply copy-pasting basic stuff from prior projects each time I wanted to test something new.

Setup is easy. Just download the template .yyz file and create a new project by executing it.

## Feature list
* __Rendering system__ - double buffered rendering for post fx and shader programs as structs.
* __Notification system__ - a signal framework for easy observer pattern implementation, and a great way to decouple objects.
* __Timing module__ - enabling easy implementations of delta time, profiling and an alarm system based on real time instead of frames.
* __ParticleSystem wrapper__ - for easy particle systems setup and allowing particles to update based on delta time.
* __Lighting system__ - lightweight 2D light engine with vivid lights based on sprites or shapes.
* __Terminal module__ - a lightweight debugging console for easy input/output during runtime, with easy to setup commands.
* __World module__ - worlds, or levels, described as scructs with tilemaps and fast collision checking.
* __GameObjects__ and __LiteGameObjects__ - the ability to create and diffirentiate between real GameMaker objects and lightweight objects based on structs.
* __GameController__ module - Controlls object culling, sorting and overall behaviour of the game. GameController events is split up between a couple frames, to even out the workload and improve performance.

---
# Features

## Rendering
Instead of directly rendering the application surface to the screen, the application surface is scaled down to fit the style of low-res type of games and is at the end of the draw-pass rendered to a double buffer. This double buffer can then be utilized for easy post-fx drawing by just rendering ping-pong style between the two buffers. Finally, when all post-fx is rendered, the surface will be rendered upscaled to the screen. It is also possible to render this stage through a shader as well, for high-res post-fx.

A camera is included in the rendering system and easily controllable, and expandable after demand of the user.

Shader programs are saved as structs, cointaining easy utilization and access to uniforms and samplers.

## NotificationSystem
This is a lightweight signal framework and a great way to decouple objects, and making the game logic more event driven. [Link to original repo.](https://github.com/babaganosch/NotificationSystem) This is an old project of mine, but still very relevant.

Following is some example usage.
```gml
// Create event for an object which wants to listen to the notification bus.
subscribe();
receiver = new Receiver();

receiver.add("Monster killed", function() {
    increase_score();
});
```
```gml
// Code in a monsters destroy event
broadcast("Monster killed");
```
The messages do not have to be strings. Enums or numbers works as well, and is preferred performance wise.
```gml
enum MESSAGES {
    MONSTER_KILLED,
    GAME_OVER,
    PLAYER_JUMP,
    ...
}

receiver.add(MESSAGES.MONSTER_KILLED, function(score) {
    increase_score(score);
});

broadcast(MESSAGES.MONSTER_KILLED, 10);
```

## Timing module
Keeps tracks of gamespeed, delta time and timers. When working with delta time, the regular GameMaker-Alarms can be a troublesome as they are dependent on frame count and not real time. GameMaker has support for real-time timers with timesources, although I personally find them bulky and inconvenient. Especially when you need to pause some timers due to game being in a paused state.

Example usage:
```gml
/// Create event of something

// Create a local timer contained within the object.
timer = new AlarmSystem();

// This will print "Hello World!" every 200 milliseconds, periodically and contained within the object. Destroyed when manually aborted or object is destroyed.
timer.add(milliseconds(200), function() {
    print("Hello World!");
}, true);

// This will print "Hello World!" every 200 milliseconds, once and even though the object disappear.
game_alarms.add(milliseconds(200), function() {
    print("Hello World!");
}, false);

// This will print "Hello World!" every 200 milliseconds, periodically even though the object disappear.
// This timer will also tick even though the game is in a paused state and gamespeed is tuned to 0 fps (great for system controllers).
sys_alarms.add(milliseconds(200), function() {
    print("Hello World!");
}, true);
```

## ParticleSystems
A simple wrapper and controller for particle systems. This makes it easy to control, enable and disable particle systems when not needed. For example when object is culled due to outside the view. These particle systems also update based on delta time instead of directly bound to the frame update speed.

Example usage:
```gml
/// Adding a new type of particle to the system in the particle controller
particle_controller.add_particle(init_particle(PARTICLES.BLUE_FLAMES));
```

```gml
/// Another object who sets up a particle system and creates some crisp blue flames
ps = new ParticleSystem();
flames = load_particle(PARTICLES.BLUE_FLAMES);

// Spawns 10 blue flames at pos 150,150
ps.spawn_particle(150, 150, flames, 10);

// Create an emitter and continuously spawn 10 flames
emitter = ps.create_emitter(0, 0, 20, 20, ps_shape_rectangle, ps_distr_linear);
emitter.set_stream(flames, 10);
```

## Lighting
GameMaker Scaffolding includes a lightweight 2D lighting system. [Link to original repo.](https://github.com/babaganosch/LightingSystem2D) This is an old project of mine, a remake of the lighting system <a href="https://github.com/niksudan/prettylight">prettylight</a> made by <a href="https://github.com/niksudan">@niksudan</a>.

If needed, one can construct a light sprite of any size runtime with `ConstructLightSprite()`. (__If used, this should always be done once at bootup and not during gameplay__). This is good for experimentation, but preferably, the sprites should not be created runtime. The sprites can be of any shape or size. For device compatibility however, try to keep the dimensions square and the sizes in a power of two. For example, 16x16, 32x32..

```gml
spr_light = ConstructLightSprite(128);
```

```gml
light = new LightSource( spr_light, {
  color: c_orange,
  alpha: 0.7,
  flicker: {
    amplitude: 0.05,
    speed: 0.02
  }
});
```

## Terminal
I've included a terminal for easy debugging. This is a great way to run commands runtime like spawning instances, changing variables or changing states of the game.

## World Module
Levels, or Worlds, are expressed as 2D grids contained within structs. Each cell of the grid contains some data expressing the cell, for example if it's a wall or a floor tile. For simplicity sake, the information is expressed per data-bit. On top of that, a solid cell (wall or void), is an even number as opposed to an open cell (floor or whatever) which is expressed as an uneven number. This makes collision checking simple, and the data does not take up a lot of unnecessary storage. For example, a cell could look like this:
`CELL_DATA : 100101`, where the lowest bit shows it's a floor tile, and bit 3 and 6 indicates there's something else on the tile as well. Perhaps a chest or a door?

Each level contains a list of active and deactivated instances, and is stored when moving on to a new level if needed.

Example usage of setting up levels:

```gml
function Shop(tileset, w, h) : World(tileset, w, h) constructor
{ ... } // Stuff relevant for a shop

function OverWorld(tileset, w, h) : World(tileset, w, h) constructor
{ ... } // Stuff relevant for an over world

enum AREA
{
    OVER_WORLD,
    SHOP
};

level[AREA.OVER_WORLD] = new OverWorld(theme_tileset, 100, 100);
level[AREA.SHOP] = new Shop(theme_tileset, 100, 100);

level[AREA.OVER_WORLD].set_area(4, 4, 30, 30,   CELL_DATA.FLOOR);
level[AREA.OVER_WORLD].set_area(8, 4, 12, 8,    CELL_DATA.WALL);
...
level[AREA.OVER_WORLD].render();

level[AREA.SHOP].set_area(5, 5, 37, 37, CELL_DATA.FLOOR);
level[AREA.SHOP].set_area(24, 24, 26, 26, CELL_DATA.WALL);
...
level[AREA.SHOP].render();

CURRENT_LEVEL = AREA.OVER_WORLD;
CURRENT_LEVEL.activate();

...

// Moving on to the shop area
CURRENT_LEVEL.deactivate();
CURRENT_LEVEL = AREA.SHOP;
CURRENT_LEVEL.activate();
```
