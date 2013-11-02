//
//  NSCoder+RNMapKit.h
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSCoder (RNMapKit)
- (void)RN_encodeMKCoordinateRegion:(MKCoordinateRegion)region
                             forKey:(NSString *)key;
- (MKCoordinateRegion)RN_decodeMKCoordinateRegionForKey:(NSString *)key;
@end
