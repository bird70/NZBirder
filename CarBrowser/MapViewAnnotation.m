//
//  MapViewAnnotation.m
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import "MapViewAnnotation.h"
#import "Spot.h"

@implementation MapViewAnnotation

+ (NSSet *)keyPathsForValuesAffectingCoordinate {
  return [NSSet setWithArray:@[ @"spot.latitude", @"spot.longitude" ]];
}

- (MapViewAnnotation *)initWithSpot:(Spot *)spot
{
  self = [super init];
  if (self) {
    _spot = spot;
  }
  return self;
}
- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.spot.latitude, self.spot.longitude);
}

@end
