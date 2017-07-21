//
//  GNRUploadTask.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRUploadTask.h"
#import "AFNetworking.h"

@interface GNRUploadTask ()

@property (nonatomic, strong)NSMutableURLRequest * request;
@property (nonatomic, strong)AFURLSessionManager * manager;
@property (nonatomic, strong)NSURLSessionUploadTask * uploadTask;
@end

@implementation GNRUploadTask

- (NSMutableURLRequest *)request{
    if (!_request) {
        WEAK_SELF;
        GLog(@"filePath %@",wself.importIPAPath);
        _request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:self.uploadUrl parameters:[self parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             [formData appendPartWithFileURL:[NSURL fileURLWithPath:wself.importIPAPath] name:@"file" fileName:@"app.ipa" mimeType:@"application/octet-stream" error:nil];
        } error:nil];
    }
    return _request;
}

- (NSMutableDictionary *)parameters{
    NSMutableDictionary * _parameters = [NSMutableDictionary dictionary];
    [_parameters setObject:self.userkey?:@"" forKey:@"uKey"];
    [_parameters setObject:self.appkey?:@"" forKey:@"_api_key"];
    [_parameters setObject:[NSString stringWithFormat:@"From——自动部署工具 %@",[GNRHelper getAppVersion]] forKey:@"updateDescription"];
    return _parameters;
}

- (AFURLSessionManager *)manager{
    if (!_manager) {
        _manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _manager;
}

- (BOOL)check{
    if (self.appkey.length &&
        self.userkey.length &&
        self.uploadUrl.length) {//都有值
        return YES;
    }
    return NO;
}

- (void)uploadIPAWithrogress:(void(^)(NSProgress *))progress completion:(void(^)(BOOL,id responseObject,NSError *))completion{
    if (canceled) {
        return;
    }
    if (![self check]) {
        if (completion) {
            NSError * error = [NSError errorWithDomain:@"请检查上传URL/ApiKey/UserKey是否填写！" code:200 userInfo:nil];
            completion(NO,nil,error);
        }
        return;
    }
    _uploadTask = [self.manager
                  uploadTaskWithStreamedRequest:self.request
                  progress:^(NSProgress * _Nonnull uploadProgress) {

                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (progress) {
                              progress(uploadProgress);
                          }
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          if (completion) {
                              completion(NO,nil,error);
                          }
                      } else {
                          if (responseObject) {
                              if ([[responseObject objectForKey:@"code"] integerValue]==0) {//成功
                                  if (completion) {
                                      completion(YES,responseObject,nil);
                                  }
                              }else{
                                  if (completion) {
                                      NSError * error_g = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:[[responseObject objectForKey:@"code"] integerValue] userInfo:nil];
                                      completion(NO,responseObject,error_g);
                                  }
                              }
                          }
                          NSLog(@"%@ %@", response, responseObject);
                      }
                      
                  }];
    
    [_uploadTask resume];//开始上传

}

- (void)cancel{
    [super cancel];
    if (_uploadTask) {
        [_uploadTask cancel];
        _uploadTask = nil;
    }
}

@end
