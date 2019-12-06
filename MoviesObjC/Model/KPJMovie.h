//
//  KPJMovie.h
//  MoviesObjC
//
//  Created by Kyle Jennings on 12/6/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KPJMovie : NSObject
// setting the properties necessary to update the tableview
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, readonly) NSNumber *rating;
@property (nonatomic, copy, readonly) NSString *overview;
@property (nonatomic, copy, readonly) NSString *posterPath;

// initializer
- (instancetype)initWithTitle: (NSString *)title
                       rating: (NSNumber *)rating
                     overview: (NSString *)overview
                   posterPath: (NSString *)posterPath;

@end

@interface KPJMovie (JSONConvertable)
// initializer with dictionary
- (instancetype)initWithDictionary: (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
