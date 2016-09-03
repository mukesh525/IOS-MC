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
    var locationManager = CLLocationManager()
    var location:CLLocationCoordinate2D!
    @IBOutlet weak var latlong: UILabel!
    let regionRadius: CLLocationDistance = 1000
    var punkt:MapPin!
    override func viewDidLoad() {
        self.mapView.delegate = self
        latlong.text="LAT:12.9719811 LONG:77.7502391"
        location = CLLocationCoordinate2D(
            latitude: 12.9719811,
            longitude: 77.7502391
        )
       
        let span = MKCoordinateSpanMake(0.01, 0.01)
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
            self.addressLabel.text="\(address.LocationName!),\(address.Street!),\(address.City!),\(address.Zip!),\(address.Country!)"
  
        })

        
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
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
    
    

    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if view.annotation!.isKindOfClass(MKUserLocation){
            return
        }
        
        let customView = (NSBundle.mainBundle().loadNibNamed("CustomSubView", owner: self, options: nil))[0] as! CustomSubView;
        
        var calloutViewFrame = customView.frame;
            calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15,-calloutViewFrame.size.height);
        
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
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        
        //self.mapView.selectAnnotation(punkt, animated: false)
        
//        for map in mapView.annotations {
//            if(map.isEqual(punkt)){
//                mapView.selectAnnotation(map, animated: false)
//            }
//        }

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.mapView.delegate=self
    }
    
 
    
    override func viewDidAppear(animated: Bool) {
        let region = MKCoordinateRegion(center:location, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(region, animated: true)
        punkt = MapPin(name: "Rohit", type: MISSED, time: "2:00 pm", date: "23/12/78", number: "9886102532")
        punkt.coordinate = location
        mapView.addAnnotation(punkt)
       self.mapView.selectAnnotation(punkt, animated: false)
        
        
    }
    

    
 
}