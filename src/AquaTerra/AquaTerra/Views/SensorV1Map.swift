//
//  SensorV1Map.swift
//  AquaTerra
//
//  Created by Davincci on 11/10/2023.
//


import SwiftUI
import MapKit

struct SensorV1MapView: View {
    @Binding var fullScreen : Bool
    @Binding var selectPosion: CLLocationCoordinate2D?
    @Binding var annotations: [MKPointAnnotation]
    
    @Binding var latitude: String?
    @Binding var longitude: String?
    
    @Binding private var region: MKCoordinateRegion
    @State private var enable = true
    @State private var allowLocation = false
    
    
    init(fullScreen: Binding<Bool>, selectPosion: Binding<CLLocationCoordinate2D?>, annotations: Binding<[MKPointAnnotation]>, latitude: Binding<String?>, longitude: Binding<String?>, region:Binding<MKCoordinateRegion>) {
        self._fullScreen = fullScreen
        self._selectPosion = selectPosion
        self._annotations = annotations
        self._latitude = latitude
        self._longitude = longitude
        self._region = region
    }
    
    var body: some View {
        VStack{
            ZStack{
                SMapView(selectedCoordinate: $selectPosion, region: $region, annotations: $annotations, allowLocation: $allowLocation, latitude: latitude, longitude: longitude)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing){
                        HStack{
                            HStack{
                                Image("hand_ic")
                                    .onTapGesture {
                                        allowLocation = false
                                    }
                                    .opacity(allowLocation ? 0.5 : 1)
                                Image("map_pin_ic")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.black)
                                    .onTapGesture {
                                        allowLocation = true
                                    }
                                    .opacity(allowLocation ? 1 : 0.5)
                            }
                            .frame(width: 77,height: 33)
                            .background(Color.white)
                        }
                        .padding()
                        
                        Image("scale_full_ic")
                            .onTapGesture {
                                withAnimation(.spring(response: 1,dampingFraction: 0.5,blendDuration: 1)) {
                                    fullScreen.toggle()
                                }
                            }
                            .padding(.top,2)
                            .padding(.trailing)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            addAnnotation()
        }
    }
    
    func addAnnotation() {
        if let latitudeStr = latitude, let longitudeStr = longitude,
           let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
            let initialAnnotation = MKPointAnnotation()
            initialAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotations.append(initialAnnotation)
        }
    }
}
