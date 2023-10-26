import gameLoop.*

// Bullets
class Bullet {
    var property position = game.center()
    const speed = 6
    const property weight = 8
    const property image = "bullet.png"
    const id

    method init() {
        game.addVisual(self)
        gameLoop.add("player_bullet_move" + id, {self.move()})
    }   
    
    method move() {
        if(position.x() >= game.width() + 50) {
            game.removeVisual(self)
            gameLoop.remove("player_bullet_move" + id)
        }
        position = position.right(speed)
    }
}

class FastBullet inherits Bullet(speed = 9, weight = 5, image = "bullet.png"){
}

class HeavyBullet inherits Bullet(speed = 3, weight = 10, image = "heavy-bullet.png"){
}

object fastWeapon{
    var property bulletsLeft = 20
    var property weight = 5

    method shoot() {
        bulletsLeft -= 1
    }
}

object heavyWeapon{
    var property bulletsLeft = 10
    var property weight = 10

    method shoot() {
        bulletsLeft -= 1
    }
}

// Objects
object player {
    var property weapon = fastWeapon
    const speed = 30 / weapon.weight()

    var isMovingUp = false
    var property health = 100
    var bulletNumber = 0
    
    var property position = game.at(0, 400)
    method image() = "player.png"
    
    method init() {
        game.addVisual(self)
        game.addVisual(new UI (weapon = heavyWeapon, position = game.at(game.width() - 100, 20)))
        game.addVisual(new UI (weapon = fastWeapon, position = game.at(game.width() - 150, 20)))
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
        keyboard.o().onPressDo({weapon = fastWeapon})
        keyboard.p().onPressDo({weapon = heavyWeapon})
    }

    method generateBullets (){
        if(weapon == fastWeapon){
            const bullet = new FastBullet(position = position, id = bulletNumber)
            bulletNumber += 1
            bullet.init()
        }
        else {
            const bullet = new HeavyBullet(position = position, id = bulletNumber)
            bulletNumber += 1
            bullet.init()
        }
    }

    method shoot() {
        if(weapon.bulletsLeft() > 0) {
            self.generateBullets()
            weapon.shoot()
            }
        }

    method die() {
        game.stop()
        // game.addVisual(gameOver) //TODO make gameOver in main
    }
}


// ============== UI ================
class UI{
    const weapon
    const property position

    method text() = "Bullets: " + weapon.bulletsLeft()
    method textColor() = "#FFF"
}