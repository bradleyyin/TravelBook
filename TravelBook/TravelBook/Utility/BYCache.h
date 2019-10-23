//
//  BYCache.h
//  TravelBook
//
//  Created by Bradley Yin on 10/22/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYCache: NSCache

- (void)cacheEntriesForKey:(NSString * _Nonnull)key entries:(NSArray * _Nonnull)entries;
- (NSArray * _Nullable)entriesForKey:(NSString * _Nonnull)key;

@end
