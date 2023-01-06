//
//  Users.swift
//  GitHub User
//
//  Created by Jay Kaushal on 2023-01-05.
//

import Foundation

struct Users: Codable {
    
    let id: Double?
    let login: String?
    let node_id: String?
    let avatar_url: String?
    let url: String?
    let followers_url: String?
    let following_url: String?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let followers: Double?
    let following: Double?
    let message: String?
    let twitter_username: String?
    let public_repos: Double?
}
