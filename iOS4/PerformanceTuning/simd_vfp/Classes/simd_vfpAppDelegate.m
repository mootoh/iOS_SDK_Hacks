//
//  simd_vfpAppDelegate.m
//  simd_vfp
//
//  Created by Motohiro Takayama on 8/5/10.
//  Copyright Personal 2010. All rights reserved.
//

#import "simd_vfpAppDelegate.h"
#import "simd_vfpViewController.h"

@implementation simd_vfpAppDelegate

@synthesize window;
@synthesize viewController;

void load_store(float * src, float * dst)
{
   __asm__ volatile (
                     "fldmias %0!, {s8-s11} \n\t" // operations
                     "fstmias %1!, {s8-s11} \n\t"
                     : "=r" (src), "=r" (dst)     // output operands
                     : "0" (src), "1" (dst)       // input operands
                     : "memory" // clobbers
                     );   
}

/*
 * dot product of 4 vectors
 *
 * d1 = p11 * q11 + p12 * q12 + p13 * q13 + p14 * q14
 * d2 = p21 * q21 + p22 * q22 + p23 * q23 + p24 * q24
 * d3 = p31 * q31 + p32 * q32 + p33 * q33 + p34 * q34
 * d4 = p41 * q41 + p42 * q42 + p43 * q43 + p44 * q44
 *
 * 1st:
 *   (p11*q11, p12*q12, p13*q13, p14*q14) : 16,17,18,19
 *   (p21*q21, p22*q22, p23*q23, p24*q24) : 20,21,22,23
 *   (p31*q31, p32*q32, p33*q33, p34*q34) : 24,25,26,27
 *   (p41*q41, p42*q42, p43*q43, p44*q44) : 28,29,30,31
 *
 * transpose:
 *   (p11*q11, p21*q21, p31*q31, p41*q41)
 *   (p12*q12, p22*q22, p32*q32, p42*q42)
 *   (p13*q13, p23*q23, p33*q33, p43*q43)
 *   (p14*q14, p24*q24, p34*q34, p44*q44)
 *
 * then sum them.
 */
void dot_product4_vfp(float *dst, const float *ps, const float *qs)
{
   __asm__ volatile (
                     /*
                      * initialize: use 4 floats
                      */
                     "fmrx r0, fpscr \n\t"
                     "bic r0, r0, #0x00370000 \n\t"
                     "orr r0, r0, #0x00030000 \n\t" // the 3 in here is the width
                     "fmxr fpscr, r0 \n\t"
                     
                     /*
                      * 1st phase:
                      *
                      * result should be:
                      *   0.09 0.16 0.21 0.24
                      *   0.02 0.27 0.32 0.35
                      *   0.06 0.04 0.45 0.56
                      *   0.12 0.10 0.06 0.72
                      */
                     "fldmias %1!, {s8-s11} \n\t"  // p1
                     "fldmias %2!, {s12-s15} \n\t" // q1
                     "fmuls s16, s8, s12 \n\t"     // p1*q1
                     
                     "fldmias %1!, {s8-s11} \n\t"  // p2
                     "fldmias %2!, {s12-s15} \n\t" // q2
                     "fmuls s20, s8, s12 \n\t"     // p2*q2
                     
                     "fldmias %1!, {s8-s11} \n\t"  // p3
                     "fldmias %2!, {s12-s15} \n\t" // q3
                     "fmuls s24, s8, s12 \n\t"     // p3*q3
                     
                     "fldmias %1!, {s8-s11} \n\t"  // p4
                     "fldmias %2!, {s12-s15} \n\t" // q4
                     "fmuls s28, s8, s12 \n\t"     // p4*q4
                     
                     /*
                      * 2nd phase: shuffle to transpose.
                      *
                      * result should be:
                      *   0.09 0.02 0.06 0.12
                      *   0.16 0.27 0.04 0.10
                      *   0.21 0.32 0.45 0.06
                      *   0.24 0.35 0.56 0.72
                      */
                     "fmrs r0,  s17 \n\t"
                     "fmrs r1,  s20 \n\t"
                     "fmsr s17, r1  \n\t"
                     "fmsr s20, r0  \n\t"
                     
                     "fmrs r0,  s18 \n\t"
                     "fmrs r1,  s24 \n\t"
                     "fmsr s18, r1  \n\t"
                     "fmsr s24, r0  \n\t"
                     
                     "fmrs r0,  s19 \n\t"
                     "fmrs r1,  s28 \n\t"
                     "fmsr s19, r1  \n\t"
                     "fmsr s28, r0  \n\t"
                     
                     "fmrs r0,  s22 \n\t"
                     "fmrs r1,  s25 \n\t"
                     "fmsr s22, r1  \n\t"
                     "fmsr s25, r0  \n\t"
                     
                     "fmrs r0,  s23 \n\t"
                     "fmrs r1,  s29 \n\t"
                     "fmsr s23, r1  \n\t"
                     "fmsr s29, r0  \n\t"
                     
                     "fmrs r0,  s27 \n\t"
                     "fmrs r1,  s30 \n\t"
                     "fmsr s27, r1  \n\t"
                     "fmsr s30, r0  \n\t"
                     
                     /*
                      * 3rd phase: add them.
                      */
                     "fadds s8,   s16, s20 \n\t"
                     "fadds s12,  s24, s28 \n\t"
                     "fadds s16,   s8, s12 \n\t"
                     
                     "fstmias %0!, {s16-s19} \n\t" // store the results
                     
                     // closing: use 0 floats
                     "fmrx r0, fpscr \n\t"
                     "bic r0, r0, #0x00370000 \n\t"
                     "fmxr fpscr, r0 \n\t"
                     
                     : "+r" (dst)                       // output operands
                     : "r" (ps), "r" (qs)    // input  operands
                     : "memory", "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "s12", "s13", "s14", "s15", "s16", "s17", "s18", "s19", "s20", "s21", "s22", "s23", "s24", "s25", "s26", "s27", "s28", "s29", "s30", "s31" // clobbers
                     );
}

void dot_product4_vfp_simple(float *dst, const float *ps, const float *qs)
{
   __asm__ volatile (
                     /*
                      * initialize: use 4 floats
                      */
                     "fmrx r0, fpscr \n\t"
                     "bic r0, r0, #0x00370000 \n\t"
                     "orr r0, r0, #0x00030000 \n\t" // the 3 in here is the width
                     "fmxr fpscr, r0 \n\t"
                     
                     /*
                      * 1st phase:
                      *
                      * result should be:
                      *   0.09 0.16 0.21 0.24
                      *   0.02 0.27 0.32 0.35
                      *   0.06 0.04 0.45 0.56
                      *   0.12 0.10 0.06 0.72
                      */
                     "fldmias %1!, {s8-s11} \n\t"  // p1
                     "fldmias %2!, {s12-s15} \n\t" // q1
                     "fmuls s16, s8, s12 \n\t"     // p1*q1
                     
                     "fldmias %1!, {s8-s11} \n\t"  // p2
                     "fldmias %2!, {s12-s15} \n\t" // q2
                     "fmuls s20, s8, s12 \n\t"     // p2*q2
                     
                     "fldmias %1!, {s8-s11} \n\t"  // p3
                     "fldmias %2!, {s12-s15} \n\t" // q3
                     "fmuls s24, s8, s12 \n\t"     // p3*q3
                     
                     "fldmias %1!, {s8-s11} \n\t"  // p4
                     "fldmias %2!, {s12-s15} \n\t" // q4
                     "fmuls s28, s8, s12 \n\t"     // p4*q4
                     
                     /*
                      * preparation for 2nd phase:
                      *   closing: use 0 floats
                      */
                     "fmrx r0, fpscr \n\t"
                     "bic r0, r0, #0x00370000 \n\t"
                     "fmxr fpscr, r0 \n\t"
                     
                     /*
                      * 2nd phase:
                      *   add horizontally.
                      */
                     "fadds s16, s16, s17 \n\t"
                     "fadds s17, s18, s19 \n\t"
                     "fadds s8, s16, s17 \n\t"
                     
                     "fadds s20, s20, s21 \n\t"
                     "fadds s21, s22, s23 \n\t"
                     "fadds s9, s20, s21 \n\t"
                     
                     "fadds s24, s24, s25 \n\t"
                     "fadds s25, s26, s27 \n\t"
                     "fadds s10, s24, s25 \n\t"
                     
                     "fadds s28, s28, s29 \n\t"
                     "fadds s29, s30, s31 \n\t"
                     "fadds s11, s28, s29 \n\t"
                     
                     "fstmias %0!, {s8-s11} \n\t" // store the results
                     
                     // closing: use 0 floats
                     "fmrx r0, fpscr \n\t"
                     "bic r0, r0, #0x00370000 \n\t"
                     "fmxr fpscr, r0 \n\t"
                     
                     : "+r" (dst)                       // output operands
                     : "r" (ps), "r" (qs)    // input  operands
                     : "memory", "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "s12", "s13", "s14", "s15", "s16", "s17", "s18", "s19", "s20", "s21", "s22", "s23", "s24", "s25", "s26", "s27", "s28", "s29", "s30", "s31" // clobbers
                     );
}

void dot_product4_vfp_another(float *dst, const float *pt, const float *qt)
{
   __asm__ volatile (
                     /*
                      * initialize: use 4 floats
                      */
                     "fmrx r0, fpscr \n\t"
                     "bic r0, r0, #0x00370000 \n\t"
                     "orr r0, r0, #0x00030000 \n\t" // the 3 in here is the width
                     "fmxr fpscr, r0 \n\t"
                     
                     /*
                      * 1st phase:
                      *
                      * result should be:
                      *   0.09 0.16 0.21 0.24
                      *   0.02 0.27 0.32 0.35
                      *   0.06 0.04 0.45 0.56
                      *   0.12 0.10 0.06 0.72
                      */
                     "fldmias %1!, {s8-s11} \n\t"  // px
                     "fldmias %2!, {s12-s15} \n\t" // qx
                     "fmuls s16, s8, s12 \n\t"     // px*qx
                     
                     "fldmias %1!, {s8-s11} \n\t"  // py
                     "fldmias %2!, {s12-s15} \n\t" // qy
                     "fmacs s16, s8, s12 \n\t"     // px*qx + py*qy
                     
                     "fldmias %1!, {s8-s11} \n\t"  // pz
                     "fldmias %2!, {s12-s15} \n\t" // qz
                     "fmacs s16, s8, s12 \n\t"     // px*qx + py*qy + pz*qz
                     
                     "fldmias %1!, {s8-s11} \n\t"  // pz
                     "fldmias %2!, {s12-s15} \n\t" // qz
                     "fmacs s16, s8, s12 \n\t"     // px*qx + py*qy + pz*qz + pw*qw
                     
                     "fstmias %0, {s16-s19} \n\t" // store the results
                     
                     // closing: use 0 floats
                     "fmrx r0, fpscr \n\t"
                     "bic r0, r0, #0x00370000 \n\t"
                     "fmxr fpscr, r0 \n\t"
                     
                     : "+r" (dst)                       // output operands
                     : "r" (pt), "r" (qt) // input  operands
                     : "memory", "r0", "s8", "s9", "s10", "s11", "s12", "s13", "s14", "s15", "s16", "s17", "s18", "s19" // clobbers
                     );
}

void dot_product4(float *dst, const float *ps, const float *qs)
{
   dst[0] = ps[0] * qs[0] + ps[1] * qs[1] + ps[2] * qs[2] + ps[3] * qs[3];
   dst[1] = ps[4] * qs[4] + ps[5] * qs[5] + ps[6] * qs[6] + ps[7] * qs[7];
   dst[2] = ps[8] * qs[8] + ps[9] * qs[9] + ps[10] * qs[10] + ps[11] * qs[11];
   dst[3] = ps[12] * qs[12] + ps[13] * qs[13] + ps[14] * qs[14] + ps[15] * qs[15];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
   [window addSubview:viewController.view];
   [window makeKeyAndVisible];
   
   float ps[] = {
      0.1f, 0.2f, 0.3f, 0.4f,
      0.2f, 0.3f, 0.4f, 0.5f,
      0.3f, 0.4f, 0.5f, 0.7f,
      0.4f, 0.5f, 0.6f, 0.8f
   };
   
   float qs[] = {
      0.9f, 0.8f, 0.7f, 0.6f,
      0.1f, 0.9f, 0.8f, 0.7f,
      0.2f, 0.1f, 0.9f, 0.8f,
      0.3f, 0.2f, 0.1f, 0.9f
   };
   
   float pt[] = {
      ps[0], ps[4], ps[8], ps[12],
      ps[1], ps[5], ps[9], ps[13],
      ps[2], ps[6], ps[10], ps[14],
      ps[3], ps[7], ps[11], ps[15]
   };
   
   float qt[] = {
      qs[0], qs[4], qs[8], qs[12],
      qs[1], qs[5], qs[9], qs[13],
      qs[2], qs[6], qs[10], qs[14],
      qs[3], qs[7], qs[11], qs[15]
   };
   
   
   float dst1[4] = {0.0f, 0.0f, 0.0f, 0.0f};
   float dst2[4] = {0.0f, 0.0f, 0.0f, 0.0f};
   float dst3[4] = {0.0f, 0.0f, 0.0f, 0.0f};
   float dst4[4] = {0.0f, 0.0f, 0.0f, 0.0f};
   
   NSDate *date1 = [NSDate new];
   
   for (int i=0; i<100; i++)
      dot_product4_vfp(dst1, ps, qs);
   
   NSDate *date2 = [NSDate new];
   
   for (int i=0; i<100; i++)
      dot_product4_vfp_simple(dst2, ps, qs);
   
   NSDate *date3 = [NSDate new];
   
   for (int i=0; i<100; i++)
      dot_product4_vfp_another(dst3, pt, qt);
   
   NSDate *date4 = [NSDate new];
   
   for (int i=0; i<100; i++)
      dot_product4(dst4, ps, qs);
   
   NSDate *date5 = [NSDate new];
   
   // should be (0.7, 0.96, 1.11, 1.00)
   NSLog(@"%f elapsed: %f %f %f %f", [date2 timeIntervalSinceDate:date1], dst1[0], dst1[1], dst1[2], dst1[3]);
   NSLog(@"%f elapsed: %f %f %f %f", [date3 timeIntervalSinceDate:date2], dst2[0], dst2[1], dst2[2], dst2[3]);
   NSLog(@"%f elapsed: %f %f %f %f", [date4 timeIntervalSinceDate:date3], dst3[0], dst3[1], dst3[2], dst3[3]);
   NSLog(@"%f elapsed: %f %f %f %f", [date5 timeIntervalSinceDate:date4], dst4[0], dst4[1], dst4[2], dst4[3]);
   
   return YES;
}

#pragma mark -

- (void)dealloc
{
   [viewController release];
   [window release];
   [super dealloc];
}

@end