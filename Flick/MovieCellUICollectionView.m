//
//  MovieCellUICollectionView.m
//  Flick
//
//  Created by Abhinav Wagle on 1/25/17.
//  Copyright © 2017 Abhinav. All rights reserved.
//

#import "MovieCellUICollectionView.h"

@implementation MovieCellUICollectionView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"I am calling the detailViewController");
    NSLog(@"segue.identifier %@",segue.identifier);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
