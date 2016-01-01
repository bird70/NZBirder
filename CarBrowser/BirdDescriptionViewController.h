//
//  BirdDescriptionViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 13/05/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Bird;

@interface BirdDescriptionViewController : UIViewController
@property (weak, nonatomic) Bird *bird;
@property (weak, nonatomic) IBOutlet UITextView *birdLink;

@property (weak, nonatomic) IBOutlet UILabel *birdOtherName;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *birdDescriptionLabel2;
//@property (weak, nonatomic) IBOutlet UILabel *birdDescriptionLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *birdDescriptionThumbnail;
//@property (weak, nonatomic) IBOutlet UIWebView *bdescWebView;
- (IBAction)backToDetail:(UIBarButtonItem *)sender;

@end
