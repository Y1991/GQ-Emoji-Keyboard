
//
//  GQEmojiScrollView.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQEmojiScrollView.h"

#define GQEmojiImageVMinHorizontalPadding (20)
#define GQEmojiImageVDefaultRows (4)

@interface GQEmojiScrollView () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *sectionViews;
@property (strong, nonatomic) GQEmojiImagePreView *emojiPreview;

@end
@implementation GQEmojiScrollView
{
    BOOL _inTouching;
    BOOL _inPreviewing;
    BOOL _inScolling;
    BOOL _isTouchDown;
    
    CGSize _emojiImgVSize;
    CGFloat _emojiImgVHorizontalPadding;
    CGFloat _emojiImgVVerticalPadding;
    NSInteger _emojiImgVColumns;
    NSInteger _emojiImgVRows;
    
    CGPoint _currentLocation;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialized];
        
        [self loadData];
        
        [self makeUI];
    }
    return self;
}

- (void)initialized{
 
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    [super setDelegate:self];

    self.multipleTouchEnabled = NO;
   
    self.exclusiveTouch = YES;
    self.clipsToBounds = NO;
    
    _inPreviewing = NO;
    _inScolling = NO;
    _inTouching = NO;
    
    _emojiImgVRows = GQEmojiImageVDefaultRows;
    
    _sectionViews = @[].mutableCopy;
}

- (void)loadData{
   
    _emojiImgVSize = [GQEmojiImageView emojiImageViewSize];
    

    CGFloat screenWidth = DEVICE_WIDTH;
    int column = 0;
    CGFloat w = GQEmojiImageVMinHorizontalPadding;
    while (w < screenWidth){
        column++;
        w += GQEmojiImageVMinHorizontalPadding+_emojiImgVSize.width;
    }
    _emojiImgVHorizontalPadding = (screenWidth-column*_emojiImgVSize.width)/(column+1);
  
    _emojiImgVVerticalPadding = (GQEKBEmojiHeight - GQEKBEmojiToolBarHeight-_emojiImgVRows*_emojiImgVSize.height)/(_emojiImgVRows + 1);

    _emojiImgVColumns = column;
}

- (void)makeUI{

    _emojiPreview = [GQEmojiImagePreView new];
    [self addSubview:_emojiPreview];
    _emojiPreview.hidden = YES;
}

- (void)updateEmojiType:(GQKeyboardEmojiType)emojiType{
    UIView *sectionView = _sectionViews[emojiType-1];
    [self setContentOffset:CGPointMake(CGRectGetMinX(sectionView.frame), 0)];
    _inScolling = NO;
}

- (void)reloadData{
    if (!_emojiDelegate) {
        return;
    }

    [_sectionViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_sectionViews removeAllObjects];

    CGFloat sectionLeft = 0;
    for (int section = 0; section < [_emojiDelegate countOfEmojiPageSection]; section++){
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(sectionLeft, 0, 0, CGRectGetHeight(self.bounds))];
        sectionView.userInteractionEnabled = NO;
        [_sectionViews addObject:sectionView];
        [self addSubview:sectionView];
        
        NSArray<GQEmoji *> *emojis = [_emojiDelegate emojisForSection:section];
        NSInteger page = emojis.count/(_emojiImgVColumns*_emojiImgVRows-1) + ((emojis.count%(_emojiImgVColumns*_emojiImgVRows-1))?1:0); //从1开始
        NSInteger currentPage = 0;
        
        for (NSInteger i = 0; i < (emojis.count+page); i++){
            currentPage = (i+1)/(_emojiImgVColumns*_emojiImgVRows) + (((i+1)%(_emojiImgVColumns*_emojiImgVRows))?1:0);

            NSInteger index = i;
            NSString * emoji = nil;
            UIView *emojiView = nil;
            if ((page == currentPage)&&(i==(emojis.count+page-1)) ) {
                emojiView = [self makeDeleteView];

                index = (_emojiImgVColumns*_emojiImgVRows)*(page)-1 ;
                
            }else if (((i+1)%(_emojiImgVColumns*_emojiImgVRows)) == 0) {

                emojiView = [self makeDeleteView];
       
            } else {
                emoji = emojis[i-(currentPage-1)].emoji;
                emojiView = [self makeEmojiView:emoji];
            }
   
            [emojiView setFrame:[self getEmojiImageVFrameWithIndex:index currentPage:currentPage] ];
 
            [sectionView addSubview:emojiView];
  
        }
        

        sectionView.frame = CGRectMake(CGRectGetMinX(sectionView.frame), 0, page*DEVICE_WIDTH, CGRectGetHeight(self.bounds));
        sectionLeft = CGRectGetMinX(sectionView.frame) + page*DEVICE_WIDTH;
    }

    [self bringSubviewToFront:_emojiPreview];
    self.contentSize = CGSizeMake(sectionLeft, CGRectGetHeight(self.frame));
}

- (CGRect)getEmojiImageVFrameWithIndex:(NSInteger)index currentPage:(NSInteger)currentPage{

    CGFloat column = index%_emojiImgVColumns +1;
    CGFloat row = index/_emojiImgVColumns +1 - (currentPage-1)*_emojiImgVRows; // 从1开始

    CGFloat left = (column-1)*(_emojiImgVHorizontalPadding + _emojiImgVSize.width) + _emojiImgVHorizontalPadding + (currentPage-1)*DEVICE_WIDTH;
    CGFloat top = (row-1)*(_emojiImgVVerticalPadding + _emojiImgVSize.height) + _emojiImgVVerticalPadding;
    
    return CGRectMake(left, top, _emojiImgVSize.width, _emojiImgVSize.height);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _inTouching = YES;

    _currentLocation = [[touches anyObject] locationInView:self];
    
    if (!_inScolling && !_inPreviewing){
        [self showPreview];
    }
    
    [self handleTouchForDeleteWithIsBegin:YES isEnd:NO];
}

- (void)showPreview{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (!_inScolling && _inTouching){
            _inPreviewing = YES;
            self.scrollEnabled = NO;

            [self showEmojiPreview];
        }
    });
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    _currentLocation = [[touches anyObject] locationInView:self];
    if (_inPreviewing){

        [self showEmojiPreview];
    }
    
    [self handleTouchForDeleteWithIsBegin:NO isEnd:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchDidEnd];
    
    [self handleTouchForDeleteWithIsBegin:NO isEnd:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchDidEnd];
}

- (void)showEmojiPreview{

    [self getEmojiFromCurrentLocation:^(CGPoint emojiCenterInSelf, NSString *emoji) {
        if ([emoji isEqualToString:@"删除"]) {
            _emojiPreview.hidden = YES;
        } else {
     
            if (emoji){
                _emojiPreview.hidden = NO;
                [_emojiPreview setEmoji:emoji];
                [_emojiPreview setCenter:CGPointMake(emojiCenterInSelf.x,emojiCenterInSelf.y-(CGRectGetHeight(_emojiPreview.frame)-_emojiImgVSize.height)/2)];
            }
            else{
                _emojiPreview.hidden = YES;
            }
         
        }
        
    }];
}

- (void)touchDidEnd{
    if (!_inScolling){

        [self getEmojiFromCurrentLocation:^(CGPoint emojiCenterInSelf, NSString *emoji) {
            if ([emoji isEqualToString:@"删除"]) {
                _emojiPreview.hidden = YES;
            } else {
                if (emoji){
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_inPreviewing?0:0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _emojiPreview.hidden = YES;
                    });
                    [_emojiDelegate emojiDidClicked:emoji];
                }
            }
            
        }];
    }
    _inTouching = NO;
    _inPreviewing = NO;
    self.scrollEnabled = YES;
}

- (void)handleTouchForDeleteWithIsBegin:(BOOL)isBegin isEnd:(BOOL)isEnd{
    if (isEnd) {
        [self touchUp];
    } else {
        if (!_inScolling){

            [self getEmojiFromCurrentLocation:^(CGPoint emojiCenterInSelf, NSString *emoji) {
                
                if ([emoji isEqualToString:@"删除"]){
                    
                    [self touchDown];
                } else {
                    if (isBegin == NO) {
                        [self touchUp];
                    }
                    
                }
            }];
        }
    }
    
}

- (void)touchDown{
    _isTouchDown = YES;
    [self startActionWithDelaytime:0.3 isFirst:YES event:^{
        [self tureAction];
    }];
    
}

- (void)touchUp{
    _isTouchDown = NO;
}

- (void)startActionWithDelaytime:(CGFloat)delaytime isFirst:(BOOL)isFirst event:(void(^)(void))event{

    if (event) {

        if (isFirst)
            event();

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaytime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isTouchDown){
                event();
                
                [self startActionWithDelaytime:0.1 isFirst:NO event:event];
            }
        });
    }
    
}

- (void)tureAction{
    if (_emojiDelegate&&[_emojiDelegate respondsToSelector:@selector(emojiDeleteClicked)]) {
        [_emojiDelegate emojiDeleteClicked];
    }
    
}

- (void)getEmojiFromCurrentLocation:(void(^)(CGPoint emojiCenterInSelf, NSString *emoji))handler{

    if (_currentLocation.x>0 && _currentLocation.x<self.contentSize.width && _currentLocation.y>0 && _currentLocation.y<(_emojiImgVRows*(_emojiImgVSize.height+_emojiImgVVerticalPadding)+_emojiImgVVerticalPadding)){
        NSInteger section = [self sectionForLocation:_currentLocation];
        UIView *sectionView = _sectionViews[section];
        [self getEmojiInBounds:sectionView.bounds
                      location:[self convertPoint:_currentLocation toView:sectionView]
                        emojis:[_emojiDelegate emojisForSection:section]
                       handler:^(CGPoint emojiCenter, NSString *emoji) {

                           if([emoji isEqualToString:@"删除"]){
                               handler(CGPointZero, @"删除");
                           }else if(emoji){
                               handler([self convertPoint:emojiCenter fromView:sectionView], emoji);
                           }
                           else{
                               handler(CGPointZero, nil);
                           }
                       }];
    }
    else{
        handler(CGPointZero, nil);
    }
}

- (NSInteger)sectionForLocation:(CGPoint)location{
    if (location.x < 0){
        return 0;
    }
    else if (location.x > self.contentSize.width-CGRectGetWidth(self.frame)){
        return [_emojiDelegate countOfEmojiPageSection]-1;
    }

    NSInteger section = 0;
    for (;section<_sectionViews.count;section++){
        UIView *sectionView = _sectionViews[section];
        //        NSLog(@"%f, %f, %f, %f" ,sectionView.frame.origin.x, sectionView.frame.origin.y , sectionView.frame.size.width, sectionView.frame.size.height );
        if (CGRectContainsPoint(sectionView.frame, location)){
            return section;
        }
    }
    return NSNotFound;
}

- (void)getEmojiInBounds:(CGRect)bounds
                location:(CGPoint)location
                  emojis:(NSArray<GQEmoji *> *)emojis
                 handler:(void(^)(CGPoint emojiCenter, NSString *emoji))handler{

    CGFloat w = _emojiImgVHorizontalPadding+_emojiImgVSize.width;

    NSInteger screenWidthCount = (NSInteger)(location.x/DEVICE_WIDTH);
    NSInteger currentPage = screenWidthCount + ((location.x-DEVICE_WIDTH*screenWidthCount)>0?1:0);

    NSInteger column = (NSInteger)((MAX(location.x-screenWidthCount*DEVICE_WIDTH-_emojiImgVHorizontalPadding/2, 0))/w) + 1;

    if (column>_emojiImgVColumns){
        
        column = _emojiImgVColumns;
    }

    NSInteger row = (NSInteger)((MAX(location.y-_emojiImgVVerticalPadding/2,0))/(_emojiImgVSize.height+_emojiImgVVerticalPadding)) + 1;

    NSInteger arrIndex = (currentPage-1) * (_emojiImgVColumns*_emojiImgVRows-1) + (row - 1)*_emojiImgVColumns + column -1;
    NSInteger allIndex = (currentPage-1) * (_emojiImgVColumns*_emojiImgVRows) + (row - 1)*_emojiImgVColumns + column -1;

    NSString * emoji = nil;
    if ((column==_emojiImgVColumns)&&(row==_emojiImgVRows)) { 
        emoji = @"删除";
        
    } else {
        emoji = emojis[arrIndex].emoji;
    }
    if ([emoji isEqualToString:@"删除"]) {
        handler(CGPointZero, @"删除");
    } else {
        if (arrIndex < emojis.count){

            CGRect rect = [self getEmojiImageVFrameWithIndex:allIndex currentPage:currentPage];
            CGPoint emojiP = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));

            handler(emojiP, emojis[arrIndex].emoji);
        }
        else{
            handler(CGPointZero, nil);
        }
    }
    
}

- (GQEmojiImageView *)makeEmojiView:(NSString *)emoji{
    GQEmojiImageView *emojiView = [GQEmojiImageView new];
    emojiView.emoji = emoji;
    return emojiView;
}

- (UIView *)makeDeleteView{
    UIImageView * emojiView = [UIImageView new];
    emojiView.image = [[UIImage imageNamed:@"keyboard_btn_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    emojiView.contentMode = UIViewContentModeCenter;
    return emojiView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_inScolling){
    }
    _inPreviewing = NO;
    _inScolling = YES;

    if ([_emojiDelegate respondsToSelector:@selector(didScrollToSection:)]){
        [_emojiDelegate didScrollToSection:[self sectionForLocation:CGPointMake(scrollView.contentOffset.x, 30)]];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        _inScolling = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>=0 && scrollView.contentOffset.x<=(scrollView.contentSize.width-CGRectGetWidth(scrollView.bounds))){
        _inScolling = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _inScolling = NO;
}

@end
