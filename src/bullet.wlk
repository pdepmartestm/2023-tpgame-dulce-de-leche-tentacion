import _utils.*
import gameLoop.*
import player.*

class Bullet {
    var property position
    const id = utils.generateRandomId()
    const speed
    const damage
    const vxScaler = 1
    const vyScaler = 0
    const image_name
    const property image = player.selectedPlayer() + "/" + image_name

    method init() {
        game.addVisual(self)
        gameLoop.add("bullet" + id, {self.move()})
        game.onCollideDo(self, {visual => visual.getDamaged(damage)})
    }   
    
    method move() {
       if(position.x() >= game.width() + 50 || position.x() <= -20) {
            game.removeVisual(self)
            gameLoop.remove("bullet" + id)
        } 
        position = position.right(vxScaler*speed).up(vyScaler*speed)
    }

    method getDamaged() {      

    }
}

