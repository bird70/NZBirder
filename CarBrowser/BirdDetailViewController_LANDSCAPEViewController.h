//
//  BirdDetailViewController_LANDSCAPEViewController.h
//  BirdBrowser
//
//  Created by Tilmann Steinmetz on 22/06/13.
//  Copyright (c) 2013 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Bird;

@interface BirdDetailViewController_LANDSCAPEViewController : UIViewController
@property (weak, nonatomic) Bird *bird;
@property (weak, nonatomic) NSArray *birds;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)backToPortrait:(id)sender;
@end
