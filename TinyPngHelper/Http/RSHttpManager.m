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
    
    switch (request.method) {
        case RSRequestMethod_POST:
            [self handlePostWithManager:manager
                                    url:url
                                request:request
                           successBlock:successBlock
                         rawFailedBlock:rawFailedBlock
                        completionBlock:completionBlock];
            break;
        case RSRequestMethod_GET:
            [self handleGetWithManager:manager
                                   url:url
                               request:request
                          successBlock:successBlock
                        rawFailedBlock:rawFailedBlock
                       completionBlock:completionBlock];
            break;
        case RSRequestMethod_BINARY:
            [self handleBinaryWithManager:manager
                                      url:url
                               authHeader:basicValue
                                  request:request
                             successBlock:successBlock
                           rawFailedBlock:rawFailedBlock
                          completionBlock:completionBlock];
            break;
        default:
            break;
    }
}

+ (void)get {
    // TODO: GET
}

+ (void)downloadFromUrlString:(NSString *)urlString
              destinationPath:(NSURL *)destination
                     progress:(void (^)(NSProgress *))progressHandler
               successHandler:(void (^)(void))successHandler
                failedHandler:(void (^)(RSError *))failedHandler
{
    NSURL *url = [NSURL URLWithString:urlString];
    [self downloadFromUrl:url
          destinationPath:destination
                 progress:progressHandler
           successHandler:successHandler
            failedHandler:failedHandler];
}

+ (void)downloadFromUrl:(NSURL *)url
        destinationPath:(NSURL *)destination
               progress:(void (^)(NSProgress *))progressHandler
         successHandler:(void (^)(void))successHandler
          failedHandler:(void (^)(RSError *))failedHandler
{
    AFHTTPSessionManager *manager = [self sharedManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [manager downloadTaskWithRequest:request
                            progress:^(NSProgress * _Nonnull downloadProgress) {
                                if (progressHandler) {
                                    progressHandler(downloadProgress);
                                }
                            }
                         destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                             return destination;
                         }
                   completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                       if (error) {
                           if (failedHandler) {
                               failedHandler([RSError initWithError:error]);
                           }
                       } else {
                           if (successHandler) {
                               successHandler();
                           }
                       }
                   }];
}

#pragma mark - Internal

+ (void)handlePostWithManager:(AFHTTPSessionManager *)manager
                          url:(NSString *)url
                      request:(RSRequest<RSAPIDefinition> *)request
                 successBlock:(void (^)(void))successBlock
               rawFailedBlock:(void (^)(RSError *))rawFailedBlock
              completionBlock:(void (^)(void))completionBlock
{
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *mimeBodies = request.mimeBodies;
        if (mimeBodies) {
            [formData appendPartWithFileData:mimeBodies[0]
                                        name:mimeBodies[1]
                                    fileName:mimeBodies[2]
                                    mimeType:mimeBodies[3]];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccessResponse:responseObject
                            request:request
                            success:successBlock
                          rawFailed:rawFailedBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailedResponse:error rawFailed:rawFailedBlock];
    }];
}

+ (void)handleBinaryWithManager:(AFHTTPSessionManager *)manager
                            url:(NSString *)url
                     authHeader:(NSString *)authHeader
                        request:(RSRequest<RSAPIDefinition> *)request
                   successBlock:(void (^)(void))successBlock
                 rawFailedBlock:(void (^)(RSError *))rawFailedBlock
                completionBlock:(void (^)(void))completionBlock
{
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = [request mimeBodies].firstObject;
    [urlRequest setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [[manager dataTaskWithRequest:urlRequest
                   uploadProgress:nil
                 downloadProgress:nil
                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
      {
          if (error) {
              [self handleFailedResponse:error rawFailed:rawFailedBlock];
          } else {
              [self handleSuccessResponse:responseObject
                                  request:request
                                  success:successBlock
                                rawFailed:rawFailedBlock];
          }
      }] resume];
}

+ (void)handleGetWithManager:(AFHTTPSessionManager *)manager
                         url:(NSString *)url
                     request:(RSRequest<RSAPIDefinition> *)request
                successBlock:(void (^)(void))successBlock
              rawFailedBlock:(void (^)(RSError *))rawFailedBlock
             completionBlock:(void (^)(void))completionBlock
{
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
