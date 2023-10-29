import _utils.*
import gameLoop.*
import player.*
import gameObject.*

class Bullet inherits GameObject(name = "bullet"){
    const id = utils.generateRandomId()
    var property position
    const speed
    const damage
    const vxScaler = 1
    const vyScaler = 0
    const image_name
    const property image = player.selectedPlayer() + "/" + image_name

    method init() {
        game.addVisual(self)
        gameLoop.add("bullet" + id, {self.move()})
        game.whenCollideDo(self, {visual => self.onCollideDo(visual)})
    }   
    
    method move() {
       if(position.x() >= game.width() + 50 || position.x() <= -20) {
           self.remove()
        } 
        position = position.right(vxScaler*speed).up(vyScaler*speed)
    }

    method remove() {
        game.removeVisual(self)
        gameLoop.remove("bullet" + id)
    }

    method onCollideDo(visual) {
        self.remove()
    }
}

