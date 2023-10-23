import gameLoop.*

// Bullets
class Bullet {
    var property position = game.center()
    var speed = 5
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

class FastBullet inherits Bullet{
    var property image = "bullet.png"
    var property weight = 5
}

class HeavyBullet inherits Bullet{
    var property image = "heavy-bullet.png"
    var property weight = 10
}

object FastWeapon{
    var property bullet = "Fast"
    var property bulletsLeft = 20
    var property weight = 5
}

object HeavyWeapon{
    var property bullet = "Heavy"
    var property bulletsLeft = 10
    var property weight = 10
}

// Objects
object player {
    var property weapon = FastWeapon
    var property bulletsLeft = weapon.bulletsLeft()
    var property bulletType = weapon.bullet()
    var speed = 30/ weapon.weight()

    var isMovingUp = false
    var property health = 100
    var bulletNumber = 0
    
    var property position = game.at(0, 400)
    method image() = "player.png"
    
    method init() {
        game.addVisual(self)
        game.addVisual(playerBulletsUI)
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
        /* keyboard.o().onPressDo({weapon(FastWeapon)})
        keyboard.p().onPressDo({weapon(HeavyWeapon)}) */
    }

    method shoot() {
        if(bulletsLeft > 0) {
            if(bulletType == "Fast"){
                const bullet = new FastBullet(position = position, id = bulletNumber)
                bulletNumber += 1
                bullet.init()
                playerBulletsUI.bullets(bulletsLeft)
                weapon.bulletsLeft(bulletsLeft -1)
            }
            if(bulletType == "Heavy"){
                const bullet = new HeavyBullet(position = position, id = bulletNumber)
                bulletNumber += 1
                bullet.init()
                playerBulletsUI.bullets(bulletsLeft)
                weapon.bulletsLeft(bulletsLeft -1)
            }
            else{
                throw new Exception(message = "No hay arma que encuadre")
            }
        }
    }

    method die() {
        game.stop()
        // game.addVisual(gameOver) //TODO make gameOver in main
    }
}


// ============== UI ================
object playerBulletsUI {
    var property bullets = player.bulletsLeft()
    method position() = game.at(game.width() - 100, 20)
    method message() = "Bullets: " + player.bulletsLeft()
    method text() = "Bullets: " + player.bulletsLeft()
}

