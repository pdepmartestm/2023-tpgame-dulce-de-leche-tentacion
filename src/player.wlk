import gameLoop.*
import sceneManager.*
import _scheduler.*
import _utils.*
import bullet.*
import gameVisual.*
import ui.*
import constants.*

object playerGunNames {
    const property names = new Dictionary() 

//pensarlo como que cada personaje sabe las armas que tiene
    method setGunsNames() {
        if(player.selectedPlayer() == "massa") {
            names.put("shotgun", PLAYER_GUNS.massa.shotgun())
            names.put("scar", PLAYER_GUNS.massa.scar())
            names.put("heavy", PLAYER_GUNS.massa.heavy())
        }
        else {
            names.put("shotgun", PLAYER_GUNS.milei.shotgun())
            names.put("scar", PLAYER_GUNS.milei.scar())
            names.put("heavy", PLAYER_GUNS.milei.heavy())
        }
    }
}

class Gun {
    const property name
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
            new PlayerBullet(position = player.position().right(10), speed = 9, vxScaler = SCALERS.shotgunScalers.vx(), vyScaler = SCALERS.shotgunScalers.vy(), damage = 40, image_name = "multiple.png").init()
            new PlayerBullet(position = player.position().right(10), speed = 9, damage = 40, image_name = "multiple.png").init()
            new PlayerBullet(position = player.position().right(10), speed = 9, vxScaler = SCALERS.shotgunScalers.vx(), vyScaler = -SCALERS.shotgunScalers.vy(), damage = 40, image_name = "multiple.png").init()
            game.sound(player.selectedPlayer() + "/multiple.mp3").play()
        })
    }
}
object heavy inherits Gun(magazine = 10, weight = 20, name = "heavy", bulletsLeft = 10, delayBetweenShots = 1000) {
    override method shoot(x) {
        super({new PlayerBullet(position = player.position().right(10), speed = 7, damage = 100, image_name = "heavy-bullet.png").init()
        game.sound(player.selectedPlayer()+"/heavy.mp3").play()})
    }
}

object scar inherits Gun(magazine = 30, weight = 10, name = "scar", bulletsLeft = 30, delayBetweenShots = 500) {
    override method shoot(x) {
        super({new PlayerBullet(position = player.position().right(10),  speed = 15, damage = 20, image_name = "fast-bullet.png").init()
        game.sound(player.selectedPlayer()+"/fast.mp3").play()})
    }
}

object player inherits GameVisual(name = "player") {
    var property selectedPlayer = players.get(index)
    const players = ["massa", "milei"]
    var property weapon = scar
    var index = 0
    const speed = 30 / weapon.weight()
    var isMovingUp = false
    var property health = 100
    var property position = game.at(0, 400)
    method image() = selectedPlayer  + "/player.png"

    method init() {
        game.addVisual(self)
        game.addVisual(new BulletsUI (weapon = scar, position = game.at((game.width() / 2) - 100, game.height() - 75)))
        game.addVisual(new BulletsUI (weapon = heavy, position = game.at((game.width() / 2) - 240, game.height() - 75)))
        game.addVisual(new BulletsUI (weapon = shotgun, position = game.at((game.width() / 2) + 20, game.height() - 75)))
        playerGunNames.setGunsNames()
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
        keyboard.num1().onPressDo({weapon = scar})
        keyboard.num2().onPressDo({weapon = heavy})
        keyboard.num3().onPressDo({weapon = shotgun})
    }

    method shoot() {
        weapon.shoot("")
    }

    method die() {
        sceneManager.load(defeat) 
    }
    method changeCharacter(){
        if(selectedPlayer == players.last()){ // Hacemos así porque no anda length
            index = 0
            selectedPlayer = players.get(index)
        }
        else {
            index += 1
            selectedPlayer = players.get(index)
        }
    }
}


class BulletsUI inherits GameVisual(name = "bulletsUI") {
    const weapon
    const property position
    
    method text() = playerGunNames.names().get(weapon.name()) + ": " + weapon.bulletsLeft()
    method textColor() = COLORS.gold
}