import _utils.*
import gameLoop.*

class Bullet {
    var property position
    const id = utils.generateRandomId()
    const speed
    const damage
    const vxScaler = 1
    const vyScaler = 0
    const property image

    method init() {
        game.addVisual(self)
        gameLoop.add("player_bullet_move" + id, {self.move()})
        game.onCollideDo(self, {visual => visual.getDamaged(damage)})
    }   
    
    method move() {
       if(position.x() >= game.width() + 50) {
            game.removeVisual(self)
            gameLoop.remove("player_bullet_move" + id)
        } 
        position = position.right(vxScaler*speed).up(vyScaler*speed)
    }

    method getDamaged() {      

    }
}

