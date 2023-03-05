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

# Timing module
Keeps tracks of gamespeed, delta time and timers. When working with delta time, the regular GameMaker-Alarms can be a troublesome as they are dependent on frame count and not real time. GameMaker has support for real-time timers with timesources, although I personally find them bulky and inconvenient. Especially when you need to pause some timers due to game being in a paused state.

Example usage:
```gml
/// Create event of something

// Create a local timer contained within the object.
timer = new AlarmSystem();

// This will print "Hello World!" every 200 milliseconds, periodically and contained within the object.
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
