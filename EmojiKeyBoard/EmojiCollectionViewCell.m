//
//  EmojiCollectionViewCell.m
//  
//
//  Created by 晓琳 on 17/2/28.
//
//

#import "EmojiCollectionViewCell.h"
#import "Masonry.h"

@implementation EmojiCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints{
    [super updateConstraints];
    [self addSubview:self.emojiLabel];
    
    [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UILabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [[UILabel alloc] init];
//        _emojiLabel.backgroundColor = [UIColor yellowColor];
        _emojiLabel.textAlignment = 1;
        _emojiLabel.font = [UIFont systemFontOfSize:20];
    }
    return _emojiLabel;
}




@end
