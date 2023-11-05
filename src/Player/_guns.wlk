import Engine._scheduler.*
import Engine._gameVisual.*
import Player._index.*
import _ui.*
import Common._bullet.*
import _constants.*

class Gun {
    const property name = {}
    const property weight
    var property magazine
    var property bulletsLeft = magazine
    const delayBetweenShots
    var shouldShoot = true

    method shoot(fn) {
        if(shouldShoot || bulletsLeft > 0){
            shouldShoot = false
            scheduler.schedule(delayBetweenShots, {shouldShoot = true})
            bulletsLeft -=  1
            fn.apply()
        }
    }
}

class PlayerBullet inherits Bullet {
    override method onCollideDo(visual) {
        if(visual.name() === "enemy") {
            visual.whenCollided(damage)
            self.remove()
        }
    }  
}

class BulletsUI inherits GameVisual(name = "bulletsUI") {
    const weapon
    const property position

    method text() = weapon.name().apply() + ": " + weapon.bulletsLeft()
    method textColor() = COLORS.gold
}


// ============ Guns definitions ============
object shotgun inherits Gun(magazine = 10, weight = 12, name = {player.selectedPlayer().shotgun()}, bulletsLeft = 15, delayBetweenShots = 500) {
    override method shoot(x) {
        super({
            new PlayerBullet(position = player.position().right(10), speed = 9, vxScaler = SCALERS.shotgunScalers.vx(), vyScaler = SCALERS.shotgunScalers.vy(), damage = 40, image_name = "multiple.png").load()
            new PlayerBullet(position = player.position().right(10), speed = 9, damage = 40, image_name = "multiple.png").load()
            new PlayerBullet(position = player.position().right(10), speed = 9, vxScaler = SCALERS.shotgunScalers.vx(), vyScaler = -SCALERS.shotgunScalers.vy(), damage = 40, image_name = "multiple.png").load()
            game.sound(player.selectedPlayer().name()  + "/multiple.mp3").play()
        })
    }
}
object heavy inherits Gun(magazine = 10, weight = 20, name = {player.selectedPlayer().heavy()}, bulletsLeft = 10, delayBetweenShots = 1000) {
    override method shoot(x) {
        super({new PlayerBullet(position = player.position().right(10), speed = 7, damage = 100, image_name = "heavy-bullet.png").load()
        game.sound(player.selectedPlayer().name() +"/heavy.mp3").play()})
    }
}

object scar inherits Gun(magazine = 30, weight = 10, name = {player.selectedPlayer().scar()}, bulletsLeft = 30, delayBetweenShots = 500) {
    override method shoot(x) {
        super({new PlayerBullet(position = player.position().right(10),  speed = 15, damage = 20, image_name = "fast-bullet.png").load()
        game.sound(player.selectedPlayer().name() +"/fast.mp3").play()})
    }
}