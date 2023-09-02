//
//  GRMapView.swift
//  Gateways
//
//  Created by ... on 2023/9/9.
//

import SwiftUI
import MapKit

struct GRMapView: View {
    @Binding var fullScreen : Bool
    @Binding var selectPosion: CLLocationCoordinate2D?
    @Binding var annotations: [MKPointAnnotation]
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var enable = true
    @State private var allowLocation = false
    
    var body: some View {
        VStack{
            Text("Please add a markerr using icon to locate your gateway on the map.")
            ZStack{
                MapView(selectedCoordinate: $selectPosion,region: $region,annotations: $annotations,allowLocation: $allowLocation)
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
    }
    
    func addAnnotation() {
        if let coordinate = selectPosion {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [MKPointAnnotation]
    
    @Binding var allowLocation : Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isZoomEnabled = true
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        // click add
        let gestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSingleTapPress(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let identifier = "CustomAnnotationView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            annotationView?.markerTintColor = .black
            annotationView?.glyphImage = UIImage(named: "map_pin_ic")
            
            return annotationView
        }
        
        @objc func handleSingleTapPress(_ gestureRecognizer: UITapGestureRecognizer) {
            
            if !parent.allowLocation { return }
            
            guard let mapView = gestureRecognizer.view as? MKMapView else {
                return
            }
            
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = coordinate
            
            parent.annotations.removeAll()
            
            parent.annotations.append(newAnnotation)
            parent.selectedCoordinate = coordinate
            parent.region.center = coordinate
        }
    }
}

struct GRMapView_Previews: PreviewProvider {
    @State static var state = true
    @State static var selectedLL : CLLocationCoordinate2D?
    @State static var annotations : [MKPointAnnotation] = []
    static var previews: some View {
        GRMapView(fullScreen: $state,selectPosion: $selectedLL,annotations: $annotations)
    }
}
