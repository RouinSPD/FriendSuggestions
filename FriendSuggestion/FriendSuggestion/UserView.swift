//
//  UserView.swift
//  FriendSuggestion
//
//  Created by Pedro Daniel Rouin Salazar on 19/05/24.
//

import SwiftUI

struct UserView: View {
    var user: User
    @ObservedObject var viewModel: SocialGraphViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name).font(.headline)

            // Display current friends
            Text("Friends: \(user.friends.map { $0.name }.joined(separator: ", "))")
                .font(.subheadline)

            // Allow adding a new friendship
            Text("Simulate a visit to user's profile:")
                .font(.subheadline)
            HStack{
                
                ForEach(viewModel.users.filter { $0.id != user.id }, id: \.id) { otherUser in
                    
                    if !user.friends.contains(where: { $0.id == otherUser.id }){
                        Button(otherUser.name) {
                            viewModel.recordVisit(from: user.id, to: otherUser.id)
                        }
                        .padding(4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    }
                }
                Spacer()
            }

            // Display friend suggestions
            Text("Suggested Friends:").font(.subheadline)
            Text("\(viewModel.suggestFriends(for: user.id))")
                .font(.subheadline)
        }
        //.padding()
    }
}


//#Preview {
//    UserView()
//}
