//
//  DDMenuController.h
//  DDMenuController

#import <UIKit/UIKit.h>

@protocol DDMenuControllerDelegate;
@interface DDMenuController : UIViewController <UIGestureRecognizerDelegate>{
    
    id _tap;

    struct {
        unsigned int respondsToWillShowViewController:1;
        unsigned int showingLeftView:1;
        unsigned int canShowLeft:1;
    } _menuFlags;
}

- (id)initWithRootViewController:(UIViewController*)controller;

@property(nonatomic,assign) id <DDMenuControllerDelegate> delegate;

@property(nonatomic,strong) UIViewController *leftViewController;
@property(nonatomic,strong) UIViewController *rootViewController;
@property(nonatomic,strong) NSString * rightViewController;

@property(nonatomic,readonly) UITapGestureRecognizer *tap;
@property(nonatomic,assign) Class barButtonItemClass; 

- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated; // used to push a new controller on the stack
- (void)showRootController:(BOOL)animated; // reset to "home" view controlle´r
- (void)showLeftController:(BOOL)animated;  // show left

@end

@protocol DDMenuControllerDelegate 
- (void)menuController:(DDMenuController*)controller willShowViewController:(UIViewController*)controller;
@end