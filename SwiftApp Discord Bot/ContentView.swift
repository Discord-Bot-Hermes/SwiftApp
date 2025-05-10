//
//  ContentView.swift
//  DiscordApp_Demo
//
//  Created by Campus Heilbronn on 19.03.25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var bots: [Bot]
    
    var body: some View {
        NavigationStack {
            VStack {
                if let bot = bots.first {
                    BotView(bot: bot)
                } else {
                    // No bot found, create one
                    ContentUnavailableView {
                        Label("No Bot Available", systemImage: "exclamationmark.triangle")
                            .foregroundColor(.tumOrange)
                    } actions: {
                        Button("Create Bot") {
                            createBot()
                        }
                        .foregroundColor(.tumBlue)
                        .padding()
                        .background(Color.tumGray8)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.tumGray9)
                }
            }
            .onAppear {
                if bots.isEmpty {
                    createBot()
                }
            }
        }
        .accessibilityIdentifier("mainView")
    }
    
    private func createBot() {
        let newBot = Bot(
            name: "Master Mind",
            apiClient: APIClient(serverIP: "http://127.0.0.1:5000", apiKey: "025002"),
            token: "",
            devToken: ""
        )
        modelContext.insert(newBot)
        do {
            try modelContext.save()
            print("DEBUG: Bot created and saved to persistent storage")
        } catch {
            print("DEBUG: Failed to save bot: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
