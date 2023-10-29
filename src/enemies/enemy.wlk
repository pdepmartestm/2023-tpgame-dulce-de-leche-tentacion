import ui.* 
import _utils.* 
import gameLoop.*
import enemies.index.waveManager
import gameObject.*
import player.*

class Enemy inherits GameObject(name = "enemy") {
    const speed
    const image_name
    const property image = player.selectedPlayer() + "/" + image_name
    var property position = utils.getRandomPosOutOfScreenRight()
    var property health = 100
    const id = utils.generateRandomId()

    method init() {
        game.addVisual(self)
        new HealthBar(parent = self, yOffset = 20, xOffset = -5).init()
        // game.addVisual(new HealthBar(parent = self, upFromPos =  20))
        gameLoop.add("enemy_move" + id, {self.move()})
    }

    method stopMoving() {
        gameLoop.remove("enemy_move" + id)
    }

    method move()

    method attack()

    method whenCollided(damage) {
        health -= damage
        if(health <= 0) {
            self.die()
        }
    }

    method die() {
        waveManager.destroyEnemy(self)
        gameLoop.remove("enemy_move" + id)
    }  
}

