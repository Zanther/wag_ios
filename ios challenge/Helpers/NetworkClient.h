//
//  NetworkClient.h
//  ios challenge
//
//  Created by Steven Lattenhauer II on 5/31/18.
//

#import <Foundation/Foundation.h>

@interface NetworkClient : NSObject
{
    
}

+ (NetworkClient *)sharedInstance;


-(void)getUserdataWithSuccess:(void(^)(NSArray *arr))success
                      failure:(void(^)(NSString* message))failure;


@end
