//
//  TagListView.m
//  TagObjc
//
//  Created by Javi Pulido on 16/7/15.
//  Copyright (c) 2015 Javi Pulido. All rights reserved.
//

#import "TagListView.h"
#import "TagView.h"

@interface TagListView ()

@property (nonatomic, strong) TagView *selectedTagView;//默认是没有选中的

@end

@implementation TagListView

// Required by Interface Builder
#if TARGET_INTERFACE_BUILDER
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];  
    return self;
}
#endif

- (NSMutableArray *)tagViews {
    if(!_tagViews) {
        [self setTagViews:[[NSMutableArray alloc] init]];
    }
    return _tagViews;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for(TagView *tagView in [self tagViews]) {
        [tagView setTextColor:textColor];
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    for(TagView *tagView in [self tagViews]) {
        [tagView setSelectedTextColor:selectedTextColor];
    }
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor {
    _tagBackgroundColor = tagBackgroundColor;
    for(TagView *tagView in [self tagViews]) {
        [tagView setTagBackgroundColor:tagBackgroundColor];
    }
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    _selectedBackgroundColor = selectedBackgroundColor;
    for(TagView *tagView in [self tagViews]) {
        [tagView setSelectedBackgroundColor:selectedBackgroundColor];
    }
}

- (void)setTagBackgroundImage:(UIImage *)tagBackgroundImage {
    _tagBackgroundImage = tagBackgroundImage;
    for(TagView *tagView in [self tagViews]) {
        [tagView setTagBackgroundImage:tagBackgroundImage];
    }
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    _selectedBackgroundImage = selectedBackgroundImage;
    for(TagView *tagView in [self tagViews]) {
        [tagView setSelectedBackgroundImage:selectedBackgroundImage];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    for(TagView *tagView in [self tagViews]) {
        [tagView setCornerRadius:cornerRadius];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    for(TagView *tagView in [self tagViews]) {
        [tagView setBorderWidth:borderWidth];
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    for(TagView *tagView in [self tagViews]) {
        [tagView setBorderColor:borderColor];
    }
}

- (void)setSelectedBorderColor:(UIColor *)selectedBorderColor {
    _selectedBorderColor = selectedBorderColor;
    for(TagView *tagView in [self tagViews]) {
        [tagView setSelectedBorderColor:selectedBorderColor];
    }
}

- (void)setPaddingY:(CGFloat)paddingY {
    _paddingY = paddingY;
    for(TagView *tagView in [self tagViews]) {
        [tagView setPaddingY:paddingY];
    }
}

- (void)setPaddingX:(CGFloat)paddingX {
    _paddingX = paddingX;
    for(TagView *tagView in [self tagViews]) {
        [tagView setPaddingX:paddingX];
    }
}

- (void)setMarginY:(CGFloat)marginY {
    _marginY = marginY;
    [self rearrangeViews];
}

- (void)setMarginX:(CGFloat)marginX {
    _marginX = marginX;
    [self rearrangeViews];
}

- (void)setRows:(int)rows {
    _rows = rows;
    [self invalidateIntrinsicContentSize];
}

- (void)setAlignment:(TagListAlignment)alignment {
    _alignment = alignment;
    [self rearrangeViews];
}

# pragma mark - Interface builder

- (void)prepareForInterfaceBuilder {
    [self addTag:@"Thanks"];
    [self addTag:@"for"];
    [self addTag:@"using"];
    [self addTag:@"TagListView"];
}

# pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self rearrangeViews];
}

- (void)rearrangeViews {
    for(TagView *tagView in [self tagViews]) {
        [tagView removeFromSuperview];
    }
    
    int currentRow = 0;
    int currentRowTagCount = 0;
    CGFloat currentRowWidth = 0;
    for(TagView *tagView in [self tagViews]) {
        CGRect tagViewFrame = [tagView frame];
        tagViewFrame.size = [tagView intrinsicContentSize];
        [tagView setFrame:tagViewFrame];
        self.tagViewHeight = tagViewFrame.size.height;
        
        if (currentRowTagCount == 0 || (currentRowWidth + tagView.frame.size.width + [self marginX]) > self.frame.size.width) {
            currentRow += 1;
            CGRect tempFrame = [tagView frame];
            tempFrame.origin.x = 0;
            tempFrame.origin.y = (currentRow - 1) * ([self tagViewHeight] + [self marginY]);
            [tagView setFrame:tempFrame];
            
            currentRowTagCount = 1;
            currentRowWidth = tagView.frame.size.width + [self marginX];
        } else {
            CGRect tempFrame = [tagView frame];
            tempFrame.origin.x = currentRowWidth;
            tempFrame.origin.y = (currentRow - 1) * ([self tagViewHeight] + [self marginY]);
            [tagView setFrame:tempFrame];
            
            currentRowTagCount += 1;
            currentRowWidth += tagView.frame.size.width + [self marginX];
        }
        
        [self addSubview:tagView];
    }
    self.rows = currentRow;
}

# pragma mark - Manage tags

- (CGSize) intrinsicContentSize {
    CGFloat height = [self rows] * ([self tagViewHeight] + [self marginY]);
    if([self rows] > 0) {
        height -= [self marginY];
    }
    return CGSizeMake(self.frame.size.width, height);
}

- (void)setSelectedTagAtIndex:(NSInteger) index {
    TagView *tagView = [[self tagViews] objectAtIndex:index];
    if (self.selectedTagView) {
        self.selectedTagView.isSelected = NO;
    }
    self.selectedTagView = tagView;
    self.selectedTagView.isSelected = YES;
}

- (TagView *)addTag:(NSString *)title {
    return [self addTag:title atIndex:[self.tagViews count]];
}

- (TagView *)addTag:(NSString *)title atIndex:(NSInteger) index {
    TagView *tagView = [[TagView alloc] initWithTitle:title];
    
    [tagView setTextColor: [self textColor]];
    [tagView setSelectedTextColor:[self selectedTextColor]];
    [tagView setTagBackgroundColor: [self tagBackgroundColor]];
    [tagView setCornerRadius: [self cornerRadius]];
    [tagView setBorderWidth: [self borderWidth]];
    [tagView setBorderColor: [self borderColor]];
    [tagView setSelectedBorderColor:[self selectedBorderColor]];
    [tagView setPaddingY: [self paddingY]];
    [tagView setPaddingX: [self paddingX]];
    [tagView setTextFont: [self textFont]];
    [tagView setSelectedBackgroundColor:[self selectedBackgroundColor]];
    [tagView setTagBackgroundImage:[self tagBackgroundImage]];
    [tagView setSelectedBackgroundImage:[self selectedBackgroundImage]];
    
    [tagView addTarget:self action:@selector(tagPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTagView:tagView atIndex:index];
    
    return tagView;
}

- (TagView *)insertTag:(NSString *)title atIndex:(NSInteger) index {
    return [self addTag:title atIndex:index];
}

- (void) addTagView:(TagView *)tagView atIndex:(NSInteger) index {
    [[self tagViews] insertObject:tagView atIndex:index];
    [self rearrangeViews];
}



- (void)addTags:(NSArray<NSString *> *)titles {
    for (NSString *title in titles) {
        [self addTag:title];
    }
}

- (void)removeTag:(NSString *)title {
    // Author's note: Loop the array in reversed order to remove items during loop
    for(int index = (int)[[self tagViews] count] - 1 ; index <= 0; index--) {
        TagView *tagView = [[self tagViews] objectAtIndex:index];
        if([[tagView currentTitle] isEqualToString:title]) {
            [tagView removeFromSuperview];
            [[self tagViews] removeObjectAtIndex:index];
        }
    }
}

- (void)removeAllTags {
    for(TagView *tagView in [self tagViews]) {
        [tagView removeFromSuperview];
    }
    [self setTagViews:[[NSMutableArray alloc] init]];
    [self rearrangeViews];
}

- (void)tagPressed:(TagView *)sender {
    NSInteger index = [[self tagViews] indexOfObject:sender];
    [self setSelectedTagAtIndex:index];
    
    if (self.onTapTagAtIndex) {
        self.onTapTagAtIndex(index);
    }
    
    if (self.onTapTagAtTitle) {
        self.onTapTagAtTitle(sender.currentTitle);
    }
    if (sender.onTap) {
        sender.onTap(sender);
    }
}

@end
