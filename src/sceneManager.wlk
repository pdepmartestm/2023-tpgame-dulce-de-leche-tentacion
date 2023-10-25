import enemies.index.*
import gameLoop.*
import player.*

class Scene {
    method load() {
        self.loadVisuals()
        self.setupControls()
    }

    method loadVisuals() {}

    /* method remove() {
        //Removes all visuals
    } */

    method setupControls() {}
}

object menu inherits Scene {
    override method loadVisuals() {
        game.boardGround("menu.png")
        keyboard.space().onPressDo({sceneManager.load(main)})
        // hacer que al apretar la tecla H o ESC, te mande al How To Play
    }
}

object main inherits Scene {
    override method loadVisuals() {
        game.boardGround("background.png")
        gameLoop.start()
        player.init()
        waveManager.init()
    }
}

object howToPlay inherits Scene {
    override method loadVisuals() {
        // poner el howToPlay, explicado en objeto menú
    }
}

object sceneManager {
    var currentScene = menu

    method load(scene) {
        //currentScene.remove() después lo ponemos, ahora esto jode
        currentScene = scene
        currentScene.load()
    }
}