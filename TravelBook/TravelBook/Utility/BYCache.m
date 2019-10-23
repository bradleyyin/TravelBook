//
//  BYCache.m
//  TravelBook
//
//  Created by Bradley Yin on 10/22/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

#import "BYCache.h"

@interface BYCache ()


@property (nonatomic) NSCache *cache;

@end

@implementation BYCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 20;
    }
    return self;
}

- (void)cacheEntriesForKey:(NSString *)key entries:(NSArray *)entries {
    if (entries) {
        [self.cache setObject:entries forKey:key];
    }
}

- (NSArray *)entriesForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

@end
