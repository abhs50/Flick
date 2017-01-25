//
//  DetailViewController.m
//  Flick
//
//  Created by Abhinav Wagle on 1/24/17.
//  Copyright © 2017 Abhinav. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *movieOverviewLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Image
    self.movieImage.contentMode = UIViewContentModeScaleAspectFit;
    NSData *imageData = [NSData dataWithContentsOfURL:self.movie.posterURL];
    self.movieImage.image = [UIImage imageWithData:imageData];
    
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.cardView.backgroundColor = [UIColor blueColor];
    
    //Scroll View
    CGFloat xMargin = 48;
    CGFloat cardHeight = 200; // arbitrary value
    CGFloat bottomPadding = 64;
    CGFloat cardOffset = cardHeight * 0.75;
    self.scrollView.frame = CGRectMake(xMargin, // x
                                       CGRectGetHeight(self.view.bounds) - cardHeight - bottomPadding, // y
                                       CGRectGetWidth(self.view.bounds) - 2 * xMargin, // width
                                       cardHeight); // height
    
    self.cardView.frame = CGRectMake(0, cardOffset, CGRectGetWidth(self.scrollView.bounds), cardHeight);
    // content height is the height of the card plus the offset we want
    CGFloat contentHeight =  cardHeight + cardOffset;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, contentHeight);
    
    // Set Name, Description
    self.movieNameLabel.text = self.movie.title;
    self.movieOverviewLabel.text = self.movie.movieDescription;
    self.movieOverviewLabel.numberOfLines = 0;
    [self.movieOverviewLabel sizeToFit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
