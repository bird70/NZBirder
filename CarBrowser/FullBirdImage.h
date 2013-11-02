//
//  FullBirdImage.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 17/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bird_attributes;

@interface FullBirdImage : NSManagedObject

@property (nonatomic, retain) id fullimage;
@property (nonatomic, retain) Bird_attributes *birdonpic;

@end
