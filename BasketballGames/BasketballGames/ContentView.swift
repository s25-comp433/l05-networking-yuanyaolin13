//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct ContentView: View {
    struct Response: Codable {
        var results: [Game]
    }

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
    
    @State private var games = [Game]()
    
    var body: some View {
        List(games, id: \.id) { game in
            HStack {
                VStack {
                    Text("test")
                }
                Spacer()
                VStack {
                    Text("\(game.score.unc) - \(game.score.opponent)")
                    Text(
                        game.isHomeGame ? "Home" : "Away"
                    )
                    .font(.caption)
                }
            }
        }
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
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                print("Decoded games:", decodedResponse)
                games = decodedResponse.results
            }
        } catch {
            print("Invalid Data")
        }
            
    }
}

#Preview {
    ContentView()
}
