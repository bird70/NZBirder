//
//  MapViewAnnotation.h
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Spot;

@interface MapViewAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly, weak) Spot *spot;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (MapViewAnnotation *)initWithSpot:(Spot *)spot;

@end
