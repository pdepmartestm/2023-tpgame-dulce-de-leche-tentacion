class Scene {
    method load()

    method remove() {
        game.allVisuals().forEach({visual => visual.remove()})
    }
}