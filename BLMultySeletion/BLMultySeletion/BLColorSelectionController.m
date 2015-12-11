//
//  BLColorSelectionController.m
//  BLMultySeletion
//
//  Created by 班磊 on 15/12/11.
//  Copyright © 2015年 bennyban. All rights reserved.
//

#import "BLColorSelectionController.h"

@interface BLColorSelectionController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;  /**< 车型列表 */
@property (nonatomic, strong) NSMutableArray *arrData;    /**< 数组列表中的数据 */
@property (nonatomic, strong) UIButton    *btnSure;

@end

@implementation BLColorSelectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"多选框";
    
    if (_arrData) {
        _arrData = [NSMutableArray array];
    }
    
    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    /**
     * 数据请求之后添加
     */
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Color" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arrResults = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
    
    NSArray *arrSelectedColor = [_selectedColor componentsSeparatedByString:@","];
    NSMutableArray *arrChange = [[NSMutableArray alloc] init];
    for (int i=0 ; i<arrResults.count; i++) {
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:arrResults[i]];
        
        BOOL isSelected = NO;
        for (NSString *tempColor in arrSelectedColor) {
            if ([tempColor isEqualToString:itemDic[@"color_name"]]) {
                isSelected = YES;
            }
        }
        
        NSString *obj = (isSelected) ? @"1" : @"0";
        [itemDic setObject:obj forKey:@"checkstate"];
        [arrChange addObject:itemDic];
    }
    _arrData = [NSMutableArray arrayWithArray:arrChange];
    
    [self initView];
}

- (void)initView
{
    CGFloat orignX = 0;
    CGFloat orignY = 0;
    CGFloat width  = ScreenWidth;
    CGFloat height = ScreenHeight - NavigationBarHeight - StateBarHeight - 60;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(orignX, orignY, width, height)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    orignY = ScreenHeight - NavigationBarHeight - StateBarHeight - 60;
    height = 60;
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(orignX, orignY, width, height)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    
    orignX = 10;
    orignY = 10;
    width  = ScreenWidth - 2*orignX;
    height = 40;
    
    _btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSure.frame = CGRectMake(orignX, orignY, width, height);
    [_btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [_btnSure.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    _btnSure.backgroundColor = kBtn_WordsColor;
    [_btnSure addTarget:self action:@selector(doActionToDone) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:_btnSure];
    
    [self.view addSubview:tableFooterView];
}

- (void)doActionToDone
{
    NSMutableArray *arrSelected = [NSMutableArray array];
    for (int i=0; i<_arrData.count; i++) {
        NSString *checkState = _arrData[i][@"checkstate"];
        if ([checkState isEqualToString:@"1"]) {
            [arrSelected addObject:_arrData[i]];
        }
    }
    _tapAction (arrSelected);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        
        UIImageView *checkImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        checkImgV.tag = 001;
        cell.accessoryView = checkImgV;
    }
    
    NSDictionary *dict = _arrData[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"color_name"]];
    
    UIImageView *checkImageView = (UIImageView *)[cell.accessoryView viewWithTag:001];
    checkImageView.image = ([dict[@"checkstate"] isEqualToString:@"1"]) ? [UIImage imageNamed:@"filterCheck.png"] : [UIImage imageNamed:@"filterUncheck.png"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_arrData[indexPath.row]];
    NSString *checkState = dict[@"checkstate"];
    checkState = ([checkState isEqualToString:@"0"]) ? @"1" : @"0";
    [dict setObject:checkState forKey:@"checkstate"];
    [_arrData replaceObjectAtIndex:indexPath.row withObject:dict];
    
    
    UITableViewCell *selectCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *arrorImgV = (UIImageView *)[selectCell viewWithTag:001];
    if ([arrorImgV.image isEqual:[UIImage imageNamed:@"filterCheck.png"]]) {
        arrorImgV.image = [UIImage imageNamed:@"filterUncheck.png"];
    } else
    {
        arrorImgV.image = [UIImage imageNamed:@"filterCheck.png"];
    }
    [tableView reloadData];
}

@end
