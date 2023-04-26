//
//  ViewController.swift
//  juegoGato
//
//  Created by Mac09 on 06/03/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var imvGato: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        imvGato.frame.origin.y = view.frame.height
        imvGato.frame.origin.x = (view.frame.width - imvGato.frame.width)/2.0
        
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2, delay: 0.5, options: .curveEaseOut) {
            self.imvGato.frame.origin.y = (self.view.frame.height - self.imvGato.frame.height)/2.0
            
            self.imvGato.alpha=1.0
            
        } completion: { (res) in
            
            //self.performSegue(withIdentifier: "pash", sender: nil)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                
                self.performSegue(withIdentifier: "hola", sender: nil)
                
            }
        }
    }

}

