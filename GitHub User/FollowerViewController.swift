//
//  FollowerViewController.swift
//  GitHub User
//
//  Created by Jay Kaushal on 2023-01-05.
//

import UIKit

class FollowerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var userFollow: [Users] = []
    var users: Users?
    var userName = UserDefaults.standard.string(forKey: "USERNAME")
    var follow = UserDefaults.standard.string(forKey: "FOLLOW")
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        getData()
        super.viewWillAppear(animated)
    }
    
    //MARK: - actions
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - functionalities
    
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFollow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowerTableViewCell
        
        let data = userFollow[indexPath.row]
        
        let imgUrl = URL(string: "\(data.avatar_url ?? "")")
        if let data = try? Data(contentsOf: imgUrl! ) {
            DispatchQueue.main.async {
                cell.profileImg.image = UIImage(data: data)
            }
        }
        
        cell.nameLbl.text = data.name
        cell.userNameLbl.text = data.login
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let data = userFollow[indexPath.row]
        
        if let url = URL(string: data.url ?? ""){
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
                            
                            print("API executed successfully!!! ✅ ")
                            
                            //PRINTING THE RESPONSE
                            print(response)
                        }
                        
                    }
                    catch{
                        // ERROR HANDLING
                        DispatchQueue.main.async {
                            self.displayAlertMessage(userMessage: "Maximum allowed size is 100")
                        }
                        
                    }
                }else
                {
                    //ERROR HANDLING
                    self.displayAlertMessage(userMessage: error?.localizedDescription ?? "Data not found")
                }
                
            }.resume()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func getData()
    {
        if let url = URL(string: "https://api.github.com/users/\(userName ?? "")/\(follow ?? "")"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    print(url)
                    do {
                        
                        let response = try JSONDecoder().decode([Users].self, from: data ?? Data())
                        
                        // DISPATCH TO MAIN QUEUE
                        DispatchQueue.main.async {
                            
                            // CAPTURE DATA
                            self.userFollow = response
                            
                            // RELOAD TABLEVIEW
                            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                            print("API executed successfully!!! ✅ ")
                            
                            //PRINTING THE RESPONSE
                            print(response)
                            print(self.userFollow.count)
                        }
                        
                    }
                    catch{
                        // ERROR HANDLING
                        DispatchQueue.main.async {
                            self.displayAlertMessage(userMessage: "Maximum allowed size is 100")
                        }
                        
                    }
                }else
                {
                    //ERROR HANDLING
                    self.displayAlertMessage(userMessage: error?.localizedDescription ?? "Data not found")
                }
                
            }.resume()
            
        }
        
    }
    
    
    
}
