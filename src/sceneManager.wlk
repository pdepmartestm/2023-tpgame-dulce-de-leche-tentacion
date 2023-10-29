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
        game.boardGround("intro.png")
        sceneManager.himno().play()
        keyboard.h().onPressDo({sceneManager.load(howToPlay)})
        keyboard.enter().onPressDo({sceneManager.load(main)})
    }
}

object main inherits Scene {
    override method load() {
        game.boardGround("background.jpg")
        sceneManager.himno().pause()
        game.sound(player.selectedPlayer()+"/cancion.mp3").play()
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
    var massa = true
    override method load() {
        game.boardGround("seleccion-massa.png")
        keyboard.left().onPressDo({self.changeCharacter()})
        keyboard.right().onPressDo({self.changeCharacter()})
        keyboard.a().onPressDo({self.run()})
    }
    method changeCharacter() {
        massa = !massa
        if(massa){
            game.boardGround("seleccion-massa.png")
        }
        else{
            game.boardGround("seleccion-milei.png")
        }
    }
    method run(){
        if(massa){
            player.selectedPlayer("massa")
        }
        else{
            player.selectedPlayer("milei")
        }
        sceneManager.load(main)
    }
}

object sceneManager {
    var currentScene = menu
    const property himno = game.sound("himno.mp3")

    method load(scene) {
        currentScene.remove()
        scene.load()
        currentScene = scene
    }
}