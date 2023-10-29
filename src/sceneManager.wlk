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
        keyboard.enter().onPressDo({sceneManager.load(main)})
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
        keyboard.r().onPressDo({sceneManager.load(selectCharacter)})
    }
}

object selectCharacter inherits Scene {
    override method load() {
        keyboard.n().onPressDo({
            player.selectedPlayer("massa")
            sceneManager.load(main)})
        keyboard.m().onPressDo({
            player.selectedPlayer("milei")
            sceneManager.load(main)})
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