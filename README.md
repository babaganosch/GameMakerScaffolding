<h1 align="center">GMS 2.3+ GameMaker Scaffolding | v1.0.0</h1>
<p align="center"><a href="https://twitter.com/Babaganosch">@babaganosch</a></p>
<p align="center">Download: <a href=".">latest</a></p>

---

**GameMaker Scaffolding** is a template project for GameMaker Studio 2.3, focusing on 2D tile-based world games. The reason for this template is to facilitate new projects for me, and possibly others, as I grew tierd of simply copy-pasting basic stuff from prior projects each time I wanted to test something new.

Setup is easy. Just download the template .yyz file and create a new project by executing it.

Features included:
* Rendering system - double buffered rendering for post fx and shader programs as structs.
* Notification system - a signal framework for easy observer pattern implementation, and a great way to decouple objects.
* Timing module - enabling easy implementations of delta time updates, profiling and an alarm system based on real time instead of frames.
* ParticleSystem wrapper, for easy particle systems setup and allowing particles to update based on delta time.
* Lighting system - lightweight 2D light engine with vivid lights based on sprites or shapes.
* Terminal module - a lightweight debugging console for easy input/output during runtime, with easy to setup commands.
* World module - worlds, or levels, described as scructs with tilemaps and fast collision checking.
* GameObjects and LiteGameObjects - the ability to create and diffirentiate between real GameMaker objects and liteweight objects based on structs.
* GameController module - Controlls object culling, sorting and overall behaviour of the game.
