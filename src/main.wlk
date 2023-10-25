import player.*
import gameLoop.*
import enemies.index.*
import wollok.game.*
import sceneManager.*

object gameManager {
    method start() {
        game.width(600)
        game.height(800) //es esta la mejor proporción para jugar? no es mejor en 4:3 de manera horizontal?
        game.cellSize(1)
        game.boardGround("background.png") //esta línea es mejor que esté en las escenas
        game.start()
        //gameLoop.start()
        sceneManager.load(menu)
    }
}