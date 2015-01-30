//
//  NetManager.m
//  UThing
//
//  Created by luyuda on 15/1/30.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "NetManager.h"
#import "AFNetworking.h"

static NetManager *manager = nil;
@implementation NetManager

+(instancetype)manager
{
    if (manager == nil) {
        manager = [[NetManager alloc] init];
    }
    return manager;
}



- (id)init
{
    if(self = [super init]){
    
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    }
    
    return self;
        
        
}




- (void)postRequest:(NSURLRequest *)urlRequest success:(void (^)(NSURLRequest *request, id JSON))success
            failure:(void (^)(ErrorCode code))failure
{
    AFJSONRequestOperation *post = [AFJSONRequestOperation  JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        
        
        NSDictionary *obj = [JSON objectForKey:@"data"];
        NSString *sign = [JSON objectForKey:@"sign"];
        
        ParametersManagerObject *p = [[ParametersManagerObject alloc] init];
        BOOL isSign = [p checkSign:obj Sign:sign];
        if (isSign) {
            success(request,JSON);
        }else{
            failure(sigError);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        
        failure(NetError);
        
    }];
    
    
    [post start];
    
    
}


- (void)postRequest:(NSURLRequest*)Request delegate:(id)delegate NetName:(NSString*)name
{
    
    AFJSONRequestOperation *post = [AFJSONRequestOperation  JSONRequestOperationWithRequest:Request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        
        
        NSDictionary *obj = [JSON objectForKey:@"data"];
        NSString *sign = [JSON objectForKey:@"sign"];
        
        ParametersManagerObject *p = [[ParametersManagerObject alloc] init];
        BOOL isSign = [p checkSign:obj Sign:sign];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (isSign) {
                if (delegate &&[delegate respondsToSelector:@selector(requestSuccess:NetName:)]) {
                    [delegate requestSuccess:JSON NetName:name];
                }
            }else{
                if (delegate && [delegate respondsToSelector:@selector(requestFailure:NetName:)]) {
                    [delegate requestFailure:sigError NetName:name];
                }
            }
            
        });
        
        
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(requestFailure:NetName:)]) {
                [delegate requestFailure:NetError NetName:name];
            }
        
        });
        
    }];
    
    
    [post start];
    
    

    

}







@end
