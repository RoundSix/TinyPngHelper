//
//  RSError.m
//  TinyPngHelper
//
//  Created by lumeng on 5/26/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSError.h"

@implementation RSError

#pragma mark - Public methods

+ (instancetype)initWithJsonObject:(id)jsonObject {
    RSError *rsError = [[RSError alloc] initWithCode:999 jsonObject:jsonObject];
    return rsError;
}

+ (instancetype)initWithError:(NSError *)error {
    RSError *rsError = [[RSError alloc] initWithCode:999 error:error];
    return rsError;
}

#pragma mark - Initialize

- (instancetype)initWithCode:(NSUInteger)code jsonObject:(id)jsonObject {
    if (self = [super initWithDomain:@"" code:9999 userInfo:nil]) {
        _title = [jsonObject objectForKey:@"error"];
        _message = [jsonObject objectForKey:@"message"];
    }
    return self;
}

- (instancetype)initWithCode:(NSUInteger)code error:(NSError *)error {
    if (self = [super initWithDomain:@"" code:9999 userInfo:nil]) {
        _message = error.localizedDescription;
    }
    return self;
}

@end
