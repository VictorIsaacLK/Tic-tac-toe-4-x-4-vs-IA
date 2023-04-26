
//  registroController.swift
//  juegoGato
//
//  Created by imac on 19/04/23.
//

import UIKit

class registroController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var txfNombre: UITextField!
    @IBOutlet weak var txtNombre: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Establecer el delegado de txfNombre para recibir eventos del textField
        txfNombre.delegate = self

        // Inicialmente desactivar el botón 'Siguiente'
        btnSiguiente.isEnabled = false

        // Agregar un objetivo para detectar cambios en el textField
        txfNombre.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    // Método para manejar cambios en el textField
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            btnSiguiente.isEnabled = !text.isEmpty
        } else {
            btnSiguiente.isEnabled = false
        }
    }

    // UITextFieldDelegate: Limpiar el textField cuando se selecciona
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    // UITextFieldDelegate: Ocultar el teclado cuando se presiona 'return'
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func btnSiguienteTapped(_ sender: UIButton) {
        if btnSiguiente.isEnabled {
            performSegue(withIdentifier: "menuAGatito", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuAGatito" {
            let vc = segue.destination as! JuegoGatoViewController
            vc.nombre = txfNombre.text
           
        }
    }
}
