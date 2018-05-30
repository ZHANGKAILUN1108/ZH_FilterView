//
//  CKExpenditureFilterView.h
//  chekuwang
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKExpenditureFilterViewDelegate <NSObject>
- (void)signatureFiltrateViewDidSelectItem:(NSDictionary *)item;
@end

@interface CKExpenditureFilterView : UIView
@property (nonatomic, assign) id<CKExpenditureFilterViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) NSMutableArray *valuesArr;
@end
