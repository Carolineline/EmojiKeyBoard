//
//  NSString+Emoji.m
//  EmojiKeyBoard
//
//  Created by 晓琳 on 17/2/28.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import "NSString+Emoji.h"

@implementation NSString (Emoji)

+ (NSDictionary *)getAllEmoji
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EmojiPList" ofType:@"plist"];
    NSDictionary *fileDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return fileDic;
}

+ (NSString *)showChatWithEmojiContent:(NSString *)content
{
    NSData *respData = [content dataUsingEncoding:NSUnicodeStringEncoding];
    NSString *result=[[NSString alloc]initWithData:respData encoding:NSUnicodeStringEncoding];
    if ([NSString stringContainsEmoji:result]) {
        NSLog(@"11111111");
    }
    return content;
}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)  \u1F601-\u1F64F
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (BOOL)isEmoji{
    const unichar high = [self characterAtIndex:0];
    
    // Surrogate pair (U+1D000-1F77F)
    if (0xd800 <= high && high <= 0xdbff && self.length >= 2) {
        const unichar low = [self characterAtIndex:1];
        const int codepoint = ((high - 0xd800) * 0x400) + (low - 0xdc00) + 0x10000;
        NSLog(@"%d",codepoint);
        BOOL res = (0x1d000 <= codepoint && codepoint <= 0x1f77f);
        return res;
        
        // Not surrogate pair (U+2100-27BF)
    } else {
        BOOL res = (0x2100 <= high && high <= 0x27bf);
        return res;
    }
}


+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end
