//
//  Bird_attributes.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 8/07/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Bird_attributes : NSManagedObject

@property (nonatomic, retain) NSString * beak_colour;
@property (nonatomic, retain) NSString * beak_length;
@property (nonatomic, retain) NSString * behaviour;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * colour;
@property (nonatomic, retain) NSDate * date_last_changed;
@property (nonatomic, retain) NSNumber * extra;
@property (nonatomic, retain) NSString * family;
@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSString * habitat;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * item_description;
@property (nonatomic, retain) NSString * leg_colour;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * othername;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * size_and_shape;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSString * threat_status;
@property (nonatomic, retain) id thumbnail;

@end
