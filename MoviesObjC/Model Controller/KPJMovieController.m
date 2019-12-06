//
//  KPJMovieController.m
//  MoviesObjC
//
//  Created by Kyle Jennings on 12/6/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

#import "KPJMovieController.h"

// baseurl for fetching movies
static NSString *const baseURLString = @"https://api.themoviedb.org/3/search";
static NSString *const apiKeyQuery = @"api_key";
static NSString *const apiKey = @"5a305d7b820dcbeed1d9b87786e175d5";
static NSString *const queryKey = @"query";
static NSString *const resultsKey = @"results";
// url for fetching images
static NSString *const imageURLString = @"http://image.tmdb.org/t/p/w500/";


@implementation KPJMovieController

+ (void)fetchMoviesFromSearchTerm:(NSString *)searchTerm completion:(void (^)(NSArray<KPJMovie *> * _Nonnull))completion
{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURL *secondURL = [baseURL URLByAppendingPathComponent:@"movie"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:secondURL resolvingAgainstBaseURL:true];
    NSURLQueryItem *apiQueryItem = [NSURLQueryItem queryItemWithName:apiKeyQuery value:apiKey];
    NSURLQueryItem *querySearch = [NSURLQueryItem queryItemWithName:queryKey value:searchTerm];
    urlComponents.queryItems = @[apiQueryItem, querySearch];
    NSURL *finalURL = urlComponents.URL;
    
    //    NSLog(@"URL: %@",finalURL.absoluteString);
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // handling the error
        if (error)
        {
            NSLog(@"Error\nIn %s: %@\n---\n%@", __PRETTY_FUNCTION__, error.localizedDescription, error);
            return completion([NSArray new]);
        }
        // if there is no data return an empty array
        if (!data)
        {
            NSLog(@"No Data");
            return completion([NSArray new]);
        }
        
        // grabbing the data as a dictionary using JSONSerialization
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        // if there was an error, log the error and return an empty array
        if (error)
        {
            NSLog(@"Error\nIn %s: %@\n---\n%@", __PRETTY_FUNCTION__, error.localizedDescription, error);
            return completion([NSArray new]);
        }
        
        // creating an empty array to add movies to
        NSMutableArray *movieArray = [NSMutableArray new];
        
        // looping through the dataDictionary to add movies to the movieArray
        for (NSDictionary *dict in dataDictionary[resultsKey])
        {
            // creating a movie using our initWithDictionary initializer
            KPJMovie *movie = [[KPJMovie alloc]initWithDictionary:dict];
            // adding the movie to the movieArray
            [movieArray addObject:movie];
        }
        //       NSLog(@"MOVIES: %@", movieArray);
        // completing with the array of movies
        return completion(movieArray);
        
    }]resume];
}


+ (void)fetchPosterFromMovie:(KPJMovie *)movie completion:(void (^)(UIImage * _Nullable))completion
{
    // need a separate URL for fetching posters
    NSURL *baseURL = [NSURL URLWithString:imageURLString];
    if (![movie.posterPath isKindOfClass:[NSNull class]])
    {
        NSURL *finalURL = [baseURL URLByAppendingPathComponent:movie.posterPath];
        
        [[NSURLSession.sharedSession dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"Error\nIn %s: %@\n---\n%@", __PRETTY_FUNCTION__, error.localizedDescription, error);
                return completion(nil);
            }
            
            if (!data)
            {
                NSLog(@"No Data");
                return completion(nil);
            }
            
            // luckily images are easy because they have the handy imageWithData method, using the data to create the image
            UIImage *poster = [UIImage imageWithData:data];
            
            //returning the image
            return completion(poster);
        }]resume];
    }
    return completion(nil);
}

@end
