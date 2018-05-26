//
//  RSCompressRequest.m
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSCompressRequest.h"
@class UIImage;

@implementation Input
@end

@implementation Output
@end

@interface RSCompressRequest()

@property (nonatomic, strong) NSString *fileName;

@end

@implementation RSCompressRequest

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)url {
    return @"shrink";
}

- (NSString *)method {
    return @"post";
}

- (BOOL)forceHttps {
    return YES;
}

- (NSArray *)mimeBodies {
    return nil;
}

- (void)parseResponse:(id)responseObject {
    id input = [responseObject objectForKey:@"input"];
    id output = [responseObject objectForKey:@"output"];
    
    _input = [Input new];
    _input.size = [input objectForKey:@"size"];
    _input.type = [input objectForKey:@"type"];
    
    _output = [Output new];
    _output.size = [output objectForKey:@"size"];
    _output.type = [output objectForKey:@"type"];
    _output.width = [output objectForKey:@"width"];
    _output.height = [output objectForKey:@"height"];
    _output.ratio = [[output objectForKey:@"ratio"] floatValue];
    _output.url = [output objectForKey:@"url"];
}
@end
