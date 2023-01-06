//
//  ProfileViewController.swift
//  GitHub User
//
//  Created by Jay Kaushal on 2023-01-05.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followerLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var profileImgLink = UserDefaults.standard.string(forKey: "IMAGEURL")
    var name = UserDefaults.standard.string(forKey: "NAME")
    var userName = UserDefaults.standard.string(forKey: "USERNAME")
    var following = UserDefaults.standard.string(forKey: "FOLLOWING")
    var followingLink = UserDefaults.standard.string(forKey: "FOLLOWINGURL")
    var follower = UserDefaults.standard.string(forKey: "FOLLOWERS")
    var followerLink = UserDefaults.standard.string(forKey: "FOLLOWERURL")
    var twitter = UserDefaults.standard.string(forKey: "TWITTER")
    var publicRepo = UserDefaults.standard.string(forKey: "PUBLICREPOS")
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfileData()
        super.viewWillAppear(animated)
       
    }
    
    //MARK: - actions
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func followerBtn(_ sender: UIButton) {
        
        
        if followerLbl.text == "0"
        {
            displayAlertMessage(userMessage: "Followers not available.")
        } else {
            UserDefaults.standard.set("followers", forKey: "FOLLOW")
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FollowerViewController") as! FollowerViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func followingBtn(_ sender: UIButton) {
        
        if followingLbl.text == "0" {
            displayAlertMessage(userMessage: "Followings not available.")
        } else {
            UserDefaults.standard.set("following", forKey: "FOLLOW")
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FollowerViewController") as! FollowerViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

    }
    
    //MARK: - functionalities
    
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func getProfileData()
    {
        if profileImgLink == "" {
            profileImg.image = UIImage(named: "hand")
        } else {
            let imgUrl = URL(string: "\(profileImgLink ?? "")")
            if let data = try? Data(contentsOf: imgUrl! ) {
                DispatchQueue.main.async {
                    self.profileImg.image = UIImage(data: data)
                }
            }
        }

        nameLbl.text = name
        userNameLbl.text = userName
        followingLbl.text = following
        followerLbl.text = follower
        descriptionLbl.text = "Twitter name: \(twitter ?? "") and the public repos in total is \(publicRepo ?? "")."
    }
    

}
