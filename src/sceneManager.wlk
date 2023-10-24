class Scene {
    method load() {
        self.loadVisuals()
        self.setupControls()
    }

    method loadVisuals() {

    }

    method remove {
        //Removes all visuals
    }

    method setupControls {

    }
}

object main inherits Scene {
    override method loadVisuals() {
        player.init()
        waveManager.init()
    }
}

object howToPlay inherits Scene {
    override method loadVisuals() {
        player.init()
        waveManager.init()
    }
}

object menu inherits Scene {
    override method loadVisuals() {
        player.init()
        waveManager.init()
    }
}

object sceneManager {
    var currentScene = main

    method load(scene) {
        currentScene.remove()
        currentScene = scene
        currentScene.load()
    }

    method main() {
        self.load(main)
    }

    method menu() {
        self.load(menu)
    }

    method howToPlay() {
        self.load(howToPlay)
    }
}