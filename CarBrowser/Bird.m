//
//  Bird.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/6/13.
//  Copyright (c) 2013 Tilmann Steinmetz. All rights reserved.
//

#import "Bird.h"

@implementation Bird

+ (Bird *)birdWithName:(NSString *)name maoriname:(NSString *)maoriname image:(UIImage *)image sound:(NSString *)sound description:(NSString *)description family:(NSString *)family link:(NSString *)link category:(NSString *)category    
{
    Bird *retVal = [[Bird alloc] init];
    [retVal setName:name];
    [retVal setMaoriname:maoriname];
    [retVal setImage:image];
    [retVal setSound:sound];
    [retVal setDescription:description];
    [retVal setFamily:family];
    [retVal setLink:link];
    [retVal setCategory:category];
    return retVal;
}

+ (Bird *)birdWithDescription:(NSString *)name image:(UIImage *)image description:(NSString *)description family:(NSString *)family
{
    Bird *retVal = [[Bird alloc] init];
    [retVal setName:name];
    [retVal setImage:image];
    [retVal setDescription:description];
    [retVal setFamily:family];
    return retVal;
}


+ (Bird *)birdWithLink:(NSString *)name image:(UIImage *)image description:(NSString *)description link:(NSString *)link
{
    Bird *retVal = [[Bird alloc] init];
    [retVal setName:name];
    [retVal setImage:image];
    [retVal setDescription:description];
    [retVal setFamily:link];
    return retVal;
}
@end
