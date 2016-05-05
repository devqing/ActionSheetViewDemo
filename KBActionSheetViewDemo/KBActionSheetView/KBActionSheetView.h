//
//  KBActionSheetView.h
//  KBActionSheetViewDemo
//
//  Created by liuweiqing on 16/4/27.
//  Copyright © 2016年 RT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KBActionSheetView;
@protocol KBActionSheetViewDelegate <NSObject>

- (void)actionSheetView:(KBActionSheetView *)actionSheetView didClickTitleAtIndex:(NSInteger)index;

@end

@interface KBActionSheetView : UIView

/**
 *  creat action sheet view
 *
 *  @param title          actionSheet Top title (if not need please input nil)
 *  @param titles         button titles
 *  @param redButtonIndex special red button index  (if no need please input -1)
 *
 *  @return actionSheetView
 */
+ (instancetype)actionSheetWithTitle:(NSString *)title buttonTitles:(NSArray *)titles redButtonIndex:(NSInteger)redButtonIndex delegate:(id<KBActionSheetViewDelegate>)delegate;

- (void)show;

@property (nonatomic, weak) id<KBActionSheetViewDelegate> delegate;

@end
