//
//  ViewModel.swift
//  APICallJson
//
//  Created by edilsonalmeida on 15/03/23.
//

import Foundation





struct Sensor: Codable {
    var distanceCm : Double?
}


class ViewModel : ObservableObject {
    @Published var distancia = 0.0
    
    func fetch(){
        guard let url = URL(string: "http://127.0.0.1:1880/distancia" ) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
                guard let data = data, error == nil else{
                return
            }
            
            do {
                let parsed = try JSONDecoder().decode(Sensor.self, from: data)
                
                DispatchQueue.main.async {
                    self?.distancia = parsed.distanceCm!
                }
            }catch{
                print(error)
            }
        }
        
        task.resume()
    }
}
