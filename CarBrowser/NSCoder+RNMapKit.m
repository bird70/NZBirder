//
//  NSCoder+RNMapKit.m
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import "NSCoder+RNMapKit.h"

@implementation NSCoder (RNMapKit)

- (void)RN_encodeMKCoordinateRegion:(MKCoordinateRegion)region
                             forKey:(NSString *)key {
  [self encodeObject:@[ @(region.center.latitude),
   @(region.center.longitude),
   @(region.span.latitudeDelta),
   @(region.span.longitudeDelta)]
              forKey:key];
}

- (MKCoordinateRegion)RN_decodeMKCoordinateRegionForKey:(NSString *)key {
  NSArray *array = [self decodeObjectForKey:key];
  MKCoordinateRegion region;
  region.center.latitude = [array[0] doubleValue];
  region.center.longitude = [array[1] doubleValue];
  region.span.latitudeDelta = [array[2] doubleValue];
  region.span.longitudeDelta = [array[3] doubleValue];
  return region;
}

@end
