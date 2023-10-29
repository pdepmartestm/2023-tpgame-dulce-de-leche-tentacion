import player.*
import gameLoop.*
import wollok.game.*
import sceneManager.*

object gameManager {
    method start() {
        game.width(1366)
        game.height(768) //es esta la mejor proporción para jugar? no es mejor en 4:3 de manera horizontal?
        game.cellSize(10)
        game.start()
        sceneManager.load(menu)
    }
}