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

- (void)cacheValuesForKey:(NSString *)key values:(NSArray *)values {
    if (values) {
        [self.cache setObject:values forKey:key];
    }
}

- (NSArray *)valuesForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

@end
