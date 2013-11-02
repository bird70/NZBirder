//
//  Spot.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 19/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@class Observation;

@interface Spot : NSManagedObject


- (void)addObservationsObject:(Observation *)value;
- (void)removeObservationsObject:(Observation *)value;
- (void)addObservations:(NSSet *)values;
- (void)removeObservations:(NSSet *)values;


@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) NSDate * date_last_changed;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSString * allObs;
@property (nonatomic, retain) NSString *protocol;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) Observation *observations;

+ (Spot *)insertNewSpotWithCoordinate:(CLLocationCoordinate2D)coordinate inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Spot *)insertNewSpotWithCoordinateAndName:(CLLocationCoordinate2D)coordinate spotname:(NSString*)spotname inManagedObjectContext:(NSManagedObjectContext *)context;

@end

