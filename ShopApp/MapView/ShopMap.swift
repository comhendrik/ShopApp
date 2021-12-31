//
//  ShopMap.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI
import MapKit

struct Shop: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State private var shops: [Shop] = [
        Shop(coordinate: CLLocationCoordinate2D(latitude: 54.313780318172554, longitude: 10.102301529306365)),
        Shop(coordinate: CLLocationCoordinate2D(latitude: 54.77332465096964, longitude: 9.396206886993259)),
        Shop(coordinate: CLLocationCoordinate2D(latitude: 53.858129550927245, longitude: 10.62831124093258))
    ]

    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 54.313780318172554 , longitude: 10.102301529306365),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: shops) { shop in
            MapMarker(coordinate: shop.coordinate , tint: .red)
        }
        .edgesIgnoringSafeArea([.top])
    }
}
