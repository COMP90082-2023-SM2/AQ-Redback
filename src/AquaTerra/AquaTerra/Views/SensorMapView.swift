//
//  SensorMapView.swift
//  AquaTerra
//
//  Created by Davincci on 16/9/2023.
//

import SwiftUI
import MapKit

struct SensorMapView: View {
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

struct SMapView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [MKPointAnnotation]
    @Binding var allowLocation: Bool
    
    var latitude: String?
    var longitude: String?

    func makeUIView(context: Context) -> MKMapView {
        let smapView = MKMapView()
        smapView.isZoomEnabled = true
        smapView.delegate = context.coordinator
        
        if let latitudeStr = latitude, let longitudeStr = longitude,
           let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
            let initialAnnotation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let initialRegion = MKCoordinateRegion(center: initialAnnotation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            print("set region")
            print(Double(latitudeStr),Double(longitudeStr))
            self.selectedCoordinate = initialAnnotation
            self.region.center = initialAnnotation
            smapView.setRegion(initialRegion, animated: true)
        }

        

//        smapView.setRegion(region, animated: true)

        // Add the annotations here if needed

        // click add
        let gestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSingleTapPress(_:)))
        smapView.addGestureRecognizer(gestureRecognizer)
        return smapView
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
        var parent: SMapView
        
        init(_ parent: SMapView) {
            self.parent = parent
        }
        
        func mapView(_ smapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = smapView.region
        }
        
        func mapView(_ smapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let identifier = "CustomAnnotationView"
            var annotationView = smapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
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
            
            guard let smapView = gestureRecognizer.view as? MKMapView else {
                return
            }
            
            let location = gestureRecognizer.location(in: smapView)
            let coordinate = smapView.convert(location, toCoordinateFrom: smapView)
            
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = coordinate
            
            parent.annotations.removeAll()
            
            parent.annotations.append(newAnnotation)
            parent.selectedCoordinate = coordinate
            parent.region.center = coordinate
        }
    }
}
