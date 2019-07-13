//
//  LocationMarkCell.h
//  ContactsApp
//
//  Created by Hanna Rybakova on 6/9/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationMarkCellDelegate.h"

@interface LocationMarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *markTitle;
@property (strong, nonatomic) NSString *uniqueId;

@property (weak, nonatomic) id<LocationMarkCellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndexRow;
@end
