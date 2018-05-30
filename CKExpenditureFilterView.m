//
//  CKExpenditureFilterView.m
//  chekuwang
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CKExpenditureFilterView.h"
#import "CKItemFilterView.h"
#import "CKFilterListView.h"

@interface CKExpenditureFilterView ()<CKFilterListViewDelegate>
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIView *displayContainer;
@property (nonatomic, strong) UIView *backgroundview;
@property (nonatomic, strong) NSMutableArray *filterListViewArr;
@property (nonatomic, strong) NSMutableArray *itemViewArr;
@end

@implementation CKExpenditureFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = RGB(242, 242, 242);
    [self layoutTopTitleLabel];
}

- (void)setTitlesArr:(NSMutableArray *)titlesArr
{
    _titlesArr = titlesArr;
    [self setupSubviews];
    //添加子竖向选择filterview
    [self addChildListView];
}

#pragma mark - layoutUI

- (void)layoutTopTitleLabel{
    self.topContainerView.frame = self.bounds;
    [self addSubview:self.topContainerView];
    CGFloat itemW = (_screenWidth-self.titlesArr.count-1)/_titlesArr.count;
    CGFloat itemH = self.topContainerView.height;
    for (int i=0; i<self.titlesArr.count; i++) {
        CKItemFilterView *itemView = [[CKItemFilterView alloc] init];
        itemView.tag = i+[self itemViewBaseTag];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.userInteractionEnabled = YES;
        itemView.itemTitle = _titlesArr[i];
        [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelectFilterListView:)]];
        itemView.frame = i==0?CGRectMake(i*itemW, 0, itemW, itemH):CGRectMake(i*itemW+1*i, 0, itemW, itemH);
        [_topContainerView addSubview:itemView];
        //menu选项装进arr存储
        [self.itemViewArr addObject:itemView];
        if (i != self.titlesArr.count) {
            UIView *verLine = [[UIView alloc] init];
            verLine.backgroundColor = RGB(219, 219, 219);
            verLine.frame = CGRectMake(CGRectGetMaxX(itemView.frame), 6, 1, 23);
            [_topContainerView addSubview:verLine];
        }
    }
}

- (void)addChildListView{
    for (int i=0; i<self.titlesArr.count; i++) {
        CKFilterListView *filterListView = [[CKFilterListView alloc] init];
        filterListView.tag = i+[self filterListViewBaseTag];
        filterListView.delegate = self;
        NSArray *arr = self.valuesArr[i];
        NSArray *statusarr = [NSArray arrayWithArray:self.valuesArr[i]];
        filterListView.selectItem = arr[0];
        filterListView.statusArray = [NSMutableArray arrayWithArray:statusarr];
        //装进arr存储
        [self.filterListViewArr addObject:filterListView];
    }
}

#pragma mark - delegate

- (void)CKCKFilterListView:(CKFilterListView *)filterlistview didSelectItem:(NSDictionary *)item
{
    [self recoverListView];
    for (CKFilterListView *filterview in self.filterListViewArr) {
        if (filterlistview == filterview) {
            CKItemFilterView *itemview = [self.itemViewArr objectAtIndex:filterview.tag - [self filterListViewBaseTag]];
            itemview.itemTitleLabel.text = [[item objectForKey:@"title"] description];
        }
    }
}

#pragma mark - response event

- (void)showSelectFilterListView:(UIGestureRecognizer *)gesture{
    UIView *senderView = gesture.view;
    NSInteger index = senderView.tag-[self itemViewBaseTag];
    NSArray *itemArr = _valuesArr[index];
    
    CKItemFilterView *itemView = [self viewWithTag:senderView.tag];
    if ([itemView.itemTitleLabel.textColor isEqual:THEMERGB]) {
        itemView.itemTitleLabel.textColor = [UIColor blackColor];
        itemView.rightIcon.image = [UIImage imageNamed:@"下拉"];
        [self recoverListView];
    } else {
        itemView.rightIcon.image = [UIImage imageNamed:@"收回（选中）"];
        itemView.itemTitleLabel.textColor = THEMERGB;
        //设置为default
        for (CKItemFilterView *subitem in self.itemViewArr) {
            if (subitem != itemView) {
                subitem.itemTitleLabel.textColor = [UIColor blackColor];
                subitem.rightIcon.image = [UIImage imageNamed:@"下拉"];
            }
        }
        [self recoverListViewExcept:senderView.tag-[self itemViewBaseTag]+[self filterListViewBaseTag]];
        [self addbackgroundview];
        //filterview动画
        CKFilterListView *selectFilterView ;
        for (CKFilterListView *filterView in self.filterListViewArr) {
            if (filterView.tag == senderView.tag-[self itemViewBaseTag]+[self filterListViewBaseTag]) {
                selectFilterView = filterView;
            }
        }
        selectFilterView.frame = CGRectMake(0, 0, _screenWidth, 0);
        [self.displayContainer addSubview:selectFilterView];
        [UIView animateWithDuration:0.3 animations:^{
            selectFilterView.height = itemArr.count*44+4;
            _backgroundview.alpha = 0.4f;
        }];
    }
}

- (void)recoverListView{
    //收回所有控件
    for (CKFilterListView *filterListView in self.filterListViewArr) {
        [UIView animateWithDuration:0.3 animations:^{
            filterListView.height = 0;
            _backgroundview.alpha = 0.f;
        } completion:^(BOOL finished) {
            [filterListView removeFromSuperview];
        }];
    }
    //延迟执行 因为动画需要0.3s时间结束
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 0.31*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self recoverBackgroundview];
    });
    //设定字体颜色为未选中
    for (CKItemFilterView *itemView in self.itemViewArr) {
        itemView.itemTitleLabel.textColor = [UIColor blackColor];
        itemView.rightIcon.image = [UIImage imageNamed:@"下拉"];
    }
}

//收回除去！=tag的filterview
- (void)recoverListViewExcept:(NSInteger)tag{
    for (CKFilterListView *filterListView in self.filterListViewArr) {
        if (filterListView.tag != tag) {
            [UIView animateWithDuration:0.3 animations:^{
                filterListView.height = 0;
                _backgroundview.alpha = 0.f;
            } completion:^(BOOL finished) {
                [filterListView removeFromSuperview];
            }];
        }
    }
}

- (void)addbackgroundview{
    self.displayContainer.frame = CGRectMake(0, self.Y+self.height+1, _screenWidth, _screenHeight-99);
    UIViewController *owner =(UIViewController *)_delegate;
    [owner.view addSubview:self.displayContainer];
    self.backgroundview.frame = owner.view.bounds;
    [self.displayContainer addSubview:self.backgroundview];
}

//设空
- (void)recoverBackgroundview{
    if (_backgroundview == nil && _displayContainer == nil) {
        return;
    }
    [self.backgroundview removeFromSuperview];
    [self.displayContainer removeFromSuperview];
    self.backgroundview = nil;
    self.displayContainer = nil;
}

#pragma mark - getter

- (UIView *)topContainerView
{
    if (_topContainerView == nil) {
        _topContainerView = [[UIView alloc] init];
        _topContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _topContainerView;
}

- (UIView *)displayContainer
{
    if (_displayContainer == nil) {
        _displayContainer = [[UIView alloc] init];
        _displayContainer.backgroundColor = [UIColor clearColor];
    }
    return _displayContainer;
}

- (UIView *)backgroundview
{
    if (_backgroundview == nil) {
        _backgroundview = [[UIView alloc] init];
        _backgroundview.backgroundColor = [UIColor blackColor];
        _backgroundview.alpha = 0.f;
        _backgroundview.userInteractionEnabled = YES;
        [_backgroundview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoverListView)]];
    }
    return _backgroundview;
}

- (NSMutableArray *)filterListViewArr
{
    if (_filterListViewArr == nil) {
        _filterListViewArr = [NSMutableArray array];
    }
    return _filterListViewArr;
}

- (NSMutableArray *)itemViewArr
{
    if (_itemViewArr == nil) {
        _itemViewArr = [NSMutableArray array];
    }
    return _itemViewArr;
}

- (NSInteger)itemViewBaseTag{
    return 50;
}

- (NSInteger)filterListViewBaseTag{
    return 250;
}

@end
