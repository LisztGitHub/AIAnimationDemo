//
//  AIRefreshView.m
//  AIAnimationDemo
//
//  Created by 艾泽鑫 on 2017/2/6.
//  Copyright © 2017年 艾泽鑫. All rights reserved.
//

#import "AIRefreshView.h"

@interface AIRefreshView ()<UIScrollViewDelegate>
@property(nonatomic,strong)CAShapeLayer *ovalShapeLayer;
/** 飞机layer*/
@property(nonatomic,strong)CALayer *airplaneLayer;
/** 背景图*/
@property(nonatomic,weak)UIImageView *bgImageView;
@end

@implementation AIRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _refreshing = NO;
        _progress   = 0.;
        //add the background Image
        UIImageView *imageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"refresh-view-bg"]];
        imageView.contentMode   = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        self.bgImageView        = imageView;
        [self addSubview:imageView];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.bgImageView.frame      = self.bounds;
}



#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = MAX(-(scrollView.contentOffset.y+scrollView.contentInset.top), 0.);
    _progress       = MIN(MAX(offsetY / self.frame.size.height, 0.), 1.);
    if (!self.isRefreshing) {
        [self redrawFromProgress:self.progress];
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!self.isRefreshing && self.progress >= 1.) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshViewDidRefresh:)]) {
            [self.delegate refreshViewDidRefresh:self];
        }
    }
}
// MARK: animate the Refresh View
- (void)beginRefreshing {
    self.refreshing = YES;
    [UIView animateWithDuration:.3 animations:^{
        UIEdgeInsets newInsets       = self.scrollView.contentInset;
        newInsets.top               += self.frame.size.height;
        self.scrollView.contentInset = newInsets;
    }];
}

- (void)endRefreshing {
    self.refreshing   = NO;
    
    [UIView animateWithDuration:.3 delay:0. options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        UIEdgeInsets newInsets       = self.scrollView.contentInset;
        newInsets.top               -= self.frame.size.height;
        self.scrollView.contentInset = newInsets;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)redrawFromProgress:(CGFloat)progress {
    
}

@end
