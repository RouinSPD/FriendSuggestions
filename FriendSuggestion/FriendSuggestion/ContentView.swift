//
//  ContentView.swift
//  FriendSuggestion
//
//  Created by Pedro Daniel Rouin Salazar on 19/05/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = SocialGraphViewModel()

        var body: some View {
            NavigationView {
                
                ScrollView() {
                    ForEach(viewModel.users, id: \.id) { user in
                        UserView(user: user, viewModel: viewModel)
                        Divider()
                    }
                }
                .navigationBarTitle("Social Graph")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
}

#Preview {
    ContentView()
}
