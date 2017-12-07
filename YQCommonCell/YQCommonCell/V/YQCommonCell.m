//
//  YQCommonCell.m
//  YQCommonCell
//
//  Created by 俞琦 on 2017/8/28.
//  Copyright © 2017年 俞琦. All rights reserved.
//

#import "YQCommonCell.h"
#import "YQBadgeView.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

// 存在优先级问题
/*
 当item的辅助属性：assistLabelText、assistImageFileStr等属性同时设置的时候，显示的优先级为
 Custom >> Label >> Field >> ImageURL >> ImageFile >> Custom
 */
typedef NS_ENUM(NSInteger, YQCommonCellAssistType)
{
    YQCommonCellAssistTypeNone = 0,
    YQCommonCellAssistTypeCustom = 1,
    YQCommonCellAssistTypeLabel = 2,
    YQCommonCellAssistTypeField = 3,
    YQCommonCellAssistTypeImage = 4,
};

@interface YQCommonCell()
@property (nonatomic, strong) UILabel *assistLabel; ///< 辅助信息lable
@property (nonatomic, strong) UIImageView *assistImageView; ///< 辅助imageView
@property (nonatomic, strong) UITextField *assistTextField; ///< 辅助UITextField
@property (nonatomic, strong) UIView *assistCustomView; ///< 辅助自定义视图
@property (nonatomic, strong) YQBadgeView *badgeView; ///< 提醒按钮

@property (nonatomic, assign) YQCommonCellAssistType assistType;
@end

@implementation YQCommonCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CommonCell";
    YQCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YQCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.assistCustomView];
        [self addSubview:self.assistImageView];
        [self addSubview:self.assistLabel];
        [self addSubview:self.assistTextFile];
        [self addSubview:self.badgeView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat cellWidth = self.bounds.size.width;
    CGFloat cellHeight = self.bounds.size.height;
    CGFloat textLabelRight = CGRectGetMaxX(self.textLabel.frame);
    CGFloat badgeMargin = 10.f;
    CGFloat badgeWidth = 20.f;
    CGFloat assistRightToCell = self.item.isArrow ? 40.f : 15.f;
    CGFloat badgeRight = 0.f;
    CGFloat assistImageWidth = self.item.assistImageWidth;
    
    // 设置小红点
    if (!self.badgeView.hidden) {
        self.badgeView.frame = CGRectMake(textLabelRight + badgeMargin, (cellHeight-badgeWidth)/2, badgeWidth, badgeWidth);
        badgeRight = CGRectGetMaxX(self.badgeView.frame);
    } else {
        self.badgeView.frame = CGRectZero;
        badgeRight = textLabelRight;
    }
    
    CGFloat maxAssistWidth = cellWidth - badgeRight - assistRightToCell; // 最大的宽
    
    /******************************* 辅助不部分 (需考虑优先级)******************************/
    switch (self.assistType) {
        case YQCommonCellAssistTypeNone:
        {
            self.assistCustomView.frame = CGRectZero;
            self.assistLabel.frame = CGRectZero;
            self.assistTextField.frame = CGRectZero;
            self.assistImageView.frame = CGRectZero;
            break;
        }
        case YQCommonCellAssistTypeCustom:
        {
            self.assistCustomView.frame = CGRectMake(cellWidth - assistRightToCell - maxAssistWidth, 0, maxAssistWidth, self.bounds.size.height);
            [self layoutCustomViewSubview];
            self.assistLabel.frame = CGRectZero;
            self.assistTextField.frame = CGRectZero;
            self.assistImageView.frame = CGRectZero;
            break;
        }
        case YQCommonCellAssistTypeLabel:
        {
            self.assistCustomView.frame = CGRectZero;
            CGSize size = [self.assistLabel.text boundingRectWithSize:CGSizeMake(maxAssistWidth, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:self.assistLabel.font}
                                                              context:nil].size;
            self.assistLabel.frame = CGRectMake(cellWidth - assistRightToCell - size.width, 0, size.width, cellHeight);
            self.assistTextField.frame = CGRectZero;
            self.assistImageView.frame = CGRectZero;
            break;
        }
        case YQCommonCellAssistTypeField:
        {
            self.assistCustomView.frame = CGRectZero;
            self.assistLabel.frame = CGRectZero;
            self.assistTextFile.frame = CGRectMake(cellWidth - assistRightToCell - maxAssistWidth, 0, maxAssistWidth, self.bounds.size.height);
            self.assistImageView.frame = CGRectZero;
            break;
        }
        case YQCommonCellAssistTypeImage:
        {
            self.assistCustomView.frame = CGRectZero;
            self.assistLabel.frame = CGRectZero;
            self.assistTextField.frame = CGRectZero;
            self.assistImageView.frame = CGRectMake(cellWidth - assistRightToCell - assistImageWidth, (cellHeight - assistImageWidth)/2, assistImageWidth, assistImageWidth);
            break;
        }
        default:
            break;
    }
    
}

- (void)layoutCustomViewSubview
{
    UIView *subView = self.item.assistCustomView;
    UIView *assistCustomView = self.assistCustomView;
    
    CGFloat assistCustomViewW = assistCustomView.bounds.size.width;
    CGFloat assistCustomViewH = assistCustomView.bounds.size.height;
    
    CGFloat subViewW = subView.bounds.size.width;
    CGFloat subViewH = subView.bounds.size.height;
    
    if (assistCustomViewW < subViewW || assistCustomViewH < subViewH) {
        subView.frame = CGRectMake(0, 0, subViewW, subViewH);
        assistCustomView.clipsToBounds = YES;
        return;
    }
    
    switch (self.item.assistCustomViewLayout) {
        case YQAssistCustomViewLayoutRight:
        {
            CGFloat subViewX = assistCustomViewW - subViewW;
            CGFloat subViewY = (assistCustomViewH - subViewH)/2;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        case YQAssistCustomViewLayoutRightBottom:
        {
            CGFloat subViewX = assistCustomViewW - subViewW;
            CGFloat subViewY = assistCustomViewH - subViewH;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        case YQAssistCustomViewLayoutBottom:
        {
            CGFloat subViewX = (assistCustomViewW - subViewW)/2;
            CGFloat subViewY = assistCustomViewH - subViewH;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        case YQAssistCustomViewLayoutLeftBottom:
        {
            CGFloat subViewX = 0;
            CGFloat subViewY = assistCustomViewH - subViewH;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        case YQAssistCustomViewLayoutLeft:
        {
            CGFloat subViewX = 0;
            CGFloat subViewY = (assistCustomViewH - subViewH)/2;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        case YQAssistCustomViewLayoutLeftTop:
        {
            CGFloat subViewX = 0;
            CGFloat subViewY = 0;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        case YQAssistCustomViewLayoutTop:
        {
            CGFloat subViewX = (assistCustomViewW - subViewW)/2;
            CGFloat subViewY = 0;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        case YQAssistCustomViewLayoutRightTop:
        {
            CGFloat subViewX = assistCustomViewW - subViewW;
            CGFloat subViewY = 0;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        case YQAssistCustomViewLayoutCenter:
        {
            CGFloat subViewX = (assistCustomViewW - subViewW)/2;
            CGFloat subViewY = (assistCustomViewH - subViewH)/2;
            subView.frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
            break;
        }
        default:
            break;
    }
}

#pragma mark - settingInfo
- (void)setCellResponse
{
    self.userInteractionEnabled = self.item.isSelectAbility;
    if (self.item.isSelectHighlight == NO) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

- (void)setCellStyle
{
    self.backgroundColor = self.item.cellBackgroudColor;
    self.textLabel.font = self.item.titleLableFont;
    self.textLabel.textColor = self.item.titleLableColor;
    self.assistLabel.font = self.item.assistLabelFont;
    self.assistLabel.textColor = self.item.assistLabelColor;
    self.assistTextField.font = self.item.assistLabelFont;
    self.assistTextField.textColor = self.item.assistLabelColor;
    if (self.item.iconWidth > 0) {
        UIImage *iconImage = self.imageView.image;
        CGSize iconSize = CGSizeMake(self.item.iconWidth, self.item.iconWidth);
        UIGraphicsBeginImageContextWithOptions(iconSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, iconSize.width, iconSize.height);
        [iconImage drawInRect:imageRect];
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if (self.item.assistImageCornerRadius > 0) {
        self.assistImageView.layer.cornerRadius = self.item.assistImageCornerRadius;
        self.assistImageView.clipsToBounds = YES;
    } else {
        self.assistImageView.layer.cornerRadius = 0.f;
        self.assistImageView.clipsToBounds = NO;
    }
}

- (void)setCellData
{
    self.imageView.image = [UIImage imageNamed:self.item.icon];
    self.textLabel.text = self.item.title;
    
    // 设置红点提醒
    if (self.item.badgeValue && self.item.badgeValue.integerValue > 0) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = self.item.badgeValue;
    } else {
        self.badgeView.hidden = YES;
    }
    
    // 设置跳转箭头
    if (self.item.isArrow) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    /******************************* 辅助不部分 (需考虑优先级)******************************/
    // 辅助自定义视图
    if (self.item.assistCustomView) {
        self.assistCustomView.hidden = NO;
        [self.assistCustomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.assistCustomView addSubview:self.item.assistCustomView];
        self.assistType = YQCommonCellAssistTypeCustom;
        return;
    } else {
        self.assistCustomView.hidden = YES;
    }
    
    // 辅助label
    if (self.item.assistLabelText && self.item.assistLabelText.length > 0) {
        self.assistLabel.hidden = NO;
        self.assistLabel.text = self.item.assistLabelText;
        self.assistType = YQCommonCellAssistTypeLabel;
        return;
    } else {
        self.assistLabel.hidden = YES;
    }
    
    // 辅助输入框
    if ((self.item.assistFieldText && self.item.assistFieldText.length > 0) || (self.item.assistFieldPlaceholderText && self.item.assistFieldPlaceholderText.length > 0)) {
        self.assistTextField.hidden = NO;
        self.assistTextField.text = self.item.assistFieldText;
        self.assistTextField.placeholder = self.item.assistFieldPlaceholderText;
        self.assistType = YQCommonCellAssistTypeField;
        return;
    } else {
        self.assistTextField.hidden = YES;
    }
    
    // 辅助图片 网络
    if (self.item.assistImageURLStr && self.item.assistImageURLStr.length > 0) {
        self.assistImageView.hidden = NO;
        [self.assistImageView sd_setImageWithURL:[NSURL URLWithString:self.item.assistImageURLStr]];
        self.assistType = YQCommonCellAssistTypeImage;
        return;
    } else {
        self.assistImageView.hidden = YES;
    }
    
    // 辅助图片 本地
    if (self.item.assistImageFileStr && self.item.assistImageFileStr.length > 0) {
        self.assistImageView.hidden = NO;
        self.assistImageView.image = [UIImage imageNamed:self.item.assistImageFileStr];
        self.assistType = YQCommonCellAssistTypeImage;
        return;
    } else {
        self.assistImageView.hidden = YES;
    }
    
    self.assistType = YQCommonCellAssistTypeNone;
}

#pragma mark - setter
- (void)setFrame:(CGRect)frame
{
    if (self.item.screenSeparator == YES) {
        frame.size.height -= 1;
    }
    [super setFrame:frame];
}


- (void)setItem:(YQCommonItem *)item
{
    _item = item;
    
    [self setCellData];
    
    [self setCellStyle];
    
    [self setCellResponse];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
}

#pragma mark - getter
- (UILabel *)assistLabel
{
    if (_assistLabel == nil) {
        _assistLabel = [[UILabel alloc] init];
        _assistLabel.hidden = YES;
        _assistLabel.textAlignment = NSTextAlignmentRight;
    }
    return _assistLabel;
}

- (UIImageView *)assistImageView
{
    if (_assistImageView == nil) {
        _assistImageView = [[UIImageView alloc] init];
        _assistImageView.hidden = YES;
    }
    return _assistImageView;
}

- (UITextField *)assistTextFile
{
    if (_assistTextField == nil) {
        _assistTextField = [[UITextField alloc] init];
        _assistTextField.hidden = YES;
        _assistTextField.borderStyle = UITextBorderStyleNone;
        _assistTextField.textAlignment = NSTextAlignmentRight;
    }
    return _assistTextField;
}

- (UIView *)assistCustomView
{
    if (_assistCustomView == nil) {
        _assistCustomView = [[UIView alloc] init];
        _assistCustomView.hidden = YES;
    }
    return _assistCustomView;
}

- (YQBadgeView *)badgeView
{
    if (_badgeView == nil) {
        _badgeView = [[YQBadgeView alloc] init];
    }
    return _badgeView;
}
@end