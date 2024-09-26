Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25B6185920;
	Thu, 26 Sep 2024 19:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727380727; cv=none; b=idhVL0Hxa9s7PDbg0YLzNQMuaCPXcP9JmunqgEI6mfDeAknld91Cj9d3f82eV10V2vD6QVqAJMcOCRpCdW7/NHVGRps/B/BYVKSFVaVMiXr4dDYWoGSV+xcgptM39nP4o30PpAd3m8y23sPrcd4+XSSR06fnBTIHrUAZruEbLQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727380727; c=relaxed/simple;
	bh=csirK8MuLMv8HpzT81ttujblQ7j4xC+2EPkiTLncOCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l0gdfdTbSP8UuWZZVe5IIOB1dDNQdrqoZSpDgqi5p8VATRDWnQPzXHqHFrYNH4KES7ZauCMpFik9JxHhJ8k2iLWP6o9NbAcsf5XetWXxmQYIamW/OxjMbOvmeGjFEror/i1fAJsHzLbx0Kh5KDPExRd8/faRF+uUNlods2IZ6Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7qE9Sdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7qE9Sdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B8FC4CECE;
	Thu, 26 Sep 2024 19:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727380727;
	bh=csirK8MuLMv8HpzT81ttujblQ7j4xC+2EPkiTLncOCw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=e7qE9Sdn92IkPH95Ck1lq3xGeTRVCNFSTQX/H07QFq2y4W+Va3Fp7mVmivVCmD6sw
	 43AkEDtLbthKxDRB2VYAB9A4ol7o/tjchc3L0OsrDxIMjeeosOZOEHaesNpFkHZog4
	 FLKsYfRoT3zET7tMDL0wxcKaX22piu3oYjENHYePsDUM5alzpAN51dECE2UHCa7tA/
	 HG3r7tpQtAAfBT5Y8BPaeQtRi7qDDdNcSzn6FFy+2UFOGbRsHsI5zhieHaQqbJKNyr
	 lFKaH9KBs2SqSR6I3HEueqCi+TiTSNQjVFjFIbGNiTwur+vDsQegqD0ZowqazoIkCa
	 QbIN3xR72YZRA==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5365392cfafso1539931e87.0;
        Thu, 26 Sep 2024 12:58:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUxPphzkP8DKSD4lnEt6A2BO03OhZyLoCIiEg/h1qt+f96hiVFD8fNbyLpucs4MvbD/0GWHngUxSUp8ThW4AuJI@vger.kernel.org, AJvYcCVJyp1jp93L6wYjGxufgdqa4uGM+4lidOcnTqSO+iudQlKu9ZP+eeVDh5Izb8FE5ebNYYHf+k7Smo/yePeC7Q==@vger.kernel.org, AJvYcCX3OAMzgPrG2YmSUWaMu532pRyltYfpFwNvFj4qSNEtWQcNLtcou68HOKBfRBC+b0mzY5B6/mU5vJD0r6GV@vger.kernel.org
X-Gm-Message-State: AOJu0YxquwdI3bEvD3BCJj52ObEwpgEjX8dJoPjhoA2ew+igZNq0Wwwt
	fKJ/dqphhIq55uvGck8+hgzdgZRhR+I6pIZodcX+K1Hk6cm6WvvLnAYwxj5c8rRS8u3NmNFd6DK
	leuwWrCRxbvwpKB5NURF+elpzLlo=
X-Google-Smtp-Source: AGHT+IGp0fmdybMXrKjGZQPupnbDp6DFKmHVk0s2kRX6HcS6XH3XwYR0CK8uEMNCN9KIil77oOFFoQ2Wk3BlCjcVJ60=
X-Received: by 2002:a05:6512:b05:b0:536:a533:c03a with SMTP id
 2adb3069b0e04-5389fc3bf34mr459368e87.17.1727380725331; Thu, 26 Sep 2024
 12:58:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZvV6X5FPBBW7CO1f@archlinux> <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com> <ZvWTXaqkmxP2E2dc@archlinux>
 <ZvWd0aK7p_1rkb7E@archlinux>
In-Reply-To: <ZvWd0aK7p_1rkb7E@archlinux>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 26 Sep 2024 21:58:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFV+Jck9Yf4w18rOzHckXvpXkhPhL-KrpBC8hqgXusw2g@mail.gmail.com>
Message-ID: <CAMj1kXFV+Jck9Yf4w18rOzHckXvpXkhPhL-KrpBC8hqgXusw2g@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in bch2_xattr_validate
To: Jan Hendrik Farr <kernel@jfarr.cc>, Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev, 
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(cc Kees and Bill)

On Thu, 26 Sept 2024 at 19:46, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
>
> On 26 19:01:20, Jan Hendrik Farr wrote:
> > On 26 18:09:57, Thorsten Blum wrote:
> > > On 26. Sep 2024, at 17:28, Thorsten Blum <thorsten.blum@toblux.com> w=
rote:
> > > > On 26. Sep 2024, at 17:14, Jan Hendrik Farr <kernel@jfarr.cc> wrote=
:
> > > >>
> > > >> Hi Kent,
> > > >>
> > > >> found a strange regression in the patch set for 6.12.
> > > >>
> > > >> First bad commit is: 86e92eeeb23741a072fe7532db663250ff2e726a
> > > >> bcachefs: Annotate struct bch_xattr with __counted_by()
> > > >>
> > > >> When compiling with clang 18.1.8 (also with latest llvm main branc=
h) and
> > > >> CONFIG_FORTIFY_SOURCE=3Dy my rootfs does not mount because there i=
s an erroneous
> > > >> detection of a buffer overflow.
> > > >>
> > > >> The __counted_by attribute is supposed to be supported starting wi=
th gcc 15,
> > > >> not sure if it is implemented yet so I haven't tested with gcc tru=
nk yet.
> > > >>
> > > >> Here's the relevant section of dmesg:
> > > >>
> > > >> [    6.248736] bcachefs (nvme1n1p2): starting version 1.12: rebala=
nce_work_acct_fix
> > > >> [    6.248744] bcachefs (nvme1n1p2): recovering from clean shutdow=
n, journal seq 1305969
> > > >> [    6.252374] ------------[ cut here ]------------
> > > >> [    6.252375] memchr: detected buffer overflow: 12 byte read of b=
uffer size 0
> > > >> [    6.252379] WARNING: CPU: 18 PID: 511 at lib/string_helpers.c:1=
033 __fortify_report+0x45/0x50
> > > >> [    6.252383] Modules linked in: bcachefs lz4hc_compress lz4_comp=
ress hid_generic usbhid btrfs crct10dif_pclmul libcrc32c crc32_pclmul crc32=
c_generic polyval_clmulni crc32c_intel polyval_generic raid6_pq ghash_clmul=
ni_intel xor sha512_ssse3 sha256_ssse3 sha1_ssse3 aesni_intel gf128mul nvme=
 crypto_simd ccp xhci_pci cryptd sp5100_tco xhci_pci_renesas nvme_core nvme=
_auth video wmi ip6_tables ip_tables x_tables i2c_dev
> > > >> [    6.252404] CPU: 18 UID: 0 PID: 511 Comm: mount Not tainted 6.1=
1.0-10065-g6fa6588e5964 #98 d8e0beb515d91b387aa60970de7203f35ddd182c
> > > >> [    6.252406] Hardware name: Micro-Star International Co., Ltd. M=
S-7D78/PRO B650-P WIFI (MS-7D78), BIOS 1.C0 02/06/2024
> > > >> [    6.252407] RIP: 0010:__fortify_report+0x45/0x50
> > > >> [    6.252409] Code: 48 8b 34 c5 30 92 21 87 40 f6 c7 01 48 c7 c0 =
75 1b 0a 87 48 c7 c1 e1 93 07 87 48 0f 44 c8 48 c7 c7 ef 03 10 87 e8 0b c2 =
9b ff <0f> 0b e9 cf 5d 9e 00 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90
> > > >> [    6.252410] RSP: 0018:ffffbb3d03aff350 EFLAGS: 00010246
> > > >> [    6.252412] RAX: 4ce590fb7c372800 RBX: ffff98d559a400e8 RCX: 00=
00000000000027
> > > >> [    6.252413] RDX: 0000000000000002 RSI: 00000000ffffdfff RDI: ff=
ff98e43db21a08
> > > >> [    6.252414] RBP: ffff98d559a400d0 R08: 0000000000001fff R09: ff=
ff98e47ddcd000
> > > >> [    6.252415] R10: 0000000000005ffd R11: 0000000000000004 R12: ff=
ff98d559a40000
> > > >> [    6.252416] R13: ffff98d54abf1320 R14: ffffbb3d03aff430 R15: 00=
00000000000000
> > > >> [    6.252417] FS:  00007efc82117800(0000) GS:ffff98e43db00000(000=
0) knlGS:0000000000000000
> > > >> [    6.252418] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > >> [    6.252419] CR2: 000055d96658ea80 CR3: 000000010a12c000 CR4: 00=
00000000f50ef0
> > > >> [    6.252420] PKRU: 55555554
> > > >> [    6.252421] Call Trace:
> > > >> [    6.252423]  <TASK>
> > > >> [    6.252425]  ? __warn+0xd5/0x1d0
> > > >> [    6.252427]  ? __fortify_report+0x45/0x50
> > > >> [    6.252429]  ? report_bug+0x144/0x1f0
> > > >> [    6.252431]  ? __fortify_report+0x45/0x50
> > > >> [    6.252433]  ? handle_bug+0x6a/0x90
> > > >> [    6.252435]  ? exc_invalid_op+0x1a/0x50
> > > >> [    6.252436]  ? asm_exc_invalid_op+0x1a/0x20
> > > >> [    6.252440]  ? __fortify_report+0x45/0x50
> > > >> [    6.252441]  __fortify_panic+0x9/0x10
> > > >> [    6.252443]  bch2_xattr_validate+0x13b/0x140 [bcachefs 8361179b=
bfcc59e669df38aec976f02d7211a659]
> > > >> [    6.252463]  bch2_btree_node_read_done+0x125a/0x17a0 [bcachefs =
8361179bbfcc59e669df38aec976f02d7211a659]
> > > >> [    6.252482]  btree_node_read_work+0x202/0x4a0 [bcachefs 8361179=
bbfcc59e669df38aec976f02d7211a659]
> > > >> [    6.252499]  bch2_btree_node_read+0xa8d/0xb20 [bcachefs 8361179=
bbfcc59e669df38aec976f02d7211a659]
> > > >> [    6.252514]  ? srso_alias_return_thunk+0x5/0xfbef5
> > > >> [    6.252515]  ? pcpu_alloc_noprof+0x741/0xb50
> > > >> [    6.252517]  ? srso_alias_return_thunk+0x5/0xfbef5
> > > >> [    6.252519]  ? time_stats_update_one+0x75/0x1f0 [bcachefs 83611=
79bbfcc59e669df38aec976f02d7211a659]
> > > >>
> > > >> ...
> > > >>
> > > >>
> > > >> The memchr in question is at:
> > > >> https://github.com/torvalds/linux/blob/11a299a7933e03c83818b431e6a=
1c53ad387423d/fs/bcachefs/xattr.c#L99
> > > >>
> > > >> There is not actually a buffer overflow here, I checked with gdb t=
hat
> > > >> xattr.v->x_name does actually contain a string of the correct leng=
th and
> > > >> xattr.v->x_name_len contains the correct length and should be used=
 to determine
> > > >> the length when memchr uses __struct_size for bounds-checking due =
to the
> > > >> __counted_by annotation.
> > > >>
> > > >> I'm at the point where I think this is probably a bug in clang. I =
have a patch
> > > >> that does fix (more like bandaid) the problem and adds some print =
statements:
> > > >>
> > > >> --
> > > >> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> > > >> index 56c8d3fe55a4..8d7e749b7dda 100644
> > > >> --- a/fs/bcachefs/xattr.c
> > > >> +++ b/fs/bcachefs/xattr.c
> > > >> @@ -74,6 +74,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct=
 bkey_s_c k,
> > > >>      enum bch_validate_flags flags)
> > > >> {
> > > >> struct bkey_s_c_xattr xattr =3D bkey_s_c_to_xattr(k);
> > > >> + const struct bch_xattr *v =3D (void *)k.v;
> > > >> unsigned val_u64s =3D xattr_val_u64s(xattr.v->x_name_len,
> > > >>  le16_to_cpu(xattr.v->x_val_len));
> > > >> int ret =3D 0;
> > > >> @@ -94,9 +95,12 @@ int bch2_xattr_validate(struct bch_fs *c, struc=
t bkey_s_c k,
> > > >>
> > > >> bkey_fsck_err_on(!bch2_xattr_type_to_handler(xattr.v->x_type),
> > > >> c, xattr_invalid_type,
> > > >> - "invalid type (%u)", xattr.v->x_type);
> > > >> + "invalid type (%u)", v->x_type);
> > > >>
> > > >> - bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_l=
en),
> > > >> + pr_info("x_name_len: %d", v->x_name_len);
> > > >> + pr_info("__struct_size(x_name): %ld", __struct_size(v->x_name));
> > > >> + pr_info("__struct_size(x_name): %ld", __struct_size(xattr.v->x_n=
ame));
> > > >> + bkey_fsck_err_on(memchr(v->x_name, '\0', v->x_name_len),
> > > >> c, xattr_name_invalid_chars,
> > > >> "xattr name has invalid characters");
> > > >> fsck_err:
> > > >> --
> > > >>
> > > >>
> > > >> Making memchr access via a pointer created with
> > > >> const struct bch_xattr *v =3D (void *)k.v fixes it. From the print=
 statements I
> > > >> can see that __struct_size(xattr.v->x_name) incorrectly returns 0,=
 while
> > > >> __struct_size(v->x_name) correctly returns 10 in this case (the va=
lue of
> > > >> x_name_len).
> > > >>
> > > >> The generated assembly illustrates what is going wrong. Below is a=
n excerpt
> > > >> of the assembly clang generated for the bch2_xattr_validate functi=
on:
> > > >>
> > > >> mov r13d, ecx
> > > >> mov r15, rdi
> > > >> mov r14, rsi
> > > >> mov rdi, offset .L.str.3
> > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > >> mov rbx, rdx
> > > >> mov edx, eax
> > > >> call _printk
> > > >> movzx edx, byte ptr [rbx + 1]
> > > >> mov rdi, offset .L.str.4
> > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > >> call _printk
> > > >> movzx edx, bh
> > > >> mov rdi, offset .L.str.4
> > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > >> call _printk
> > > >> lea rdi, [rbx + 4]
> > > >> mov r12, rbx
> > > >> movzx edx, byte ptr [rbx + 1]
> > > >> xor ebx, ebx
> > > >> xor esi, esi
> > > >> call memchr
> > > >>
> > > >> At the start of this rdx contains k.v (and is moved into rbx). The=
 three calls
> > > >> to printk are the ones you can see in my patch. You can see that f=
or the
> > > >> print that uses __struct_size(v->x_name) the compiler correctly us=
es
> > > >> movzx edx, byte ptr [rbx + 1]
> > > >> to load x_name_len into edx.
> > > >>
> > > >> For the printk call that uses __struct_size(xattr.v->x_name) howev=
er the
> > > >> compiler uses
> > > >> movzx edx, bh
> > > >> So it will print the high 8 bits of the lower 16 bits (second leas=
t
> > > >> significant byte) of the memory address of xattr.v->x_type. This i=
s obviously
> > > >> completely wrong.
> > > >>
> > > >> It is then doing the correct call of memchr because this is using =
my patch.
> > > >> Without my patch it would be doing the same thing for the call to =
memchr where
> > > >> it uses the second least significant byte of the memory address of=
 x_type as the
> > > >> length used for the bounds-check.
> > > >>
> > > >>
> > > >>
> > > >> The LLVM IR also shows the same problem:
> > > >>
> > > >> define internal zeroext i1 @xattr_cmp_key(ptr nocapture readnone %=
0, ptr %1, ptr nocapture noundef readonly %2) #0 align 16 {
> > > >> [...]
> > > >> %51 =3D ptrtoint ptr %2 to i64
> > > >> %52 =3D lshr i64 %51, 8
> > > >> %53 =3D and i64 %52, 255
> > > >>
> > > >> This is the IR for the incorrect behavior. It simply converts the =
pointer to an
> > > >> int, shifts right by 8 bits, then and with 0xFF. If it did a load =
(to i64)
> > > >> instead of ptrtoint this would actually work, as the second least =
significant
> > > >> bit of an i64 loaded from that memory address does contain the val=
ue of
> > > >> x_name_len. It's as if clang forgot to dereference a pointer here.
> > > >>
> > > >> Correct IR does this (for the other printk invocation):
> > > >>
> > > >> define internal zeroext i1 @xattr_cmp_key(ptr nocapture readnone %=
0, ptr %1, ptr nocapture noundef readonly %2) #0 align 16 {
> > > >> [...]
> > > >> %4 =3D getelementptr inbounds %struct.bch_xattr, ptr %1, i64 0, i3=
2 1
> > > >> %5 =3D load i8, ptr %4, align 8
> > > >> [...]
> > > >> %48 =3D load i8, ptr %5, align 4
> > > >> %49 =3D zext i8 %48 to i64
> > > >>
> > > >> Best Regards
> > > >> Jan
> > > >
> > > > I suspect it's the same Clang __bdos() "bug" as in [1] and [2].
> > > >
> > > > [1] https://lore.kernel.org/linux-kernel/3D0816D1-0807-4D37-8D5F-3C=
55CA910FAA@linux.dev/
> > > > [2] https://lore.kernel.org/all/20240913164630.GA4091534@thelio-399=
0X/
> > >
> > > Could you try this and see if it resolves the problem?
> > >
> > > diff --git a/include/linux/compiler_types.h b/include/linux/compiler_=
types.h
> > > index 1a957ea2f4fe..b09759f31789 100644
> > > --- a/include/linux/compiler_types.h
> > > +++ b/include/linux/compiler_types.h
> > > @@ -413,7 +413,7 @@ struct ftrace_likely_data {
> > >   * When the size of an allocated object is needed, use the best avai=
lable
> > >   * mechanism to find it. (For cases where sizeof() cannot be used.)
> > >   */
> > > -#if __has_builtin(__builtin_dynamic_object_size)
> > > +#if __has_builtin(__builtin_dynamic_object_size) && !defined(__clang=
__)
> > >  #define __struct_size(p)   __builtin_dynamic_object_size(p, 0)
> > >  #define __member_size(p)   __builtin_dynamic_object_size(p, 1)
> > >  #else
> > >
> >
> > Alright after looking at it in the debugger the code it generates now i=
s
> > just wild.
> >
> > I added one more printk before the call to memchr like so:
> >
> > diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> > index 56c8d3fe55a4..3c7c479ea3a8 100644
> > --- a/fs/bcachefs/xattr.c
> > +++ b/fs/bcachefs/xattr.c
> > @@ -96,6 +96,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey=
_s_c k,
> >                        c, xattr_invalid_type,
> >                        "invalid type (%u)", xattr.v->x_type);
> >
> > +     pr_info("__struct_size(x_name): %lu", __struct_size(xattr.v->x_na=
me));
> >       bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_le=
n),
> >                        c, xattr_name_invalid_chars,
> >                        "xattr name has invalid characters");
> > diff --git a/include/linux/compiler_types.h b/include/linux/compiler_ty=
pes.h
> > index f14c275950b5..43ac0bca485d 100644
> > --- a/include/linux/compiler_types.h
> > +++ b/include/linux/compiler_types.h
> > @@ -413,7 +413,7 @@ struct ftrace_likely_data {
> >   * When the size of an allocated object is needed, use the best availa=
ble
> >   * mechanism to find it. (For cases where sizeof() cannot be used.)
> >   */
> > -#if __has_builtin(__builtin_dynamic_object_size)
> > +#if __has_builtin(__builtin_dynamic_object_size) && !defined(__clang__=
)
> >  #define __struct_size(p)     __builtin_dynamic_object_size(p, 0)
> >  #define __member_size(p)     __builtin_dynamic_object_size(p, 1)
> >  #else
> >
> >
> > Here's the generated assembly for this:
> >
> >       mov     rdi, offset .L.str.3
> >       mov     rsi, offset .L__func__.bch2_xattr_validate
> >       mov     r12, rdx
> >       mov     rdx, -1
> >       call    _printk
> >       mov     rax, r12
> >       movzx   esi, ah
> >       movzx   edx, byte ptr [r12 + 1]
> >       cmp     rsi, rdx
> >       jb      .LBB4_15
> > # %bb.11:
> >       lea     rdi, [rax + 4]
> >       xor     ebx, ebx
> >       xor     esi, esi
> >       call    memchr
> >
> > So for the printk it hardcoded -1 (aka 0xFFFFF... 64 bit long int max)
> > as the result of __struct_size. But then for before call to memchr it d=
oes
> > the same stuff again and puts the second least significant byte of the =
memory
> > address of x_type in esi, only to then load the correct value of x_name=
_len
> > into edx and compares them for the bounds-check.
> >
>
>
> __builtin_object_size should only ever be compile time known, right? So
> it looks like this is pretty broken atm.
>
> I think until this stuff is fixed in clang the only real option is:
>
> --
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler=
_attributes.h
> index 32284cd26d52..bc5ee8ab4d21 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -101,7 +101,7 @@
>   *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D108896
>   * clang: https://github.com/llvm/llvm-project/pull/76348
>   */
> -#if __has_attribute(__counted_by__)
> +#if __has_attribute(__counted_by__) && !defined(__clang__)
>  # define __counted_by(member)          __attribute__((__counted_by__(mem=
ber)))
>  #else
>  # define __counted_by(member)
>
