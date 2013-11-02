//
//  Observation.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 8/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Spot;

@interface Observation : NSManagedObject

@property (nonatomic, retain) NSString * bird_observed;
@property (nonatomic, retain) NSNumber * number_heard;
@property (nonatomic, retain) NSNumber * number_seen;
@property (nonatomic, retain) Spot *observation_atSpot;

@end
