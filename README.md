# ZH_FilterView
### 说明
    这个控件主要是用来控制大多数iOS App界面顶部的下来筛选项，如果你经常会遇到要控制顶部筛选栏的个数和下拉的长度，不妨试试我这个控件，使用方法很简单。
__使用方法__

在懒加载中这样去初始化
```
- (CKExpenditureFilterView *)expendFilterView
{
    if (_expendFilterView == nil) {
        _expendFilterView = [[CKExpenditureFilterView alloc] init];
        _expendFilterView.delegate = self;
    }
    return _expendFilterView;
}
```
布局的时候需要去设置两个属性，titlearr和valuearr

__注意__

要先设置valuearr属性进行数据初始化，在条用titlearr的setter的方法进行ui布局，就像这样.

**titlearr:顶部筛选栏的的string类型数组**

**valuearr:对应宣栓类型数组string标题的选择项目数组**

```
- (void)setupSubviews{
    self.view.backgroundColor = RGB(242, 242, 242);
    
    self.title = @"收支明细";
    self.expendFilterView.frame = CGRectMake(0, 64, _screenWidth, 35);
    self.expendFilterView.valuesArr = [NSMutableArray arrayWithArray:self.valuesArr];
    self.expendFilterView.titlesArr = [NSMutableArray arrayWithArray:self.titlesArr];
    [self.view addSubview:_expendFilterView];
    
    self.expenditureTableview.frame = CGRectMake(0, 100, _screenWidth, _screenHeight-64);
    [self.view addSubview:self.expenditureTableview];
    
}
```

__接下来你需要的做的就是去完善代理方法中的回调即可__

有任何问题请联系我，邮箱547351710@qq.com 或者加我的微信jay594111
