//
//  LocationMarkCell.m
//  ContactsApp
//
//  Created by Hanna Rybakova on 6/9/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "LocationMarkCell.h"

@implementation LocationMarkCell

- (IBAction)onTapInfoButton:(id)sender {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:)]) {
            [self.delegate didClickOnCellAtIndex:_cellIndexRow];
        }
}

@end
