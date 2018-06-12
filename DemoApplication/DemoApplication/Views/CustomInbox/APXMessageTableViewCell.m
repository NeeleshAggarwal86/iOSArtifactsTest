//
//  APXMessageTableViewCell.m
//  AppoxeeCustomInboxApp
//
//  Created by Raz Elkayam on 12/10/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import "APXMessageTableViewCell.h"

@interface APXMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *readStateImageView;

@end

@implementation APXMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsRead:(BOOL)isRead
{
    _isRead = isRead;
    
    if (_isRead) {
        
        self.readStateImageView.image = [UIImage imageNamed:@"messageRead"];
        
    } else {
        
        self.readStateImageView.image = [UIImage imageNamed:@"messageUnread"];
    }
}

@end
