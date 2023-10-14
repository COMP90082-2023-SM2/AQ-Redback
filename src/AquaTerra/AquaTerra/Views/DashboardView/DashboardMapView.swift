//
//  DashboardMapView.swift
//  AquaTerra
//
//

import Foundation
import MapKit
import SwiftUI

struct DashboardMapView: UIViewRepresentable {
    let dashboardViewModel: DashboardViewModel
    let coordinateRegion: MKCoordinateRegion
    let annotations: [MKAnnotation]
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = .satellite
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.region = coordinateRegion
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }

    func makeCoordinator() -> DashboardMapViewCoordinator {
        DashboardMapViewCoordinator(dashboardViewModel: dashboardViewModel)
    }
}

class DashboardMapViewCoordinator: NSObject, MKMapViewDelegate {
    weak var dashboardViewModel: DashboardViewModel!

    init(dashboardViewModel: DashboardViewModel? = nil) {
        self.dashboardViewModel = dashboardViewModel
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.titleVisibility = .hidden
        view.subtitleVisibility = .hidden
        switch dashboardViewModel.sensorDataTypeSelection {
        case .moisture:
            view.markerTintColor = UIColor(named: "SoilMoisture1")
        case .battery:
            view.markerTintColor = UIColor(named: "BatteryVoltage4")
        case .temperature:
            view.markerTintColor = UIColor(named: "SoilTemperatureColor3")
        case .info:
            view.markerTintColor = .white
        }

        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let marker = view as? MKMarkerAnnotationView {
            marker.titleVisibility = .visible
            marker.subtitleVisibility = .visible
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let marker = view as? MKMarkerAnnotationView {
            marker.titleVisibility = .hidden
            marker.subtitleVisibility = .hidden
        }
    }
}
