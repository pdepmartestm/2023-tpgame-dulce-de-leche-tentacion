import enemies.index.*
import gameLoop.*
import player.*

//Aprovechar herencia

class Scene {
    method load()

    method remove() {
        game.allVisuals().forEach({visual => visual.remove()})
    }
}

object sceneManager {
    var currentScene = menu
    var property cancion = game.sound("massa/cancion.mp3")
    var property himno = game.sound("himno.mp3")
    
    method load(scene) {
        currentScene.remove()
        scene.load()
        currentScene = scene
    }
}

object menu inherits Scene {
    override method load() {
        game.boardGround("intro.png")
        sceneManager.himno(game.sound("himno.mp3"))
        sceneManager.himno().volume(0.3)
        sceneManager.himno().play()
        keyboard.h().onPressDo({sceneManager.load(howToPlay)})
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
    }
}

object main inherits Scene {
    override method load() {
        game.boardGround("background.png")
        sceneManager.cancion(game.sound(player.selectedPlayer() + "/cancion.mp3"))
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
        sceneManager.cancion().stop()
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
    }
}

object selectCharacter inherits Scene {
    var isMassa = true // ver de no usar la flag, y hacer para más personajes
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