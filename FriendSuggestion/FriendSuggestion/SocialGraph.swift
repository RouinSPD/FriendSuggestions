//
//  SocialGraph.swift
//  FriendSuggestion
//
//  Created by Pedro Daniel Rouin Salazar on 19/05/24.
//

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
    func suggestFriends(for userId: String) -> [FriendSuggestion] {
           guard let user = users[userId] else { return [] }

           var suggestions = [FriendSuggestion]()

           user.friends.forEach { friend in
               friend.friends.forEach { friendOfFriend in
                   if friendOfFriend.id != userId && !user.friends.contains(where: { $0.id == friendOfFriend.id }) {
                       let jaccardSimilarity = (jaccardSimilarity(for: user, and: friendOfFriend) * 100).rounded() / 100
                       let mutualFriendsCount = Set(user.friends.map { $0.id }).intersection(Set(friendOfFriend.friends.map { $0.id })).count
                       let visitsCount = bidirectionalVisitCount(user: user, friendOfFriend: friendOfFriend)
                       let (jaccardScore, mutualFriendsScore, visitsScore) = calculateComponentScores(jaccardSimilarity: jaccardSimilarity, mutualFriendsCount: mutualFriendsCount, visitsCount: visitsCount)
                       let combinedScore = ((jaccardScore + mutualFriendsScore + visitsScore) * 100).rounded() / 100
                       
                       suggestions.append(FriendSuggestion(friendId: friendOfFriend.id,
                                                           jaccardSimilarity: jaccardSimilarity,
                                                           mutualFriendsCount: mutualFriendsCount,
                                                           visitsCount: visitsCount,
                                                           combinedScore: combinedScore))
                   }
               }
           }

           // Return the suggestions sorted by the combined score in descending order.
           return suggestions.sorted { $0.combinedScore > $1.combinedScore }
       }
}
