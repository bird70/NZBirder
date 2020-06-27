//
//  BirdTableViewCell.m
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 2/6/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import "BirdTableViewCell.h"
@class Bird;
@class Bird_attributes;

@implementation BirdTableViewCell




@synthesize imageView, nameLabel, othernameLabel;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
//        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [nameLabel setFont:[UIFont systemFontOfSize:12.0]];
//        [nameLabel setTextColor:[UIColor darkGrayColor]];
//        [nameLabel setHighlightedTextColor:[UIColor whiteColor]];
//        [self.contentView addSubview:nameLabel];
//
//        othernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [othernameLabel setFont:[UIFont systemFontOfSize:12.0]];
//        [othernameLabel setTextColor:[UIColor blackColor]];
//        [othernameLabel setHighlightedTextColor:[UIColor whiteColor]];
//
            nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [nameLabel setFont:[UIFont systemFontOfSize:12.0]];
//          [nameLabel setTextColor:[UIColor systemGrayColor]];
//          [nameLabel setHighlightedTextColor:[UIColor whiteColor]];
            [self.contentView addSubview:nameLabel];
          
            othernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [othernameLabel setFont:[UIFont systemFontOfSize:12.0]];
//          [othernameLabel setTextColor:[UIColor systemGrayColor]];
//          [othernameLabel setHighlightedTextColor:[UIColor whiteColor]];
          
        
        [self.contentView addSubview:othernameLabel];
    }
    
    return self;
}




#pragma mark Recipe set accessor

- (void)setBird:(Bird *)newBird {
   
	}
- (void)setBird_attributes:(Bird_attributes *)newBird_attributes {
    
}


@end
