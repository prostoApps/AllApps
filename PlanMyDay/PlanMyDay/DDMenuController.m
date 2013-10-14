//
//  DDMenuController.m
//  DDMenuController

#import "DDMenuController.h"
#import "TTApplicationManager.h"

#define kMenuFullWidth 320.0f
#define kMenuDisplayedWidth 68.0f
#define kMenuOverlayWidth (self.view.bounds.size.width - kMenuDisplayedWidth)
#define kMenuBounceOffset 0.0f
#define kMenuBounceDuration .0f
#define kMenuSlideDuration .0f

@interface DDMenuController (Internal)
- (void)showShadow:(BOOL)val;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRootViewController:_root]; // reset root

    if (!_tap)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:tap];
        [tap setEnabled:NO];
        _tap = tap;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _tap = nil;
}

#pragma mark - GestureRecognizers

- (void)tap:(UITapGestureRecognizer*)gesture
{
    [gesture setEnabled:NO];
    [self showRootController:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _tap)
    {
        if (_root && _menuFlags.showingLeftView)
        {
            return CGRectContainsPoint(_root.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer==_tap)
    {
        return YES;
    }
    return NO;
}

#pragma Internal Nav Handling

- (void)resetNavButtons
{
    if (!_root) return;
    
    UIViewController *topController = nil;
    if ([_root isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController*)_root;
        
        if ([[navController viewControllers] count] > 0)
        {
            topController = [[navController viewControllers] objectAtIndex:0];
        }
    }
    else
    {
        topController = _root;
    }
    UIBarButtonItem *RightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_new_project.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showRight:)];
    UIBarButtonItem *LeftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showLeft:)];
   
                                      
    [topController.navigationItem setLeftBarButtonItem:LeftBarButtonItem];
    [topController.navigationItem setRightBarButtonItem:RightBarButtonItem];
    [topController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered  target:self action:nil];
    [topController.navigationItem setBackBarButtonItem:backButton];
   
}

- (void)showRootController:(BOOL)animated {
    
    [_tap setEnabled:NO];
    _root.view.userInteractionEnabled = YES;
    
    CGRect frame = _root.view.frame;
    frame.origin.x = 0.0f;
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated)
    {
        [UIView setAnimationsEnabled:NO];
    }
    
    [UIView animateWithDuration:.3 animations:^
    {
        _root.view.frame = frame;
    }
    completion:^(BOOL finished)
    {
        if (_left && _left.view.superview)
        {
            [_left.view removeFromSuperview];
        }
        _menuFlags.showingLeftView = NO;
    }];
    
    if (!animated)
    {
        [UIView setAnimationsEnabled:_enabled];
    }
}

- (void)showLeftController:(BOOL)animated {
    if (!_menuFlags.canShowLeft) return;
    
    if (_menuFlags.respondsToWillShowViewController)
    {
        [self.delegate menuController:self willShowViewController:self.leftViewController];
    }
    _menuFlags.showingLeftView = YES;
     [self showShadow:YES];

    UIView *view = self.leftViewController.view;
	CGRect frame = self.view.bounds;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    [self.leftViewController viewWillAppear:animated];
    
    frame = _root.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated)
    {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^
    {
        _root.view.frame = frame;
    }
    completion:^(BOOL finished)
    {
        [_tap setEnabled:YES];
    }];

    if (!animated)
    {
        [UIView setAnimationsEnabled:_enabled];
    }
}

#pragma mark Setters

- (void)setDelegate:(id<DDMenuControllerDelegate>)val
{
    delegate = val;
    _menuFlags.respondsToWillShowViewController = [(id)self.delegate respondsToSelector:@selector(menuController:willShowViewController:)];
}
- (void)setLeftViewController:(UIViewController *)leftController
{
    _left = leftController;
    _menuFlags.canShowLeft = (_left!=nil);
    [self resetNavButtons];
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    UIViewController *tempRoot = _root;
    _root = rootViewController;
    
    if (_root)
    {
        if (tempRoot)
        {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        UIView *view = _root.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
    }
    else
    {
        if (tempRoot)
        {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
    }
   [self resetNavButtons];
}

- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated
{
    if (!controller)
    {
        [self setRootViewController:controller];
        return;
    }
    if (_menuFlags.showingLeftView)
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        // slide out then come back with the new root
        __block DDMenuController *selfRef = self;
        __block UIViewController *rootRef = _root;
        CGRect frame = rootRef.view.frame;
        frame.origin.x = kMenuDisplayedWidth;
        
        [UIView animateWithDuration:.1 animations:^
        {
            rootRef.view.frame = frame;
        }
        completion:^(BOOL finished)
        {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [selfRef setRootViewController:controller];
            _root.view.frame = frame;
            [selfRef showRootController:animated];
        }];
    }
    else
    {
        // just add the root and move to it if it's not center
        [self setRootViewController:controller];
        [self showRootController:animated];
    }
}
- (void)showShadow:(BOOL)val {
    if (!_root) return;
    
    _root.view.layer.shadowOpacity = val ? 0.8f : 0.0f;
    if (val) {
        _root.view.layer.cornerRadius = 4.0f;
        _root.view.layer.shadowOffset = CGSizeZero;
        _root.view.layer.shadowRadius = 4.0f;
        _root.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
    
}

#pragma mark - Actions

- (void)showLeft:(id)sender
{
    
    [self showLeftController:YES];
}

- (void)showRight:(id)sender
{
    UINavigationController *navController = nil;
    
    if ([_root isKindOfClass:[UINavigationController class]])
    {
        navController = (UINavigationController*)_root;
    }
    else if ([_root isKindOfClass:[UITabBarController class]])
    {
        UIViewController *topController = [(UITabBarController*)_root selectedViewController];
        if ([topController isKindOfClass:[UINavigationController class]])
        {
            navController = (UINavigationController*)topController;
        }
    }
    
    if (navController == nil)
    {
        NSLog(@"root controller is not a navigation controller.");
        return;
    }
    
    [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_NEW_TASK forNavigationController:navController];
}

@end
