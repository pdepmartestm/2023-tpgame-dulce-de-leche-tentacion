import enemies.enemy.*
import main.gameManager
import player.*
import _scheduler.*

class Melee inherits Enemy(speed = 5, health = 50, image_name = "melee.png", attackInterval = 5000) { 
    const damage = 5
    var shouldAttack = false 
    var shouldMoveOnY = true
    var moveOnY = speed

    override method attack() {
        if(position.distance(player.position()) <= 150) {
            position = position.left(100)
            scheduler.schedule(200, {position = position.right(100)})
        }
        return null
    }

    method onCollideDo(visual) {
        if(visual.name() == "player")
            visual.whenCollided(damage)
    }

    method moveY() {
        const isPlayerOnTop = player.position().y() >= position.y()
        var yToMove = speed
        if(!isPlayerOnTop) yToMove = -1 * yToMove
        position = position.up(yToMove)
        moveOnY = yToMove
        shouldMoveOnY = false
        scheduler.schedule(500, {shouldMoveOnY = true})
    }

    override method move() {
        if(position.x() >= 100) 
            position = position.left(speed)
        if(shouldMoveOnY)
            self.moveY()
        else 
            position = position.up(moveOnY)
    }
}