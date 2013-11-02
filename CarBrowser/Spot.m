//
//  Spot.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 19/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "Spot.h"
#import "ModelController.h"


@implementation Spot

@dynamic latitude;
@dynamic longitude;
@dynamic date_last_changed;
@dynamic name;
@dynamic notes;
@dynamic isCurrent;
@dynamic observations;
@dynamic allObs;
@dynamic protocol;
@dynamic startTime;

+ (Spot *)insertNewSpotWithCoordinate:(CLLocationCoordinate2D)coordinate inManagedObjectContext:(NSManagedObjectContext *)context
{
    Spot *spot = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    spot.name = [NSString stringWithFormat:@"Spot (%@)", [df stringFromDate:[NSDate date]]];
    spot.date_last_changed = [NSDate date];
    spot.latitude =  coordinate.latitude;
    spot.longitude = coordinate.longitude;
    spot.protocol = @"Casual";
    spot.allObs = @"Y";
    spot.notes = @" weather, # of observers in party:";
    
    NSDate *now = [[NSDate alloc] init];
   //NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setLocale:usLocale];
//    [formatter setTimeStyle: @"HH:mm"];
//
//   // NSLog(@"Date for locale %@: %@",
//     NSString *localizedString = NSString stringWithFormat:@"%@", [formatter stringFromDate:now];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setLocale:usLocale];
    [formatter setDateFormat:@"HH:mm:ss"];
    //[formatter setTimeStyle: @"HH:mm"];

    NSString *localizedString = [formatter stringFromDate:now];
    spot.startTime = localizedString;
    
    
    //spot.latitude =  [NSNumber numberWithFloat:coordinate.latitude];
    // spot.longitude = [NSNumber numberWithFloat:coordinate.longitude];
    //spot.observations
    return spot;
}

+ (Spot *)insertNewSpotWithCoordinateAndName:(CLLocationCoordinate2D)coordinate spotname:(NSString*)spotname inManagedObjectContext:(NSManagedObjectContext *)context
{
    Spot *spot = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateStyle = NSDateFormatterShortStyle;
//    df.timeStyle = NSDateFormatterShortStyle;
//    [NSString stringWithFormat:@"Spot (%@)", [df stringFromDate:[NSDate date]]];
    NSDate *now = [[NSDate alloc] init];
    //NSDateComponents *dateComps =[now components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
    //NSDate *beginningOfDay = [now dateFromComponents:dateComps];
   // NSDate *date = [NSDate dateWithTimeIntervalSince1970:result];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *localizedString = [formatter stringFromDate:now];
    //v2: changed default protocol to stationary
    spot.date_last_changed = now;
    spot.name = spotname;
    spot.latitude = coordinate.latitude;
    spot.longitude = coordinate.longitude;
    spot.notes = @" weather, # of observers in party:";
    spot.protocol = @"Stationary";
    spot.allObs = @"Y";
    spot.startTime = localizedString;
    
    return spot;
}
@end

