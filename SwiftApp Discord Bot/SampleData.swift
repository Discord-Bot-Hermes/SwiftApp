//
//  SampleData.swift
//  DiscordApp_Demo
//
//  Created by Campus Heilbronn on 15.04.25.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()

    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }

    var bot: Bot {
        Bot.sampleData.first!
    }

    init() {
        let schema = Schema([Bot.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            context.insert(Bot.sampleData.first!)
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

}
