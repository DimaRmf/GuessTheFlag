//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Дима РМФ on 01.03.2022.
//

import SwiftUI

//структура хранящая модификаторы для картинок
struct FlagImage: View {
    var image: String
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    //счет пользователя
    @State private var userRating = 0
    
    //сообщение о том какой это флаг
    @State private var supplwMessage = ""
    
    //раунды
    @State private var rounds = 0
    
    //конец игры
    @State private var gameOver = false
    
    //анимация поворота
    @State private var animationAmount = 0.0
    
    //прозрачность
    @State private var opacityAmount = false
    
    @State private var isShowing = false

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.25), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
            Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
            VStack(spacing: 15) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundStyle(.secondary)
                        .font(.subheadline.weight(.heavy))
                    
                    Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.semibold))
                }
                
                ForEach(0..<3) { number in
                    Button {
                        //flag was tapped
                        flagTapped(number)
                    } label: {
                        FlagImage(image: countries[number])
                    }
                    .opacity(opacityAmount ? (number == correctAnswer ? 1 : 0.25) : 1)
                    .rotation3DEffect(.degrees(number == correctAnswer ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userRating)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
                Text("Rounds: \(rounds)")
                    .foregroundColor(.white)
                    .font(.headline.bold())
                Spacer()
                
                Button("Reset") {
                    reset_game()
                } .foregroundColor(.white)
                
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userRating) \n" + self.supplwMessage)
        }
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Game Over"),
                  message: Text("You achived \(userRating) points"),
                  dismissButton: .default(Text("New Game")) {
                gameOver = false
                rounds = 0
                userRating = 0
                askQuestion()
            })
        }
    
        
        
        }
    
    func flagTapped(_ number: Int) {
        rounds += 1
        if number == correctAnswer {
            withAnimation {
                animationAmount += 360
            }
            withAnimation {
                opacityAmount = true
            }
            scoreTitle = "Correct"
            userRating += 1
        } else {
            scoreTitle = "Wrong"
            supplwMessage = "Thats flag of \(self.countries[number])"
        }
        if rounds == 5 {
            gameOver = true
        } else {
            askQuestion()
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    
    func reset() {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
    }
    func reset_game() {
        reset()
        userRating = 0
        rounds = 0
    }
    
    
    }
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
