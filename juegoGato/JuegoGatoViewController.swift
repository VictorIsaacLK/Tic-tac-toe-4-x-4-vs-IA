//
//  JuegoGatoViewController.swift
//  juegoGato
//
//  Created by Mac09 on 15/03/23.
//

import UIKit
import AVFoundation

class JuegoGatoViewController: UIViewController
{
    
    var puntos = 150
    var tiempoRestante = 5 * 60 // 5 minutos en segundos
    var timer: Timer?
    var player: AVAudioPlayer?
    var nombre: String?
   
    @IBOutlet weak var lblPuntos: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet var btnTablero: [UIButton]!
    @IBOutlet weak var lblTurno: UILabel!
    
    enum Turno {
        case circulo
        case cruz
    }
    
    var turnoUno = Turno.circulo
    var turnoMaquina = Turno.cruz
    var turnoActual = Turno.circulo
    
    var BOLA="O"
    var EQUIS="X"
    
    var secuencia: [Int] = []
    var indice: Int = -1
    
    let jugadasGanadoras = [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15], [0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15], [0, 5, 10, 15], [3, 6, 9, 12]]
    
    var ganador: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
        self.playSong()
    }
    
    //Funcion para obtener el tablero
    func obtenerTablero() -> [[String]] {
        var tablero = [[String]](repeating: [String](repeating: "", count: 4), count: 4)
        
        for i in 0..<btnTablero.count {
            let row = i / 4
            let col = i % 4
            if let title = btnTablero[i].title(for: .normal) {
                tablero[row][col] = title
            }
        }
        
        return tablero
    }
    
    
    
    //Funcion para saber cuando gano alguien
    func verificarGanador() -> (String, Bool) {
        let tablero = obtenerTablero()
        
        for jugada in jugadasGanadoras
        {
            let valoresJugada = jugada.map { (index: Int) -> String in
                let row = index / 4
                let col = index % 4
                return tablero[row][col]
            }
            
            if Set(valoresJugada).count == 1 && !valoresJugada.contains("")
            {
                // Se encontró un ganador
                ganador = true
                lblTurno.text = "Ganó \(valoresJugada[0])"
                
                if lblTurno.text=="Ganó O"{
                    self.stopSong()
                    self.ganadorSong()
                    goToMenuAGatito()
                    
                   
                }
                else if lblTurno.text=="Ganó X"{
                    self.stopSong()
                    self.perdedorSong()
                    
                }
                
                // Aquí se pueden realizar acciones adicionales en caso de haber un ganador
                return (valoresJugada[0], true)
            }
        }
        
        // Si no hay ganador, se verifica si el juego terminó en empate
        if !tablero.flatMap({ $0 }).contains("")
        {
            lblTurno.text = "Empate"
            ganador = false
            // Aquí se pueden realizar acciones adicionales en caso de empate
            return("E", true)
        }
        
        ganador = false
        return ("N", false)
    }
    
    //Funcion para buscar la mejor jugada
    func mejorMovimiento(tablero: [[String]], jugador: String) -> (fila: Int, columna: Int) {
        var mejorValor = Int.min
        var mejoresMovimientos = [(fila: Int, columna: Int, valor: Int)]()
        print(tablero)
        print("jugador " + jugador)
        
        for columna in 0..<4 {
            print("entre a la fila")
            for fila in 0..<4 {
                print("entre a la columna")
                print(fila)
                print(columna)
                let elemento = tablero[fila][columna]
                print(elemento)
                if elemento == "" {
                    var tableroTemp = tablero
                    tableroTemp[fila][columna] = jugador
                    let valorMovimiento = minimax(tablero: tableroTemp, profundidad: 1, alpha: Int.min, beta: Int.max, jugadorMax: false)
                    if valorMovimiento > mejorValor {
                        mejorValor = valorMovimiento
                        mejoresMovimientos = [(fila, columna, valorMovimiento)]
                    } else if valorMovimiento == mejorValor {
                        mejoresMovimientos.append((fila, columna, valorMovimiento))
                        
                    }
                }
            }
        }
        
        print(mejoresMovimientos)
        let elegido = mejoresMovimientos.randomElement()!
        return (elegido.fila, elegido.columna)
    }
    
    
    
    func minimax(tablero: [[String]], profundidad: Int, alpha: Int, beta: Int, jugadorMax: Bool) -> Int {
        let resultado = verificarGanador()
        print(resultado.1)
        
        if resultado.1 == false{
            if resultado.0 == EQUIS {
                return 1
            } else if resultado.0 == BOLA {
                return -1
            } else {
                return 0
            }
        }
        
        if jugadorMax {
            var valorMax = Int.min
            for fila in 0..<4 {
                for columna in 0..<4 {
                    if tablero[fila][columna] == "" {
                        var nuevoTablero = tablero
                        nuevoTablero[fila][columna] = EQUIS
                        let valorMovimiento = minimax(tablero: nuevoTablero, profundidad: profundidad + 1, alpha: alpha, beta: beta, jugadorMax: false)
                        valorMax = max(valorMax, valorMovimiento)
                        let alphaTemp = max(alpha, valorMax)
                        if beta <= alphaTemp {
                            break
                        }
                    }
                }
            }
            return valorMax
        } else {
            var valorMin = Int.max
            for fila in 0..<4 {
                for columna in 0..<4 {
                    if tablero[fila][columna] == "" {
                        var nuevoTablero = tablero
                        nuevoTablero[fila][columna] = BOLA
                        let valorMovimiento = minimax(tablero: nuevoTablero, profundidad: profundidad + 1, alpha: alpha, beta: beta, jugadorMax: true)
                        valorMin = min(valorMin, valorMovimiento)
                        let betaTemp = min(beta, valorMin)
                        if betaTemp <= alpha {
                            break
                        }
                    }
                }
            }
            return valorMin
        }
    }
    
    
    
    
    @IBAction func acciondeTablero(_ sender: UIButton)
    {
        startTimer()
        if sender.title(for: .normal) == nil
        {
            if turnoActual == Turno.circulo
            {
                sender.setTitle(BOLA, for: .normal)
                print(obtenerTablero())
                print(verificarGanador())
                if verificarGanador() == (BOLA, true)
                {
                    return
                }
                lblTurno.text = EQUIS
                turnoActual = Turno.cruz
                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                {
                    print("entre al async")
                    let tablero = self.obtenerTablero()
                    let bestMove = self.mejorMovimiento(tablero: tablero, jugador: self.EQUIS)
                    print("bestMove")
                    print(bestMove)
                    let fila = Int(bestMove.fila)
                    let columna = Int(bestMove.columna)
                    self.btnTablero[fila*4+columna].setTitle(self.turnoMaquina == .circulo ? "O" : "X", for: .normal)
                    
                    print(fila)
                    print(columna)
                    print("----")
                    self.turnoActual = Turno.circulo // Cambia el turno a la máquina
                    self.lblTurno.text = self.BOLA // Actualiza el label del turno
                    self.acciondeTablero(sender)
                    print(self.verificarGanador())
                }
            }
            else if turnoActual == Turno.cruz
            {
                //sender.setTitle(EQUIS, for: .normal)
                print(obtenerTablero())
                print(verificarGanador())
                if verificarGanador() == (EQUIS, true)
                {
                    return
                }
                turnoActual = Turno.circulo
                lblTurno.text = BOLA
                
            }
        }
    }
    
    
    func mostrarMensaje(_ mensaje: String) {
        let alert = UIAlertController(title: "Fin del juego", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Jugar de nuevo", style: .default, handler: { (action) in
            self.reiniciarJuego()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reiniciarJuego() {
        secuencia.removeAll()
        indice = -1
        ganador = false
        lblTurno.text = BOLA
        for boton in btnTablero {
            boton.setTitle("", for: .normal)
        }
    }
    
    
    func perdedorSong() {
        let fileName = "perdedor"
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
    
    
    func ganadorSong() {
        let fileName = "ganador"
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
    
    
    func playSong() {
        let fileName = "audiopartida"
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
    
    func stopSong() {
        player?.stop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSong()
    }
    
    
    // Función para iniciar el temporizador
    func startTimer() {
        if timer == nil {
            updateTimerInterval()
        }
    }

    func updateTimerInterval() {
        let casillasLlenas = contarCasillasLlenas()
        let casillasVacias = 16 - casillasLlenas // Asume un tablero de 4x4
        let intervalo = max(0.1, 1.0 - (Double(casillasVacias) * 0.05)) // Ajusta este factor para controlar la velocidad del temporizador

        if let currentTimer = timer {
            currentTimer.invalidate()
        }

        timer = Timer.scheduledTimer(withTimeInterval: intervalo, repeats: true) { [weak self] _ in
            self?.updateGame()
        }
    }

    func updateGame() {

        // Verificar si hay un ganador o empate antes de actualizar el tiempo y los puntos
        let resultado = self.verificarGanador()
        if resultado.1 {
            self.timer?.invalidate()
            self.timer = nil
            return
        }

        self.tiempoRestante -= 1
        self.lblTimer.text = String(format: "%02d:%02d", self.tiempoRestante / 60, self.tiempoRestante % 60)

        if self.tiempoRestante % 3 == 0 {
            self.puntos -= 3
            self.lblPuntos.text = "\(self.puntos)"
        }

        // Actualizar la etiqueta de puntos y de tiempo restante
        self.lblPuntos.text = "\(self.puntos)"
        self.lblTimer.text = String(format: "%02d:%02d", self.tiempoRestante / 60, self.tiempoRestante % 60)

        if self.tiempoRestante == 0 {
            self.timer?.invalidate()
            self.timer = nil
            // Aquí puedes agregar la lógica que quieras para cuando se acabe el tiempo
        }

        updateTimerInterval() // Actualizar el intervalo del temporizador en función de las casillas llenas
    }


    
    func contarCasillasLlenas() -> Int {
        let tablero = obtenerTablero()
        var contador = 0
        
        for fila in tablero {
            for casilla in fila {
                if casilla != "" {
                    contador += 1
                }
            }
        }
        
        return contador
    }




        
        
        // Función para reiniciar el juego
    func reiniciarJuegotimer()
    {
        // Reiniciar los valores de las variables
        puntos = 100
        tiempoRestante = 5 * 60
            
        // Actualizar las etiquetas
        lblPuntos.text = "\(puntos)"
        lblTimer.text = String(format: "%02d:%02d", tiempoRestante / 60, tiempoRestante % 60)
        
            // Iniciar el temporizador
        startTimer()
        
    }
   

    func goToMenuAGatito() {
        performSegue(withIdentifier: "datosganadores", sender: self)
        
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "datosganadores" {
            let vc = segue.destination as! puntuacionviewController
            vc.nombre = nombre
            vc.puntos = String(puntos)
            
        }
    }
}
