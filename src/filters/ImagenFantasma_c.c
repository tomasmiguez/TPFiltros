#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2.h"
#include "../helper/utils.h"

void ImagenFantasma_c(
    uint8_t *src,
    uint8_t *dst,
    int width,
    int height,
    int src_row_size,
    int dst_row_size,
    int offsetx,
    int offsety)
{
    bgra_t (*src_matrix)[(src_row_size+3)/4] = (bgra_t (*)[(src_row_size+3)/4]) src;
    bgra_t (*dst_matrix)[(dst_row_size+3)/4] = (bgra_t (*)[(dst_row_size+3)/4]) dst;

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {

            float rr = (float)src_matrix[i][j].r;
            float gg = (float)src_matrix[i][j].g;
            float bb = (float)src_matrix[i][j].b;

            int ii = i/2 + offsety;
            int jj = j/2 + offsetx;

            float rrr = (float)src_matrix[ii][jj].r;
            float ggg = (float)src_matrix[ii][jj].g;
            float bbb = (float)src_matrix[ii][jj].b;

            float b = (rrr + 2 * ggg + bbb)/4;

            dst_matrix[i][j].r = SAT( rr * 0.9 + b/2 );
            dst_matrix[i][j].g = SAT( gg * 0.9 + b/2 );
            dst_matrix[i][j].b = SAT( bb * 0.9 + b/2 );
        }
    }
}

/*
void ImagenFantasma_c(
    uint8_t *src,
    uint8_t *dst,
    int width,
    int height,
    int src_row_size,
    int dst_row_size,
    int offsetx,
    int offsety)
{
    bgra_t (*src_matrix)[(src_row_size+3)/4] = (bgra_t (*)[(src_row_size+3)/4]) src;
    bgra_t (*dst_matrix)[(dst_row_size+3)/4] = (bgra_t (*)[(dst_row_size+3)/4]) dst;

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            
            bgra_t pixelActual = src_matrix[i][j];

            float rr = (float)pixelActual.r;
            float gg = (float)pixelActual.g;
            float bb = (float)pixelActual.b;

            int ii = i/2 + offsety;
            int jj = j/2 + offsetx;

            bgra_t pixelOff = src_matrix[ii][jj];

            float rrr = (float)pixelOff.r;
            float ggg = (float)pixelOff.g;
            float bbb = (float)pixelOff.b;

            float b = (rrr + 2 * ggg + bbb)/4;

            bgra_t* dstPixel = &(dst_matrix[i][j]);

            dstPixel->r = SAT( rr * 0.9 + b/2 );
            dstPixel->g = SAT( gg * 0.9 + b/2 );
            dstPixel->b = SAT( bb * 0.9 + b/2 );   
        }
    }
}
*/
/*
void ImagenFantasma_c(
    uint8_t *src,
    uint8_t *dst,
    int width,
    int height,
    int src_row_size,
    int dst_row_size,
    int offsetx,
    int offsety)
{
    bgra_t (*src_matrix)[(src_row_size+3)/4] = (bgra_t (*)[(src_row_size+3)/4]) src;
    bgra_t (*dst_matrix)[(dst_row_size+3)/4] = (bgra_t (*)[(dst_row_size+3)/4]) dst;

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {

            float rr = (float)src_matrix[i][j].r;
            float gg = (float)src_matrix[i][j].g;
            float bb = (float)src_matrix[i][j].b;

            int ii = i/2 + offsety;
            int jj = j/2 + offsetx;

            float rrr = (float)src_matrix[ii][jj].r;
            float ggg = (float)src_matrix[ii][jj].g;
            float bbb = (float)src_matrix[ii][jj].b;

            float b = (rrr + 2 * ggg + bbb)/4;

            if(rr* 0.9 + b/2 > 255) {
                dst_matrix[i][j].r = 255;
            } else {
                if(rr* 0.9 + b/2 < 0 ) {
                    dst_matrix[i][j].r = 0;
                } else {
                    dst_matrix[i][j].r = rr* 0.9 + b/2;
                }
            }

            if(gg* 0.9 + b/2 > 255) {
                dst_matrix[i][j].g = 255;
            } else {
                if(gg* 0.9 + b/2 < 0 ) {
                    dst_matrix[i][j].g = 0;
                } else {
                    dst_matrix[i][j].g = gg* 0.9 + b/2;
                }
            }

            if(bb* 0.9 + b/2 > 255) {
                dst_matrix[i][j].b = 255;
            } else {
                if(bb* 0.9 + b/2 < 0 ) {
                    dst_matrix[i][j].b = 0;
                } else {
                    dst_matrix[i][j].b = bb* 0.9 + b/2;
                }
            }
        }
    }
}
*/