//
//  ContentView.swift
//  APICallJson
//
//  Created by edilsonalmeida on 15/03/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack{
            Text("\(viewModel.distancia)")
            
            if(viewModel.distancia <= 10.00)
            {
                Text("oi")
            }
            
            
        }.onAppear(){
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){
                timer in
                viewModel.fetch()
            }
                
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
