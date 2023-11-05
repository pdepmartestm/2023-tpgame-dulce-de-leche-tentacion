import Scenes._scenes.*

//Aprovechar herencia
object sceneManager {
    var currentScene = menu
    var property cancion = game.sound("massa/cancion.mp3")
    var property himno = game.sound("himno.mp3")
    
    method load(scene) {
        currentScene.remove()
        scene.load()
        currentScene = scene
    }
}