//
//  UserCell.m
//  ios challenge
//
//  Created by Steven Lattenhauer II on 6/1/18.
//

#import "UserCell.h"

@implementation UserCell

@synthesize display_name, location, reputation, badge_count_bronze, badge_count_silver, badge_count_gold, profile_image;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
