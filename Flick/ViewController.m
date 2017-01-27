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
#import "MovieCellUICollectionView.h"



@interface ViewController () < UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) NSArray<MovieModel *> *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

-(void) fetchMovies:(NSString *)url;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:116.0/255.0f green:125.0/255.0f blue:125.0/255.0f alpha:1.0];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView addSubview:self.refreshControl]; //assumes tableView is @property
    
    // Segmented View
    NSArray *itemArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"segment_1.png"],[UIImage imageNamed:@"segment_2.png"],nil];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    segmentControl.frame = CGRectMake(300, 90, 100, 30);
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:0];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    self.navigationItem.rightBarButtonItem = item;
    
    // Collection View
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat screenWidth = CGRectGetHeight(self.view.bounds);
    CGFloat itemHT = 160;
    CGFloat itemWidth = screenWidth / 3;
    layout.itemSize = CGSizeMake(itemWidth, itemHT);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0, 0, 0)];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[MovieCellUICollectionView class] forCellWithReuseIdentifier:@"MovieCellUICollection"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:116.0/255.0f green:125.0/255.0f blue:125.0/255.0f alpha:1.0];
    
    // Network Call Setup
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
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.movies count]];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.moviesTableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma SEARCH

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    NSString *scope = nil;
    //NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
    [self updateFilteredContentForMovie:searchString type:scope];
    [self.moviesTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateFilteredContentForMovie:(NSString *)movieName type:(NSString *)typeName {
    
    // Update the filtered array based on the search text and scope.
    if ((movieName == nil) || [movieName length] == 0) {
        // If there is no search string and the scope is "All".
        if (typeName == nil) {
            self.searchResults = [self.movies mutableCopy];
        } else {
            // If there is no search string and the scope is chosen.
            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
            for (MovieModel *movie in self.movies) {
                if ([movie.title isEqualToString:typeName]) {
                    [searchResults addObject:movie];
                }
            }
            self.searchResults = searchResults;
        }
        return;
    }
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    for (MovieModel *movie in self.movies) {
        if (typeName == nil) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange movieNameRange = NSMakeRange(0, movie.title.length);
            NSRange foundRange = [movie.title rangeOfString:movieName options:searchOptions range:movieNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:movie];
            }
        }
    }
    
}


#pragma CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellIdentifier = @"MovieCellUICollection";
    MovieCellUICollectionView *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [image setImageWithURL:model.posterURL];
    [cell addSubview:image];
    return cell;
}

// Collection Implementation helper
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(122, 121);
}

// Collection Implementation helper
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


// CollectionView push to Detail View Controller
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.movie = [self.movies objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:NO];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

#pragma Table View

// Table Implementation helper
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.searchResults count];
    } else {
        return [self.movies count];
    }
}
// Table Implementation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const kCellIdentifier = @"MovieTableViewCell";
    MovieCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    MovieModel *movie;
    
    if (self.searchController.active) {
        movie = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        movie = [self.movies objectAtIndex:indexPath.row];
    }
    
    cell.movieName.text = movie.title;
    cell.textView.text = movie.movieDescription;
    cell.posterView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.posterView setImageWithURL:movie.posterURL];
    return cell;
}


#pragma Details Screen

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"I am calling the detailViewController");
    NSArray *sourceArray = self.searchController.active ? self.searchResults : self.movies;
    DetailViewController *detailView = segue.destinationViewController;
    MovieCellTableViewCell *cell = sender;
    NSIndexPath *selectedIndexPath = [self.moviesTableView indexPathForCell:cell];
    MovieModel *movieModel = sourceArray[selectedIndexPath.row];
    detailView.movie = movieModel;
}


#pragma Network Call

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

#pragma Refresh Control

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    [self.moviesTableView reloadData];
    [self.refreshControl endRefreshing];
}

# pragma Segmented Control

-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            NSLog(@"I am in Segment 0");
            [self.moviesTableView setHidden:NO];
            [self.collectionView setHidden:YES];
            break;
        }
        case 1:{
             NSLog(@"I am in Segment 1");
            [self.moviesTableView setHidden:YES];
            [self.view addSubview:_collectionView];
            [self.collectionView setHidden:NO];
            break;
        }
    }
}

@end
