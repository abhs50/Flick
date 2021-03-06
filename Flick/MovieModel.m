//
//  MovieModel.m
//  Flick
//
//  Created by Abhinav Wagle on 1/23/17.
//  Copyright (c) 2017 Abhinav. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.title = dictionary[@"original_title"];
        self.movieDescription = dictionary[@"overview"];
        NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", dictionary[@"poster_path"]];
        self.posterURL = [NSURL URLWithString:urlString];
        self.ratingValue = [[dictionary objectForKey:@"vote_average"] doubleValue];
    }
    return self;
}

@end
