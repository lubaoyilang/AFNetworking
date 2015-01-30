//
//  NetManager.h
//  UThing
//
//  Created by luyuda on 15/1/30.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NetError  = 0, //网络出错
    sigError        //签名出错
    
    
} ErrorCode;







@protocol NetBackProtocol <NSObject>

@optional
- (void)requestSuccess:(id)obj NetName:(NSString*)name;
- (void)requestFailure:(ErrorCode)code NetName:(NSString*)name;

@end


@interface NetManager : NSObject

+(instancetype)manager;


/**
 *  block方式 回调网络请求   回调json 就是已经解析完成的数据
 *
 *  @param urlRequest 请求网络参数
 *  @param success    成功block
 *  @param failure    失败block
 */

- (void)postRequest:(NSURLRequest *)urlRequest success:(void (^)(NSURLRequest *request, id JSON))success
            failure:(void (^)(ErrorCode code))failure;




/**
 *  用delegate方式来回调
 *
 *  @param Request  请求网络参数
 *  @param delegate 代理
 *  @param name     本次网络请求名称
 */


- (void)postRequest:(NSURLRequest*)Request delegate:(id)delegate NetName:(NSString*)name;


@end
