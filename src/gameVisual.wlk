// Any visual that can collide should inherit this class
// This way, we can define commonn behaviours between them
class GameVisual {
    const property name = ""

    method whenCollided(value) {
       
    }

    // Every game object should have a definition when another objects collides with him
    method onCollideDo(visual) {
        
    }
}