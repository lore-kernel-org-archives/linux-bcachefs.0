Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0325C4332F
	for <linux-bcachefs@archiver.kernel.org>; Wed,  9 Nov 2022 13:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiKINWM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 9 Nov 2022 08:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKINWM (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 9 Nov 2022 08:22:12 -0500
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A2AFAE3
        for <linux-bcachefs@vger.kernel.org>; Wed,  9 Nov 2022 05:22:10 -0800 (PST)
Date:   Wed, 09 Nov 2022 13:22:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1668000128; x=1668259328;
        bh=mQ7zWvz/VTGUcLpod4L7+jp0liUjYhs16Hr73/uM/v0=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=yim4biDncl0fNhgtRQqNnfFFubLSiRqxiMKD/tjJHsc1SOvD8T4x0uhHPD2j4Lfdq
         nZVLrUnDQV7/azIQjSyXahBr+Hc/NTD/EpcQA2KwAu6BeBOlWoFjlJ9Dj3b3Powwhn
         kWFESDxA0rMUU/1F7/L76wcLwKULhB9QgwR0r1iF/PfaHWuZ8HSgcyLISojo9fBd/R
         2dGYsDYj0NdoVaEU5fh2FfJIEfoJqJC+F7jHET7O08ZMK0myC3l6Qm8NPFQIfXc/wY
         3cIenMEf8BDeA0hhcOT0PGhDRpBrvddDec79ZLUzrutzwv8z5ULyL/Rn+GRj3aq2oA
         PJE08afi5oBHA==
To:     "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From:   raid5atemyhomework <raid5atemyhomework@protonmail.com>
Subject: Proposal to use Cauchy Reed-Solomon Erasure Coding
Message-ID: <76DQGHJcbeTtk41xRingY4rRWt0ovahY30ltQ9YEnNJxErroN5BftNBBNG5IQ9ym5RyA1lE9vYFguLl3G6A1mHnJ-pf4-LIWjpZjjk26oJI=@protonmail.com>
Feedback-ID: 28717774:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi bcachefs developers,

I have some code that implements Cauchy Reed-Solomon erasure coding: https:=
//github.com/raid5atemyhomework/llrfs/tree/master/libllrfs/raid

First, why you might want to switch to this:

* The implementation supports up to 128 data disks and 128 parity disks.
* In 2-parity mode (RAID6) it is faster than the implementation in `lib/rai=
d6` of Linux as well as RAIDZ2 of ZFS.
  In 3-parity mode it is faster than RAIDZ3 of ZFS.

LLRFS is an overly-ambitious filesystem side-project I have, and has almost=
 no code, but it does have the RAID erasure coding completely implemented (=
full-stripe writes, partial-stripe modifies, and recovery decoding) and opt=
imized.

As bcachefs is almost practically finished except for the "unstable" erasur=
e coding, I thought it might be useful to offer my code up to be used for e=
rasure coding in bcachefs.

The encoding used is **NOT** back-compatible with the Linux RAID6 encoding,=
 so if you switch to this encoding then you break existing bcachefs RAID6 s=
etups.

You can read more about the LLRFS RAID erasure code here: https://github.co=
m/raid5atemyhomework/llrfs/blob/master/doc/01-Grass/02-CRS.md

More details:

* From 1 to 128 parity disks and from 1 to 128 data disks.
  * Limits are ridiculously high and should be big enough for anyone.  Yes,=
 it supports 3-parity, 4-parity, 5-parity.... 128-parity.
  * No weird rules on the number of parity vs data disks.  You can even hav=
e more parity disks than data disks if you like.  In fact RAID1 is consider=
ed just a special case where the number of data disks is 1.
  * If you have `m` parity, you can recover up to `m` failing disks, under =
all conditions, i.e. minimum distance separable code.
* Fast:
  * A **NON**-SIMD compile, in RAID6 (2-parity) mode, is competitive with t=
he ZFS RAIDZ2 in SIMD compile, when encoding (i.e. full stripe write).  It =
is faster when modifying (i.e. partial stripe write) or decoding (i.e. data=
 recovery).
    * As I understand it, the ZFS RAIDZ2 coding is substantially the same a=
s the Linux RAID6 encoding, i.e. both use the Arvind technique to speed up =
encoding by using 2 as a generator inside GF(256).  The Arvind technique do=
es not speed up modifying and decoding.
  * A **NON**-SIMD compile. in 3-parity mode, is faster than the ZFS RAIDZ3=
 (3-parity) in SIMD compile.
  * The code only requires 3 SIMD operations: Wide Load, Wide Store, and Wi=
de XOR.  Wide Load and Store are absolutely necessary for any SIMD set, and=
 Wide XOR is simple enough that we expect all decent SIMD instruction sets =
to include it.  Thus, it is easy to adapt to any SIMD instruction set, incl=
uding future ones.
  * The code is simple enough that GCC and LLVM can trivially vectorize it,=
 meaning we do not even need to write any SIMD assembler or use compiler in=
trinsics / SIMD data types.  Just pass in `-O3 -ftree-vectorize` to GCC and=
 it will compile to the widest SIMD instruction set available on the target=
, and if the set has wide enough loads will even just trivially unroll the =
inner loop for even more speedup.

Now here are the drawbacks:

* Part of the speedup is due to changing how GF(256) is encoded; in particu=
lar, the schemes used by Linux RAID6 and ZFS encode GF(256) =3D=3D one byte=
.  This erasure coding uses a "rotated" encoding, where a byte encodes one =
bit of 8 different and independent GF(256) elements, and addressing individ=
ual bits of GF(256) elements is effectively always done in "wide" mode even=
 if you process 1 byte at a time.  Processing multiple bytes at a time, as =
in SIMD wide instructions or even just normal 32-bit or 64-bit load/xor/sto=
re, just speeds it up further.
  * Because of this, it is impossible to make it compatible with Linux RAID=
6 even if you mess with the Cauchy matrix to make it match the Arvind techn=
ique.
* The other part of the speedup is due to using a code generator to impleme=
nt 256 different functions that multiply an entire buffer of GF(256) elemen=
ts by a particular GF(256) element.  This eliminates any branching within t=
ight loops, and branching is only outside the tight loop that processes an =
entire block at a time.
  * This makes this relatively large in code size.
* Liber8tion still beats the pants off this technique, especially if you al=
so use a code generator to implement the 8 different functions to apply the=
 8 matrices from Liber8tion and use the same rotated encoding instead of im=
plementing general GF(2) matrix multiply on GF(256) =3D=3D one byte represe=
ntation.  Granted Liber8tion is restricted to 8 data disks and 2 parity dis=
ks, if those limits are fine with you then Liber8tion is still faster and m=
ore code-compact.

If you are interested and are willing to break back-compat (since erasure c=
oding in bcachefs is still "unstable"), below is how you can integrate the =
code.

------

# License

The code is written by me and released under MIT license, which should allo=
w it to be linked in Linux as well as other FOSS kernels.

# Compiling

The files `llr_xorgf.c`, `llr_xorgf_ones.c` and `llr_cauchy_seq.c` are gene=
rated, and are not committed in the linked repository.  To generate them, j=
ust checkout https://github.com/raid5atemyhomework/llrfs , make sure you ha=
ve autotools installed, then `autoreconf -i && ./configure && make` then lo=
ok at the `libllrfs/raid` directory.

`llr_xorgf_generator.c` generates both `llr_xorgf_ones.c` and `llr_xorgf.c`=
, while `llr_cauchy_seq.c` is generated by `llr_cauchy_seq_generator.c`.  Y=
ou can probably just commit the generated files in your own project.  The c=
ode is not expected to change at all in the future, and as noted, they are =
trivially vectorizable by decent compilers and no further SIMD code really =
needs to be written (and notice as well that even without SIMD, it is compe=
titive with SIMD versions of the Arvind technique, i.e. the technique used =
in Linux `lib/raid6`).

In principle the "real" source code is the generators, so by Free Software =
principles you should provide the generators in any source release.  This i=
s not required by the license.

The RAID code refers to files in the `libllrfs/` directory, `llr_util.h` an=
d `llr_util.c`.  These contain implementations of `memzero` and `memcpy`, w=
hich may not be available in e.g. kernel compilations, or have bespoke impl=
ementations there.  You can modify these as necessary; most modern compiler=
s can compile these to very close to optimal even with a naive implementati=
on.

A plain `-O` gives you pretty good unvectorized code (on X86-64 it will use=
 MMX SIMD instructions), and giving `-O -ftree-vectorize` automatically giv=
es practically-optimal SIMD vectorized code for your compile target.

The file `llr_xorgf.h` contains the constant `LLR_XORGF_BLOCK_SIZE`.  This =
is the size of blocks that the RAID code will process.  In my repo it is 40=
96 as that is the Linux page size and is a reasonable and common block size=
 for hardware, and most storage hardware have block sizes of 4096 or a mult=
iple thereof.  You can modify this to any multiple of 64, but note that aut=
o-vectorization will suffer if you set this to less than the number of bits=
 in a "wide" SIMD operation, e.g. if you set it to <512 then auto-vectoriza=
tion will not be able to utilize AVX512 instructions.

Changing `LLR_XORGF_BLOCK_SIZE` will make it incompatible with a different =
version that has a different `LLR_XORGF_BLOCK_SIZE`, so once you set it, yo=
u should fix it to that size forever.  This is probably not onerous since a=
ctual hardware would limit you similarly if you want good performance.

# API

None of the functions in the `libllrfs/raid` directory do dynamic allocatio=
n.  Encoding and modifying requires some (probably dynamically-sized) array=
 of pointers to buffers, and the buffers must be allocated by the caller; b=
oth are the responsibility of the caller.  Decoding requires an object and =
some extra storage in addition to the buffers, and the onus is on the calle=
r to do the dynamic allocation and provide pointers to the extra storage.

Because the functions do no allocating themselves, objects like `llr_decode=
r` are trivially destructed by simply deallocating their space, or just reu=
sing the same space.

## Encoding (Full Stripe Write)

When writing a full stripe, you use `llr_encode` function declared in `llr_=
encode.h`.  This computes all the parity blocks.

You need to have the data blocks in buffers, and allocate data blocks for p=
arity.  You probably also need to dynamically allocate the array containing=
 the pointers to the buffers.  Ownership of the data and parity blocks is b=
asically yours.

Blocks must be `LLR_XORGF_BLOCK_SIZE` bytes.

You can pass in a NULL data block pointer; the function will treat it as if=
 the corresponding data block is all 0s.

## Modifying (Partial Stripe Write)

When writing a single block in a stripe, you need to:

* Read all the parity blocks.
* Read the current data of that data block.
* XOR the new data block with the current data block (store it in the buffe=
r space for the current data block).
* Pass in the XORed data, plus the parity blocks, to `llr_encode_modify` de=
clared in `llr_encode.h`.  The parity blocks will be modified.
* Write out the new data block (not the XORed result!) and the parity block=
s.  Do this atomically if you want to close the RAID5 write hole.

If you want to write multiple blocks in a stripe but this does not reach an=
 entire stripe:

* Read all the parity blocks.
* For each modified data block:
  * Read the current data of that data block.
  * XOR the new data block with the current data block.
  * Pass in the XORed data, plus the parity blocks, to `llr_encode_modify`,=
 which will modify the parity blocks.
*  Write out the new data blocks and the parity blocks.

## Decoding (Data Recovery)

This requires allocating (could allocate on the stack) an `llr_decoder` obj=
ect, then allocating some dynamically-sized extra space for it, then initia=
lizing it.  Once initialized, the object can be reused for multiple stripes=
, as long as the same set of data blocks and parity blocks are lost (if you=
 follow "correct" RAID5 technique then you will "rainbow" the data and shif=
t the parity disk per stripe, so you will need multiple `llr_decoder` objec=
ts; you could just reinitialize it for each stripe, for simplicity).

Initialization is two steps:

* First, determine how much extra space is needed for "matrix storage" and =
"scratch space", then allocate those.
* Then initialize, passing in the "matrix storage" and "scratch space".

After initialization the scratch space can be deallocated or reused, but th=
e matrix storage must be kept until you no longer need the `llr_decoder` ob=
ject.  To fully dstruct the `llr_decoder` object, you have to free the matr=
ix storage in its `matrix_storage` field yourself, then free the `llr_decod=
er` object (or just return from the function if you allocate it on the stac=
k).

To determine how much extra space to allocate, use the `llr_decoder_sizes` =
function.  Pass in the number of total data and parity disks, as well as th=
e number of data disks lost and the number of parity disks lost.  This will=
 provide how many bytes to allocate for both the "matrix storage" and "scra=
tch space" memory areas.  This can result in 0, in which case you can safel=
y pass in NULL for those areas.  The matrix storage will never be larger th=
an 16384 and the scratch space will never be larger than 32768.

After you have determined the sizes for the matrix storage and scratch spac=
e, allocate space for them, then pass it in to `llr_decoder_init`, which wi=
ll initialize an `llr_decoder` object.

After `llr_decoder_init` returns, you can safely deallocate the scratch spa=
ce.

You can then perform decoding with `llr_decoder_decode`, passing in the buf=
fers for the available surviving data and parity blocks, as well as fresh b=
uffers for the data blocks you want to recover.

If you want to recover parity blocks, use `llr_encode` to compute those.

--

I hope this is useful to bcachefs.

Thanks
raid5atemyhomework
