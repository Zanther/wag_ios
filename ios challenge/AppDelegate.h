//
//  AppDelegate.h
//  ios challenge
//
//  Created by Steven Lattenhauer II on 5/31/18.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, strong) NSMutableArray *arrUsers;

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic) BOOL hasInternet;

- (void)saveContext;


@end

