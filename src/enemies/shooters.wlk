import enemies.enemy.*
import _utils.*
import enemies.index.*
import gameLoop.*
import _scheduler.*
import player.*
import bullet.*

class Shooter inherits Enemy {
    const moveUntil
    
    override method move() {
        position = position.left(speed)
        if(position.x() <= game.width() - moveUntil) {
            self.stopMoving()
            self.attack()
        }
    }
}

class EnemyBullet inherits Bullet {
    override method onCollideDo(visual) {
        console.println(visual.name())
        if(visual.name() == "player") {
            visual.whenCollided()
            self.remove()
        }
    }
}

class Sniper inherits Shooter(image_name = "sniper.png", speed = 4,  moveUntil = 150) {
    override method attack() {
        // From the cinematic equations of the player and bullet we can solve the y velocity in order to hit the player
        // I guess cinematcis were important after all...
        const vyScaler = -(player.position().y() - position.y()) / ((player.position().x() - position.x()) / 5)
        new EnemyBullet (damage = 25, speed = 1, image_name = "sniper_bullet.png", vyScaler = vyScaler, vxScaler = -3, position = position.left(10)).init()
        scheduler.schedule(3000, {self.attack()})
    }
}

// They only shoot ahead, witouth pointing to the player
class Turret inherits Shooter(image_name = "turret.png", speed = 4, moveUntil = 200) {
    override method attack() {
        new EnemyBullet (damage = 25, speed = 2, vxScaler = -1, image_name = "turret_bullet.png", position = position.left(10))
        scheduler.schedule(2000, {self.attack()})
    }
}

