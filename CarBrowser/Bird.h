//
//  Bird.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/6/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bird : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *maoriname;
@property (strong, nonatomic) NSString *family;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *sound;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *category;





+ (Bird *)birdWithName:(NSString *)make maoriname:(NSString *)model image:(UIImage *)image sound:(NSString *)sound description:(NSString *) description family:(NSString *)family link:(NSString *)link category:(NSString *)category;

+ (Bird *)birdWithDescription:(NSString *)name image:(UIImage *)image description:(NSString *) description family:(NSString *)family;


+ (Bird *)birdWithLink:(NSString *)name image:(UIImage *)image description:(NSString *)description link:(NSString *)link;

@end
