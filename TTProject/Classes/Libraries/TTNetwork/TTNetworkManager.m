//
//  TTNetworkManager.m
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTNetworkManager.h"

#import "ResponseModel.h"

@interface TTNetworkManager ()

@end

@implementation TTNetworkManager

+ (TTNetworkManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static TTNetworkManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:BASE_URL];
        
        _manager = [[TTNetworkManager alloc] init];
    
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
//        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0"}];
        
        //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
//        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
//                                                          diskCapacity:50 * 1024 * 1024
//                                                              diskPath:nil];
        
//        [config setURLCache:cache];
        
        _manager = [[TTNetworkManager alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:config];
        _manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
    });
    return _manager;
}

- (void)getWithUrl:(NSString *)URLString
        parameters:(NSDictionary *)parameters
           success:(void (^)(NSDictionary *result))success
           failure:(void (^)(StatusModel *status))failure {
    
    [self getWithUrl:URLString parameters:parameters progress:nil success:success failure:failure];
    
}

- (void)getWithUrl:(NSString *)URLString
        parameters:(NSDictionary *)parameters
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSDictionary *result))success
           failure:(void (^)(StatusModel *status))failure {
    
    
    parameters = [self addSystemParameters:parameters];
    DBG(@"GET URL:%@",URLString);
    DBG(@"Parameters:%@",parameters);
    
    [self GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        DBG(@"downloadProgress:%@", downloadProgress);
        if (progress) {
            progress(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ( success && failure ) {
            [self requestSuccess:success failure:failure data:responseObject];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            [self requestFailure:failure data:error];
        }
        
    }];

}

- (void)postWithUrl:(NSString *)URLString
         parameters:(NSDictionary *)parameters
            success:(void (^)(NSDictionary *result))success
            failure:(void (^)(StatusModel *status))failure {
    
    [self postWithUrl:URLString parameters:parameters progress:nil success:success failure:failure];

}

- (void)postWithUrl:(NSString *)URLString
         parameters:(NSDictionary *)parameters
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(NSDictionary *result))success
            failure:(void (^)(StatusModel *status))failure {
    
    parameters = [self addSystemParameters:parameters];
    DBG(@"POST URL:%@",URLString);
    DBG(@"Parameters:%@",parameters);
    
    [self POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        DBG(@"downloadProgress:%@", downloadProgress);
        if (progress) {
            progress(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ( success && failure ) {
            [self requestSuccess:success failure:failure data:responseObject];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            [self requestFailure:failure data:error];
        }
        
    }];
    
}

- (void)postFormDataWithUrl:(NSString *)URLString
                 parameters:(NSDictionary *)parameters
  constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))constructingBlock
                   progress:(void (^)(NSProgress *))progress
                    success:(void (^)(NSDictionary *result))success
                    failure:(void (^)(StatusModel *status))failure {
    
    parameters = [self addSystemParameters:parameters];
    DBG(@"POST URL:%@",URLString);
    DBG(@"Parameters:%@",parameters);
    
    [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (constructingBlock) {
            constructingBlock(formData);
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        DBG(@"downloadProgress:%@", uploadProgress);
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ( success && failure ) {
            [self requestSuccess:success failure:failure data:responseObject];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if (failure) {
            [self requestFailure:failure data:error];
        }
        
    }];
}

- (void)postImageWithUrl:(NSString *)URLString
                   image:(UIImage *)image
              parameters:(NSDictionary *)parameters
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(NSDictionary *result))success
                 failure:(void (^)(StatusModel *status))failure {
    
    parameters = [self addSystemParameters:parameters];
    DBG(@"POST URL:%@",URLString);
    DBG(@"Parameters:%@",parameters);
    
    [self postFormDataWithUrl:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        [formData appendPartWithFileData:imageData
                                    name:@"image"
                                fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *uploadProgress) {
        
        DBG(@"downloadProgress:%@", uploadProgress);
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSDictionary *result) {
        
        if (success) {
            success(result);
        }
        
    } failure:^(StatusModel *status) {
        
        if (failure) {
            failure(status);
        }
        
    }];
}

- (void)postImagesWithUrl:(NSString *)URLString
                   images:(NSArray<UIImage *> *)images
               parameters:(NSDictionary *)parameters
                 progress:(void (^)(NSProgress *))progress
                  success:(void (^)(NSDictionary *result))success
                  failure:(void (^)(StatusModel *status))failure {
    
    parameters = [self addSystemParameters:parameters];
    DBG(@"POST URL:%@",URLString);
    DBG(@"Parameters:%@",parameters);
    
    [self postFormDataWithUrl:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        int index = 1;
        for (UIImage *image in images) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            [formData appendPartWithFileData:imageData
                                        name:@"image[]"//[NSString stringWithFormat:@"image%d",index]
                                    fileName:[NSString stringWithFormat:@"image%d.jpg",index]
                                    mimeType:@"image/jpeg"];
            index++;
        }
        
    } progress:^(NSProgress *uploadProgress) {
        
        DBG(@"downloadProgress:%@", uploadProgress);
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSDictionary *result) {
        
        if (success) {
            success(result);
        }
        
    } failure:^(StatusModel *status) {
        
        if (failure) {
            failure(status);
        }
        
    }];
}

#pragma mark - Private Methods

- (void)requestSuccess:(void (^)(NSDictionary *result))success failure:(void (^)(StatusModel *status))failure data:(id) data {
    
    NSDictionary *responseDictionary = [data copy];
    ResponseModel *responseModel = [[ResponseModel alloc] initWithDictionary:responseDictionary error:nil];
    
    if ( responseModel && 1001 == responseModel.status){
        if (success)
        {
            success(responseModel.result);
        }
    } else {
        
        if (failure) {
            
            if ( !responseModel ) {
                
                StatusModel *status = [[StatusModel alloc] init];
                
                status.code = 404;
                status.msg = @"网络异常";
                
                failure(status);
            } else {
                
                StatusModel *status = [[StatusModel alloc] init];
                
                status.code = responseModel.status;
                status.msg = responseModel.message;
                
                failure(status);
            }
        }
    }

}

- (void)requestFailure:(void (^)(StatusModel *status))failure data:(NSError *)error {
    
    StatusModel *status = [[StatusModel alloc] init];
    
    status.code = 404;
    status.msg = @"网络异常";
    
    failure(status);
}

- (NSDictionary *)addSystemParameters:(NSDictionary *)parameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    [params setSafeObject:[UIDevice TT_uniqueID] forKey:@"did"];
    
    if (parameters) {
        [params addEntriesFromDictionary:parameters];
    }
    
    return params;
    
}

@end
