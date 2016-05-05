//
//  KBActionSheetView.m
//  KBActionSheetViewDemo
//
//  Created by liuweiqing on 16/4/27.
//  Copyright © 2016年 RT. All rights reserved.
//

#import "KBActionSheetView.h"

#define UI_WIDTH [UIScreen mainScreen].bounds.size.width
#define UI_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface KBActionSheetView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *sheetTableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger redButtonIndex;

@end

@implementation KBActionSheetView

+ (instancetype)actionSheetWithTitle:(NSString *)title buttonTitles:(NSArray *)titles redButtonIndex:(NSInteger)redButtonIndex delegate:(id<KBActionSheetViewDelegate>)delegate
{
    KBActionSheetView *sheet = [[KBActionSheetView alloc] initWithTitle:title buttonTitles:titles redButtonIndex:redButtonIndex delegate:delegate];
    
    return sheet;
}


- (instancetype)initWithTitle:(NSString *)title buttonTitles:(NSArray *)titles redButtonIndex:(NSInteger)redButtonIndex delegate:(id<KBActionSheetViewDelegate>)delegate
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.titles = titles;
        self.title = title;
        self.redButtonIndex = redButtonIndex;
        self.delegate = delegate;
        self.backgroundColor = KBColor(46, 49, 50);
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSheetView)]];
        if (title.length > 0) {
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
            
            CGSize maxSize = CGSizeMake(UI_WIDTH-40, MAXFLOAT);
            self.titleSize = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            if (self.titleSize.height < 20) {
                self.titleSize = CGSizeMake(self.titleSize.width, 10);
            }
        }
    }
    return self;
}

- (void)removeSheetView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGFloat rowHeight = self.title.length>0?self.titleSize.height+40:0;
        self.sheetTableView.frame = CGRectMake(0, UI_HEIGHT, UI_WIDTH, self.titles.count*50+50+rowHeight+6);
    } completion:^(BOOL finished) {
        [self.sheetTableView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark --UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return self.title.length>0?self.titles.count+1:self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && self.title.length > 0) {
            return self.titleSize.height+40;
        }
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_WIDTH, 6)];
        headerView.backgroundColor = KBColor(233, 233, 238);
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.title.length > 0 ) {
            if (indexPath.row != 0) {
                [self.delegate actionSheetView:self didClickTitleAtIndex:indexPath.row-1];
                [self removeSheetView];
            }
        }else
        {
            [self.delegate actionSheetView:self didClickTitleAtIndex:indexPath.row];
            [self removeSheetView];
        }
    }else
        [self removeSheetView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_WIDTH, 50)];
    UIImage *image = [UIImage imageNamed:@"cell_select_image"];
    NSInteger leftCapWidth1 = image.size.width * 0.5f;
    NSInteger topCapHeight1 = image.size.height * 0.5f;
    image = [image stretchableImageWithLeftCapWidth:leftCapWidth1 topCapHeight:topCapHeight1];
    selectImageView.image = image;
    cell.selectedBackgroundView = selectImageView;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.section == 0) {
        if (self.title.length > 0) {
            if (indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:self.titleLabel];
            }else{
                cell.textLabel.text = self.titles[indexPath.row-1];
                if (indexPath.row-1 == self.redButtonIndex) {
                    cell.textLabel.textColor = KBColor(255, 10, 10);
                }
            }
        }else{
            cell.textLabel.text = self.titles[indexPath.row];
            if (indexPath.row == self.redButtonIndex) {
                cell.textLabel.textColor = KBColor(255, 10, 10);
            }
        }
    }else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"取消";
    }
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:edgeInset];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:edgeInset];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edgeInset];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edgeInset];
    }
}

#pragma mark --UITableViewDelegate

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:self];
    [window addSubview:self.sheetTableView];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
        CGFloat rowHeight = self.title.length>0?self.titleSize.height+40:0;
        self.sheetTableView.frame = CGRectMake(0, UI_HEIGHT-(self.titles.count*50+50+rowHeight+6), UI_WIDTH, self.titles.count*50+50+rowHeight+6);
    }];
}

#pragma mark --getter&setter
- (UITableView *)sheetTableView
{
    if (_sheetTableView == nil) {
        CGFloat rowHeight = self.title.length>0?self.titleSize.height+40:0;
        _sheetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI_HEIGHT, UI_WIDTH, self.titles.count*50+50+rowHeight+6)];
        _sheetTableView.delegate = self;
        _sheetTableView.dataSource = self;
        _sheetTableView.scrollEnabled = NO;
        _sheetTableView.separatorColor = KBColor(233, 233, 238);
    }
    return _sheetTableView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_WIDTH-self.titleSize.width)/2, 20, self.titleSize.width, self.titleSize.height)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = KBColor(111, 111, 111);
        _titleLabel.text = self.title;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
