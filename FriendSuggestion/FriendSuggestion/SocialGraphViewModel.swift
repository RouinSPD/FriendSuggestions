//
//  SocialGraphViewModel.swift
//  FriendSuggestion
//
//  Created by Pedro Daniel Rouin Salazar on 19/05/24.
//

import SwiftUI
import Foundation


class SocialGraphViewModel: ObservableObject {
    @Published var users = [User]()
    private var graph = SocialGraph()

    init() {
        // Initialize with sample users
        let userNames = ["Alice", "Bob", "Charlie", "David", "Eve", "Pablo"]
        self.users = userNames.map { User(id: $0, name: $0) }
        self.users.forEach { self.graph.addUser($0) }

        // Add some initial friendships
        self.graph.addFriendship(between: "Alice", and: "Bob")
        self.graph.addFriendship(between: "Bob", and: "Charlie")
        self.graph.addFriendship(between: "David", and: "Eve")
        self.graph.addFriendship(between: "Bob", and: "Eve")
        self.graph.addFriendship(between: "Pablo", and: "Alice")
        self.graph.addFriendship(between: "Pablo", and: "Bob")
        self.graph.addFriendship(between: "Pablo", and: "Charlie")
        self.graph.addFriendship(between: "Pablo", and: "David")
        self.graph.addFriendship(between: "Pablo", and: "Eve")
    }

    func addFriendship(between user1: String, user2: String) {
        self.graph.addFriendship(between: user1, and: user2)
        self.objectWillChange.send()
    }

    func recordVisit(from visitor: String, to visited: String) {
        self.graph.recordVisit(from: visitor, to: visited)
        self.objectWillChange.send()
    }

    func suggestFriends(for userId: String) -> String {
        let suggestions = self.graph.suggestFriends(for: userId)
        return suggestions.map { "\($0.friendId) (\($0.combinedScore))" }.joined(separator: ", ")
    }
}
