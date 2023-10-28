import ui.* 
import _utils.* 
import gameLoop.*
import enemies.index.waveManager
import wollok.game.*

class Enemy {
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

    method getDamaged(value) {
        health -= value
        if(health <= 0) {
            self.die()
        }
    }

    method die() {
        waveManager.destroyEnemy(self)
        gameLoop.remove("enemy_move" + id)
    }  
}

/* class EnemyBullet {
    var property position
    const id = utils.generateRandomId()
    const speed
    const damage
    const property image

    method init() {
        game.addVisual(self)
        gameLoop.add("enemy_bullet" + id, {self.move()})
    }   
    
    method move() 

    method collision() {
        game.whenCollideDo(self, {visual => {
            visual.getDamaged(damage)
        }})
    }
} */