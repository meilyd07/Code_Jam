//
//  LocationMarkCellDelegate.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationMarkCellDelegate <NSObject>
- (void)didClickOnCellAtIndex:(NSInteger)cellIndexRow;
@end
