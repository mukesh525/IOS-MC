//
//  MapController.swift
//  MCube
//
//  Created by Mukesh Jha on 17/08/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import MapKit

class MapController: UIViewController,MKMapViewDelegate {

  @IBOutlet weak var mapView: MKMapView!
   
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        self.mapView.delegate = self
        
        var info1 = CustomPointAnnotation()
        info1.coordinate = CLLocationCoordinate2DMake(42, -84)
        info1.title = "Info1"
        info1.subtitle = "Subtitle"
        info1.imageName = "place"
        
        mapView.addAnnotation(info1)
        
        
        
        
        
        
        
    }


    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    
    
   func centerMapOnLocation(location: CLLocation) {
   let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
   }
    
    
    
}