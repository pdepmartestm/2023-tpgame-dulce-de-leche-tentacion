import enemies.index.*
import gameLoop.*
import player.*

class Scene {
    method load()

    method remove() {
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
    }
}

object menu inherits Scene {
    override method load() {
        game.boardGround("menu.png")
        keyboard.enter().onPressDo({sceneManager.load(main)})
        keyboard.h().onPressDo({sceneManager.load(howToPlay)})
    }
}

object main inherits Scene {
    override method load() {
        game.boardGround("background.png")
        gameLoop.start()
        player.init()
        waveManager.init()
    }
}

object howToPlay inherits Scene {
    override method load() {
        // poner el howToPlay, explicado en objeto menú
    }

}

object gameOver inherits Scene {
    override method load() {
        
    }
}

object sceneManager {
    var currentScene = menu

    method load(scene) {
        currentScene.remove()
        scene.load()
        currentScene = scene
    }
}