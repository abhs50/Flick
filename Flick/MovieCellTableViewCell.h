//
//  MovieCellTableViewCell.h
//  Flick
//
//  Created by Abhinav Wagle on 1/23/17.
//  Copyright (c) 2017 Abhinav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;


@end
