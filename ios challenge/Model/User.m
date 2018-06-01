//
//  User.m
//  ios challenge
//
//  Created by Steven Lattenhauer II on 5/31/18.
//

#import "User.h"
#import "AppDelegate.h"

@implementation User

- (id) initWithDic: (NSDictionary*) dicUser{
    if(self = [super init])
    {
        if (![dicUser isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        [self updateWithDic:dicUser];
    }
    return self;
}

-(void)updateWithDic:(NSDictionary *)dicUser
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    self.display_name = [self checkNullValue: [dicUser valueForKey: @"display_name"]];
    self.location = [self checkNullValue: [dicUser valueForKey: @"location"]];
    self.reputation = [[self checkNullValue: [dicUser valueForKey: @"reputation"]] stringValue];
    self.badge_counts = [self checkNullValueForDictionary:[dicUser valueForKey:@"badge_counts"]];
    self.account_id = [[self checkNullValue: [dicUser valueForKey: @"account_id"]]stringValue];
    self.profile_image_url = [self checkNullValue: [dicUser valueForKey: @"profile_image"]];
    
    if (appDelegate.hasInternet) {
    [self saveImagesInLocalDirectory:self.profile_image_url :self.account_id];
    }
}

-(void)saveImagesInLocalDirectory: (NSString *)urlString :(NSString*)imageName
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgName = [NSString stringWithFormat:@"%@.png",imageName];
    NSString *imgURL = urlString;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:imgName];
    
    if(![fileManager fileExistsAtPath:writablePath]){
        // file doesn't exist
        NSLog(@"file doesn't exist");
        //save Image From URL
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: imgURL]];
        NSError *error = nil;
        [data writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imgName]] options:NSAtomicWrite error:&error];
        if (error) {
            NSLog(@"Error Writing File : %@",error);
        }else{
            NSLog(@"Image %@ Saved SuccessFully",imgName);
        }
    }
    else{
        // file exist
    }
}

- (id) checkNullValue: (id) value
{
    if(value == nil || [value isKindOfClass: [NSNull class]])
    {
        return @"";
    }
    
    return value;
}

- (id) checkNullValueForDictionary: (id) value
{
    if(value == nil || [value isKindOfClass:[NSNull class]])
    {
        return @[];
    }
    
    return value;
}

@end
