//
//  MapController.swift
//  MCube
//
//  Created by Mukesh Jha on 17/08/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import MapKit
import Foundation

class MapController: UIViewController,MKMapViewDelegate {

  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var location:CLLocationCoordinate2D!
    @IBOutlet weak var latlong: UILabel!
    let regionRadius: CLLocationDistance = 1000
    var punkt:MapPin!
    var currentdata:Data!
       override func viewDidLoad() {
        self.mapView.delegate = self
        let locate=currentdata.location!.components(separatedBy: ",")
        latlong.text="LAT:\(locate[0]) LONG:\(locate[1])"
        location = CLLocationCoordinate2D(
            latitude: Double(locate[0])!,
            longitude: Double(locate[1])!
        )
       
        let span = MKCoordinateSpanMake(0.10, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
 
        
 
        
       
        
        addressLabel.numberOfLines = 2;
        let address=Address();
        let geoCoder = CLGeocoder()
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
           
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
               // print(locationName)
                address.LocationName=locationName as String;
            }
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                //print(street)
                 address.Street=street as String;
            }
            if let city = placeMark.addressDictionary!["City"] as? NSString {
               // print(city)
                 address.City=city as String;
            }
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
               // print(zip)
                 address.Zip=zip as String;
            }
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                address.Country=country as String;
            }
            //,\(address.Street == nil ? "":address.Street!)
            self.addressLabel.text="\(address.LocationName == nil ? "":address.LocationName!),\(address.City == nil ? "":address.City!),\(address.Zip == nil ? "":address.Zip!),\(address.Country == nil ?"":address.Country!)"
  
        })

        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
           }
        else {

            pinView!.annotation = annotation
        }
        
        pinView!.canShowCallout = true
        pinView!.animatesDrop = true
      //  pinView!.selected=true

        
        return pinView
    }
    
    

    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation!.isKind(of: MKUserLocation.self){
            return
        }
        
        let customView = (Bundle.main.loadNibNamed("CustomSubView", owner: self, options: nil))?[0] as! CustomSubView;
        
        var calloutViewFrame = customView.frame;
            calloutViewFrame.origin = CGPoint(x: -calloutViewFrame.size.width/2 + 15,y: -calloutViewFrame.size.height);
        
        customView.frame = calloutViewFrame;
        
        let cpa = view.annotation as! MapPin
        
        customView.name.text=cpa.name
        customView.number.text=cpa.number
        customView.date.text=cpa.date
        customView.type.text=cpa.type
        customView.time.text=cpa.time
        view.addSubview(customView)
        let newRegion = MKCoordinateRegion(center:cpa.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(newRegion, animated: true)
      
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.delegate=self
    }
    
 
    
    override func viewDidAppear(_ animated: Bool) {
        let region = MKCoordinateRegion(center:location, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(region, animated: true)
        punkt = MapPin(name:currentdata.callerName!, type: currentdata.status! == "0" ? MISSED:currentdata.status! == "1" ? INBOUND:OUTBOUND, time: currentdata.startTime!.getTimeFromString(), date: currentdata.startTime!.getDateFromString(), number: currentdata.callFrom!)
        punkt.coordinate = location
        mapView.addAnnotation(punkt)
       self.mapView.selectAnnotation(punkt, animated: false)
        
        
    }
    

    
 
}
