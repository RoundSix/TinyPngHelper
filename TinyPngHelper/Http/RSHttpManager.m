//
//  RSHttpManager.m
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSHttpManager.h"
/****** Vendors ******/
#import <AFNetworking.h>
#import "NSString+Base64.h"

@implementation RSHttpManager

static NSString* baseServerAddress = @"api.tinify.com";

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [AFHTTPSessionManager manager];
            instance.requestSerializer.timeoutInterval = 30.0f;
            instance.securityPolicy.allowInvalidCertificates = YES;
            instance.securityPolicy.validatesDomainName = NO;
//            [instance.reachabilityManager startMonitoring];
        }
    });
    
    return instance;
}

#pragma mark - Public methods
+ (void)postRequest:(RSRequest<RSAPIDefinition> *)request {
    [self postRequest:request successBlock:nil rawFailedBlock:nil completionBlock:nil];
}

+ (void)postRequest:(RSRequest<RSAPIDefinition> *)request
       successBlock:(void (^)(void))successBlock
     rawFailedBlock:(void (^)(RSError *))rawFailedBlock
    completionBlock:(void (^)(void))completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", request.forceHttps ? @"https://" : @"http://", baseServerAddress, request.url];
    
    NSString *assembledApikey = [NSString stringWithFormat:@"api:%@", request.apiKey];
    NSString *base64Key = [assembledApikey encodedString];
    NSString *basicValue = [NSString stringWithFormat:@"Basic %@", base64Key];
    
    AFHTTPSessionManager *manager = [self sharedManager];
//    [manager.requestSerializer setValue:basicValue forHTTPHeaderField:@"Authorization"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if ([request.method isEqualToString:@"post"]) {
        //TODO:整合移除
        NSURL *URL = [NSURL URLWithString:url];
        NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:URL];
        request1.HTTPMethod=@"POST";
        request1.HTTPBody = [request mimeBodies].firstObject;
        [request1 setValue:basicValue forHTTPHeaderField:@"Authorization"];
        [[manager dataTaskWithRequest:request1 uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [self handleFailedResponse:error rawFailed:rawFailedBlock];
            } else {
                [self handleSuccessResponse:responseObject
                                    request:request
                                    success:successBlock
                                  rawFailed:rawFailedBlock];
            }
        }] resume];
        //TODO:整合移除
//        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            NSArray *mimeBodies = request.mimeBodies;
//            if (mimeBodies) {
//                [formData appendPartWithFileData:mimeBodies[0]
//                                            name:mimeBodies[1]
//                                        fileName:mimeBodies[2]
//                                        mimeType:mimeBodies[3]];
//            }
//        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [self handleSuccessResponse:responseObject
//                                request:request
//                                success:successBlock
//                              rawFailed:rawFailedBlock];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [self handleFailedResponse:error rawFailed:rawFailedBlock];
//        }];
    } else {
        [manager GET:url
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            [self handleSuccessResponse:responseObject
                                request:request
                                success:successBlock
                              rawFailed:rawFailedBlock];
        }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
        {
            [self handleFailedResponse:error rawFailed:rawFailedBlock];
        }];
    }
}

+ (void)get {
}

#pragma mark - Internal

+ (NSString *)assembleUrlWithRequest:(RSRequest<RSAPIDefinition> *)request {
    return [NSString stringWithFormat:@"%@%@/%@", request.forceHttps ? @"https://" : @"http://", baseServerAddress, request.url];
}

+ (void)handleSuccessResponse:(id _Nullable)responseObject
                      request:(RSRequest<RSAPIDefinition> *)request
                      success:(void (^)(void))success
                    rawFailed:(void (^)(RSError *))rawFailed
{
    if ([responseObject objectForKey:@"error"]) { // means error
        RSError *rsError = [RSError initWithJsonObject:responseObject];
        if (rawFailed) {
            rawFailed(rsError);
        }
    } else { // means success
        [request parseResponse:responseObject];
        if (success) {
            success();
        }
    }
}

+ (void)handleFailedResponse:(NSError *)error rawFailed:(void (^)(RSError *))rawFailed {
    RSError *rsError = [RSError initWithError:error];
    if (rawFailed) {
        rawFailed(rsError);
    }
}

@end
