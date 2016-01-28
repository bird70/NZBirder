//
//  MapViewController.h
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class Spot;

@interface MapViewController : UIViewController <CLLocationManagerDelegate>
//- (void)removeObjectForSpot:(Spot *)spot;
//- (void)editObjectForSpot:(Spot *)spot;
//- (void)addAnnotationForSpot:(Spot *)spot;
//- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;
////- (void)handleDoubleTap:(Spot *)spot;
////- (IBAction)performCoordinateGeocode:(id)sender;
//@property (weak, nonatomic) IBOutlet UITableViewCell *mapLocationCell;
//@property (weak, nonatomic) CLPlacemark *myplacemark;
@property (weak, nonatomic) NSString *spotname;

//txs 01/16 added
//@property (nonatomic) CLAuthorizationStatus *status;
@end
