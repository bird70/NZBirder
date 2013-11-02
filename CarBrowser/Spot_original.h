//
//  Spot.h
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface Spot : NSManagedObject

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;

+ (Spot *)insertNewSpotWithCoordinate:(CLLocationCoordinate2D)coordinate inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Spot *)insertNewSpotWithCoordinateAndName:(CLLocationCoordinate2D)coordinate spotname:(NSString*)spotname inManagedObjectContext:(NSManagedObjectContext *)context;

@end
