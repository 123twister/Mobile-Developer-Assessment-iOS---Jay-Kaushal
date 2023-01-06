//
//  ViewController.swift
//  GitHub User
//
//  Created by Jay Kaushal on 2023-01-05.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchTf: UITextField!
    
    var users: Users?
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTf.delegate = self
    }
    
    //MARK: - actions
    
    @IBAction func searchBtn(_ sender: UIButton) {
        getData()
        
    }
    
    //MARK: - functionalities
    
    func getData()
    {
        if let url = URL(string: "https://api.github.com/users/\(searchTf.text ?? "")"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    print(url)
                    do {
                        
                        let response = try JSONDecoder().decode(Users.self, from: data ?? Data())
                        
                        // DISPATCH TO MAIN QUEUE
                        DispatchQueue.main.async {
                            
                            // CAPTURE DATA
                            self.users = response
                            
                            if self.users?.message == nil {
                                UserDefaults.standard.set(self.users?.name ?? "", forKey: "NAME")
                                UserDefaults.standard.set(self.users?.login ?? "", forKey: "USERNAME")
                                UserDefaults.standard.set(self.users?.followers ?? 0, forKey: "FOLLOWERS")
                                UserDefaults.standard.set(self.users?.following ?? 0, forKey: "FOLLOWING")
                                UserDefaults.standard.set(self.users?.followers_url ?? "", forKey: "FOLLOWERURL")
                                UserDefaults.standard.set(self.users?.following_url ?? "", forKey: "FOLLOWINGURL")
                                UserDefaults.standard.set(self.users?.avatar_url ?? "", forKey: "IMAGEURL")
                                UserDefaults.standard.set(self.users?.twitter_username ?? "", forKey: "TWITTER")
                                UserDefaults.standard.set(self.users?.public_repos ?? "", forKey: "PUBLICREPOS")
                                
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                self.displayAlertMessage(userMessage: self.users?.message ?? "")
                            }
                            print("API executed successfully!!! ✅ ")
                            
                            //PRINTING THE RESPONSE
                            print(response)
                        }
                        
                    }
                    catch{
                        // ERROR HANDLING
                        DispatchQueue.main.async {
                            
                            self.displayAlertMessage(userMessage: error.localizedDescription)
                            print(error.localizedDescription)
                        }
                        
                    }
                }else
                {
                    //ERROR HANDLING
                    self.displayAlertMessage(userMessage: error?.localizedDescription ?? "Data not found")
                    print(error?.localizedDescription ?? "Not Found")
                }
                
            }.resume()
            
        }
        
    }
    
    
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTf.resignFirstResponder()
    }
    
}
