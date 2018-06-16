//
//  RSError.m
//  TinyPngHelper
//
//  Created by lumeng on 5/26/18.
//  Copyright © 2018 roundsix. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
