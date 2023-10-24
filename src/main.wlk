import player.*
import gameLoop.*
import enemies.index.*
import wollok.game.*
import sceneManager.*

object gameManager {
    method start() {
        game.width(600)
        game.height(800)
        game.cellSize(1)
        game.boardGround("background.png")
        game.start()
        sceneManager.menu()
        gameLoop.start()
    }
}