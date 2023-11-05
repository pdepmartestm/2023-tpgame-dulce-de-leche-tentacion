import Scenes._index.*
import Scenes._scenes.*
import Engine._gameVisual.*
import Player._guns.*
import _ui.*


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

    override method onStart() {
        playerGunNames.setGunsNames()
        new BulletsUI (weapon = scar, position = game.at((game.width() / 2) - 100, game.height() - 75)).load()
        new BulletsUI (weapon = heavy, position = game.at((game.width() / 2) - 240, game.height() - 75)).load()
        new BulletsUI (weapon = shotgun, position = game.at((game.width() / 2) + 20, game.height() - 75)).load()
        new HealthBar(parent = self, yOffset = 20, xOffset = -14).load()
        self.setupControls()
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

    override method onUpdate() {
        self.move()
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


