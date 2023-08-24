//
//  ContentView.swift
//  5MinuteTimer
//
//  Created by Federico on 07/04/2022.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var vm = ViewModel()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    var body: some View {
        VStack {
            Text("Tempo restante:")
                .font(.system(size: 32, weight: .bold))
            Text("\(vm.time)")
                .font(.system(size: 70, weight: .medium, design: .rounded))
                .alert("Timer done!", isPresented: $vm.showingAlert) {
                    Button("Continue", role: .cancel) {
//                         Code
                    }
                }
                .padding()
                .frame(width: width)
                .background(.yellow)
                .cornerRadius(20)
                .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 2)
                    )

            HStack(spacing:30) {
                
                Button("30min") {
                    vm.start(minutes: 30)
                }
                
                Button("+ 5 min") {
                    vm.start(minutes: vm.minutes)
                    vm.addTime(minutes: 5.0)
                }
//                .buttonStyle(.bordered)

                
                Button("Encerrar", action: vm.reset)
                    .tint(.red)
            }
            .frame(width: width)
        }
        .onReceive(timer) { _ in
            vm.updateCountdown()
        }
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}

