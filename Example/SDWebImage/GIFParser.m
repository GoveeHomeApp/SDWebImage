//
//  GIFParser.m
//  SDWebImage_Example
//
//  Created by sy on 2024/10/17.
//  Copyright © 2024 songyang. All rights reserved.
//

#import "GIFParser.h"

@implementation GIFParser

- (void)parseGIFFileAtPath:(NSString *)filePath {
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

    // Check GIF signature
    if (length < 6 || memcmp(bytes, "GIF89a", 6) != 0 && memcmp(bytes, "GIF87a", 6) != 0) {
        NSLog(@"Not a valid GIF file");
        return;
    }

    // Parse Logical Screen Descriptor
    uint16_t screenWidth = (bytes[6] << 8) | bytes[7];
    uint16_t screenHeight = (bytes[8] << 8) | bytes[9];
    uint8_t packedField = bytes[10];
    uint8_t backgroundColorIndex = bytes[11];
    uint8_t pixelAspectRatio = bytes[12];

    BOOL hasGlobalColorTable = (packedField & 0x80) != 0;
    int globalColorTableSize = pow(2, ((packedField & 0x07) + 1));

    NSLog(@"Screen Width: %u", screenWidth);
    NSLog(@"Screen Height: %u", screenHeight);
    NSLog(@"Has Global Color Table: %d", hasGlobalColorTable);
    NSLog(@"Background Color Index: %u", backgroundColorIndex);
    NSLog(@"Pixel Aspect Ratio: %u", pixelAspectRatio);

    // Parse Global Color Table if exists
    if (hasGlobalColorTable) {
        for (int i = 0; i < globalColorTableSize; i++) {
            uint8_t r = bytes[13 + i * 3];
            uint8_t g = bytes[14 + i * 3];
            uint8_t b = bytes[15 + i * 3];
            NSLog(@"Color %d: RGB(%u, %u, %u)", i, r, g, b);
        }
    }

    // Parse Image Descriptors and Image Data
    int offset = hasGlobalColorTable ? 13 + globalColorTableSize * 3 : 13;
    while (offset < length) {
        uint8_t blockType = bytes[offset];
        if (blockType == 0x2C) { // Image Descriptor
            uint16_t leftPosition = (bytes[offset + 1] << 8) | bytes[offset + 2];
            uint16_t topPosition = (bytes[offset + 3] << 8) | bytes[offset + 4];
            uint16_t imageWidth = (bytes[offset + 5] << 8) | bytes[offset + 6];
            uint16_t imageHeight = (bytes[offset + 7] << 8) | bytes[offset + 8];
            uint8_t imagePackedField = bytes[offset + 9];

            BOOL hasLocalColorTable = (imagePackedField & 0x80) != 0;
            int localColorTableSize = pow(2, ((imagePackedField & 0x07) + 1));

            NSLog(@"Image Left Position: %u", leftPosition);
            NSLog(@"Image Top Position: %u", topPosition);
            NSLog(@"Image Width: %u", imageWidth);
            NSLog(@"Image Height: %u", imageHeight);
            NSLog(@"Has Local Color Table: %d", hasLocalColorTable);

            if (hasLocalColorTable) {
                for (int i = 0; i < localColorTableSize; i++) {
                    uint8_t r = bytes[offset + 10 + i * 3];
                    uint8_t g = bytes[offset + 11 + i * 3];
                    uint8_t b = bytes[offset + 12 + i * 3];
                    NSLog(@"Local Color %d: RGB(%u, %u, %u)", i, r, g, b);
                }
                offset += 10 + localColorTableSize * 3;
            } else {
                offset += 10;
            }

            // Parse Image Data
            uint8_t lzwMinimumCodeSize = bytes[offset++];
            NSLog(@"LZW Minimum Code Size: %u", lzwMinimumCodeSize);

            while (offset < length) {
                uint8_t subBlockSize = bytes[offset++];
                if (subBlockSize == 0) {
                    break; // End of Image Data
                }
                offset += subBlockSize;
            }
        } else if (blockType == 0x21) { // Extension Block
            uint8_t extensionLabel = bytes[offset + 1];
            uint8_t subBlockSize = bytes[offset + 2];
            offset += 3 + subBlockSize;

            while (offset < length) {
                subBlockSize = bytes[offset++];
                if (subBlockSize == 0) {
                    break; // End of Extension Block
                }
                offset += subBlockSize;
            }
        } else if (blockType == 0x3B) { // Trailer
            NSLog(@"End of GIF file");
            break;
        } else {
            NSLog(@"Unknown block type: %02X", blockType);
            offset++;
        }
    }
}

@end
