//
//  SensorMapView.swift
//  AquaTerra
//
//  Created by Davincci on 16/9/2023.
//

import SwiftUI
import MapKit

struct SensorMapView: View {
    @Binding var fullScreen: Bool
    @Binding var selectPosion: CLLocationCoordinate2D?
    @Binding var annotations: [MKPointAnnotation]
    @Binding var latitude: String?
    @Binding var longitude: String?
    @Binding private var region: MKCoordinateRegion
    @State private var enable = true
    @State private var allowLocation = false
    @Binding var polygenResultsV2: String?


    init(fullScreen: Binding<Bool>, selectPosion: Binding<CLLocationCoordinate2D?>, annotations: Binding<[MKPointAnnotation]>, latitude: Binding<String?>, longitude: Binding<String?>, region: Binding<MKCoordinateRegion>, polygenResultsV2: Binding<String?>) {
        self._fullScreen = fullScreen
        self._selectPosion = selectPosion
        self._annotations = annotations
        self._latitude = latitude
        self._longitude = longitude
        self._region = region
        self._polygenResultsV2 = polygenResultsV2
    }

    var body: some View {
        VStack {
//            Text(polygenResultsV2 ?? "No Polygons")
            ZStack {
                SMapView(selectedCoordinate: $selectPosion, region: $region, annotations: $annotations, allowLocation: $allowLocation, latitude: latitude, longitude: longitude, polygenResultsV2: polygenResultsV2 ?? "")
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack {
                            HStack {
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
                            .frame(width: 77, height: 33)
                            .background(Color.white)
                        }
                        .padding()

                        Image("scale_full_ic")
                            .onTapGesture {
                                withAnimation {
                                    fullScreen.toggle()
                                }
                            }
                            .padding(.top, 2)
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
    var polygenResultsV2: String

    func makeUIView(context: Context) -> MKMapView {
        let smapView = MKMapView()
        smapView.isZoomEnabled = true
        smapView.delegate = context.coordinator

        if let latitudeStr = latitude, let longitudeStr = longitude,
           let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
            let initialAnnotation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let initialRegion = MKCoordinateRegion(center: initialAnnotation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.selectedCoordinate = initialAnnotation
            region.center = initialAnnotation
        }

//        if !polygenResultsV2.isEmpty {
//            let coordinates = convertCoordinatesFromString(polygenResultsV2)
//            if !coordinates.isEmpty {
//                let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
//                smapView.addOverlay(polygon)
//            }
//        }
        print("polygenResultsV2 in SMapView:", polygenResultsV2)

        // Add the annotations here if needed

        let gestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSingleTapPress(_:)))
        smapView.addGestureRecognizer(gestureRecognizer)
        return smapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        
        if !polygenResultsV2.isEmpty {
            let coordinates = convertCoordinatesFromString(polygenResultsV2)
            if !coordinates.isEmpty {
                let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
                uiView.addOverlay(polygon)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func convertCoordinatesFromString(_ coordinateString: String) -> [CLLocationCoordinate2D] {
        print("coordinateString")
        print()
        let coordinatePairs = coordinateString.components(separatedBy: "],[")
        print("coordinatePairs")
        print(coordinatePairs)

        var coordinates: [CLLocationCoordinate2D] = []
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        for pair in coordinatePairs {
            let components = pair.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",")
            print(components)
            print("Components")
            if components.count == 2 {
                if let latitude = formatter.number(from: components[1])?.doubleValue,
                   let longitude = formatter.number(from: components[0])?.doubleValue {
                    coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    print(coordinates)
                }
            }
        }

        return coordinates
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
        
        func mapView(_ smapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                if let polygon = overlay as? MKPolygon {
                    let renderer = MKPolygonRenderer(polygon: polygon)
                    renderer.fillColor = UIColor.brown.withAlphaComponent(1) // Customize polygon fill color
                    renderer.strokeColor = UIColor.brown // Customize polygon border color
                    renderer.lineWidth = 2.0 // Customize polygon border width
                    return renderer
                }
                return MKOverlayRenderer(overlay: overlay)
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
