
import Player._index.*
import _constants.PLAYER
import Enemies._index.*
import Scenes._index.*
import Engine._scene.*
import Engine._gameLoop.*


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
        player.load()
        waveManager.onStart()
    }

    override method remove() {
        super()
        gameLoop.stop()
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
    var index = 0
    override method load() {
        game.boardGround(player.selectedPlayer()+"/seleccion.png")
        keyboard.left().onPressDo({if(index != 0) index -= 1 self.changeCharacter()})
        keyboard.right().onPressDo({if(index < PLAYER.players.size() - 1) index += 1 self.changeCharacter()})
        keyboard.a().onPressDo({sceneManager.load(main)})
    }

    method changeCharacter() {
        player.changeCharacter(index)
        game.boardGround(player.selectedPlayer()+"/seleccion.png")
    }
}