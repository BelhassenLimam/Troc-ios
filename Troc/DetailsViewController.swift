//
//  DetailsViewController.swift
//  Troc
//
//  Created by Belhassen LIMAM on 02/12/2018.
//  Copyright © 2018 firas.kordoghli. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import Cosmos

class DetailsViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
   
    @IBOutlet weak var imageBanner: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceDesc: UITextView!
    
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var serviceNam:String?
    var serviceText:String?
    var previousService:Int?
    var previousCategorie:String?
    var servicesshow : NSArray = []
    var similaresshow : NSArray = []
    let UserDefault = UserDefaults.standard
    
    @IBAction func retour(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func FetchDataSim() {
        let url = "http://192.168.1.8:3000/getSim/"
        let parameters: Parameters = ["categorie":String("'"+previousCategorie!+"'")]
        Alamofire.request( url, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
            self.similaresshow = response.result.value as! NSArray
            self.collectionView.reloadData()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similaresshow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceSim", for: indexPath)
        
        let contentView = cell.viewWithTag(0)
        
        let serviceTitre = contentView?.viewWithTag(1) as! UILabel
        
        let serviceDesc = contentView?.viewWithTag(2) as! UITextView
        let similareshow  = similaresshow[indexPath.item] as! Dictionary<String,Any>
        
        serviceTitre.text = (similareshow["titre"] as! String)
        serviceDesc.text = (similareshow["description"] as! String)
        
        return cell
    }
    
    
    
    
    
    @IBAction func insertCoreData(_ sender: Any) {
        serviceNam = serviceName.text
        serviceText = serviceDesc.text
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        
        let context = persistantContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
        
        request.predicate = NSPredicate(format: "titre == %@", serviceName!)
        request.predicate = NSPredicate(format: "desc == %@", serviceText!)
        
        
        
        
        do {
            let resultArray = try context.fetch(request)
            if resultArray.count == 0 {
                let movieDesc = NSEntityDescription.entity(forEntityName: "Service", in: context)
                
                let newService = NSManagedObject (entity: movieDesc!, insertInto: context)
                
                newService.setValue(serviceNam, forKey: "titre")
                newService.setValue(serviceText, forKey: "desc")
                
                
                
                do {
                    try context.save()
                    print ("Service Saved !!")
                } catch {
                    print("Error !")
                }
            }else{
                let alert = UIAlertController(title: "Duplication", message: "Le service est déjà dans vos favoris", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        } catch {
            print("error")
        }
        
    }
    
    
    func FetchData() {
        let url = "http://192.168.1.8:3000/getService/"
            let parameters: Parameters = ["id": String(previousService!)]
        Alamofire.request( url, method: .post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            // print(response)
            //print(response.result.value)
            
            self.servicesshow = response.result.value as! NSArray
            let serviceshow = self.servicesshow[0] as! Dictionary<String,Any>
            self.serviceName.text = (serviceshow["titre"] as! String)
            self.serviceDesc.text = (serviceshow["description"] as! String)
            
            
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       FetchData()
        FetchDataSim()
        rating.didTouchCosmos = { rating in
            let url = "http://192.168.1.8:3000/ajoutAvis"
            let parameters: Parameters = ["id_user": self.UserDefault.string(forKey: "id")!, "id_service": self.previousService!,"note": rating]
            Alamofire.request( url, method: .post, parameters: parameters).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")
                
                switch(response.result) {
                case .success(_):
                    let alert = UIAlertController(title: "Succés", message: "Votre avis à été ajouter avec succés", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                    
                    
                    
                case .failure(_):
                    let alert = UIAlertController(title: "Echec", message: "Votre n'a pas pu être ajouter", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                    
                }
                
                // print(response)
                //print(response.result.value)
               
            
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
  

    

   

}
