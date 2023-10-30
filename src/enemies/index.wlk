import shooters.*
import melee.*
import player.*
import _scheduler.*
import gameVisual.*
import sceneManager.*
import constants.COLORS

// Wave functionality
// The wave system will be fairly simple, basically we are gonna create 3 different types of waves, each one with its own items and stuff
// Each wave will be selected randomly and its difficulty will vary based on the current wave 
class Wave {
    var property enemiesToSpawn = 0
    var property totalEnemiesLeftToSpawn = 0
    var property enemiesKilled = 0
    
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
    override method spawnEnemies() {
        if (waveManager.currentWave() == 1) totalEnemiesLeftToSpawn = 3
        else if (waveManager.currentWave() == 2) totalEnemiesLeftToSpawn = 5
        else if (waveManager.currentWave() == 3) totalEnemiesLeftToSpawn = 8
        enemiesToSpawn = totalEnemiesLeftToSpawn
        self.spawnEnemy()
    }

    method spawnEnemy() {
        const rndNum = 0.randomUpTo(1)
        if(rndNum <= 0.4) new Sniper().init()
        else if(rndNum <= 0.8) new Turret().init()
        else new Melee().init()
        
        totalEnemiesLeftToSpawn -= 1

        if(totalEnemiesLeftToSpawn != 0) {
            scheduler.schedule(3000, {self.spawnEnemy()})
        }
    }
}

object waveManager {
    var property currentWave = 1
    const totalWaves = 3
    var wave = null

    method init() {
        self.startWave()
        game.addVisual(currentWaveUI)
    }

    method startWave() {
        if(currentWave >= totalWaves) {
            sceneManager.load(win)
        }
        else {
            wave = new NormalWave()
            wave.start()
        }
    }

    method nextWave() {
        wave.onWaveFinish()
        currentWave += 1
        scheduler.schedule(2000, {self.startWave()})
        player.health(100)
    }

    method destroyEnemy() {
        wave.enemiesKilled(wave.enemiesKilled() + 1)
        if(wave.enemiesKilled() == wave.enemiesToSpawn()) {
            self.nextWave()
        }
    }
}

object currentWaveUI inherits GameVisual(name = "waveUI") {
    method text() = "Ronda: " + waveManager.currentWave()
    method textColor() = COLORS.black
    method position() =  game.at((game.width() / 2) - 100, game.height() - 100)
}