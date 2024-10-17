//
//  APNGParser.m
//  SDWebImage_Example
//
//  Created by sy on 2024/10/17.
//  Copyright © 2024 songyang. All rights reserved.
//

#import "APNGParser.h"

@implementation APNGParser

- (void)parseAPNGFileAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSLog(@"File not found at path: %@", filePath);
        return;
    }

    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        NSLog(@"Failed to read file at path: %@", filePath);
        return;
    }

    const uint8_t *bytes = [data bytes];
    NSUInteger length = [data length];

    // Check PNG signature
    if (length < 8 || memcmp(bytes, "\x89PNG\x0D\x0A\x1A\x0A", 8) != 0) {
        NSLog(@"Not a valid PNG file");
        return;
    }

    // Parse chunks
    NSUInteger offset = 8;
    while (offset < length) {
        uint32_t chunkLength = (bytes[offset] << 24) | (bytes[offset + 1] << 16) | (bytes[offset + 2] << 8) | bytes[offset + 3];
        NSString *chunkType = [[NSString alloc] initWithBytes:&bytes[offset + 4] length:4 encoding:NSUTF8StringEncoding];
        uint32_t chunkDataOffset = offset + 8;
        uint32_t crcOffset = offset + 8 + chunkLength;

        if ([chunkType isEqualToString:@"IHDR"]) {
            uint32_t width = (bytes[chunkDataOffset] << 24) | (bytes[chunkDataOffset + 1] << 16) | (bytes[chunkDataOffset + 2] << 8) | bytes[chunkDataOffset + 3];
            uint32_t height = (bytes[chunkDataOffset + 4] << 24) | (bytes[chunkDataOffset + 5] << 16) | (bytes[chunkDataOffset + 6] << 8) | bytes[chunkDataOffset + 7];
            uint8_t bitDepth = bytes[chunkDataOffset + 8];
            uint8_t colorType = bytes[chunkDataOffset + 9];
            uint8_t compressionMethod = bytes[chunkDataOffset + 10];
            uint8_t filterMethod = bytes[chunkDataOffset + 11];
            uint8_t interlaceMethod = bytes[chunkDataOffset + 12];

            NSLog(@"IHDR: Width=%u, Height=%u, Bit Depth=%u, Color Type=%u, Compression Method=%u, Filter Method=%u, Interlace Method=%u",
                  width, height, bitDepth, colorType, compressionMethod, filterMethod, interlaceMethod);
        } else if ([chunkType isEqualToString:@"acTL"]) {
            uint32_t numFrames = (bytes[chunkDataOffset] << 24) | (bytes[chunkDataOffset + 1] << 16) | (bytes[chunkDataOffset + 2] << 8) | bytes[chunkDataOffset + 3];
            uint32_t numPlays = (bytes[chunkDataOffset + 4] << 24) | (bytes[chunkDataOffset + 5] << 16) | (bytes[chunkDataOffset + 6] << 8) | bytes[chunkDataOffset + 7];

            NSLog(@"acTL: Num Frames=%u, Num Plays=%u", numFrames, numPlays);
        } else if ([chunkType isEqualToString:@"fcTL"]) {
            uint32_t sequenceNumber = (bytes[chunkDataOffset] << 24) | (bytes[chunkDataOffset + 1] << 16) | (bytes[chunkDataOffset + 2] << 8) | bytes[chunkDataOffset + 3];
            uint32_t width = (bytes[chunkDataOffset + 4] << 24) | (bytes[chunkDataOffset + 5] << 16) | (bytes[chunkDataOffset + 6] << 8) | bytes[chunkDataOffset + 7];
            uint32_t height = (bytes[chunkDataOffset + 8] << 24) | (bytes[chunkDataOffset + 9] << 16) | (bytes[chunkDataOffset + 10] << 8) | bytes[chunkDataOffset + 11];
            uint32_t xPosition = (bytes[chunkDataOffset + 12] << 24) | (bytes[chunkDataOffset + 13] << 16) | (bytes[chunkDataOffset + 14] << 8) | bytes[chunkDataOffset + 15];
            uint32_t yPosition = (bytes[chunkDataOffset + 16] << 24) | (bytes[chunkDataOffset + 17] << 16) | (bytes[chunkDataOffset + 18] << 8) | bytes[chunkDataOffset + 19];
            uint16_t delayNumerator = (bytes[chunkDataOffset + 20] << 8) | bytes[chunkDataOffset + 21];
            uint16_t delayDenominator = (bytes[chunkDataOffset + 22] << 8) | bytes[chunkDataOffset + 23];
            uint8_t disposalMethod = bytes[chunkDataOffset + 24];
            uint8_t blendMethod = bytes[chunkDataOffset + 25];

            NSLog(@"fcTL: Sequence Number=%u, Width=%u, Height=%u, X Position=%u, Y Position=%u, Delay Numerator=%u, Delay Denominator=%u, Disposal Method=%u, Blend Method=%u",
                  sequenceNumber, width, height, xPosition, yPosition, delayNumerator, delayDenominator, disposalMethod, blendMethod);
        } else if ([chunkType isEqualToString:@"fdAT"]) {
            uint32_t sequenceNumber = (bytes[chunkDataOffset] << 24) | (bytes[chunkDataOffset + 1] << 16) | (bytes[chunkDataOffset + 2] << 8) | bytes[chunkDataOffset + 3];
            uint32_t frameDataLength = chunkLength - 4;

            NSLog(@"fdAT: Sequence Number=%u, Frame Data Length=%u", sequenceNumber, frameDataLength);
        } else if ([chunkType isEqualToString:@"IEND"]) {
            NSLog(@"IEND: End of file");
            break;
        } else {
            NSLog(@"Unknown chunk type: %@", chunkType);
        }

        offset = crcOffset + 4;
    }
}

@end
