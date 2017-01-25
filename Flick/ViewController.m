//
//  ViewController.m
//  Flick
//
//  Created by Abhinav Wagle on 1/23/17.
//  Copyright (c) 2017 Abhinav. All rights reserved.
//

#import "ViewController.h"
#import "MovieCellTableViewCell.h"
#import "MovieModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailViewController.h"
#import "MBProgressHUD.h"



@interface ViewController () < UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) NSArray<MovieModel *> *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
-(void) fetchMovies:(NSString *)url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView addSubview:self.refreshControl]; //assumes tableView is @property

    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    self.moviesTableView.dataSource = self;
    if ([self.restorationIdentifier isEqualToString:@"topRatedId"]) {
        NSLog(@"I am in topRated %@", self.restorationIdentifier);
        NSString *urlString = [@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:apiKey];
        [self fetchMovies:urlString];
    } else {
        NSLog(@"I am in Now Playing %@", self.restorationIdentifier);
        NSString *urlString = [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
        [self fetchMovies:urlString];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const kCellIdentifier = @"MovieTableViewCell";
    MovieCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    cell.movieName.text = model.title;
    cell.textView.text = model.movieDescription;
    cell.posterView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.posterView setImageWithURL:model.posterURL];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"I am calling the detailViewController");
    DetailViewController *detailView = segue.destinationViewController;
    
    MovieCellTableViewCell *cell = sender;
    NSIndexPath *selectedIndexPath = [self.moviesTableView indexPathForCell:cell];
    MovieModel *movieModel = self.movies[selectedIndexPath.row];
    detailView.movie = movieModel;
}


-(void) fetchMovies: (NSString*) urlString {

    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    // Display HUD right before the request is made
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
          if (!error) {
                                                    
            // Hide view once Network Request is successful
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSError *jsonError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
            NSLog(@"Response: %@", responseDictionary);
            NSArray *results = responseDictionary[@"results"];
            NSMutableArray *models = [NSMutableArray array];
            for (NSDictionary *result in results) {
                MovieModel *model = [[MovieModel alloc] initWithDictionary:result];
                NSLog(@"Model - %@", model.movieDescription);
                [models addObject:model];
            }
            self.movies = models;
            [self.moviesTableView reloadData];// reload tableView not that there is new Data
            [self.refreshControl endRefreshing]; // Tell the refreshControl to stop spinning
           } else {
               NSLog(@"An error occurred: %@", error.description);
           }
        }];
    [task resume];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    [self.moviesTableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
