//
//  KPJMovieController.h
//  MoviesObjC
//
//  Created by Kyle Jennings on 12/6/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KPJMovie.h"

NS_ASSUME_NONNULL_BEGIN

@interface KPJMovieController : NSObject

// need a static function to fetch movies with search term
+ (void)fetchMoviesFromSearchTerm: (NSString *)searchTerm completion: (void (^) (NSArray<KPJMovie *> *))completion;

// also need to fetch a poster from a separate url
+ (void)fetchPosterFromMovie: (KPJMovie *)movie completion: (void (^) (UIImage *_Nullable))completion;

@end

NS_ASSUME_NONNULL_END
