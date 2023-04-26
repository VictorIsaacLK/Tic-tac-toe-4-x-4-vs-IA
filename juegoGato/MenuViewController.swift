import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileName = "Heart - _Barracuda_ (1977) (1)"
        let fileExtension = "mp3"
        let folderName = "audios de juego"
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension, subdirectory: folderName) else {
            print("No se pudo encontrar el archivo de audio.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.enableRate = true
            player?.play()
            print("La canción se está reproduciendo.")
            print("La canción se encuentra en la carpeta 'audios/juego'.")
        } catch {
            print("No se pudo reproducir la canción.")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Detener la reproducción de la canción si está en curso
        player?.stop()
    }
}

