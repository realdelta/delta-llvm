; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2

;
; Variable Shifts
;

define <4 x i64> @var_shift_v4i64(<4 x i64> %a, <4 x i64> %b) {
; AVX1-LABEL: var_shift_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpsrlq %xmm2, %xmm3, %xmm4
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpsrlq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm4[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpsrlq %xmm1, %xmm0, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,3,0,1]
; AVX1-NEXT:    vpsrlq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm3[0,1,2,3],xmm0[4,5,6,7]
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: var_shift_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrlvq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <4 x i64> %a, %b
  ret <4 x i64> %shift
}

define <8 x i32> @var_shift_v8i32(<8 x i32> %a, <8 x i32> %b) {
; AVX1-LABEL: var_shift_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpextrd $1, %xmm2, %eax
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vpextrd $1, %xmm3, %ecx
; AVX1-NEXT:    shrl %cl, %eax
; AVX1-NEXT:    vmovd %xmm2, %edx
; AVX1-NEXT:    vmovd %xmm3, %ecx
; AVX1-NEXT:    shrl %cl, %edx
; AVX1-NEXT:    vmovd %edx, %xmm4
; AVX1-NEXT:    vpinsrd $1, %eax, %xmm4, %xmm4
; AVX1-NEXT:    vpextrd $2, %xmm2, %eax
; AVX1-NEXT:    vpextrd $2, %xmm3, %ecx
; AVX1-NEXT:    shrl %cl, %eax
; AVX1-NEXT:    vpinsrd $2, %eax, %xmm4, %xmm4
; AVX1-NEXT:    vpextrd $3, %xmm2, %eax
; AVX1-NEXT:    vpextrd $3, %xmm3, %ecx
; AVX1-NEXT:    shrl %cl, %eax
; AVX1-NEXT:    vpinsrd $3, %eax, %xmm4, %xmm2
; AVX1-NEXT:    vpextrd $1, %xmm0, %eax
; AVX1-NEXT:    vpextrd $1, %xmm1, %ecx
; AVX1-NEXT:    shrl %cl, %eax
; AVX1-NEXT:    vmovd %xmm0, %edx
; AVX1-NEXT:    vmovd %xmm1, %ecx
; AVX1-NEXT:    shrl %cl, %edx
; AVX1-NEXT:    vmovd %edx, %xmm3
; AVX1-NEXT:    vpinsrd $1, %eax, %xmm3, %xmm3
; AVX1-NEXT:    vpextrd $2, %xmm0, %eax
; AVX1-NEXT:    vpextrd $2, %xmm1, %ecx
; AVX1-NEXT:    shrl %cl, %eax
; AVX1-NEXT:    vpinsrd $2, %eax, %xmm3, %xmm3
; AVX1-NEXT:    vpextrd $3, %xmm0, %eax
; AVX1-NEXT:    vpextrd $3, %xmm1, %ecx
; AVX1-NEXT:    shrl %cl, %eax
; AVX1-NEXT:    vpinsrd $3, %eax, %xmm3, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: var_shift_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrlvd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <8 x i32> %a, %b
  ret <8 x i32> %shift
}

define <16 x i16> @var_shift_v16i16(<16 x i16> %a, <16 x i16> %b) {
; AVX1-LABEL: var_shift_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vpsllw $12, %xmm2, %xmm3
; AVX1-NEXT:    vpsllw $4, %xmm2, %xmm2
; AVX1-NEXT:    vpor %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpaddw %xmm2, %xmm2, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm4
; AVX1-NEXT:    vpsrlw $8, %xmm4, %xmm5
; AVX1-NEXT:    vpblendvb %xmm2, %xmm5, %xmm4, %xmm2
; AVX1-NEXT:    vpsrlw $4, %xmm2, %xmm4
; AVX1-NEXT:    vpblendvb %xmm3, %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $2, %xmm2, %xmm4
; AVX1-NEXT:    vpaddw %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpblendvb %xmm3, %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $1, %xmm2, %xmm4
; AVX1-NEXT:    vpaddw %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpblendvb %xmm3, %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpsllw $12, %xmm1, %xmm3
; AVX1-NEXT:    vpsllw $4, %xmm1, %xmm1
; AVX1-NEXT:    vpor %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpaddw %xmm1, %xmm1, %xmm3
; AVX1-NEXT:    vpsrlw $8, %xmm0, %xmm4
; AVX1-NEXT:    vpblendvb %xmm1, %xmm4, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm1
; AVX1-NEXT:    vpblendvb %xmm3, %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm1
; AVX1-NEXT:    vpaddw %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpblendvb %xmm3, %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $1, %xmm0, %xmm1
; AVX1-NEXT:    vpaddw %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpblendvb %xmm3, %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: var_shift_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpxor %ymm2, %ymm2, %ymm2
; AVX2-NEXT:    vpunpckhwd {{.*#+}} ymm3 = ymm1[4],ymm2[4],ymm1[5],ymm2[5],ymm1[6],ymm2[6],ymm1[7],ymm2[7],ymm1[12],ymm2[12],ymm1[13],ymm2[13],ymm1[14],ymm2[14],ymm1[15],ymm2[15]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} ymm4 = ymm0[4,4,5,5,6,6,7,7,12,12,13,13,14,14,15,15]
; AVX2-NEXT:    vpsrlvd %ymm3, %ymm4, %ymm3
; AVX2-NEXT:    vpsrld $16, %ymm3, %ymm3
; AVX2-NEXT:    vpunpcklwd {{.*#+}} ymm1 = ymm1[0],ymm2[0],ymm1[1],ymm2[1],ymm1[2],ymm2[2],ymm1[3],ymm2[3],ymm1[8],ymm2[8],ymm1[9],ymm2[9],ymm1[10],ymm2[10],ymm1[11],ymm2[11]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm0[0,0,1,1,2,2,3,3,8,8,9,9,10,10,11,11]
; AVX2-NEXT:    vpsrlvd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrld $16, %ymm0, %ymm0
; AVX2-NEXT:    vpackusdw %ymm3, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <16 x i16> %a, %b
  ret <16 x i16> %shift
}

define <32 x i8> @var_shift_v32i8(<32 x i8> %a, <32 x i8> %b) {
; AVX1-LABEL: var_shift_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpsrlw $4, %xmm2, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX1-NEXT:    vpand %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm5
; AVX1-NEXT:    vpsllw $5, %xmm5, %xmm5
; AVX1-NEXT:    vpblendvb %xmm5, %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $2, %xmm2, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm6 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; AVX1-NEXT:    vpand %xmm6, %xmm3, %xmm3
; AVX1-NEXT:    vpaddb %xmm5, %xmm5, %xmm5
; AVX1-NEXT:    vpblendvb %xmm5, %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $1, %xmm2, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm7 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; AVX1-NEXT:    vpand %xmm7, %xmm3, %xmm3
; AVX1-NEXT:    vpaddb %xmm5, %xmm5, %xmm5
; AVX1-NEXT:    vpblendvb %xmm5, %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm3
; AVX1-NEXT:    vpand %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpsllw $5, %xmm1, %xmm1
; AVX1-NEXT:    vpblendvb %xmm1, %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm3
; AVX1-NEXT:    vpand %xmm6, %xmm3, %xmm3
; AVX1-NEXT:    vpaddb %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpblendvb %xmm1, %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $1, %xmm0, %xmm3
; AVX1-NEXT:    vpand %xmm7, %xmm3, %xmm3
; AVX1-NEXT:    vpaddb %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpblendvb %xmm1, %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: var_shift_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsllw    $5, %ymm1, %ymm1
; AVX2-NEXT:    vpsrlw    $4, %ymm0, %ymm2
; AVX2-NEXT:    vpand     {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw    $2, %ymm0, %ymm2
; AVX2-NEXT:    vpand     {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpaddb    %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw    $1, %ymm0, %ymm2
; AVX2-NEXT:    vpand     {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpaddb    %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <32 x i8> %a, %b
  ret <32 x i8> %shift
}

;
; Uniform Variable Shifts
;

define <4 x i64> @splatvar_shift_v4i64(<4 x i64> %a, <4 x i64> %b) {
; AVX1-LABEL: splatvar_shift_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpsrlq %xmm1, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatvar_shift_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrlq %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %splat = shufflevector <4 x i64> %b, <4 x i64> undef, <4 x i32> zeroinitializer
  %shift = lshr <4 x i64> %a, %splat
  ret <4 x i64> %shift
}

define <8 x i32> @splatvar_shift_v8i32(<8 x i32> %a, <8 x i32> %b) {
; AVX1-LABEL: splatvar_shift_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3,4,5,6,7]
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpsrld %xmm1, %xmm2, %xmm2
; AVX1-NEXT:    vpsrld %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatvar_shift_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3,4,5,6,7]
; AVX2-NEXT:    vpsrld %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %splat = shufflevector <8 x i32> %b, <8 x i32> undef, <8 x i32> zeroinitializer
  %shift = lshr <8 x i32> %a, %splat
  ret <8 x i32> %shift
}

define <16 x i16> @splatvar_shift_v16i16(<16 x i16> %a, <16 x i16> %b) {
; AVX1-LABEL: splatvar_shift_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vmovd %xmm1, %eax
; AVX1-NEXT:    movzwl %ax, %eax
; AVX1-NEXT:    vmovd %eax, %xmm1
; AVX1-NEXT:    vpsrlw %xmm1, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatvar_shift_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovd %xmm1, %eax
; AVX2-NEXT:    movzwl %ax, %eax
; AVX2-NEXT:    vmovd %eax, %xmm1
; AVX2-NEXT:    vpsrlw %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %splat = shufflevector <16 x i16> %b, <16 x i16> undef, <16 x i32> zeroinitializer
  %shift = lshr <16 x i16> %a, %splat
  ret <16 x i16> %shift
}

define <32 x i8> @splatvar_shift_v32i8(<32 x i8> %a, <32 x i8> %b) {
; AVX1-LABEL: splatvar_shift_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpsrlw $4, %xmm2, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm8 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX1-NEXT:    vpand %xmm8, %xmm3, %xmm3
; AVX1-NEXT:    vpsllw $5, %xmm1, %xmm1
; AVX1-NEXT:    vpblendvb %xmm1, %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $2, %xmm2, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm5 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; AVX1-NEXT:    vpand %xmm5, %xmm3, %xmm3
; AVX1-NEXT:    vpaddb %xmm1, %xmm1, %xmm6
; AVX1-NEXT:    vpblendvb %xmm6, %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $1, %xmm2, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm7 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; AVX1-NEXT:    vpand %xmm7, %xmm3, %xmm3
; AVX1-NEXT:    vpaddb %xmm6, %xmm6, %xmm4
; AVX1-NEXT:    vpblendvb %xmm4, %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm3
; AVX1-NEXT:    vpand %xmm8, %xmm3, %xmm3
; AVX1-NEXT:    vpblendvb %xmm1, %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm1
; AVX1-NEXT:    vpand %xmm5, %xmm1, %xmm1
; AVX1-NEXT:    vpblendvb %xmm6, %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $1, %xmm0, %xmm1
; AVX1-NEXT:    vpand %xmm7, %xmm1, %xmm1
; AVX1-NEXT:    vpblendvb %xmm4, %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatvar_shift_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpbroadcastb %xmm1, %ymm1
; AVX2-NEXT:    vpsrlw $4, %ymm0, %ymm2
; AVX2-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpsllw $5, %ymm1, %ymm1
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw $2, %ymm0, %ymm2
; AVX2-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw $1, %ymm0, %ymm2
; AVX2-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %splat = shufflevector <32 x i8> %b, <32 x i8> undef, <32 x i32> zeroinitializer
  %shift = lshr <32 x i8> %a, %splat
  ret <32 x i8> %shift
}

;
; Constant Shifts
;

define <4 x i64> @constant_shift_v4i64(<4 x i64> %a) {
; AVX1-LABEL: constant_shift_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpsrlq $62, %xmm1, %xmm2
; AVX1-NEXT:    vpsrlq $31, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpsrlq $7, %xmm0, %xmm2
; AVX1-NEXT:    vpsrlq $1, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: constant_shift_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrlvq {{.*}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <4 x i64> %a, <i64 1, i64 7, i64 31, i64 62>
  ret <4 x i64> %shift
}

define <8 x i32> @constant_shift_v8i32(<8 x i32> %a) {
; AVX1-LABEL: constant_shift_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpextrd $1, %xmm1, %eax
; AVX1-NEXT:    shrl $9, %eax
; AVX1-NEXT:    vmovd %xmm1, %ecx
; AVX1-NEXT:    shrl $8, %ecx
; AVX1-NEXT:    vmovd %ecx, %xmm2
; AVX1-NEXT:    vpinsrd $1, %eax, %xmm2, %xmm2
; AVX1-NEXT:    vpextrd $2, %xmm1, %eax
; AVX1-NEXT:    shrl $8, %eax
; AVX1-NEXT:    vpinsrd $2, %eax, %xmm2, %xmm2
; AVX1-NEXT:    vpextrd $3, %xmm1, %eax
; AVX1-NEXT:    shrl $7, %eax
; AVX1-NEXT:    vpinsrd $3, %eax, %xmm2, %xmm1
; AVX1-NEXT:    vpextrd $1, %xmm0, %eax
; AVX1-NEXT:    shrl $5, %eax
; AVX1-NEXT:    vmovd %xmm0, %ecx
; AVX1-NEXT:    shrl $4, %ecx
; AVX1-NEXT:    vmovd %ecx, %xmm2
; AVX1-NEXT:    vpinsrd $1, %eax, %xmm2, %xmm2
; AVX1-NEXT:    vpextrd $2, %xmm0, %eax
; AVX1-NEXT:    shrl $6, %eax
; AVX1-NEXT:    vpinsrd $2, %eax, %xmm2, %xmm2
; AVX1-NEXT:    vpextrd $3, %xmm0, %eax
; AVX1-NEXT:    shrl $7, %eax
; AVX1-NEXT:    vpinsrd $3, %eax, %xmm2, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: constant_shift_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <8 x i32> %a, <i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 8, i32 7>
  ret <8 x i32> %shift
}

define <16 x i16> @constant_shift_v16i16(<16 x i16> %a) {
; AVX1-LABEL: constant_shift_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpsrlw $8, %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [32896,37008,41120,45232,49344,53456,57568,61680]
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $4, %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [256,8480,16704,24928,33152,41376,49600,57824]
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $2, %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [512,16960,33408,49856,768,17216,33664,50112]
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $1, %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [1024,33920,1280,34176,1536,34432,1792,34688]
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $8, %xmm0, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,4112,8224,12336,16448,20560,24672,28784]
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,8224,16448,24672,32896,41120,49344,57568]
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,16448,32896,49344,256,16704,33152,49600]
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $1, %xmm0, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,32896,256,33152,512,33408,768,33664]
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: constant_shift_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpxor %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} ymm3 = ymm2[4],ymm1[4],ymm2[5],ymm1[5],ymm2[6],ymm1[6],ymm2[7],ymm1[7],ymm2[12],ymm1[12],ymm2[13],ymm1[13],ymm2[14],ymm1[14],ymm2[15],ymm1[15]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} ymm4 = ymm0[4,4,5,5,6,6,7,7,12,12,13,13,14,14,15,15]
; AVX2-NEXT:    vpsrlvd %ymm3, %ymm4, %ymm3
; AVX2-NEXT:    vpsrld $16, %ymm3, %ymm3
; AVX2-NEXT:    vpunpcklwd {{.*#+}} ymm1 = ymm2[0],ymm1[0],ymm2[1],ymm1[1],ymm2[2],ymm1[2],ymm2[3],ymm1[3],ymm2[8],ymm1[8],ymm2[9],ymm1[9],ymm2[10],ymm1[10],ymm2[11],ymm1[11]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} ymm0 = ymm0[0,0,1,1,2,2,3,3,8,8,9,9,10,10,11,11]
; AVX2-NEXT:    vpsrlvd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrld $16, %ymm0, %ymm0
; AVX2-NEXT:    vpackusdw %ymm3, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <16 x i16> %a, <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8, i16 9, i16 10, i16 11, i16 12, i16 13, i16 14, i16 15>
  ret <16 x i16> %shift
}

define <32 x i8> @constant_shift_v32i8(<32 x i8> %a) {
; AVX1-LABEL: constant_shift_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpsrlw $4, %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm8 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX1-NEXT:    vpand %xmm8, %xmm2, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [0,1,2,3,4,5,6,7,7,6,5,4,3,2,1,0]
; AVX1-NEXT:    vpsllw $5, %xmm4, %xmm4
; AVX1-NEXT:    vpblendvb %xmm4, %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $2, %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm5 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; AVX1-NEXT:    vpand %xmm5, %xmm2, %xmm2
; AVX1-NEXT:    vpaddb %xmm4, %xmm4, %xmm6
; AVX1-NEXT:    vpblendvb %xmm6, %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $1, %xmm1, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm7 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; AVX1-NEXT:    vpand %xmm7, %xmm2, %xmm2
; AVX1-NEXT:    vpaddb %xmm6, %xmm6, %xmm3
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm2
; AVX1-NEXT:    vpand %xmm8, %xmm2, %xmm2
; AVX1-NEXT:    vpblendvb %xmm4, %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm2
; AVX1-NEXT:    vpand %xmm5, %xmm2, %xmm2
; AVX1-NEXT:    vpblendvb %xmm6, %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $1, %xmm0, %xmm2
; AVX1-NEXT:    vpand %xmm7, %xmm2, %xmm2
; AVX1-NEXT:    vpblendvb %xmm3, %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: constant_shift_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa   {{.*#+}} ymm1 = [0,1,2,3,4,5,6,7,7,6,5,4,3,2,1,0,0,1,2,3,4,5,6,7,7,6,5,4,3,2,1,0]
; AVX2-NEXT:    vpsllw    $5, %ymm1, %ymm1
; AVX2-NEXT:    vpsrlw    $4, %ymm0, %ymm2
; AVX2-NEXT:    vpand     {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw    $2, %ymm0, %ymm2
; AVX2-NEXT:    vpand     {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpaddb    %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw    $1, %ymm0, %ymm2
; AVX2-NEXT:    vpand     {{.*}}(%rip), %ymm2, %ymm2
; AVX2-NEXT:    vpaddb    %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpblendvb %ymm1, %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <32 x i8> %a, <i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>
  ret <32 x i8> %shift
}

;
; Uniform Constant Shifts
;

define <4 x i64> @splatconstant_shift_v4i64(<4 x i64> %a) {
; AVX1-LABEL: splatconstant_shift_v4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpsrlq $7, %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrlq $7, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatconstant_shift_v4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrlq $7, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <4 x i64> %a, <i64 7, i64 7, i64 7, i64 7>
  ret <4 x i64> %shift
}

define <8 x i32> @splatconstant_shift_v8i32(<8 x i32> %a) {
; AVX1-LABEL: splatconstant_shift_v8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpsrld $5, %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrld $5, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatconstant_shift_v8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrld $5, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <8 x i32> %a, <i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5>
  ret <8 x i32> %shift
}

define <16 x i16> @splatconstant_shift_v16i16(<16 x i16> %a) {
; AVX1-LABEL: splatconstant_shift_v16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpsrlw $3, %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrlw $3, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatconstant_shift_v16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrlw $3, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <16 x i16> %a, <i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3>
  ret <16 x i16> %shift
}

define <32 x i8> @splatconstant_shift_v32i8(<32 x i8> %a) {
; AVX1-LABEL: splatconstant_shift_v32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpsrlw $3, %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31]
; AVX1-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $3, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: splatconstant_shift_v32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpsrlw $3, %ymm0
; AVX2-NEXT:    vpand {{.*}}(%rip), %ymm0
; AVX2-NEXT:    retq
  %shift = lshr <32 x i8> %a, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  ret <32 x i8> %shift
}
