import player.*
import gameLoop.*
import wollok.game.*
import sceneManager.*

object gameManager {
    method start() {
        game.width(1360)
        game.height(660) //es esta la mejor proporción para jugar? no es mejor en 4:3 de manera horizontal?
        game.cellSize(1)
        game.start()
        sceneManager.load(menu)
    }
}