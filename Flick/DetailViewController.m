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
    self.movieImage.contentMode = UIViewContentModeScaleAspectFit;
    NSData *imageData = [NSData dataWithContentsOfURL:self.movie.posterURL];
    self.movieImage.image = [UIImage imageWithData:imageData];
    
    self.movieNameLabel.text = self.movie.title;
    self.movieOverviewLabel.text = self.movie.movieDescription;
    [self.movieOverviewLabel sizeToFit];
    
    CGFloat contentOffsetY = 180 + CGRectGetHeight(self.cardView.bounds);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width,contentOffsetY);
    self.scrollView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    
    
    self.cardView.backgroundColor = [UIColor blueColor];
    
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
