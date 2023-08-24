//
//  ContentView.swift
//  desafio_mapa
//
//  Created by Student on 23/05/23.
//

import SwiftUI
import MapKit


struct Location: Identifiable{
   
    let id = UUID()
    let name : String
    let coordinate: CLLocationCoordinate2D
    //zlet flag: String
    let endereco: String
    let disponibilidade: String
    let urlImage: String
    
     
}
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.yellow)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
struct ContentView: View {
    
    @State private var disponibilidade = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -19.9246932, longitude: -43.9975674), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta:0.05))
    @State private var ç = false;
    @State private var showSheet = false;
    
    @State private var localClicado =  Location(name: "Belo Horizonte",coordinate: CLLocationCoordinate2D(latitude: 12.8610333, longitude: -87.660051),  endereco: "R. Pará de Minas, 821 - Padre Eustáquio, Belo Horizonte - MG, 30730-440",
        disponibilidade:"Disponível",
        urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png")
    
    let regions =
    [
        
     
        Location(name: "Mecantil do Brasil - Bem Aqui",coordinate: CLLocationCoordinate2D(latitude: -19.8994557, longitude: -44.0056853),  endereco: "R. Pará de Minas, 821 - Padre Eustáquio, Belo Horizonte - MG, 30730-440",disponibilidade:"Disponível",urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
        Location(name: "Banco do Brasil Padre Eustaquio",coordinate: CLLocationCoordinate2D(latitude: -19.9151055, longitude: -43.9816139),  endereco: "Av. Abílio Machado, 2057 - Glória, Belo Horizonte - MG, 32110-010" ,disponibilidade:"Disponível", urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
        Location(name: "Estação Calafate",coordinate: CLLocationCoordinate2D(latitude: -19.9224388, longitude: -43.9728827),  endereco: "Calafate, Belo Horizonte - MG, 30410-620",disponibilidade:"Disponível",urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
        Location(name: "Diamond Mall",coordinate: CLLocationCoordinate2D(latitude: -19.9279851, longitude: -43.9499844),  endereco: "Av. Olegário Maciel, 1600 - Santo Agostinho, Belo Horizonte - MG, 30180-111",disponibilidade:"Disponível", urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
        Location(name: "Banco Santander - PUC",coordinate: CLLocationCoordinate2D(latitude: -19.9243095, longitude: -43.9927648),  endereco: "R. Dom José Gaspar, 500 - Vila PUC, Belo Horizonte - MG, 30535-901", disponibilidade:"Disponível",urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
        
        Location(name: "Aeroporto Carlos Drummond de Andrade ",coordinate: CLLocationCoordinate2D(latitude:-19.8515457, longitude:  -43.957144),  endereco: "Praça Bagatelle, 204 - São Luiz, Belo Horizonte - MG, 31270-705",disponibilidade:"Disponível", urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
        
        Location(name: "Itau Praça São Vicente",coordinate: CLLocationCoordinate2D(latitude:-19.9274558, longitude: -43.9892329),  endereco: "R. Pará de Minas, 1177 - Padre Eustáquio, Belo Horizonte - MG, 30730-440",disponibilidade:"Disponível", urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
        Location(name: "Shopping Del Rey",coordinate: CLLocationCoordinate2D(latitude:-19.8905556, longitude: -43.9892329), endereco: "Av. Presidente Carlos Luz, 3001 - Pampulha, Belo Horizonte - MG, 31250-010",disponibilidade:"Disponível", urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
          
            
        Location(name: "Mineirão",coordinate: CLLocationCoordinate2D(latitude:-19.8498475, longitude: 43.9548899),  endereco: "Av. Antônio Abrahão Caram, 1001 - São José, Belo Horizonte - MG, 31275-000", disponibilidade:"Disponível",urlImage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png")
        
        
        
    ]
    var body: some View {
        NavigationStack {
        VStack {
           
            
            Text("GuardaKi")
                .font(.largeTitle)
                .foregroundColor(.yellow)
            Text(localClicado.name)
            
            Spacer()
            
            Map(coordinateRegion: $region, annotationItems: regions){
                region in
                MapAnnotation(coordinate: region.coordinate) {
                    AsyncImage(url: URL(string: localClicado.urlImage)) { image in
                        image.resizable()
                        .foregroundColor(.pink)
                        .frame(width: 50.0, height: 50.0)
                        
                    } placeholder: {
                        ProgressView()
                    }
                     
                        .onTapGesture
                    {
                            showSheet = true;
                            localClicado = region
                            
                    }
                    
                }
              
                
                
            }
            
            .frame(width: 400.0, height: 400.0)
                Spacer()
                .sheet(isPresented:$showSheet) {
                    
                    AsyncImage(url: URL(string: localClicado.urlImage)) { image in
                    image.resizable()
                    .padding(.top, 50)
                    .frame(width: 150.0, height: 150.0)
                        
                        VStack
                        {
                            //Spacer()
                            Text(localClicado.name)
                            .font(.largeTitle)
                           
                            //.foregroundColor(.green)
                            Spacer()
                            Text("Endereço: ")
                                .font(.title2)
                            Text(localClicado.endereco)
                                .frame(width: 350, alignment: .center)
                            .padding(10.0)
                            Spacer()
                            Text("Status: ")
                                .font(.title2)
                            Text(localClicado.disponibilidade)
                            if disponibilidade == "Disponível"{
                                Text(localClicado.disponibilidade)
                                    .foregroundColor(.green)
                            }
                            if disponibilidade == "Indisponível"{
                                Text(localClicado.disponibilidade)
                                    .foregroundColor(.red)
                            }
                            Button("Alugar") {
                                    print("Button tapped!")
                            }
                            .buttonStyle(GrowingButton())

                           // Spacer()
                                
                                
                        }
                }
                placeholder: {
                    ProgressView()
                }
                //.frame(width: 200.0, height: 300.0)
                .scaledToFill()
              
             
                
            }
            
            HStack{

               // NavigationLink(dest)
               
                    NavigationLink(destination:
                                    MeusCofres()){
                       
                        Text("Meus Cofres")
                            .foregroundColor(.black)
                            .padding()
                            .background(.yellow)
                            
                        .buttonStyle(GrowingButton())
                        
                    }
                   
                    
                }
              
                
                
            }
            .padding()
        }
        
        
        
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
