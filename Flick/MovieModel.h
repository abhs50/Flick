//
//  MovieModel.h
//  Flick
//
//  Created by Abhinav Wagle on 1/23/17.
//  Copyright (c) 2017 Abhinav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *movieDescription;
@property (nonatomic, strong) NSURL *posterURL;
@property float ratingValue;

@end
