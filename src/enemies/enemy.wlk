import ui.* 
import _utils.* 
import gameLoop.*
import enemies.index.waveManager
import gameVisual.*
import player.*
import _scheduler.*

class Enemy inherits GameVisual(name = "enemy") {
    const speed
    const attackInterval
    const attackId = "attack" + id
    const moveId = "enemy_move" + id
    var property isAlive = true
    const image_name
    const property image = player.selectedPlayer() + "/" + image_name
    var property position = utils.getRandomPosOutOfScreenRight()
    var property health = 100
    const healthBar = new HealthBar(parent = self, yOffset = 20, xOffset = -20)

    method init() {
        game.addVisual(self)
        healthBar.init()
        gameLoop.add(moveId, {self.move()})
        scheduler.every(attackInterval, attackId, {self.attack()})
    }

    method stopMoving() {
        gameLoop.remove(moveId)
    }

    method attack()

    method move()


    method whenCollided(value) {
        health -= value
        if(health <= 0) {
            self.die()
        }
    }

    method die() {
        waveManager.destroyEnemy()
        healthBar.remove()
        gameLoop.remove(moveId)
        scheduler.stop(attackId)
        self.stopMoving()
        game.removeVisual(self)
    }  

    override method remove() {
        super()
        gameLoop.remove(moveId)
        scheduler.stop(attackId)
        self.stopMoving()
    }
}

