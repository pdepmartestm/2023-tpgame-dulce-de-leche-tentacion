import ui.* 
import _utils.* 
import gameLoop.*
import enemies.index.waveManager
import gameVisual.*
import player.*

class Enemy inherits GameVisual(name = "enemy") {
    const speed
    var isAlive = true
    const image_name
    const property image = player.selectedPlayer() + "/" + image_name
    var property position = utils.getRandomPosOutOfScreenRight()
    var property health = 100

    method init() {
        game.addVisual(self)
        new HealthBar(parent = self, yOffset = 20, xOffset = -5).init()
        gameLoop.add("enemy_move" + id, {self.move()})
    }

    method stopMoving() {
        gameLoop.remove("enemy_move" + id)
    }

    method move()

    method attack()

    method whenCollided(value) {
        health -= value
        if(health <= 0) {
            self.die()
        }
    }

    method die() {
        waveManager.destroyEnemy(self)
        gameLoop.remove("enemy_move" + id)
        isAlive = false
    }  
}

