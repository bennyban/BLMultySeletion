//
//  RootViewController.m
//  BLMultySeletion
//
//  Created by 班磊 on 15/12/11.
//  Copyright © 2015年 bennyban. All rights reserved.
//

#import "RootViewController.h"
#import "BLColorSelectionController.h"


@interface RootViewController ()

@property (nonatomic, strong) UIButton *btnSelected;
@property (nonatomic, strong) NSMutableDictionary   *dicSubmit;          /**< 提交的数组 */

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"多选框";
    
    if (!_dicSubmit) {
        _dicSubmit = [NSMutableDictionary dictionary];
        [_dicSubmit setObject:@"" forKey:@"carcolor"];
    }
    
    [self initView];
}

- (void)initView
{
    _btnSelected = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSelected.backgroundColor = [UIColor redColor];
    _btnSelected.frame = CGRectMake(100, 100, ScreenWidth - 200, ScreenWidth - 200);
    [_btnSelected setTitle:@"颜色\n不限" forState:UIControlStateNormal];
    _btnSelected.titleLabel.numberOfLines = 0;
    [_btnSelected addTarget:self action:@selector(doActionToSelectColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSelected];
}

- (void)doActionToSelectColor
{
    __weak typeof(self) weakSelf = self;
    BLColorSelectionController *selectCtrl = [[BLColorSelectionController alloc] init];
    selectCtrl.selectedColor = _dicSubmit[@"carcolor"];
    selectCtrl.tapAction = ^(NSArray *colorarr){
        [weakSelf refreshSelectColor:colorarr];
    };
    UINavigationController         *navCtrl = [[UINavigationController alloc] initWithRootViewController:selectCtrl];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

- (void)refreshSelectColor:(NSArray *)arr
{
    NSString *colortitle = nil;
    for (NSDictionary *tempDic in arr) {
        if (!colortitle) {
            colortitle = [NSString stringWithFormat:@"%@",tempDic[@"color_name"]];
        } else
        {
            colortitle = [NSString stringWithFormat:@"%@,%@",colortitle,tempDic[@"color_name"]];
        }
    }
    
    [_dicSubmit setObject:colortitle forKey:@"carcolor"];
    [_btnSelected setTitle:colortitle forState:UIControlStateNormal];
}

@end
