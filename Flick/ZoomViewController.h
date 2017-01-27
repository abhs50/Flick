//
//  ZoomViewController.h
//  Flick
//
//  Created by Abhinav Wagle on 1/26/17.
//  Copyright © 2017 Abhinav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (nonatomic, strong) UIImage *image;

@end
