//
//  BLColorSelectionController.h
//  BLMultySeletion
//
//  Created by 班磊 on 15/12/11.
//  Copyright © 2015年 bennyban. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StateBarHeight      20.0f
#define kTabBarHeight       49.0f
#define NavigationBarHeight 44.0f
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define RGBAColor(r,g,b,a)                  [UIColor colorWithRed:((CGFloat)(r))/255.0 green:((CGFloat)(g))/255.0 blue:((CGFloat)(b))/255.0 alpha:(a)]

#define RGBColor(r,g,b)                     RGBAColor(r,g,b,1.0)
#define kBtn_WordsColor                     RGBColor(39, 157, 12)

typedef void(^FilterSelectedColorTapActionBlock)(NSArray *colorarr);

@interface BLColorSelectionController : UIViewController

@property (nonatomic, strong) FilterSelectedColorTapActionBlock tapAction;

@property (nonatomic, strong) NSString *selectedColor;

@end
