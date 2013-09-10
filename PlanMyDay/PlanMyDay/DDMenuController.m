//
//  DDMenuController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 toaast. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DDMenuController.h"
#import "TTApplicationManager.h"

#define kMenuFullWidth 320.0f
#define kMenuDisplayedWidth 90.0f
#define kMenuOverlayWidth (self.view.bounds.size.width - kMenuDisplayedWidth)
#define kMenuBounceOffset 0.0f
#define kMenuBounceDuration .0f
#define kMenuSlideDuration .0f


@interface DDMenuController (Internal)

@end

@implementation DDMenuController

@synthesize delegate, barButtonItemClass;

@synthesize leftViewController=_left;
@synthesize rootViewController=_root;

@synthesize tap=_tap;


- (id)initWithRootViewController:(UIViewController*)controller {
    if ((self = [self init])) {
        _root = controller;
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        self.barButtonItemClass = [UIBarButtonItem class];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRootViewController:_root]; // reset root
    
    
    
    if (!_tap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:tap];
        [tap setEnabled:NO];
        _tap = tap;
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _tap = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [_root shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (_root) {
        
        [_root willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
        
        UIView *view = _root.view;
        
       if (_menuFlags.showingLeftView) {
            
            view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            
        } else {
            
            view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
        }
        
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if (_root) {
        
        [_root didRotateFromInterfaceOrientation:fromInterfaceOrientation];
        
        CGRect frame = self.view.bounds;
        if (_menuFlags.showingLeftView) {
            frame.origin.x = frame.size.width - kMenuOverlayWidth;
        }
        _root.view.frame = frame;
        _root.view.autoresizingMask = self.view.autoresizingMask;
        
       
        
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (_root) {
        [_root willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    
}


#pragma mark - GestureRecognizers

- (void)tap:(UITapGestureRecognizer*)gesture {
    
    [gesture setEnabled:NO];
    [self showRootController:YES];
    
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    
    if (gestureRecognizer == _tap) {
        
        if (_root && _menuFlags.showingLeftView) {
            return CGRectContainsPoint(_root.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        
        return NO;
        
    }
    
    return YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer==_tap) {
        return YES;
    }
    return NO;
}


#pragma Internal Nav Handling

- (void)resetNavButtons {

    if (!_root) return;
    
    UIViewController *topController = nil;
    if ([_root isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navController = (UINavigationController*)_root;
        if ([[navController viewControllers] count] > 0) {
            topController = [[navController viewControllers] objectAtIndex:0];
        }
        
    } else if ([_root isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabController = (UITabBarController*)_root;
        topController = [tabController selectedViewController];
        
    } else {
        
        topController = _root;
        
    }
    
    
    UIBarButtonItem *infoButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"=" style:UIBarButtonItemStyleBordered  target:self action:@selector(showLeft:)];
    UIBarButtonItem *infoButtonItem2=[[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleBordered  target:self action:@selector(showRight:)];
    [topController.navigationItem setLeftBarButtonItem:infoButtonItem];
    [topController.navigationItem setRightBarButtonItem:infoButtonItem2];
    [topController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

-(void)RightBarButtonItemAction{
//    // lets just push another feed view

}

- (void)showRootController:(BOOL)animated {
    
    [_tap setEnabled:NO];
    _root.view.userInteractionEnabled = YES;
    
    CGRect frame = _root.view.frame;
    frame.origin.x = 0.0f;
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        
        _root.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (_left && _left.view.superview) {
            [_left.view removeFromSuperview];
        }
        

        
        _menuFlags.showingLeftView = NO;
        
       
        
        
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
}

- (void)showLeftController:(BOOL)animated {
    if (!_menuFlags.canShowLeft) return;
    
    if (_menuFlags.respondsToWillShowViewController) {
        [self.delegate menuController:self willShowViewController:self.leftViewController];
    }
    _menuFlags.showingLeftView = YES;
   
    
    UIView *view = self.leftViewController.view;
	CGRect frame = self.view.bounds;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    [self.leftViewController viewWillAppear:animated];
    
    frame = _root.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
}


#pragma mark Setters

- (void)setDelegate:(id<DDMenuControllerDelegate>)val {
    delegate = val;
    _menuFlags.respondsToWillShowViewController = [(id)self.delegate respondsToSelector:@selector(menuController:willShowViewController:)];
}
- (void)setLeftViewController:(UIViewController *)leftController {
    _left = leftController;
    _menuFlags.canShowLeft = (_left!=nil);
    [self resetNavButtons];
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    UIViewController *tempRoot = _root;
    _root = rootViewController;
    
    if (_root) {
        
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        
        UIView *view = _root.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = (id<UIGestureRecognizerDelegate>)self;
        
    } else {
        
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        
    }
    
   [self resetNavButtons];
}

- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated {
    
    if (!controller) {
        [self setRootViewController:controller];
        return;
    }
    
    if (_menuFlags.showingLeftView) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        // slide out then come back with the new root
        __block DDMenuController *selfRef = self;
        __block UIViewController *rootRef = _root;
        CGRect frame = rootRef.view.frame;
        frame.origin.x = kMenuDisplayedWidth;
        
        [UIView animateWithDuration:.1 animations:^{
            
            rootRef.view.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [selfRef setRootViewController:controller];
            _root.view.frame = frame;
            [selfRef showRootController:animated];
            
        }];
        
    } else {
        
        // just add the root and move to it if it's not center
        [self setRootViewController:controller];
        [self showRootController:animated];
        
    }
    
}


#pragma mark - Root Controller Navigation

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSAssert((_root!=nil), @"no root controller set");
    
    UINavigationController *navController = nil;
    
    if ([_root isKindOfClass:[UINavigationController class]]) {
        
        navController = (UINavigationController*)_root;
        
    } else if ([_root isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *topController = [(UITabBarController*)_root selectedViewController];
        if ([topController isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController*)topController;
        }
        
    }
    
    if (navController == nil) {
        
        NSLog(@"root controller is not a navigation controller.");
        return;
    }
    
    
    
        [navController pushViewController:viewController animated:animated];

}


#pragma mark - Actions

- (void)showLeft:(id)sender {
    
    [self showLeftController:YES];
    
}

- (void)showRight:(id)sender {
    
    TTNewProjectViewController *NewProject = [[TTNewProjectViewController alloc] initWithNibName:@"TTNewProjectViewController" bundle:nil];
    [self pushViewController:NewProject animated:YES];
    
}

@end
