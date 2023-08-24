//
//  ContentView.swift
//  cofreList
//
//  Created by Student24 on 13/06/23.
//

import SwiftUI
import MapKit

struct cofre: Identifiable{
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var endereco: String
    var lock: Bool
    var icon: String
    var urlimage: String
}


struct Place :  Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    }

var localClicado =  cofre(name: "Mineirão",coordinate: CLLocationCoordinate2D(latitude:-19.8498475, longitude: 43.9548899),  endereco: "Av. Antônio Abrahão Caram, 1001 - São José, Belo Horizonte - MG, 31275-000", lock: true, icon: "lock.square.fill", urlimage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png" )
  var showSheet = false

  var localAtual = "Brazil"

  var annotations = [Place(name: "Banco do Brasil Padre Eustaquio", coordinate: CLLocationCoordinate2D(latitude: -19.9151055, longitude: -43.9816139)), Place(name: "Estação Calafate", coordinate: CLLocationCoordinate2D(latitude: -19.9224388, longitude: -43.9728827)), Place(name: "Banco Santander - PUC", coordinate: CLLocationCoordinate2D(latitude: -19.9243095, longitude: -43.9927648)), Place(name: "Shopping Del Rey", coordinate: CLLocationCoordinate2D(latitude: -19.8905556, longitude: -43.9892329)), Place(name: "Diamond Mall", coordinate: CLLocationCoordinate2D(latitude: -19.9279851, longitude: -43.9499844))]



struct MeusCofres: View {
    @State var cofres = [
                  cofre(name: "Banco do Brasil Padre Eustaquio",coordinate: CLLocationCoordinate2D(latitude: -19.9151055, longitude: -43.9816139),  endereco: "R. Padre Eustáquio, 2783 - Padre Eustáquio, Belo Horizonte - MG, 30720-100" ,lock:false, icon: "lock.square.fill", urlimage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
                  cofre(name: "Estação Calafate",coordinate: CLLocationCoordinate2D(latitude: -19.9224388, longitude: -43.9728827),  endereco: "Calafate, Belo Horizonte - MG, 30410-620",lock:true, icon: "lock.square.fill", urlimage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
                  cofre(name: "Banco Santander - PUC",coordinate: CLLocationCoordinate2D(latitude: -19.9243095, longitude: -43.9927648),  endereco: "R. Dom José Gaspar, 500 - Vila PUC, Belo Horizonte - MG, 30535-901", lock:true, icon: "lock.square.fill", urlimage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
                  cofre(name: "Shopping Del Rey",coordinate: CLLocationCoordinate2D(latitude:-19.8905556, longitude: -43.9892329), endereco: "Av. Presidente Carlos Luz, 3001 - Pampulha, Belo Horizonte - MG, 31250-010",lock:false, icon: "lock.square.fill", urlimage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png"),
                  cofre(name: "Diamond Mall",coordinate: CLLocationCoordinate2D(latitude: -19.9279851, longitude: -43.9499844),  endereco: "Av. Olegário Maciel, 1600 - Santo Agostinho, Belo Horizonte - MG, 30180-111",lock:false, icon: "lock.square.fill", urlimage: "https://cdn-icons-png.flaticon.com/512/4807/4807938.png")]

    
    @StateObject var viewModel = APIView()
    @State private var showingSheet = false
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -19.9151055, longitude: -43.9816139), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var body: some View {
        NavigationStack {
            VStack {
               
                Text("Meus Cofres")
                    .font(.system(size: 38))
                Spacer()
                    .frame(height: 40.0)
                ForEach(cofres, id: \.id) { cofre in
                    
                    HStack{
                        Image(systemName: (cofre.icon))
                            .font(.system(size: 60))
                            .frame(width: 35.0, height: 50.0)
                            .foregroundColor(.red)
                        Spacer()
                        Text(cofre.name)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .textCase(.uppercase)
                        
                        if cofre.lock{
                            Image(systemName: (cofre.icon))
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: (cofre.icon))
                                .foregroundColor(.green)
                        }
                        NavigationLink(destination:
                                        TimerView()){
                           
                           
                            Image(systemName: "timer.square")
                                .font(.system(size: 40))
                            
                            
                        }
                       
                        
                        
                        
                        //
                        //                    Spacer()
                        //                        .frame(width: 30.0)
                        Button{
                            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: cofre.coordinate.latitude, longitude: cofre.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                            localClicado = cofre
                            localAtual = cofre.name
                            showingSheet.toggle()
                        }label: {
                            Image(systemName: "map.fill")
                        }
                        
                        .sheet(isPresented: $showingSheet) {
                            Text(localAtual)
                            Map(coordinateRegion: $region, annotationItems: cofres) { cofres in
                                MapAnnotation(coordinate: cofres.coordinate) {
                                    Image(systemName: "lock.circle.fill")
                                        .font(.system(size: 40))
                                    
                                    //                                Circle()
                                    //                                    .strokeBorder(.red, lineWidth: 4)
                                    //                                    .frame(width: 40, height: 40)
                                    //                                    .onTapGesture {
                                    //                                        showSheet = true
                                    //                                    }
                                }
                            }
                            Button{
                                //                            dismiss()
                            }label: {
                                Image(systemName: "pip.exit")
                            }
                            .font(.title)
                            .padding()
                            .background(.black)
                            //                        SheetView()
                        }
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                        .cornerRadius(50)
                        .padding(.horizontal, 10)
                        
                    }.background(Color.yellow)
                        .cornerRadius(20)
                    
                    
                    
                    
                }
                .padding()
            }.onAppear(){
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
                    viewModel.fetch()
                    if(viewModel.distancia <= 5.00)
                    {
                        cofres[0].lock = true
                        
                    }else if(viewModel.distancia > 5.00){
                        cofres[0].lock = false
                    }
                    print(cofres[0].lock)
                }
            }
        }
    }
//    struct SheetView: View {
//        @Environment(\.dismiss) var dismiss
//
////        @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -19.9279851, longitude: -43.9499844), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        var body: some View {
//            Text(localAtual)
//            Map(coordinateRegion: $region, annotationItems: cofres) { cofres in
//                MapAnnotation(coordinate: cofres.coordinate) {
//                    Circle()
//                        .strokeBorder(.red, lineWidth: 4)
//                        .frame(width: 40, height: 40)
//                        .onTapGesture {
//                            showSheet = true
//                        }
//                }
//            }
//            Button{
//                dismiss()
//            }label: {
//                Image(systemName: "pip.exit")
//            }
//            .font(.title)
//            .padding()
//            .background(.black)
//        }
//    }
    struct MeusCofres_Previews: PreviewProvider {
        static var previews: some View {
            MeusCofres()
        }
    }
}
