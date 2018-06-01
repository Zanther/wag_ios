//
//  ViewController.m
//  ios challenge
//
//  Created by Steven Lattenhauer II on 5/31/18.
//

#import "ViewController.h"
#import "NetworkClient.h"
#import "AppDelegate.h"
#import "UserCell.h"
#import "User.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (strong, nonatomic) NSArray *userList;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    CGRect frame = CGRectMake (self.view.frame.size.width/2, self.view.frame.size.height/2, 80, 80);
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self.view insertSubview:self.activity aboveSubview:self.userTableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self downloadUserData];
    self.userTableView.delegate = self;
    self.userTableView.dataSource =self;

}


-(void)downloadUserData
{
    self.appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [[NetworkClient sharedInstance] getUserdataWithSuccess:^(NSArray * arrResponse) {
        [self.activity performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];

        for (NSDictionary *dic in arrResponse) {
            User *user = [[User alloc] initWithDic:dic];
            [self.appDelegate.arrUsers addObject:user];
        }
        
        self.userList = self.appDelegate.arrUsers;
        
        [self.userTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [self.activity performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
        
    } failure:^(NSString *message) {
       NSLog(@"Error Message %@", message);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"userCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    User *user = [self.userList objectAtIndex:indexPath.row];
    
    cell.display_name = (UILabel *)[self.userTableView viewWithTag:11];
    cell.reputation = (UILabel *)[self.userTableView viewWithTag:12];
    cell.location = (UILabel *)[self.userTableView viewWithTag:13];
    cell.badge_count_bronze = (UILabel *)[self.userTableView viewWithTag:14];
    cell.badge_count_silver = (UILabel *)[self.userTableView viewWithTag:15];
    cell.badge_count_gold = (UILabel *)[self.userTableView viewWithTag:16];
    cell.profile_image = (UIImageView *)[self.userTableView viewWithTag:20];

    cell.display_name.text = user.display_name;
    cell.reputation.text = user.reputation;
    cell.location.text = user.location;
    cell.badge_count_bronze.text = [[user.badge_counts objectForKey:@"bronze"] stringValue];
    cell.badge_count_silver.text = [[user.badge_counts objectForKey:@"silver"] stringValue];
    cell.badge_count_gold.text = [[user.badge_counts objectForKey:@"gold"] stringValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *userPhotoSearch = [NSString stringWithFormat:@"%@.png", user.account_id];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:userPhotoSearch];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UserCell *newUserCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (newUserCell)
                        newUserCell.profile_image.image = image;
                });
            } else {
                NSLog(@"No Image Found");
            }
     });
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.userList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}



@end
