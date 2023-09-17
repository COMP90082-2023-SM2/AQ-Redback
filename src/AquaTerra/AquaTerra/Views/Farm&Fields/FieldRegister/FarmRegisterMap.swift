//
//  FarmRegisterWKMap.swift
//  AquaTerra
//
//  Created by wd on 2023/9/14.
//

import SwiftUI
import MapKit

struct FarmRegisterMap: View {
        
    @Binding var mapFullScreen: Bool

    @Binding var drawPolylineFinished: Bool

    @State private var shouldDrawPolyline = false

    @Binding var locations: [CLLocation]

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    
    var body: some View {
        VStack {
            HStack(alignment: .center, content: {
                Text("• Please draw a polygon shape on the map using the")
                    .font(.custom("OpenSans-Regular", size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                Image("FarmRegisterMapPolyline")
                    .resizable()
                    .frame(width: 25, height: 27)
                Text("to outline your field.")
                    .font(.custom("OpenSans-Regular", size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            })
            
            Text("• The field must be within 1000 metres from the gateway.")
                .font(.custom("OpenSans-Regular", size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                
                FarmRegisterWKMap(shouldDrawPolyline: $shouldDrawPolyline, drawPolylineFinished: $drawPolylineFinished, locations: $locations)
                
                HStack {
                    Spacer()
                    VStack(alignment: .trailing){
                        HStack{
                            HStack{
                                Image("hand_ic")
                                    .onTapGesture {
                                        shouldDrawPolyline = false
                                    }
                                    .opacity(shouldDrawPolyline ? 0.5 : 1)
                                Image("FarmRegisterMapPolyline")
                                    .resizable()
                                    .frame(width: 25, height: 27)
                                    .onTapGesture {
                                        shouldDrawPolyline = true
                                    }
                                    .opacity(shouldDrawPolyline ? 1 : 0.5)
                            }
                            .frame(width: 77,height: 33)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        
                        Image("scale_full_ic")
                            .onTapGesture {
                                withAnimation(.spring(response: 1,dampingFraction: 0.5,blendDuration: 1)) {
                                    
                                    mapFullScreen.toggle()
                                }
                            }
                            .padding(.top,2)
                            .padding(.trailing)
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct FarmRegisterWKMap: UIViewRepresentable {
    
    let mapView = MKMapView()
    
    let region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Binding var shouldDrawPolyline: Bool

    @Binding var drawPolylineFinished: Bool

    @Binding var locations: [CLLocation]
    
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.delegate = context.coordinator
        mapView.region = region
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        debugPrint("updateUIView")
        
        if locations.isEmpty {
            view.removeOverlays(view.overlays)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
    var parent: FarmRegisterWKMap
    
    init(_ parent: FarmRegisterWKMap) {
        self.parent = parent
        super.init()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.delegate = self
        self.parent.mapView.addGestureRecognizer(tap)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 8
            renderer.alpha = 0.75
            
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    @objc func tapHandler(_ gesture: UITapGestureRecognizer) {

        guard self.parent.shouldDrawPolyline else {
            return
        }
        
        let touchPoint = gesture.location(in: self.parent.mapView)

        let coordinate = self.parent.mapView.convert(touchPoint, toCoordinateFrom: self.parent.mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        guard let firstLocation = self.parent.locations.first else {
            
            self.parent.locations.append(location)
            
            let polyline = MKPolyline(coordinates: [location.coordinate], count: 1)
            self.parent.mapView.addOverlay(polyline)
            return
        }
        
        let firstPoint = self.parent.mapView.convert(firstLocation.coordinate, toPointTo: self.parent.mapView)
        
        let deltaX = abs(touchPoint.x - firstPoint.x)
        let deltaY = abs(touchPoint.y - firstPoint.y)
        let distance = sqrt(deltaX*deltaX + deltaY*deltaY)
        
        print("x1 y1: \(firstPoint.x) \(firstPoint.y)")
        print("x2 y2: \(touchPoint.x) \(touchPoint.y)")
        print("two point distance == \(distance)")
        
        if distance > 10 {
            //draw new line
            let polyline = MKPolyline(coordinates: [self.parent.locations.last!.coordinate, location.coordinate], count: 2)
            self.parent.mapView.addOverlay(polyline)
            
            self.parent.locations.append(location)
            
        } else {
            
            if self.parent.locations.count < 2 {
                return
            }
            
            //finish draw
            let polyline = MKPolyline(coordinates: [self.parent.locations.last!.coordinate, self.parent.locations.first!.coordinate], count: 2)
            self.parent.mapView.addOverlay(polyline)
            
            self.parent.locations.append(location)
            
            self.parent.drawPolylineFinished = true
        }
    }
}
