//
//  TCUtil.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/1/13.
/*
 Copyright 2013 Rustici Software
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "TCUtil.h"

@implementation TCUtil


+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (NSString *)CFBridgingRelease(string);
}

+ (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}

+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}

@end
