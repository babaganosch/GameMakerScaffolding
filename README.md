<h1 align="center">GMS 2.3+ GameMaker Scaffolding | v1.0.0</h1>
<p align="center"><a href="https://twitter.com/Babaganosch">@babaganosch</a></p>
<p align="center">Download: <a href="https://github.com/babaganosch/GameMakerScaffolding/releases/download/v1.0.0/GameMakerScaffolding.yyz">latest</a></p>

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
* __GameController module__ - Controlls object culling, sorting and overall behaviour of the game. GameController events is split up between a couple frames, to even out the workload and improve performance.

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

<p align="center">
  <img src="https://raw.githubusercontent.com/babaganosch/open_storage/master/lights_0.png">
</p>

## Terminal
I've included a terminal for easy debugging. This is a great way to run commands runtime like spawning instances, changing variables or changing states of the game.

<p align="center">
  <img src="https://raw.githubusercontent.com/babaganosch/open_storage/master/terminal_0.gif">
</p>

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

## GameObjects
All non-GameSystem objects should inherit the parent GameObject class, or any ancestor to that. This will enable the object to update and render only when not outside view, and be controlled by the Game Controller instance. The ancestor Entity of GameObject contains some basic physics, and is will perform collision checks against the current world.

As stated above, GameObjects gets culled and deactivated when outside the camera view, and then re-activated again when back inside the view.

It is also possible to create sub-classes of the LiteGameObject struct. These objects is only structs and more lightweight for the engine to handle. This is a good choice when needing a great amount of objects of something with simple logic. For example, bullets, effects, bugs, whatever. LiteGameObjects are also culled by the Game Controller.

```gml
function Bullet(x, y, hspd, vspd) : LiteGameObject(x, y, spr_bullet) constructor
{
    static update = function(delta)
    {
        x += hspd * delta; y += vspd * delta;
        if (x < 0 || x > room_width || y < 0 || y > room_height)
        {
            destroy();
        }
    }
}

function SmokeEffect(x, y) : AnimatedLiteGameObject(x, y, spr_smoke) constructor
{
    static update = function(delta)
    {
        var last_frame = image_index;
        animate(delta);
        alpha -= 0.1 * delta;
        if (image_index < last_frame)
        {
            destroy();
        }
    }
}
```

## Game Controller
This system object currently controls the culling and sorting of game objects. The behaviour of the Game Controller is split up between some couple of frames, to even out the load and improve performance. All GameController events is put into UserEvents of the GameController, and expressed as an enum value. It is of course possible to run more then one event per frame, but the important task is balance. You do not want to utilize high percentage of the CPU on one frame, and then 0% on the next frame.

The following example will run GameObject culling on first frame. Sorting the draw order of the objects in the second frame. Culling of the LiteGameObjects in the third frame and finally sorting the draw order of the GameObjects and updating something important on the fourth frame. And then repeat.

```gml
enum GC_EVENT {
    OBJECT_CULLING = 0,
    OBJECT_SORTING = 1,
    LITE_OBJECT_CULLING = 2,
    UPDATE_SOMETHING_IMPORTANT = 3
}

frame_events[0] = [ GC_EVENT.OBJECT_CULLING ];
frame_events[1] = [ GC_EVENT.OBJECT_SORTING ];
frame_events[2] = [ GC_EVENT.LITE_OBJECT_CULLING ];
frame_events[3] = [ GC_EVENT.OBJECT_SORTING, GC_EVENT.UPDATE_SOMETHING_IMPORTANT ];
```

Another thing that the Game Controller does is handle the rendering of all the GameObjects. The rendering order (depth value) is based on the y value of the GameObject. But instead of being drawn on different layers, as with the usual `depth = -y;`, every object are rendered in the same layer and no overhead of creating new layers per y-value is required.

<p align="center">
  <img src="https://raw.githubusercontent.com/babaganosch/open_storage/master/culling_0.gif">
</p>

## Notes
The project also contains some other convenient stuff, like singleton keywords, easy memory cleanup for persistent objects, stress-test macro and easy logging functionality.

There is __A LOT__ of areas of improvement in this project. Most of the modules, and code, is simply copy-pasted from my prior projects. For example, I think that the terminal module should be reworked from scratch. Game size is currently hardcoded in a very ugly way. I'm not sure but I suspect rendering objects with shaders will cause a lot of unnecessary batch breaking. The code could be commented much better as well.

Light system should probably be implemented as rgba16f surfaces and blurring shaders could be dropped, when available on master release of GMS.
