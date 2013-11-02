//
//  NSCoder+FavSpots.h
//  FavSpots
//
//  Created by Tilmann Steinmetz on 20/06/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCoder+RNMapKit.h"

@class Spot;

@interface NSCoder (FavSpots)
- (void)RN_encodeSpot:(Spot *)spot forKey:(NSString *)key;
- (Spot *)RN_decodeSpotForKey:(NSString *)key;
@end
