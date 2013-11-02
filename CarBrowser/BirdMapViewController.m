//
//  BirdMapViewController.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 15/05/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BirdMapViewController.h"
#define METERS_PER_MILE 1609.344
#import <CoreLocation/CoreLocation.h>


@interface BirdMapViewController () <MKMapViewDelegate>

@end

@implementation BirdMapViewController
@synthesize mapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    // 1
    //CLLocationCoordinate2D zoomLocation;
    //zoomLocation.latitude = 48.281516;
    //zoomLocation.longitude= 8.580806;
    
    // 2
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    //[mapView setRegion:viewRegion animated:YES];
    
    [mapView setZoomEnabled:YES];
    [mapView setMapType:2]; //make mapView type '2' (which is 'hybrid')
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100, 100);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"this is my location!!";
    //self.lblLat = userLocation. userLocation.coordinate.latitude;
    
    [self.mapView addAnnotation:point];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
