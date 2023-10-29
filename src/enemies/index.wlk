import shooters.*
import melee.*
import player.*
import _scheduler.*
import gameVisual.*

// Wave functionality
// The wave system will be fairly simple, basically we are gonna create 3 different types of waves, each one with its own items and stuff
// Each wave will be selected randomly and its difficulty will vary based on the current wave 
class Wave {
    const property enemies = []
    const currentWave
    
    //This gets used to later check if the player take any damage, if not then we award him with health
    var playerHealthAtStartOfWave = 0

    method start(){
        playerHealthAtStartOfWave = player.health()
        self.spawnEnemies()
    } 
    
    method spawnEnemies()

    method onWaveFinish() {
        if(player.health() == playerHealthAtStartOfWave) 
            player.health(100)
    }
}

class NormalWave inherits Wave {
    var totalEnemiesLeftToSpawn = 0
    var enemyNumber = 0
    
    override method spawnEnemies() {
        totalEnemiesLeftToSpawn = currentWave
        self.spawnEnemy()
    }

    method spawnEnemy() {
        const rndNum = 0.randomUpTo(2).round()
        if(rndNum == 0) new Sniper().init()
        else if(rndNum == 1) new Sniper().init()
        else if(rndNum == 2) new Sniper().init()
        enemyNumber += 1
        totalEnemiesLeftToSpawn -= 1

        if(totalEnemiesLeftToSpawn != 0) {
            scheduler.schedule(1000, {self.spawnEnemy()})
        }
    }
}

object waveManager {
    var property currentWave = 2
    var wave = null

    method init() {
        self.startWave()
        game.addVisual(currentWaveUI)
    }

    method startWave() {
       //TODO a counter before starting the wave and the wave number should be displayed
       const rndNumber = 0.randomUpTo(0).round()
       if(rndNumber == 0) 
        wave = new NormalWave(currentWave = currentWave)
       wave.start()
    }

    method nextWave() {
        wave.onWaveFinish()
        currentWave += 1
        scheduler.schedule(3000, {self.startWave()})
        player.weapon().bulletsLeft(player.weapon().magazine())
        player.health(100)
    }

    method destroyEnemy(enemy) {
        wave.enemies().remove(enemy)
        game.removeVisual(enemy)
        if(wave.enemies().isEmpty()) {
            self.nextWave()
        }
    }
}

object currentWaveUI inherits GameVisual(name = "waveUI") {
    method text() = "Wave: " + waveManager.currentWave()
    method message() = "Wave: " + waveManager.currentWave()
    method position() = game.at(game.width() - 100, game.height() - 100) 
}