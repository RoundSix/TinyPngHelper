//
//  RSHttpManager.h
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSError.h"
#import "RSRequest.h"
#import "RSAPIDefinition.h"

@interface RSHttpManager : NSObject

//RS_DOWNWARN_PROTOTYPES

+ (void)postRequest:(RSRequest<RSAPIDefinition> *)request;

+ (void)postRequest:(RSRequest<RSAPIDefinition> *)request
       successBlock:(void (^)(void))successBlock
     rawFailedBlock:(void (^)(RSError *error))rawFailedBlock
    completionBlock:(void (^)(void))completionBlock;

+ (void)get;

+ (void)downloadFromUrlString:(NSString *)urlString
              destinationPath:(NSURL *)destination
                     progress:(void (^)(NSProgress *progress))progressHandler
               successHandler:(void (^)(void))successHandler
                failedHandler:(void (^)(RSError *error))failedHandler;

+ (void)downloadFromUrl:(NSURL *)url
        destinationPath:(NSURL *)destination
               progress:(void (^)(NSProgress *progress))progressHandler
         successHandler:(void (^)(void))successHandler
          failedHandler:(void (^)(RSError *error))failedHandler;

@end
