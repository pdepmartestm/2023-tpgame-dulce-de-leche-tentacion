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
        game.boardGround("menu.png")
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
    }

}

object gameOver inherits Scene {
    override method load() {
        game.boardGround("menu.png")
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
        keyboard.r().
    }
}

object selectCharacter inherits Scene {
    override method load() {
        keyboard.n().onPressDo({
            sceneManager.candidato("massa")
            sceneManager.load(main)})
        keyboard.m().onPressDo({
            sceneManager.candidato("milei")
            sceneManager.load(main)})
    }

}

object sceneManager {
    var currentScene = menu
    var property candidato = "massa"

    method load(scene) {
        currentScene.remove()
        scene.load()
        currentScene = scene
    }
}