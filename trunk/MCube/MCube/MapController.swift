//
//  MapController.swift
//  MCube
//
//  Created by Mukesh Jha on 17/08/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import MapKit

class MapController: UIViewController,MKMapViewDelegate {

  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
   
    @IBOutlet weak var latlong: UILabel!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        self.mapView.delegate = self
        latlong.text="LAT:12.9719811 LONG:77.7502391"
        
        let location = CLLocationCoordinate2D(
            latitude: 12.9719811,
            longitude: 77.7502391
        )
        // 2
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Call Received Location"
        annotation.subtitle = "London London London"
       
        mapView.addAnnotation(annotation)
        addressLabel.numberOfLines = 2;
        
        
        
        let address=Address();
        let geoCoder = CLGeocoder()
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
           
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
           // print(placeMark.addressDictionary!)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
               // print(locationName)
                address.LocationName=locationName as String;
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                //print(street)
                 address.Street=street as String;
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
               // print(city)
                 address.City=city as String;
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
               // print(zip)
                 address.Zip=zip as String;
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
               // print(country)
                address.Country=country as String;
            }
            self.addressLabel.text="\(address.LocationName!),\(address.Street!),\(address.City!),\(address.Zip!),\(address.Country!)"
  
        })

        
        
        
        
        
        
        
        
    }
    
    



}