//
//  BYCache.h
//  TravelBook
//
//  Created by Bradley Yin on 10/22/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYCache: NSCache

- (void)cacheValuesForKey:(NSString * _Nonnull)key values:(NSArray * _Nonnull)entries;
- (NSArray * _Nullable)valuesForKey:(NSString * _Nonnull)key;

@end
