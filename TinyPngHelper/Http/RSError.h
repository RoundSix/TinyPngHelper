//
//  RSError.h
//  TinyPngHelper
//
//  Created by lumeng on 5/26/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSError : NSError

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *message;

+ (instancetype)initWithJsonObject:(id)jsonObject;

+ (instancetype)initWithError:(NSError *)error;

@end
