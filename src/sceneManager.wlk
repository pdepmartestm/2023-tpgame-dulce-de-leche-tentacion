import enemies.index.*
import gameLoop.*
import player.*

class Scene {
    method load()

    method remove() {
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
    }
}

object sceneManager {
    var currentScene = menu
    var property cancion = game.sound(player.selectedPlayer()+"/cancion.mp3")
    const property himno = game.sound("himno.mp3")
    method load(scene) {
        currentScene.remove()
        scene.load()
        currentScene = scene
    }
}

object menu inherits Scene {
    override method load() {
        game.boardGround("intro.png")
        sceneManager.himno().play()
        keyboard.h().onPressDo({sceneManager.load(howToPlay)})
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
    }
}

object main inherits Scene {
    override method load() {
        game.boardGround("background.png")
        sceneManager.himno().pause()
        sceneManager.cancion().volume(0.2)
        sceneManager.cancion().play()
        gameLoop.start()
        player.init()
        waveManager.init()
    }
}

object howToPlay inherits Scene {
    override method load() {
        game.boardGround("how-to-play.png")
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
    }
}

object win inherits Scene{
    override method load() {
        game.boardGround(player.selectedPlayer()+"/win.png")
        sceneManager.cancion().stop()
        sceneManager.himno().play()
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
    }
}

object defeat inherits Scene {
    override method load() {
        game.boardGround(player.selectedPlayer()+"/defeat.png")
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
    }
}

object selectCharacter inherits Scene {
    var isMassa = true
    override method load() {
        game.boardGround("seleccion-massa.png")
        keyboard.left().onPressDo({self.changeCharacter()})
        keyboard.right().onPressDo({self.changeCharacter()})
        keyboard.a().onPressDo({self.run()})
    }
    method changeCharacter() {
        isMassa = !isMassa
        if(isMassa){
            game.boardGround("seleccion-massa.png")
        }
        else{
            game.boardGround("seleccion-milei.png")
        }
    }
    method run(){
        if(isMassa){
            player.selectedPlayer("massa")
        }
        else{
            player.selectedPlayer("milei")
        }
        sceneManager.load(main)
    }
}