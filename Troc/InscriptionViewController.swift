//
//  InscriptionViewController.swift
//  Troc
//
//  Created by Besbes Ahmed on 11/25/18.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire

class InscriptionViewController: UIViewController {
    
    // textfields
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var indentifiant: UITextField!
    @IBOutlet weak var mdp: UITextField!
    @IBOutlet weak var telephone: UITextField!
    // utils
    let URL_SIGNUP = "http://localhost:3000/signup"
    
    
    
    
    @IBAction func Inscription(_ sender: Any) {
        
        let parameters: Parameters = ["username": indentifiant.text!,"email": email.text!,"password": mdp.text!]

        Alamofire.request( URL_SIGNUP, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        print(nom.text!)
        print(prenom.text!)
        print(email.text!)
        print(indentifiant.text!)
        print(mdp.text!)
        print(telephone.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}