//
//  BirdMapViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 15/05/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface BirdMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *lblLong;

@property (weak, nonatomic) IBOutlet UILabel *lblLat;
@end

