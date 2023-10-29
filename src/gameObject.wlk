// Any visual that can collide should inherit this class
// This way, we can define commonn behaviours between them
class GameObject {
    const property name

    // Every game object should have a definition when another objects collides with him
    method whenCollided(value) {}
}