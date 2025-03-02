//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct ContentView: View {
    struct Game: Codable {
        var id: Int
        var date: String
        var opponent: String
        var score: Score
        var isHomeGame: Bool
        var team: String
    }
    
    struct Score: Codable {
        var opponent: Int
        var unc: Int
    }
    
    @State private var results = [Game]()
    
    var body: some View {
        
        Text("UNC Basketball")
            .font(.title)
            .bold()
        List(results, id: \.id) { game in
            HStack {
                VStack (alignment: .leading){
                    Text("\(game.team) UNC vs. \(game.opponent)")
                    Text(game.date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack (alignment: .trailing){
                    Text("\(game.score.unc) - \(game.score.opponent)")
                    Text(
                        game.isHomeGame ? "Home" : "Away"
                    )
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }
            
        }
        .bold()
        .task {
            await loadData()
        }
    }
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid Data")
        }
            
    }
}

#Preview {
    ContentView()
}
