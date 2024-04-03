import Foundation

// Represents a user in the social network.
class User {
    let id: String // Unique identifier for the user.
    let name: String // Name of the user.
    var friends: [User] // List of direct friends, represented as User objects.
    var visitedProfiles: [String] // IDs of profiles this user has visited.
    
    // Initializes a new User object.
    init(id: String, name: String, friends: [User] = [], visitedProfiles: [String] = []) {
        self.id = id
        self.name = name
        self.friends = friends
        self.visitedProfiles = visitedProfiles
    }
    
    // Adds a friend to this user's list of friends, avoiding duplicates.
    func addFriend(_ friend: User) {
        if !self.friends.contains(where: { $0.id == friend.id }) {
            self.friends.append(friend)
        }
    }
}

// Manages the social graph, including users and their relationships.
class SocialGraph {
    private var users: [String: User] = [:] // Dictionary mapping user IDs to User objects for quick lookup.
    
    // Adds a user to the social graph.
    func addUser(_ user: User) {
        users[user.id] = user
    }
    
    // Establishes a bidirectional friendship between two users by their IDs.
    func addFriendship(between user1Id: String, and user2Id: String) {
        guard let user1 = users[user1Id], let user2 = users[user2Id] else { return }
        
        user1.addFriend(user2)
        user2.addFriend(user1)
    }
    
    // Suggests potential friends for a user by calculating the Jaccard similarity
    // and considering mutual friends.
    func suggestFriends(for userId: String) -> [(friendId: String, jaccardSimilarity: Double, mutualFriendsCount: Int)] {
        guard let user = users[userId] else { return [] }
        
        var suggestions: [String: (jaccardSimilarity: Double, mutualFriendsCount: Int)] = [:]
        
        // Convert user's direct friends list to a set of IDs for easier comparison.
        let directFriends = Set(user.friends.map { $0.id })
        
        // Iterate over each direct friend of the user.
        user.friends.forEach { friend in
            // Then, iterate over each friend of those direct friends (potential friends).
            friend.friends.forEach { friendOfFriend in
                // Check if the potential friend is not the user and not already a direct friend.
                if friendOfFriend.id != userId && !directFriends.contains(friendOfFriend.id) {
                    let friendOfFriendSet = Set(friendOfFriend.friends.map { $0.id })
                    let intersection = directFriends.intersection(friendOfFriendSet).count
                    let union = directFriends.union(friendOfFriendSet).count
                    let jaccardSimilarity = Double(intersection) / Double(union)
                    
                    // Round the Jaccard similarity to 2 decimal places.
                    let roundedJaccardSimilarity = (jaccardSimilarity * 100).rounded() / 100
                    
                    suggestions[friendOfFriend.id] = (roundedJaccardSimilarity, intersection)
                }
            }
        }
        
        // Sort the suggestions based on Jaccard similarity scores in descending order.
        let sortedSuggestions = suggestions.sorted { $0.value.jaccardSimilarity > $1.value.jaccardSimilarity }
                                           .map { ($0.key, $0.value.jaccardSimilarity, $0.value.mutualFriendsCount) }
        
        // Print detailed suggestions including friend ID, Jaccard similarity, and mutual friends count.
        print("Suggested friends for \(user.name):")
        sortedSuggestions.forEach { friendId, score, mutualFriendsCount in
            print("\(friendId) - Mutual friends Score: \(score), Mutual Friends: \(mutualFriendsCount)")
        }
        
        return sortedSuggestions
    }
}

// The setup for creating users and friendships, and then getting suggestions, is similar to previous examples.


// Example setup and usage
// Assume user creation and friendship establishment are done similarly to previous examples


// Example Usage:
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
socialGraph.addFriendship(between: "Bob", and: "Diego")
socialGraph.addFriendship(between: "Diego", and: "Charlie")
socialGraph.addFriendship(between: "Diego", and: "David")
socialGraph.addFriendship(between: "Pedro", and: "Pablo")
socialGraph.addFriendship(between: "Pedro", and: "Pau")
socialGraph.addFriendship(between: "Pedro", and: "Aldo")
// Get and print friend suggestions for Alice
socialGraph.suggestFriends(for: "Alice")


