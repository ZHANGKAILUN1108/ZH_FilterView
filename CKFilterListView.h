//
//  CKFilterListView.h
//  chekuwang
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CKFilterListView;

@protocol CKFilterListViewDelegate <NSObject>
- (void)CKCKFilterListView:(CKFilterListView *)filterlistview didSelectItem:(NSDictionary *)item;
@end

@interface CKFilterListView : UIView
@property (nonatomic, weak) id<CKFilterListViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, strong) NSDictionary *selectItem;
@end

