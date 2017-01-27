//
//  ZoomViewController.m
//  Flick
//
//  Created by Abhinav Wagle on 1/26/17.
//  Copyright © 2017 Abhinav. All rights reserved.
//

#import "ZoomViewController.h"

@implementation ZoomViewController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewDidLoad {
    NSLog(@" I am in ZoomView");
    [super viewDidLoad];
    self.ImageView.image = self.image;
}

@end
