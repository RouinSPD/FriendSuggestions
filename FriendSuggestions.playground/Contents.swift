import Foundation

// Represents an individual within the social network, capable of friendships and visiting other profiles.
class User {
    let id: String // A unique identifier for the user, such as a username.
    let name: String // The user's full name.
    var friends: [User] // A dynamic list of this user's friends, represented by User objects.
    var visitedProfiles: [String: Int] // A dictionary mapping the IDs of visited user profiles to the number of visits.

    // Constructor for creating a new User object.
    init(id: String, name: String, friends: [User] = [], visitedProfiles: [String: Int] = [:]) {
        self.id = id
        self.name = name
        self.friends = friends
        self.visitedProfiles = visitedProfiles
    }

    // Adds a new friend to the user's friends list, ensuring there are no duplicate entries.
    func addFriend(_ friend: User) {
        if !self.friends.contains(where: { $0.id == friend.id }) {
            self.friends.append(friend)
        }
    }

    // Records a visit to another user's profile, incrementing the visit count in the visitedProfiles dictionary.
    func visitProfile(of user: User) {
        visitedProfiles[user.id, default: 0] += 1
    }
}

// Manages the overall social network, including users and their relationships.
class SocialGraph {
    private var users: [String: User] = [:] // A collection of all users in the network, keyed by their unique IDs.

    // Introduces a new user into the social graph.
    func addUser(_ user: User) {
        users[user.id] = user
    }

    // Establishes a mutual friendship between two specified users.
    func addFriendship(between user1Id: String, and user2Id: String) {
        guard let user1 = users[user1Id], let user2 = users[user2Id] else { return }
        
        user1.addFriend(user2)
        user2.addFriend(user1)
    }

    // Calculates the Jaccard similarity between two users based on their friends.
    private func jaccardSimilarity(for user: User, and friendOfFriend: User) -> Double {
        let userFriendsSet = Set(user.friends.map { $0.id })
        let friendOfFriendSet = Set(friendOfFriend.friends.map { $0.id })
        let intersection = userFriendsSet.intersection(friendOfFriendSet).count
        let union = userFriendsSet.union(friendOfFriendSet).count
        return union == 0 ? 0 : Double(intersection) / Double(union)
    }

    // Determines the total number of profile visits between two users, accounting for visits in both directions.
    private func bidirectionalVisitCount(user: User, friendOfFriend: User) -> Int {
        let visitsToFriendOfFriend = user.visitedProfiles[friendOfFriend.id, default: 0]
        let visitsFromFriendOfFriend = friendOfFriend.visitedProfiles[user.id, default: 0]
        return visitsToFriendOfFriend + visitsFromFriendOfFriend
    }

    // Generates friend suggestions for a given user, ranked by Jaccard similarity and enhanced with visit data.
    func suggestFriends(for userId: String) -> [(friendId: String, jaccardSimilarity: Double, mutualFriendsCount: Int, visitsCount: Int)] {
        guard let user = users[userId] else { return [] }
        var suggestions = [String: (jaccardSimilarity: Double, mutualFriendsCount: Int, visitsCount: Int)]()

        user.friends.forEach { friend in
            friend.friends.forEach { friendOfFriend in
                // Exclude the user and their current friends from suggestions.
                if friendOfFriend.id != userId && !user.friends.contains(where: { $0.id == friendOfFriend.id }) {
                    let jaccardScore = (jaccardSimilarity(for: user, and: friendOfFriend)*100).rounded()/100
                    let visitCount = bidirectionalVisitCount(user: user, friendOfFriend: friendOfFriend)
                    let mutualFriendsCount = Set(user.friends.map { $0.id })
                        .intersection(Set(friendOfFriend.friends.map { $0.id })).count
                    suggestions[friendOfFriend.id] = (jaccardScore, mutualFriendsCount, visitCount)
                }
            }
        }

        // Sort suggestions by Jaccard similarity score (primary) and visit count (secondary).
        let sortedSuggestions = suggestions.sorted {
            $0.value.jaccardSimilarity > $1.value.jaccardSimilarity ||
            ($0.value.jaccardSimilarity == $1.value.jaccardSimilarity && $0.value.visitsCount > $1.value.visitsCount)
        }.map { ($0.key, $0.value.jaccardSimilarity, $0.value.mutualFriendsCount, $0.value.visitsCount) }
        
        // Output the sorted list of suggestions with detailed metrics.
        print("Suggested friends for \(user.name):")
        sortedSuggestions.forEach { friendId, score, mutualFriends, visits in
            print("\(friendId) - Jaccard Similarity: \(score), Mutual Friends: \(mutualFriends), Profile Visits: \(visits)")
        }
        
        return sortedSuggestions
    }

    // Records a profile visit from one user (visitor) to another (visited).
    func recordVisit(from visitorId: String, to visitedId: String) {
        guard let visitor = users[visitorId], let visited = users[visitedId] else { return }
        visitor.visitProfile(of: visited)
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
// Get and print friend suggestions for a user
socialGraph.suggestFriends(for: "Alice")
//socialGraph.suggestFriends(for: "Pedro")
//let jaccardScore = (jaccardSimilarity(for: user, and: friendOfFriend)*100).rounded()/100

