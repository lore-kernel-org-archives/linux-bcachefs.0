Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDB1193
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 01:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727400637; cv=none; b=knC7hITzJmsKEWiBhawPKOaJAI0E87G5iNgqWBbW7VEcDnXPIwniFQOKsKlkyBOJPVizFeTHg/18iGlg1Fr9C2wHiMbhfX5Uf3LPTjBTlaVFI3EWzJhN4BQea4k7IqVqF6LGhO3l2AfebkEFCg2jkbfZeBxtMGV/L7dxBZOUVJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727400637; c=relaxed/simple;
	bh=zu1Gd/b6mSFsQnE9SquvBSzmfht+TMBCgJEgd48Cp4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IAsLycfxqywkLfViYQad6L0nQSlzTvBSpmWhxuB2hbEdRhSOq7rDfQLC+uCi95AxiL0wXXN0InrAod0eq7UZDB5IQ+SsRqjaDv+XAQNC1Gx+3sfpGy9rDyEhlnExabG9Mf5xR5ug7jO7SP5a9f89KLfhvtYVSog1n4T/s7bBjVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uA+mPYrB; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uA+mPYrB"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a83562f9be9so143345066b.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 18:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727400633; x=1728005433; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xg3wV/pQhTWJt03A+VQrrhFbG/VZmKb3C/uzMo1xX7k=;
        b=uA+mPYrBfr7VNUntx6UFz3VQ6M2yTwC60w+OxzwGYUiNDyGxTt2yIXqVK1Oho6rvoH
         7mV34dqLzEotN+3tX4xveaXp6VpqiKFuTnPwSZJ15aCesj8rXqmB6mRUuww738BfIJlk
         LalVkkSTaUvPm5spw1/Mzc4XR/vEw3F+COzf/X5X86imDs8r6tpdgI4fDcwpOsfLe94p
         oLXZAuaMsCdn2hnSX/qVX9EsDQTyEKNrScUhvmTf7EjPxDlpta+wjxJXgCO02LNpnXQD
         g9Xh1tOncCGq+kPD5hLJyLXMbii13IbxB1R3L6HlzX53rq6cyH19K6JBt0sKdBeUgO2C
         QiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727400633; x=1728005433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xg3wV/pQhTWJt03A+VQrrhFbG/VZmKb3C/uzMo1xX7k=;
        b=CXw1nm5vPEW2ePoxLUJW7Wb1P6yXgF0g0C1q/sjQEODEye0CPftt90DWAYBSO9hdM8
         qy7Y3wRysJfIB8CVYQaa6hecBAD7Qw28eger7YWkDyPYzmgDjBhKKI3iSrZVrhK2pxvx
         GPXeQCYgGtjq0/GL1J+uyit6J+MFf8/Wtun+zgsdyKPUN++YKb5q/Q6QgXMFMbAm3w+h
         GZgmIwrUOKkpz5ARp3cy6xkgRYDnsar5CXH11F2qIZM69iN1lOjlCIhSKXJHCXak1EgT
         HM9xr6Yk/3BzOcCDH1THZXGG+ORco1aTdcMlACi2jnoEgJ2btfd1ckWjFOvIk5jJULLK
         Amww==
X-Forwarded-Encrypted: i=1; AJvYcCVF2aYJZhRNV67GmzOZ3zgvHZndU67L02nueY1HKqRrjkzRNuJz0Vc8Z8UxrjN5bGO74E/yHczyCXZkUy1gcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPoHnjziEYK5SM6JypjvQGcocrYXef4uPS0Wi8/thPyfyTIoFf
	C55My6aXcp87rMXz4IJL+p1Gh58A3qpQB8UgksJ3KtSsUI+6sdQqwTUWuAcmMFdul2qf5mlpHQr
	cwLaab2DNJ6Gev1s4ymhvuugNw2o7UqpnP/M=
X-Google-Smtp-Source: AGHT+IFWsEr09B36HWHZ0Jf6z7llfdYi9OX2qDQ6cmBHPIDp3bVPkNYnYGODEOrnoMH/1wOyBvgD4bct1B0SpslK3Gg=
X-Received: by 2002:a17:907:36c2:b0:a86:789b:71fe with SMTP id
 a640c23a62f3a-a93c4ae8f90mr103123466b.48.1727400632639; Thu, 26 Sep 2024
 18:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZvV6X5FPBBW7CO1f@archlinux> <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com> <ZvWTXaqkmxP2E2dc@archlinux>
 <ZvWd0aK7p_1rkb7E@archlinux> <CAMj1kXFV+Jck9Yf4w18rOzHckXvpXkhPhL-KrpBC8hqgXusw2g@mail.gmail.com>
 <CAGG=3QXG+Vsm7mjLV42Q-uA-EvgfOehSUeNQjKA3QQbw8vqSCg@mail.gmail.com>
In-Reply-To: <CAGG=3QXG+Vsm7mjLV42Q-uA-EvgfOehSUeNQjKA3QQbw8vqSCg@mail.gmail.com>
From: Bill Wendling <morbo@google.com>
Date: Thu, 26 Sep 2024 18:30:15 -0700
Message-ID: <CAGG=3QVWCQB-3sM=iwgTmX8zrU81H+F_A1icJwROvW_DSvsBeA@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in bch2_xattr_validate
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev, 
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2024 at 3:18=E2=80=AFPM Bill Wendling <morbo@google.com> wr=
ote:
>
> On Thu, Sep 26, 2024 at 12:58=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org>=
 wrote:
> >
> > (cc Kees and Bill)
> >
> > On Thu, 26 Sept 2024 at 19:46, Jan Hendrik Farr <kernel@jfarr.cc> wrote=
:
> > >
> > > On 26 19:01:20, Jan Hendrik Farr wrote:
> > > > On 26 18:09:57, Thorsten Blum wrote:
> > > > > On 26. Sep 2024, at 17:28, Thorsten Blum <thorsten.blum@toblux.co=
m> wrote:
> > > > > > On 26. Sep 2024, at 17:14, Jan Hendrik Farr <kernel@jfarr.cc> w=
rote:
> > > > > >>
> > > > > >> Hi Kent,
> > > > > >>
> > > > > >> found a strange regression in the patch set for 6.12.
> > > > > >>
> > > > > >> First bad commit is: 86e92eeeb23741a072fe7532db663250ff2e726a
> > > > > >> bcachefs: Annotate struct bch_xattr with __counted_by()
> > > > > >>
> > > > > >> When compiling with clang 18.1.8 (also with latest llvm main b=
ranch) and
> > > > > >> CONFIG_FORTIFY_SOURCE=3Dy my rootfs does not mount because the=
re is an erroneous
> > > > > >> detection of a buffer overflow.
> > > > > >>
> > > > > >> The __counted_by attribute is supposed to be supported startin=
g with gcc 15,
> > > > > >> not sure if it is implemented yet so I haven't tested with gcc=
 trunk yet.
> > > > > >>
> > > > > >> Here's the relevant section of dmesg:
> > > > > >>
> > > > > >> [    6.248736] bcachefs (nvme1n1p2): starting version 1.12: re=
balance_work_acct_fix
> > > > > >> [    6.248744] bcachefs (nvme1n1p2): recovering from clean shu=
tdown, journal seq 1305969
> > > > > >> [    6.252374] ------------[ cut here ]------------
> > > > > >> [    6.252375] memchr: detected buffer overflow: 12 byte read =
of buffer size 0
> > > > > >> [    6.252379] WARNING: CPU: 18 PID: 511 at lib/string_helpers=
.c:1033 __fortify_report+0x45/0x50
> > > > > >> [    6.252383] Modules linked in: bcachefs lz4hc_compress lz4_=
compress hid_generic usbhid btrfs crct10dif_pclmul libcrc32c crc32_pclmul c=
rc32c_generic polyval_clmulni crc32c_intel polyval_generic raid6_pq ghash_c=
lmulni_intel xor sha512_ssse3 sha256_ssse3 sha1_ssse3 aesni_intel gf128mul =
nvme crypto_simd ccp xhci_pci cryptd sp5100_tco xhci_pci_renesas nvme_core =
nvme_auth video wmi ip6_tables ip_tables x_tables i2c_dev
> > > > > >> [    6.252404] CPU: 18 UID: 0 PID: 511 Comm: mount Not tainted=
 6.11.0-10065-g6fa6588e5964 #98 d8e0beb515d91b387aa60970de7203f35ddd182c
> > > > > >> [    6.252406] Hardware name: Micro-Star International Co., Lt=
d. MS-7D78/PRO B650-P WIFI (MS-7D78), BIOS 1.C0 02/06/2024
> > > > > >> [    6.252407] RIP: 0010:__fortify_report+0x45/0x50
> > > > > >> [    6.252409] Code: 48 8b 34 c5 30 92 21 87 40 f6 c7 01 48 c7=
 c0 75 1b 0a 87 48 c7 c1 e1 93 07 87 48 0f 44 c8 48 c7 c7 ef 03 10 87 e8 0b=
 c2 9b ff <0f> 0b e9 cf 5d 9e 00 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 =
90
> > > > > >> [    6.252410] RSP: 0018:ffffbb3d03aff350 EFLAGS: 00010246
> > > > > >> [    6.252412] RAX: 4ce590fb7c372800 RBX: ffff98d559a400e8 RCX=
: 0000000000000027
> > > > > >> [    6.252413] RDX: 0000000000000002 RSI: 00000000ffffdfff RDI=
: ffff98e43db21a08
> > > > > >> [    6.252414] RBP: ffff98d559a400d0 R08: 0000000000001fff R09=
: ffff98e47ddcd000
> > > > > >> [    6.252415] R10: 0000000000005ffd R11: 0000000000000004 R12=
: ffff98d559a40000
> > > > > >> [    6.252416] R13: ffff98d54abf1320 R14: ffffbb3d03aff430 R15=
: 0000000000000000
> > > > > >> [    6.252417] FS:  00007efc82117800(0000) GS:ffff98e43db00000=
(0000) knlGS:0000000000000000
> > > > > >> [    6.252418] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800500=
33
> > > > > >> [    6.252419] CR2: 000055d96658ea80 CR3: 000000010a12c000 CR4=
: 0000000000f50ef0
> > > > > >> [    6.252420] PKRU: 55555554
> > > > > >> [    6.252421] Call Trace:
> > > > > >> [    6.252423]  <TASK>
> > > > > >> [    6.252425]  ? __warn+0xd5/0x1d0
> > > > > >> [    6.252427]  ? __fortify_report+0x45/0x50
> > > > > >> [    6.252429]  ? report_bug+0x144/0x1f0
> > > > > >> [    6.252431]  ? __fortify_report+0x45/0x50
> > > > > >> [    6.252433]  ? handle_bug+0x6a/0x90
> > > > > >> [    6.252435]  ? exc_invalid_op+0x1a/0x50
> > > > > >> [    6.252436]  ? asm_exc_invalid_op+0x1a/0x20
> > > > > >> [    6.252440]  ? __fortify_report+0x45/0x50
> > > > > >> [    6.252441]  __fortify_panic+0x9/0x10
> > > > > >> [    6.252443]  bch2_xattr_validate+0x13b/0x140 [bcachefs 8361=
179bbfcc59e669df38aec976f02d7211a659]
> > > > > >> [    6.252463]  bch2_btree_node_read_done+0x125a/0x17a0 [bcach=
efs 8361179bbfcc59e669df38aec976f02d7211a659]
> > > > > >> [    6.252482]  btree_node_read_work+0x202/0x4a0 [bcachefs 836=
1179bbfcc59e669df38aec976f02d7211a659]
> > > > > >> [    6.252499]  bch2_btree_node_read+0xa8d/0xb20 [bcachefs 836=
1179bbfcc59e669df38aec976f02d7211a659]
> > > > > >> [    6.252514]  ? srso_alias_return_thunk+0x5/0xfbef5
> > > > > >> [    6.252515]  ? pcpu_alloc_noprof+0x741/0xb50
> > > > > >> [    6.252517]  ? srso_alias_return_thunk+0x5/0xfbef5
> > > > > >> [    6.252519]  ? time_stats_update_one+0x75/0x1f0 [bcachefs 8=
361179bbfcc59e669df38aec976f02d7211a659]
> > > > > >>
> > > > > >> ...
> > > > > >>
> > > > > >>
> > > > > >> The memchr in question is at:
> > > > > >> https://github.com/torvalds/linux/blob/11a299a7933e03c83818b43=
1e6a1c53ad387423d/fs/bcachefs/xattr.c#L99
> > > > > >>
> > > > > >> There is not actually a buffer overflow here, I checked with g=
db that
> > > > > >> xattr.v->x_name does actually contain a string of the correct =
length and
> > > > > >> xattr.v->x_name_len contains the correct length and should be =
used to determine
> > > > > >> the length when memchr uses __struct_size for bounds-checking =
due to the
> > > > > >> __counted_by annotation.
> > > > > >>
> > > > > >> I'm at the point where I think this is probably a bug in clang=
. I have a patch
> > > > > >> that does fix (more like bandaid) the problem and adds some pr=
int statements:
> > > > > >>
> > > > > >> --
> > > > > >> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> > > > > >> index 56c8d3fe55a4..8d7e749b7dda 100644
> > > > > >> --- a/fs/bcachefs/xattr.c
> > > > > >> +++ b/fs/bcachefs/xattr.c
> > > > > >> @@ -74,6 +74,7 @@ int bch2_xattr_validate(struct bch_fs *c, st=
ruct bkey_s_c k,
> > > > > >>      enum bch_validate_flags flags)
> > > > > >> {
> > > > > >> struct bkey_s_c_xattr xattr =3D bkey_s_c_to_xattr(k);
> > > > > >> + const struct bch_xattr *v =3D (void *)k.v;
> > > > > >> unsigned val_u64s =3D xattr_val_u64s(xattr.v->x_name_len,
> > > > > >>  le16_to_cpu(xattr.v->x_val_len));
> > > > > >> int ret =3D 0;
> > > > > >> @@ -94,9 +95,12 @@ int bch2_xattr_validate(struct bch_fs *c, s=
truct bkey_s_c k,
> > > > > >>
> > > > > >> bkey_fsck_err_on(!bch2_xattr_type_to_handler(xattr.v->x_type),
> > > > > >> c, xattr_invalid_type,
> > > > > >> - "invalid type (%u)", xattr.v->x_type);
> > > > > >> + "invalid type (%u)", v->x_type);
> > > > > >>
> > > > > >> - bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_na=
me_len),
> > > > > >> + pr_info("x_name_len: %d", v->x_name_len);
> > > > > >> + pr_info("__struct_size(x_name): %ld", __struct_size(v->x_nam=
e));
> > > > > >> + pr_info("__struct_size(x_name): %ld", __struct_size(xattr.v-=
>x_name));
> > > > > >> + bkey_fsck_err_on(memchr(v->x_name, '\0', v->x_name_len),
> > > > > >> c, xattr_name_invalid_chars,
> > > > > >> "xattr name has invalid characters");
> > > > > >> fsck_err:
> > > > > >> --
> > > > > >>
> > > > > >>
> > > > > >> Making memchr access via a pointer created with
> > > > > >> const struct bch_xattr *v =3D (void *)k.v fixes it. From the p=
rint statements I
> > > > > >> can see that __struct_size(xattr.v->x_name) incorrectly return=
s 0, while
> > > > > >> __struct_size(v->x_name) correctly returns 10 in this case (th=
e value of
> > > > > >> x_name_len).
> > > > > >>
> > > > > >> The generated assembly illustrates what is going wrong. Below =
is an excerpt
> > > > > >> of the assembly clang generated for the bch2_xattr_validate fu=
nction:
> > > > > >>
> > > > > >> mov r13d, ecx
> > > > > >> mov r15, rdi
> > > > > >> mov r14, rsi
> > > > > >> mov rdi, offset .L.str.3
> > > > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > > > >> mov rbx, rdx
> > > > > >> mov edx, eax
> > > > > >> call _printk
> > > > > >> movzx edx, byte ptr [rbx + 1]
> > > > > >> mov rdi, offset .L.str.4
> > > > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > > > >> call _printk
> > > > > >> movzx edx, bh
> > > > > >> mov rdi, offset .L.str.4
> > > > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > > > >> call _printk
> > > > > >> lea rdi, [rbx + 4]
> > > > > >> mov r12, rbx
> > > > > >> movzx edx, byte ptr [rbx + 1]
> > > > > >> xor ebx, ebx
> > > > > >> xor esi, esi
> > > > > >> call memchr
> > > > > >>
> > > > > >> At the start of this rdx contains k.v (and is moved into rbx).=
 The three calls
> > > > > >> to printk are the ones you can see in my patch. You can see th=
at for the
> > > > > >> print that uses __struct_size(v->x_name) the compiler correctl=
y uses
> > > > > >> movzx edx, byte ptr [rbx + 1]
> > > > > >> to load x_name_len into edx.
> > > > > >>
> > > > > >> For the printk call that uses __struct_size(xattr.v->x_name) h=
owever the
> > > > > >> compiler uses
> > > > > >> movzx edx, bh
> > > > > >> So it will print the high 8 bits of the lower 16 bits (second =
least
> > > > > >> significant byte) of the memory address of xattr.v->x_type. Th=
is is obviously
> > > > > >> completely wrong.
> > > > > >>
> > > > > >> It is then doing the correct call of memchr because this is us=
ing my patch.
> > > > > >> Without my patch it would be doing the same thing for the call=
 to memchr where
> > > > > >> it uses the second least significant byte of the memory addres=
s of x_type as the
> > > > > >> length used for the bounds-check.
> > > > > >>
> > > > > >>
> > > > > >>
> > > > > >> The LLVM IR also shows the same problem:
> > > > > >>
> > > > > >> define internal zeroext i1 @xattr_cmp_key(ptr nocapture readno=
ne %0, ptr %1, ptr nocapture noundef readonly %2) #0 align 16 {
> > > > > >> [...]
> > > > > >> %51 =3D ptrtoint ptr %2 to i64
> > > > > >> %52 =3D lshr i64 %51, 8
> > > > > >> %53 =3D and i64 %52, 255
> > > > > >>
> > > > > >> This is the IR for the incorrect behavior. It simply converts =
the pointer to an
> > > > > >> int, shifts right by 8 bits, then and with 0xFF. If it did a l=
oad (to i64)
> > > > > >> instead of ptrtoint this would actually work, as the second le=
ast significant
> > > > > >> bit of an i64 loaded from that memory address does contain the=
 value of
> > > > > >> x_name_len. It's as if clang forgot to dereference a pointer h=
ere.
> > > > > >>
> > > > > >> Correct IR does this (for the other printk invocation):
> > > > > >>
> > > > > >> define internal zeroext i1 @xattr_cmp_key(ptr nocapture readno=
ne %0, ptr %1, ptr nocapture noundef readonly %2) #0 align 16 {
> > > > > >> [...]
> > > > > >> %4 =3D getelementptr inbounds %struct.bch_xattr, ptr %1, i64 0=
, i32 1
> > > > > >> %5 =3D load i8, ptr %4, align 8
> > > > > >> [...]
> > > > > >> %48 =3D load i8, ptr %5, align 4
> > > > > >> %49 =3D zext i8 %48 to i64
> > > > > >>
> > > > > >> Best Regards
> > > > > >> Jan
> > > > > >
> > > > > > I suspect it's the same Clang __bdos() "bug" as in [1] and [2].
> > > > > >
> > > > > > [1] https://lore.kernel.org/linux-kernel/3D0816D1-0807-4D37-8D5=
F-3C55CA910FAA@linux.dev/
> > > > > > [2] https://lore.kernel.org/all/20240913164630.GA4091534@thelio=
-3990X/
> > > > >
> > > > > Could you try this and see if it resolves the problem?
> > > > >
> > > > > diff --git a/include/linux/compiler_types.h b/include/linux/compi=
ler_types.h
> > > > > index 1a957ea2f4fe..b09759f31789 100644
> > > > > --- a/include/linux/compiler_types.h
> > > > > +++ b/include/linux/compiler_types.h
> > > > > @@ -413,7 +413,7 @@ struct ftrace_likely_data {
> > > > >   * When the size of an allocated object is needed, use the best =
available
> > > > >   * mechanism to find it. (For cases where sizeof() cannot be use=
d.)
> > > > >   */
> > > > > -#if __has_builtin(__builtin_dynamic_object_size)
> > > > > +#if __has_builtin(__builtin_dynamic_object_size) && !defined(__c=
lang__)
> > > > >  #define __struct_size(p)   __builtin_dynamic_object_size(p, 0)
> > > > >  #define __member_size(p)   __builtin_dynamic_object_size(p, 1)
> > > > >  #else
> > > > >
> > > >
> > > > Alright after looking at it in the debugger the code it generates n=
ow is
> > > > just wild.
> > > >
> > > > I added one more printk before the call to memchr like so:
> > > >
> > > > diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> > > > index 56c8d3fe55a4..3c7c479ea3a8 100644
> > > > --- a/fs/bcachefs/xattr.c
> > > > +++ b/fs/bcachefs/xattr.c
> > > > @@ -96,6 +96,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct =
bkey_s_c k,
> > > >                        c, xattr_invalid_type,
> > > >                        "invalid type (%u)", xattr.v->x_type);
> > > >
> > > > +     pr_info("__struct_size(x_name): %lu", __struct_size(xattr.v->=
x_name));
> > > >       bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_nam=
e_len),
> > > >                        c, xattr_name_invalid_chars,
> > > >                        "xattr name has invalid characters");
> > > > diff --git a/include/linux/compiler_types.h b/include/linux/compile=
r_types.h
> > > > index f14c275950b5..43ac0bca485d 100644
> > > > --- a/include/linux/compiler_types.h
> > > > +++ b/include/linux/compiler_types.h
> > > > @@ -413,7 +413,7 @@ struct ftrace_likely_data {
> > > >   * When the size of an allocated object is needed, use the best av=
ailable
> > > >   * mechanism to find it. (For cases where sizeof() cannot be used.=
)
> > > >   */
> > > > -#if __has_builtin(__builtin_dynamic_object_size)
> > > > +#if __has_builtin(__builtin_dynamic_object_size) && !defined(__cla=
ng__)
> > > >  #define __struct_size(p)     __builtin_dynamic_object_size(p, 0)
> > > >  #define __member_size(p)     __builtin_dynamic_object_size(p, 1)
> > > >  #else
> > > >
> > > >
> > > > Here's the generated assembly for this:
> > > >
> > > >       mov     rdi, offset .L.str.3
> > > >       mov     rsi, offset .L__func__.bch2_xattr_validate
> > > >       mov     r12, rdx
> > > >       mov     rdx, -1
> > > >       call    _printk
> > > >       mov     rax, r12
> > > >       movzx   esi, ah
> > > >       movzx   edx, byte ptr [r12 + 1]
> > > >       cmp     rsi, rdx
> > > >       jb      .LBB4_15
> > > > # %bb.11:
> > > >       lea     rdi, [rax + 4]
> > > >       xor     ebx, ebx
> > > >       xor     esi, esi
> > > >       call    memchr
> > > >
> > > > So for the printk it hardcoded -1 (aka 0xFFFFF... 64 bit long int m=
ax)
> > > > as the result of __struct_size. But then for before call to memchr =
it does
> > > > the same stuff again and puts the second least significant byte of =
the memory
> > > > address of x_type in esi, only to then load the correct value of x_=
name_len
> > > > into edx and compares them for the bounds-check.
> > > >
> > >
> > >
> > > __builtin_object_size should only ever be compile time known, right? =
So
> > > it looks like this is pretty broken atm.
> > >
Right. It's __builtin_dynamic_object_size that's known during runtime.

> > > I think until this stuff is fixed in clang the only real option is:
> > >
> There seems to be an issue with how the offset to the flexible array
> member is calculated internally. I'm looking into it now.
>
What Clang's doing is calculating the size of the object with this formula:

  size_t struct_size_including_flexible_array_members =3D
    MAX(sizeof(struct posix_acl),
        offsetof(struct posix_acl, a_entries) +
        sizeof(struct posix_acl_entry) * count);

The various sizes and offsets are as follows:

  sizeof(struct posix_acl) =3D=3D 32
  sizeof(struct posix_acl_entry) =3D=3D 8

  sizeof(a_refcount) =3D=3D 4 :: offset =3D=3D 0
  sizeof(a_rcu) =3D=3D 16 :: offset =3D=3D 8
  sizeof(a_count) =3D=3D 4 :: offset =3D=3D 24
  offsetof(a_entries) =3D=3D 28

The resulting "real" size (according to Clang) is MAX(32, 28 + 8 * 1)
=3D=3D 36. I believe it's padding that results in the size of 40 for the
malloc size. Does that description jibe with what you're seeing?

(For what it's worth, I think Clang is correct here.)

-bw
