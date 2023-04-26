import UIKit

struct Puntuacion: Codable {
    var nombre: String
    var puntos: Int
}

class puntuacionviewController: UIViewController {
    var nombre: String?
    var puntos: String?
    var puntuacionesPredeterminadas = [
        Puntuacion(nombre: "Juan", puntos: 120),
        Puntuacion(nombre: "Pedro", puntos: 68),
        Puntuacion(nombre: "Luis", puntos: 40),
        Puntuacion(nombre: "Maria", puntos: 30),
        Puntuacion(nombre: "Ana", puntos: 10)
    ]

    @IBOutlet weak var puntuacionDos: UILabel!
    @IBOutlet weak var puntuacionCuatro: UILabel!
    @IBOutlet weak var puntuacionTres: UILabel!
    @IBOutlet weak var puntuacionQuinto: UILabel!
    @IBOutlet weak var puntuacionUno: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        cargarPuntuaciones()
        Checarycomodardatos()
        actualizarLabels()
        guardarPuntuaciones()
        print(nombre ?? "Nombre vacío")
        print(puntos ?? "Puntos vacíos")
    }

    func Checarycomodardatos() {
        if let nombre = nombre, !nombre.isEmpty, let puntos = puntos, let puntosInt = Int(puntos), puntosInt != 0 {
            for (index, puntuacion) in puntuacionesPredeterminadas.enumerated() {
                if puntosInt >= puntuacion.puntos {
                    print(puntuacion)
                    puntuacionesPredeterminadas[index] = Puntuacion(nombre: nombre, puntos: puntosInt)
                    break
                }
            }
        }
    }

    func actualizarLabels() {
        let labels = [puntuacionUno, puntuacionDos, puntuacionTres, puntuacionCuatro, puntuacionQuinto]
        for (index, label) in labels.enumerated() {
            let puntuacion = puntuacionesPredeterminadas[index]
            label?.text = "\(puntuacion.nombre) : \(puntuacion.puntos) puntos"
        }
    }
    
    func guardarPuntuaciones() {
        let puntuacionesData = try? JSONEncoder().encode(puntuacionesPredeterminadas)
        UserDefaults.standard.set(puntuacionesData, forKey: "puntuaciones")
    }
    
    func cargarPuntuaciones() {
        if let puntuacionesData = UserDefaults.standard.data(forKey: "puntuaciones"),
           let puntuacionesCargadas = try? JSONDecoder().decode([Puntuacion].self, from: puntuacionesData) {
            puntuacionesPredeterminadas = puntuacionesCargadas
        }
    }
}


