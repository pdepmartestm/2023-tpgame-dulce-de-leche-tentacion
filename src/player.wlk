import gameLoop.*
import sceneManager.*
import _scheduler.*
import _utils.*
import constants.*
import bullet.*
import ui.*

class Gun {
    const property name
    const property weight
    var property bulletsLeft
    const delayBetweenShots
    var shouldShoot = true

    method shoot(fn) {
        if(!shouldShoot || bulletsLeft <= 0) return null
        else {
            shouldShoot = false
            scheduler.schedule(delayBetweenShots, {shouldShoot = true})
            bulletsLeft -=  1
            const audio = game.sound("polentaa.mp3")
            audio.play()
            fn.apply()
        }
    }
}

object shotgun inherits Gun(weight = 12, name = "shotgun", bulletsLeft = 15, delayBetweenShots = 500) {
    override method shoot(x) {
        super({
            new Bullet(position = player.position(), speed = 5, vxScaler = SCALERS.shotgunScalers.vx(), vyScaler = SCALERS.shotgunScalers.vy(), damage = 40, image = "heavy-bullet.png").init()
            new Bullet(position = player.position(), speed = 5, damage = 40, image = "heavy-bullet.png").init()
            new Bullet(position = player.position(), speed = 5, vxScaler = SCALERS.shotgunScalers.vx(), vyScaler = -SCALERS.shotgunScalers.vy(), damage = 40, image = "heavy-bullet.png").init()
        })
    }
}
object sniper inherits Gun(weight = 20, name = "sniper", bulletsLeft = 10, delayBetweenShots = 1000) {
    override method shoot(x) {
        super({new Bullet(position = player.position(), speed = 4, damage = 100, image = "heavy-bullet.png").init()})
    }
}
object scar inherits Gun(weight = 10, name = "scar", bulletsLeft = 30, delayBetweenShots = 500) {
    override method shoot(x) {
        super({new Bullet(position = player.position(),  speed = 8, damage = 20, image = "fast-bullet.png").init()})
    }
}

object player {
    var property weapon = shotgun
    const speed = 30 / weapon.weight()
    var isMovingUp = false
    var property health = 100
    var property position = game.at(0, 400)
    method image() = "player.png"
    
    method init() {
        game.addVisual(self)
        new HealthBar(parent = self, yOffset = 20, xOffset = -5).init()
        self.setupControls()
        gameLoop.add("player_move", {self.move()})
    } 

    method move() {
        if(isMovingUp) {
            if(position.y() >= game.height())
                isMovingUp = false
            position = position.up(speed)
        }
        else {
            if(position.y() <= 0)  
                isMovingUp = true
            position = position.down(speed)    
        }
    }

    method getDamaged(damage) {
        health -= damage
        if(health <= 0) self.die()
    }

    method setupControls() {
        keyboard.w().onPressDo({isMovingUp = true})
        keyboard.s().onPressDo({isMovingUp = false})
        keyboard.space().onPressDo({self.shoot()})
    }

    method shoot() {
        weapon.shoot("")
    }

    method die() {
        game.stop()
        sceneManager.load(gameOver) //TODO make gameOver in main
    }
}


// ============== UI ================
class UI{
    const weapon
    const property position

    method text() = "Bullets: " + weapon.bulletsLeft()
    method textColor() = "#FFF"
}