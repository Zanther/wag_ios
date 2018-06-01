//
//  NetworkClient.m
//  ios challenge
//
//  Created by Steven Lattenhauer II on 5/31/18.
//
#include <netdb.h>
#import "NetworkClient.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation NetworkClient

{
    BOOL hasInternetConnection;
    
}

+ (NetworkClient *)sharedInstance
{
    static NetworkClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkClient alloc] init];
    });
    return sharedInstance;
}

-(BOOL)isNetworkAvailable
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection! Using Saved User Data");
        appDelegate.hasInternet = NO;
        return NO;
    }
    else{
        NSLog(@"-> connection established! ");
        appDelegate.hasInternet = YES;
        return YES;
    }
}


-(void)getUserdataWithSuccess:(void(^)(NSArray *arr))success
                      failure:(void(^)(NSString* message))failure
{
    [self isNetworkAvailable];
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *jsonPath = [documentsDirectory stringByAppendingPathComponent:@"data.json"];
    
    if (!appDelegate.hasInternet) {
    
       NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        
        if (data == nil) {
            
            NSLog(@"No Saved User Data");
            
        } else {
            
            NSData *data = [NSData dataWithContentsOfFile:jsonPath];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:nil];
            
            NSArray* arrData = [json objectForKey:@"items"];
            success(arrData);
            
        }
        
    } else {
        
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        
        if (data != nil) {
            
            NSLog(@"User Data already Exists, Will use this data");
            
            NSData *data = [NSData dataWithContentsOfFile:jsonPath];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:nil];
            
            NSArray* arrData = [json objectForKey:@"items"];
            
            
            
            success(arrData);
            
        } else {
            
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:USER_DATA_API_URL]
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:20];
            
            [request setHTTPMethod:@"GET"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError * error) {
                
                NSInteger statusCode = -1;
                
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    statusCode = [(NSHTTPURLResponse *) response statusCode];
                    NSLog(@"Status Code of Response %li", (long)statusCode);
                    
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
                    
                    if (statusCode == 200) {
                        
                        [self saveJsonWithData:data];
                        
                        NSArray* arrData = [json objectForKey:@"items"];
                        
                        success(arrData);
                        
                    } else {
                        
                        NSString * errorMessage = [NSString stringWithFormat:@"%@", error];
                        
                        NSLog(@"Error %@ %@", error, errorMessage);
                        
                        failure(errorMessage);
                        
                    }
                    
                }
                
            }] resume];
        }
    }
    
}
-(void)saveJsonWithData:(NSData *)data{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *jsonPath = [documentsDirectory stringByAppendingPathComponent:@"data.json"];
    NSLog(@"Saved Data at Path %@",jsonPath);
    
    [data writeToFile:jsonPath atomically:YES];
    
}


@end
