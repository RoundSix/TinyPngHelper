//
//  RSCompressRequest.h
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSRequest.h"
#import "RSAPIDefinition.h"

@class UIImage;

@interface Input : NSObject

@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, copy) NSString *type;

@end

@interface Output : NSObject

@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, assign) float ratio;
@property (nonatomic, copy) NSString *url;

@end

@interface RSCompressRequest : RSRequest <RSAPIDefinition>

@property (nonatomic, strong, readonly) Input *input;
@property (nonatomic, strong, readonly) Output *output;

RS_INIT_UNAVAILABLE

- (instancetype)initWithImage:(UIImage *)image;

@end
