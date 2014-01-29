//
//  LostCell.h
//  LostCharacterDatabase
//
//  Created by Kagan Riedel on 1/28/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UILabel *spoilerLabel;
@property (weak, nonatomic) IBOutlet UILabel *passangerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;




@end
