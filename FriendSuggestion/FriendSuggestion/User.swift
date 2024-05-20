//
//  User.swift
//  FriendSuggestion
//
//  Created by Pedro Daniel Rouin Salazar on 19/05/24.
//

import Foundation

// The User class represents an individual in the social network.
class User {
    let id: String // A unique identifier, such as a username.
    let name: String // The full name of the user.
    var friends: [User] // A list of this user's friends, dynamically updated.
    // A dictionary tracking the number of times this user has visited other users' profiles.
    var visitedProfiles: [String: Int]

    // Initializes a new User with optional friends and visited profiles.
    init(id: String, name: String, friends: [User] = [], visitedProfiles: [String: Int] = [:]) {
        self.id = id
        self.name = name
        self.friends = friends
        self.visitedProfiles = visitedProfiles
    }

    // Adds a friend to this user's list if not already present, preventing duplicates.
    func addFriend(_ friend: User) {
        if !self.friends.contains(where: { $0.id == friend.id }) {
            self.friends.append(friend)
        }
    }

    // Increments the visit count for a given user's profile, enhancing interaction tracking.
    func visitProfile(of user: User) {
        visitedProfiles[user.id, default: 0] += 1
    }
}
