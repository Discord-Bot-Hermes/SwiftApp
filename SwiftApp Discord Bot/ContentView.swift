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
        }
        .accessibilityIdentifier("mainView")
    }
    
    private func createBot() {
        let newBot = Bot(
            name: "Bot",
            apiClient: APIClient(serverIP: "http://127.0.0.1:5000", apiKey: "025002"),
            token: "",
            devToken: ""
        )
        modelContext.insert(newBot)
        try? modelContext.save()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Bot.self)
}
