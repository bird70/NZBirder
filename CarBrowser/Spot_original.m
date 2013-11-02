//
//  Spot.m
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import "Spot.h"
#import "ModelController.h"

@implementation Spot

@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic notes;
@dynamic observations;


+ (Spot *)insertNewSpotWithCoordinate:(CLLocationCoordinate2D)coordinate inManagedObjectContext:(NSManagedObjectContext *)context
{
  Spot *spot = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  df.dateStyle = NSDateFormatterShortStyle;
  df.timeStyle = NSDateFormatterShortStyle;
  spot.name = [NSString stringWithFormat:@"Spot (%@)", [df stringFromDate:[NSDate date]]];
  //spot.latitude = coordinate.latitude;
  //spot.longitude = coordinate.longitude;
  return spot;
}

+ (Spot *)insertNewSpotWithCoordinateAndName:(CLLocationCoordinate2D)coordinate spotname:(NSString*)spotname inManagedObjectContext:(NSManagedObjectContext *)context
{
    Spot *spot = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    spot.name = spotname;
    //[NSString stringWithFormat:@"Spot (%@)", [df stringFromDate:[NSDate date]]];
    //spot.latitude = coordinate.latitude;
    //spot.longitude = coordinate.longitude;
    return spot;
}
/*
+ (Spot *)getSpotWithCoordinate:(CLLocationCoordinate2D)coordinate inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Trying to get spot");
    //return spot;
}*/

@end
