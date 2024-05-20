//
//  FriendSuggestion.swift
//  FriendSuggestion
//
//  Created by Pedro Daniel Rouin Salazar on 19/05/24.
//
import Foundation

struct FriendSuggestion {
    let friendId: String
    let jaccardSimilarity: Double
    let mutualFriendsCount: Int
    let visitsCount: Int
    let combinedScore: Double
}
