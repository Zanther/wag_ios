//
//  User.h
//  ios challenge
//
//  Created by Steven Lattenhauer II on 5/31/18.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic, strong) NSString *display_name;
@property(nonatomic, strong) NSString *reputation;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *account_id;
@property(nonatomic, strong) NSDictionary *badge_counts;
@property(nonatomic, strong) NSString *profile_image_url;


- (id) initWithDic: (NSDictionary*) dicUser;

@end
