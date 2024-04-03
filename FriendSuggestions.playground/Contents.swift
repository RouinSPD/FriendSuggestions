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

// Manages the social network, including user relationships and interactions.
class SocialGraph {
    // All users in the network, indexed by their unique ID for efficient access.
    private var users: [String: User] = [:]

    // Adds a user to the social graph.
    func addUser(_ user: User) {
        users[user.id] = user
    }

    // Forms a mutual friendship between two users, symbolizing a bidirectional relationship.
    func addFriendship(between user1Id: String, and user2Id: String) {
        guard let user1 = users[user1Id], let user2 = users[user2Id] else { return }
        user1.addFriend(user2)
        user2.addFriend(user1)
    }

    // Records a visit from one user to another's profile.
    func recordVisit(from visitorId: String, to visitedId: String) {
        guard let visitor = users[visitorId], let visited = users[visitedId] else { return }
        visitor.visitProfile(of: visited)
    }

    // Calculates Jaccard similarity between two users based on their friends, measuring the overlap in their social circles.
    private func jaccardSimilarity(for user: User, and friendOfFriend: User) -> Double {
        let userFriendsSet = Set(user.friends.map { $0.id })
        let friendOfFriendSet = Set(friendOfFriend.friends.map { $0.id })
        let intersection = userFriendsSet.intersection(friendOfFriendSet).count
        let union = userFriendsSet.union(friendOfFriendSet).count
        return union == 0 ? 0 : Double(intersection) / Double(union)
    }

    // Computes the total visits between two users, considering both directions to account for mutual interest.
    private func bidirectionalVisitCount(user: User, friendOfFriend: User) -> Int {
        let visitsToFriendOfFriend = user.visitedProfiles[friendOfFriend.id, default: 0]
        let visitsFromFriendOfFriend = friendOfFriend.visitedProfiles[user.id, default: 0]
        return visitsToFriendOfFriend + visitsFromFriendOfFriend
    }

    // Calculates weighted scores for Jaccard similarity, mutual friends count, and visit count, combining them into a single metric.
    private func calculateComponentScores(jaccardSimilarity: Double, mutualFriendsCount: Int, visitsCount: Int) -> (Double, Double, Double) {
        let weightJaccard = 0.5 // Emphasizes the importance of similar social circles.
        let weightMutualFriends = 0.3 // Values the number of shared connections.
        let weightVisits = 0.2 // Considers the level of direct interaction through profile visits.

        let jaccardScore = jaccardSimilarity * weightJaccard
        let mutualFriendsScore = Double(mutualFriendsCount) * weightMutualFriends
        let visitsScore = Double(visitsCount) * weightVisits
        
        return (jaccardScore, mutualFriendsScore, visitsScore)
    }

    // Suggests potential friends for a user, ranking them by a combined score derived from Jaccard similarity, mutual friends, and visit count.
    func suggestFriends(for userId: String) {
        guard let user = users[userId] else { return }

        var suggestions: [String: (jaccardSimilarity: Double, mutualFriendsCount: Int, visitsCount: Int, combinedScore: Double)] = [:]

        // Iterates through friends and their friends to identify potential connections not already in the user's circle.
        user.friends.forEach { friend in
            friend.friends.forEach { friendOfFriend in
                if friendOfFriend.id != userId && !user.friends.contains(where: { $0.id == friendOfFriend.id }) {
                    let jaccardSimilarity = (jaccardSimilarity(for: user, and: friendOfFriend)*100).rounded()/100
                    let mutualFriendsCount = Set(user.friends.map { $0.id }).intersection(Set(friendOfFriend.friends.map { $0.id })).count
                    let visitsCount = bidirectionalVisitCount(user: user, friendOfFriend: friendOfFriend)
                    let (jaccardScore, mutualFriendsScore, visitsScore) = calculateComponentScores(jaccardSimilarity: jaccardSimilarity, mutualFriendsCount: mutualFriendsCount, visitsCount: visitsCount)
                    let combinedScore = ((jaccardScore + mutualFriendsScore + visitsScore)*100).rounded()/100
                    
                    suggestions[friendOfFriend.id] = (jaccardSimilarity, mutualFriendsCount, visitsCount, combinedScore)
                }
            }
        }

        // Sorts potential friends based on the combined score to prioritize those with higher overlap and interaction.
        let sortedSuggestions = suggestions.sorted { $0.value.combinedScore > $1.value.combinedScore }

        // Outputs detailed information for each suggestion, including the rationale for the suggestion based on shared friends, interaction, and social circle similarity.
        print("Detailed friend suggestions for \(user.name):")
        sortedSuggestions.forEach { friendId, details in
            print("""
            Friend ID: \(friendId)
            - Jaccard Similarity: \(details.jaccardSimilarity)
            - Mutual Friends Count: \(details.mutualFriendsCount)
            - Number of Visits: \(details.visitsCount)
            - Final Score: \(details.combinedScore)
            """)
        }
    }
}


// Example setup and usage

let socialGraph = SocialGraph()

// Create user instances
let alice = User(id: "Alice", name: "Alice")
let bob = User(id: "Bob", name: "Bob")
let charlie = User(id: "Charlie", name: "Charlie")
let david = User(id: "David", name: "David")
let eve = User(id: "Eve", name: "Eve")
let diego = User(id: "Diego", name: "Diego")
let pedro = User(id: "Pedro", name: "Pedro")
let pau = User(id: "Pau", name: "Pau")
let pablo = User(id: "Pablo", name: "Pablo")
let aldo = User(id: "Aldo", name: "Aldo")

// Add users to the social graph
socialGraph.addUser(alice)
socialGraph.addUser(bob)
socialGraph.addUser(charlie)
socialGraph.addUser(david)
socialGraph.addUser(eve)
socialGraph.addUser(diego)
socialGraph.addUser(pedro)
socialGraph.addUser(pau)
socialGraph.addUser(pablo)
socialGraph.addUser(aldo)

// Establish friendships
socialGraph.addFriendship(between: "Alice", and: "Bob")
socialGraph.addFriendship(between: "Bob", and: "Charlie")
socialGraph.addFriendship(between: "Alice", and: "Charlie")
socialGraph.addFriendship(between: "Alice", and: "David")
socialGraph.addFriendship(between: "David", and: "Eve")
socialGraph.addFriendship(between: "Eve", and: "Bob")
socialGraph.addFriendship(between: "Eve", and: "Charlie")
socialGraph.addFriendship(between: "Bob", and: "Diego")
//socialGraph.addFriendship(between: "Diego", and: "Charlie")
socialGraph.addFriendship(between: "Diego", and: "David")
socialGraph.addFriendship(between: "Pedro", and: "Pablo")
socialGraph.addFriendship(between: "Pedro", and: "Pau")
socialGraph.addFriendship(between: "Pedro", and: "Aldo")

// Record some profile visits.
socialGraph.recordVisit(from: "Alice", to: "Bob")
socialGraph.recordVisit(from: "Alice", to: "Charlie")
socialGraph.recordVisit(from: "Bob", to: "Alice")
socialGraph.recordVisit(from: "Eve", to: "Alice")
socialGraph.recordVisit(from: "Alice", to: "Diego")
socialGraph.recordVisit(from: "Alice", to: "Eve")
socialGraph.recordVisit(from: "Diego", to: "Alice")
socialGraph.recordVisit(from: "Diego", to: "Alice")

// Get and print friend suggestions for a user
socialGraph.suggestFriends(for: "Alice")


