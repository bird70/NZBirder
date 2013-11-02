//
//  MapViewController.m
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"
#import "Spot.h"
#import "DetailViewController.h"
#import "ModelController.h"
#import "NSCoder+RNMapKit.h"

static NSString * const kRegionKey = @"kRegionKey";
static NSString * const kUserTrackingKey = @"kUserTrackingKey";
#define kSanFranciscoCoordinate CLLocationCoordinate2DMake(37.776278, -122.419367)

//@interface ReverseViewController ()


@interface MapViewController () <MKMapViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D currentUserCoordinate;
@end

@implementation MapViewController
@synthesize spotname;

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
  [super encodeRestorableStateWithCoder:coder];
  
  [coder RN_encodeMKCoordinateRegion:self.mapView.region
                              forKey:kRegionKey];
  [coder encodeInteger:self.mapView.userTrackingMode
                forKey:kUserTrackingKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
  [super decodeRestorableStateWithCoder:coder];
  
  if ([coder containsValueForKey:kRegionKey]) {
    self.mapView.region =
    [coder RN_decodeMKCoordinateRegionForKey:kRegionKey];
  }
  
  self.mapView.userTrackingMode =
  [coder decodeIntegerForKey:kUserTrackingKey];
}

- (void)awakeFromNib {
  self.managedObjectContext = [[ModelController sharedController] managedObjectContext];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handleLongPress:)];
  lpgr.minimumPressDuration = 1.0;
  [self.mapView addGestureRecognizer:lpgr];
  for (Spot *spot in [self.fetchedResultsController fetchedObjects]) {
    [self addAnnotationForSpot:spot];
  //UISwipeGestureRecognizer
  }
  
  MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
  self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)addAnnotationForSpot:(Spot *)spot
{
  MapViewAnnotation *ann = [[MapViewAnnotation alloc] initWithSpot:spot];
  [self.mapView addAnnotation:ann];
}

//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UITouch *aTouch in touches) {
//        if (aTouch.tapCount >= 3) {
//            // The view responds to the tap
//            //[[self handleDoubleTap] (aTouch)]
//            NSLog(@"Tapped 3x");
//            //[self handleTripleTap:aTouch];
//            
//            
//        }
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//}

//- (void)handleTripleTap:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
//        return;
//    
//    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
//    CLLocationCoordinate2D touchMapCoordinate =
//    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
//    
//    Spot *spot = [Spot insertNewSpotWithCoordinate:touchMapCoordinate inManagedObjectContext:self.managedObjectContext];
//    
//    //[self editObjectForSpot:spot];
//    //[self performSegueWithIdentifier:@"newSpot" sender:spot];
//}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
  if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
    return;
  
  CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
  CLLocationCoordinate2D touchMapCoordinate =
  [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
  
   //geocode the location pressed on the map
    // and add a new spot for the location, (spot.name is composed of location and date)
   NSString *when = [self getdate];
    
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
        {
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
            if (error){
                NSLog(@"Geocode failed with error: %@", error);
                //[self displayError:error];
                //NSString *placename = @"%@, %@", touchMapCoordinate.latitude, touchMapCoordinate.longitude;
                self.spotname  =
                [NSString stringWithFormat:@"%.3f, %.3f, %@", touchMapCoordinate.latitude, touchMapCoordinate.longitude, when];
                
                //return geocodedPlacename;
            }
            
            NSLog(@"Received placemarks: %@", placemarks);
            //[self displayPlacemarks:placemarks];
            CLPlacemark *myplacemark = [placemarks objectAtIndex:0];
            //[self displayPlacemarks:placemarks];
            //self.locationLabel.text =
            NSString *geocodedPlacename = myplacemark.locality;
            if (geocodedPlacename == nil) {
                geocodedPlacename  =
                [NSString stringWithFormat:@"%.3f, %.3f", touchMapCoordinate.latitude, touchMapCoordinate.longitude];
                
            }
            self.spotname = [NSString stringWithFormat:@"%@ at %@",geocodedPlacename, when];
            NSLog (@"self.spotname is: %@", self.spotname);
            
            Spot *spot = [Spot insertNewSpotWithCoordinateAndName:touchMapCoordinate spotname:self.spotname inManagedObjectContext:self.managedObjectContext];
           
           
            
            //NSManagedObjectContext *context2 = [[ModelController sharedController] managedObjectContext];
            NSEntityDescription *entityDescription = [NSEntityDescription
                                                      entityForName:@"CurrentSpot" inManagedObjectContext:self.managedObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDescription];
            
            
            NSPredicate *predicate = nil;
            [request setPredicate:predicate];
            [request setSortDescriptors:nil];
            
            
            //Retrieve the Current Spot
            //make the newly added spot the new current spot
            NSArray *mo = [self.managedObjectContext executeFetchRequest:request error:&error];
            if (mo == nil)
            {
                // Deal with error...
                NSLog(@"can't retrieve the only CurrentSpot entry");
            }
            else{
                [mo[0] setValue:spot.name forKey:@"name"];
            }
            
            [self.managedObjectContext save:nil];
            NSManagedObjectID *newspotID = spot.objectID;
             [self performSegueWithIdentifier:@"newSpot" sender:spot];
        }];
    }
  
    
  }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"newSpot"]) {
    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.spot = sender;
  }
}

- (NSFetchedResultsController *)fetchedResultsController
{
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }
  
  NSManagedObjectContext *moc = [[ModelController sharedController] managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spot" inManagedObjectContext:moc];
  [fetchRequest setEntity:entity];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = @[sortDescriptor];
  
  [fetchRequest setSortDescriptors:sortDescriptors];
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                              managedObjectContext:moc
                                                                                                sectionNameKeyPath:nil
                                                                                                         cacheName:@"MapView"];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;
  
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  
  return _fetchedResultsController;
}

#pragma mark Actions
/*
- (IBAction)performCoordinateGeocode:(id)sender
{
    //[self lockUI];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocationCoordinate2D coord =  kSanFranciscoCoordinate; //: _currentUserCoordinate;
    
    //CLLocationCoordinate2D coord =
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            //[self displayError:error];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        //[self displayPlacemarks:placemarks];
    }];
}
*/

- (void)removeObjectForSpot:(Spot *)spot
{
    for (MapViewAnnotation *ann in self.mapView.annotations) {
        if ([ann.spot isEqual:spot]) {
            [self.mapView removeAnnotation:ann];
            NSLog(@"removing annotation");
            break;
        }
    }
}


//- (void)editObjectForSpot:(Spot *)spot
//{
//    NSLog(@"editing existing spot");
//    for (MapViewAnnotation *ann in self.mapView.annotations) {
//        NSLog(@"editing existing spot");
//        
//        if ([ann.spot isEqual:spot]) {
//            [self performSegueWithIdentifier:@"newSpot" sender:spot];
//            break;
//        }
//    }
//}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self addAnnotationForSpot:anObject];
            NSLog(@"add annoForSpot");
            break;
            
        case NSFetchedResultsChangeDelete:
            [self removeObjectForSpot:anObject];
            NSLog(@"remove anno");
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MapViewAnnotation class]]) {
        MapViewAnnotation *ann = view.annotation;
        [self performSegueWithIdentifier:@"newSpot" sender:ann.spot];
        [self.mapView deselectAnnotation:view.annotation animated:NO];
    }
}

-(NSString *)getdate{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM, yyyy HH:mm"];
    //NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    //[timeFormat setDateFormat:@"HH:mm:ss"];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
//    [dateFormatter setDateFormat:@"EEEE"];
    
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:now];
//    NSString *theDate = [dateFormat stringFromDate:now];
//    //NSString *theTime = [timeFormat stringFromDate:now];
    
//    NSString *week = [dateFormatter stringFromDate:now];
//    NSLog(@"\n"
//          "dateString: |%@| \n"
//          "dateFormatter: |%@| \n"
//          "Now: |%@| \n"
//          "Week: |%@| \n"
//          
//          , dateString, dateFormatter,theDate,week);
//    
    return dateString;
}
@end
