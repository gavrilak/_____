//
//  NFXIntroViewController.m
//  NFXTourViewControllerDEMO
//
//  Created by Tomoya_Hirano on 2014/10/04.
//  Copyright (c) 2014年 Tomoya_Hirano. All rights reserved.
//

#import "NFXIntroViewController.h"

#define nextText @"next"
#define startText @"start"

@interface NFXIntroViewController ()<UIScrollViewDelegate>{
    UIScrollView*_scrollview;
    UIButton*_button;
    UIPageControl*_pgcontrol;
    NSArray*_images;
    UIImageView*_backgroundimageview;
}

@end

@implementation NFXIntroViewController

-(id)initWithViews:(NSArray*)images{
    self = [super init];
    if (self) {
        //check views length
        NSAssert(images.count!=0, @".views's length is zero.");
        
        /**
         *  setup viewcontroller
         */
        self.view.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(227/255.0) blue:(227/255.0) alpha:1];;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _images = images;
        
        /**
         *  positions
         */
        CGRect svrect_ = CGRectZero;
        svrect_.size.height = self.view.bounds.size.height;
        svrect_.size.width = self.view.bounds.size.width;
        CGPoint svcenter_ = CGPointZero;
        svcenter_.x = self.view.center.x;
        svcenter_.y = self.view.center.y;
        CGSize svconsize = CGSizeZero;
        svconsize.height = svrect_.size.height;
        svconsize.width = svrect_.size.width * images.count;
        
        CGPoint pgconcenter_ = CGPointZero;
        pgconcenter_.x = self.view.center.x;
        pgconcenter_.y = svcenter_.y + (svrect_.size.height/2) - 20;
        
       // CGRect btnrect_ = CGRectZero;
       // btnrect_.size.width =  65;
       // btnrect_.size.height = 50;
        CGPoint btncenter_ = CGPointZero;
        btncenter_.x = self.view.bounds.size.width -30;
        btncenter_.y = self.view.bounds.size.height- 20;
        
        
           _button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *btnImg = [UIImage imageNamed:@"cancel_blue.png"];
       
        _button.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
        [_button setImage:btnImg forState:UIControlStateNormal];
     
        [_button addTarget:self action:@selector(clickOut:) forControlEvents:UIControlEventTouchDown];
      
        
        _button.clipsToBounds = true;
       // _button.frame = btnrect_;
        _button.center = btncenter_;
       // _button.layer.cornerRadius = 4;
       // _button.layer.borderWidth = 0.5f;
       // _button.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        
        [self.view addSubview:_button];
        /*
         Views
         */
        _backgroundimageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_backgroundimageview];
        
        _scrollview = [[UIScrollView alloc] initWithFrame:svrect_];
        _scrollview.center = svcenter_;
       // _scrollview.backgroundColor = [UIColor redColor];
        _scrollview.contentSize = svconsize;
        _scrollview.pagingEnabled = true;
        _scrollview.bounces = false;
        _scrollview.delegate = self;
        _scrollview.layer.borderWidth = 0.5f;
        _scrollview.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _scrollview.showsHorizontalScrollIndicator = false;
        _scrollview.layer.cornerRadius = 2;
        [self.view addSubview:_scrollview];
        
        _pgcontrol = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pgcontrol.pageIndicatorTintColor = [UIColor colorWithRed:(175/255.0) green:(175/255.0) blue:(175/255.0) alpha:1];
        _pgcontrol.currentPageIndicatorTintColor = [UIColor colorWithRed:(67/255.0) green:(149/255.0) blue:(200/255.0) alpha:1];
        _pgcontrol.numberOfPages = _images.count;
        _pgcontrol.currentPage = 0;
        [_pgcontrol sizeToFit];

        _pgcontrol.center = pgconcenter_;
         [_pgcontrol addTarget:self action:@selector(clickIndicators:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_pgcontrol];
        
   
     
        [self.view addSubview:_button];
        
        int index_ = 0;
        for (UIImage*image_ in images) {
            NSAssert([image_ isKindOfClass:[UIImage class]],@".views are not only UIImage.");
            CGRect ivrect_ = CGRectMake(_scrollview.bounds.size.width * index_,
                                        0,
                                        _scrollview.bounds.size.width,
                                        _scrollview.bounds.size.height - 40);
            UIImageView*iv_ = [[UIImageView alloc] initWithFrame:ivrect_];
            iv_.contentMode = UIViewContentModeScaleAspectFill;
            iv_.clipsToBounds = true;
            iv_.image = image_;
            [_scrollview addSubview:iv_];
            index_++;
        }
    }
    return self;
}

-(void)clickOut:(UIButton*)button{
 
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)clickIndicators:(UIButton*)button{
    int page_ = (int)round(_scrollview.contentOffset.x / _scrollview.frame.size.width);
    /**
     *  scroll or finish
     */
    if (page_!=(_images.count-1)) {
        CGRect rect = _scrollview.frame;
        rect.origin.x = rect.size.width * (page_+1);
        [_scrollview scrollRectToVisible:rect animated:true];
    }else{
        CGRect rect = _scrollview.frame;
        rect.origin.x = rect.size.width * 0;
        [_scrollview scrollRectToVisible:rect animated:true];
   
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page_ = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
        _pgcontrol.currentPage = page_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

UIImage *(^createImageFromUIColor)(UIColor *) = ^(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
};

@end
