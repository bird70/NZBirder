//
//  BirdTableViewCell.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/6/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//
#import "Bird_attributes.h"
#import <UIKit/UIKit.h>

@interface BirdTableViewCell : UITableViewCell
{
    Bird_attributes *bird;
    
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *othernameLabel;
}


@property (strong, nonatomic, retain) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *othernameLabel;


@end

