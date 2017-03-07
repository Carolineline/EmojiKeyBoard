//
//  ViewController.m
//  EmojiKeyBoard
//
//  Created by 晓琳 on 17/2/27.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import "EmojiViewController.h"
#import "InputBar.h"
#import "Masonry.h"
#import "NSString+Emoji.h"
#import "ReactiveCocoa.h"
#import "EmojiKeyBoardView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define IsTextContainFace(text) [text containsString:@"["] &&  [text containsString:@"]"] && [[text substringFromIndex:text.length - 1] isEqualToString:@"]"]


@interface EmojiViewController ()<UITextViewDelegate, InPutBarDelegate, EmojiKeyBoardViewDelegate>

@property (nonatomic, strong) InputBar *inputViewBar;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSMutableArray *tempArr;

@property (nonatomic, strong) EmojiKeyBoardView *emojiView;

@end

@implementation EmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tempArr  = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
    [self.view addSubview:tapView];
    [self setupConstraints];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tapView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if ([self.inputViewBar.inputTextView isFirstResponder]) {
        [self.inputViewBar.inputTextView resignFirstResponder];
        [self.inputViewBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
//            make.height.equalTo(@(60)).priorityLow();
        }];
    }else{
        if (self.inputViewBar.isDefaultKeyboard == NO) {
//            self.emojiView.hidden = 
            [self.inputViewBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.equalTo(self.view.mas_right);
                make.bottom.equalTo(self.view.mas_bottom);
//                make.height.equalTo(@(60)).priorityLow();
            }];
        }
    }
}

- (void)setupConstraints
{
    [self.view addSubview:self.inputViewBar];
    [self.view addSubview:self.emojiView];

    [self.inputViewBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(60)).priorityLow();
    }];
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputViewBar.mas_bottom);
        make.height.equalTo(@(200));
        make.left.right.equalTo(self.view);
    }];
}

- (void)keyBoardView:(CGRect)endR ChangeDuration:(CGFloat)durtion EmojikeyBoardType:(BOOL)type
{
    if (type == YES) {
        self.emojiView.hidden = NO;
        [UIView animateWithDuration:durtion
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                            [self.inputViewBar mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.view.mas_bottom).offset(-200);
                                 make.left.mas_equalTo(0);
                                 make.width.mas_equalTo(WIDTH);
                             }];
                         }
                         completion:^(BOOL finished) {
                             
                         }];

    }else{
        self.emojiView.hidden = YES;
        NSLog(@"ddd = %f",endR.origin.y);
        [UIView animateWithDuration:durtion
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.inputViewBar mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.mas_equalTo(-HEIGHT + endR.origin.y);
                            }];
                         }
                         completion:nil];
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
////    CGSize sizeThatFitsTextView = [self.inputViewBar.inputTextView sizeThatFits:CGSizeMake((WIDTH - 100), MAXFLOAT)];
////    
////    //    CGRect rect = self.frame;
////    //    CGRect topRect = self.topView.frame;
////    //
////    //    CGFloat topH = sizeThatFitsTextView.height + 20;
////    
////    if (sizeThatFitsTextView.height <= 40) {
////        
////    } else if ( sizeThatFitsTextView.height >= 80 ) {
////        
////        
////        [self.inputViewBar.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
////            make.height.equalTo(@80);
////        }];
////        
////    } else {
////        [self.inputViewBar.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
////            make.height.offset(sizeThatFitsTextView.height);
////        }];
////        
////    }
//    [self updateTextViewHeight];
//    return YES;
//}

- (void) updateTextViewHeight
{
    CGSize sizeThatFitsTextView = [self.inputViewBar.inputTextView sizeThatFits:CGSizeMake((WIDTH - 100), MAXFLOAT)];
    
    if (sizeThatFitsTextView.height <= 40) {
        [self.inputViewBar.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
        }];
        
    } else if ( sizeThatFitsTextView.height >= 75 ) {
        
        
        [self.inputViewBar.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@75);
        }];
        
    } else {
        [self.inputViewBar.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(sizeThatFitsTextView.height);
        }];
        
    }

}
#pragma mark -- EmojiKeyBoardViewDelegate
- (void)showEmoji:(NSString *)emojiStr
{
    if (emojiStr && ![emojiStr isEqualToString:@""]) {
        [self.tempArr addObject:emojiStr];
    }
    self.content = self.inputViewBar.inputTextView.text;
    self.inputViewBar.inputTextView.text = [NSString stringWithFormat:@"%@%@",self.content, emojiStr];
    [self updateTextViewHeight];
}



- (void)emojiViewDelete
{
    NSRange range = self.inputViewBar.inputTextView.selectedRange;
    NSString *handleText;
    NSString *appendText;
    if (range.location == self.inputViewBar.inputTextView.text.length) {
        handleText = self.inputViewBar.inputTextView.text;
        appendText = @"";
    }else {
        handleText = [self.inputViewBar.inputTextView.text substringToIndex:range.location];
        appendText = [self.inputViewBar.inputTextView.text substringFromIndex:range.location];
    }
    
    if (handleText.length > 0) {
        
        [self deleteBackward:handleText appendText:appendText];
        [self updateTextViewHeight];
    }

}

- (void)deleteBackward:(NSString *)text appendText:(NSString *)appendText
{
    if (IsTextContainFace(text)) { // 如果最后一个是表情
        
        NSRange startRang = [text rangeOfString:@"[" options:NSBackwardsSearch];
        NSString *current = [text substringToIndex:startRang.location];
        self.inputViewBar.inputTextView.text = [current stringByAppendingString:appendText];
        self.inputViewBar.inputTextView.selectedRange = NSMakeRange(current.length, 0);
        
    }else { // 如果最后一个系统键盘输入的文字
        
        if (text.length >= 2) {
            
            NSString *tempString = [text substringWithRange:NSMakeRange(text.length - 2, 2)];
            
            if ([tempString isEmoji]) { // 如果是Emoji表情
                NSString *current = [text substringToIndex:text.length - 2];
                self.inputViewBar.inputTextView.text = [current stringByAppendingString:appendText];
                self.inputViewBar.inputTextView.selectedRange = NSMakeRange(current.length, 0);

                
            }else { // 如果是纯文字
                NSString *current = [text substringToIndex:text.length - 1];
                self.inputViewBar.inputTextView.text = [current stringByAppendingString:appendText];
                self.inputViewBar.inputTextView.selectedRange = NSMakeRange(current.length, 0);
            }
            
        }else { // 如果是纯文字
            
            NSString *current = [text substringToIndex:text.length - 1];
            self.inputViewBar.inputTextView.text = [current stringByAppendingString:appendText];
            self.inputViewBar.inputTextView.selectedRange = NSMakeRange(current.length, 0);
        }
    }
}

#pragma mark -- getter

- (InputBar *)inputViewBar
{
    if (!_inputViewBar) {
        _inputViewBar = [[InputBar alloc] init];
        _inputViewBar.delegate = self;
        _inputViewBar.userInteractionEnabled = YES;
        [_inputViewBar setFitWhenKeyboardShowOrHide:YES];
    }
    return _inputViewBar;
}

- (EmojiKeyBoardView *)emojiView
{
    if (!_emojiView) {
        _emojiView = [[EmojiKeyBoardView alloc] init];
        _emojiView.emojiDelegate = self;
    }
    return _emojiView;
}




@end
