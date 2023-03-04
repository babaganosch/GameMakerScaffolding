event_inherited();

physics = {
    velocity: [0, 0],  // Current velocity of the entity
    force: [0, 0],     // Where the entity wants to go, input applied here for example
    acceleration: 0.3, // 
    friction: 0.3,     //
    collision: false   // Tells if the entity has collided with a WALL this frame
};
