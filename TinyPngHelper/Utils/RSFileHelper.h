//
//  RSFileHelper.h
//  TinyPngHelper
//
//  Created by lumeng on 6/12/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSFileHelper : NSObject

+ (NSURL *)getDefaultOutputPath;

+ (NSString *)fileNameFromUrl:(NSURL *)url;

+ (float)getFileSizeWithFileUrl:(NSURL *)url;

@end
