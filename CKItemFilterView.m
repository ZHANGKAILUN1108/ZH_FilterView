//
//  CKItemFilterView.m
//  chekuwang
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CKItemFilterView.h"

@implementation CKItemFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

//此方法进行布局
- (void)setItemTitle:(NSString *)itemTitle
{
    _itemTitle = itemTitle;
    
    _itemTitleLabel = [[UILabel alloc] init];
    _itemTitleLabel.text = _itemTitle;
    _itemTitleLabel.textColor = [UIColor blackColor];
    _itemTitleLabel.font = [UIFont systemFontOfSize:14];
    _itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_itemTitleLabel];
    [_itemTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    _rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉"]];
    [self addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_itemTitleLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(6);
    }];

}

@end
