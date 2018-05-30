//
//  CKFilterListView.m
//  chekuwang
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CKFilterListView.h"
#import "CKFiltrateRankTableViewCell.h"

@interface CKFilterListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableview;
@end

@implementation CKFilterListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - layoutUI

- (void)setupSubviews{
    self.mainTableview.frame = CGRectMake(0, 0, _screenWidth, self.statusArray.count*44+4);
    [self addSubview:_mainTableview];
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKFiltrateRankTableViewCell *statusCell = [tableView dequeueReusableCellWithIdentifier:@"statusCell"];
    statusCell.leftTitleLabel.text = [self.statusArray[indexPath.row] objectForKey:@"title"];
    if ([[self.statusArray[indexPath.row] objectForKey:@"title"] isEqualToString:[self.selectItem objectForKey:@"title"]]) {
        statusCell.markIcon.hidden = NO;
    } else {
        statusCell.markIcon.hidden = YES;
    }
    return statusCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(CKCKFilterListView:didSelectItem:)]) {
        [_delegate CKCKFilterListView:self didSelectItem:self.statusArray[indexPath.row]];
        self.selectItem = self.statusArray[indexPath.row];
        [self.mainTableview reloadData];
    }
}

#pragma mark - setter

- (void)setStatusArray:(NSMutableArray *)statusArray
{
    _statusArray = [NSMutableArray arrayWithArray:statusArray];
    [self setupSubviews];
    [self.mainTableview reloadData];
}

#pragma mark - getter

- (UITableView *)mainTableview
{
    if (_mainTableview == nil) {
        _mainTableview = [[UITableView alloc] init];
        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _mainTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
//            self..automaticallyAdjustsScrollViewInsets = NO;
        }
        [_mainTableview registerNib:[UINib nibWithNibName:@"CKFiltrateRankTableViewCell" bundle:nil] forCellReuseIdentifier:@"statusCell"];
    }
    return _mainTableview;
}


@end
