//
//  KPJMovie.m
//  MoviesObjC
//
//  Created by Kyle Jennings on 12/6/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

#import "KPJMovie.h"
// keys
static NSString *const titleKey = @"title";
static NSString *const ratingKey = @"vote_average";
static NSString *const overviewKey = @"overview";
static NSString *const posterPathKey = @"poster_path";

@implementation KPJMovie

// initializing the KPJMovie
- (instancetype)initWithTitle:(NSString *)title rating:(NSNumber *)rating overview:(NSString *)overview posterPath:(NSString *)posterPath
{
    self = [super init];
    if (self)
    {
        _title = [title copy];
        _rating = [rating copy];
        _overview = [overview copy];
        _posterPath = [posterPath copy];
    }
    return self;
}

@end

@implementation KPJMovie (JSONConvertable)

// initializing KPJMovie with a dictionary
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *title = dictionary[titleKey];
    NSNumber *rating = dictionary[ratingKey];
    NSString *overview = dictionary[overviewKey];
    NSString *posterPath = dictionary[posterPathKey];
    
    return [self initWithTitle:title rating:rating overview:overview posterPath:posterPath];
}

@end
