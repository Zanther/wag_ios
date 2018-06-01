//
//  UserCell.h
//  ios challenge
//
//  Created by Steven Lattenhauer II on 6/1/18.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *display_name;

@property(nonatomic, weak) UILabel *display_name;
@property(nonatomic, weak) UILabel *reputation;
@property(nonatomic, weak) UILabel *location;
@property(nonatomic, weak) UILabel *badge_count_bronze;
@property(nonatomic, weak) UILabel *badge_count_silver;
@property(nonatomic, weak) UILabel *badge_count_gold;
@property(nonatomic, weak) UIImageView *profile_image;


@end
