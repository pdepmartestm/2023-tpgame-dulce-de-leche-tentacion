import gameLoop.*
import sceneManager.*
import _scheduler.*
import _utils.*
import constants.*
import bullet.*
import gameVisual.*
import ui.*

class Gun {
    const property name
    const property weight
    var property magazine
    var property bulletsLeft = magazine
    const delayBetweenShots
    var shouldShoot = true

    method shoot(fn) {
        if(!shouldShoot || bulletsLeft <= 0) return null
        else {
            shouldShoot = false
            scheduler.schedule(delayBetweenShots, {shouldShoot = true})
            bulletsLeft -=  1
            fn.apply()
        }
    }
}

class PlayerBullet inherits Bullet {
    method onCollideDo(visual) {
        if(visual.name() ==  "enemy") {
            visual.whenCollided(damage)
            self.remove()
        }
    }  
}

object shotgun inherits Gun(magazine = 10, weight = 12, name = "shotgun", bulletsLeft = 15, delayBetweenShots = 500) {
    override method shoot(x) {
        super({
            new PlayerBullet(position = player.position().right(10), speed = 5, vxScaler = SCALERS.shotgunScalers.vx(), vyScaler = SCALERS.shotgunScalers.vy(), damage = 40, image_name = "multiple.png").init()
            new PlayerBullet(position = player.position().right(10), speed = 5, damage = 40, image_name = "multiple.png").init()
            new PlayerBullet(position = player.position().right(10), speed = 5, vxScaler = SCALERS.shotgunScalers.vx(), vyScaler = -SCALERS.shotgunScalers.vy(), damage = 40, image_name = "multiple.png").init()
            game.sound(player.selectedPlayer()+"/multiple.mp3").play()
        })
    }
}
object heavy inherits Gun(magazine = 10, weight = 20, name = "heavy", bulletsLeft = 10, delayBetweenShots = 1000) {
    override method shoot(x) {
        super({new PlayerBullet(position = player.position().right(10), speed = 4, damage = 100, image_name = "heavy-bullet.png").init()
        game.sound(player.selectedPlayer()+"/heavy.mp3").play()})
    }
}

object scar inherits Gun(magazine = 30, weight = 10, name = "scar", bulletsLeft = 30, delayBetweenShots = 500) {
    override method shoot(x) {
        super({new PlayerBullet(position = player.position().right(10),  speed = 8, damage = 20, image_name = "fast-bullet.png").init()
        game.sound(player.selectedPlayer()+"/fast.mp3").play()})
    }
}

object player inherits GameVisual(name = "player") {
    var property selectedPlayer = "massa"
    var property weapon = scar
    const speed = 30 / weapon.weight()
    var isMovingUp = false
    var property health = 100
    var property position = game.at(0, 400)
    method image() = selectedPlayer  + "/player.png"
    
    method init() {
        game.addVisual(self)
        game.addVisual(new BulletsUI (weapon = heavy, position = game.at(game.width() - 100, 20)))
        game.addVisual(new BulletsUI (weapon = scar, position = game.at(game.width() - 150, 20)))
        game.addVisual(new BulletsUI (weapon = shotgun, position = game.at(game.width() - 200, 20)))
        new HealthBar(parent = self, yOffset = 20, xOffset = -14).init()
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

    override method whenCollided(value) {
        health -= value
        if(health <= 0) self.die()
    }

    method setupControls() {
        keyboard.w().onPressDo({isMovingUp = true})
        keyboard.s().onPressDo({isMovingUp = false})
        keyboard.space().onPressDo({self.shoot()})
        keyboard.i().onPressDo({weapon = scar})
        keyboard.o().onPressDo({weapon = heavy})
        keyboard.p().onPressDo({weapon = shotgun})
    }

    method shoot() {
        weapon.shoot("")
    }

    method die() {
        sceneManager.load(defeat) 
    }
}


class BulletsUI inherits GameVisual(name = "bulletsUI") {
    const weapon
    const property position
    
    method text() = "Bullets: " + weapon.bulletsLeft() + "/" + weapon.magazine()
    method textColor() = "#FFF"
}