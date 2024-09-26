Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB3313B5B4;
	Thu, 26 Sep 2024 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727370083; cv=none; b=KzesHh1XEusd+jNCHpUzndV5qNBGgu5XeLYSb7K1guGK9Lc/JG7ft0R0Y+GWve4vvHGVbGuGkToMelEtIrKz+mFU4FoaoB39gOS3CB+/UlIaQWN9caw15qGQV9q2QoNf4IMjReFLYS+9N8BLu61Wi7kS4nTz7GpaRcGyYJLUMM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727370083; c=relaxed/simple;
	bh=LMAchIt46jsNMmWdOpmkfAkCZl4l1fWbdJ7aeUS5LRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ci/lMZrqvZ78t5Ar4oFiCc5ox3xH1ZuhWsTKRnjuY7SYoFvdTxQlz8JPZom5MiGA8dQD75gNtnSC739/FPLaIyErNrK+S8NViC+RTdTFoY9nfaWW+VifuXRtyufwltUTtiPD7fBbgX2pc3ZF2EBb0s7FXL2nj0kN3L1d0VPDGtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=qjEw/0pq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ll8OmUtD; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="qjEw/0pq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ll8OmUtD"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id AF747138010C;
	Thu, 26 Sep 2024 13:01:20 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 26 Sep 2024 13:01:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727370080; x=1727456480; bh=4fSFLCINFt
	7cgtytZlqcRKAfL/4/3naIxELDwHMAFDw=; b=qjEw/0pqiTsCj+Rkhy3M1seuNn
	yL70lXfKUllFAHEgxdHshheMPKp5wm9D6uSez/zjMRRZMW7qcRvjfO8wi68F93MI
	KQ7ht+mCHdauxB+9ppj/K/SSYeW9GU+kLPFVrcyrqcJSvv2S/8QxTcBKmQDuvQX5
	I8zBdbbuq/+7ojZcLG8EMi80pM6B801Bj6b8Ee1y4D86CJy5fDeZBg/zAMxxMQS1
	rJBYXf6EnLbWdLCAGfm0cC67CFToFRg0l25Mc8wKw/e10f+1VOpD4A2Kdy0UF218
	UtFd9HF60GX27IhjxVijpr26JWGDFBDqBpo9W4dQ9+qzk5641c0zxFPbz/0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727370080; x=1727456480; bh=4fSFLCINFt7cgtytZlqcRKAfL/4/
	3naIxELDwHMAFDw=; b=ll8OmUtDJb7yptTkfe/Pfeb2NkuWJqdxtX0fwgKs48hs
	z6RZAyj7t0AhOC6ldvLQOzYZ8/HdaaU8bXBFkRMQ1BiOISBqY6NyFSFxQMXKbHub
	V+vpIhZz7a5jS79OPZjPE5s7SHC5VQwd6iNX0BXDW1M8XySdfofsUwA45UWi5Dp0
	YNE1w0RnzhPT9jqBPvJpVl6EZX7N8BqfAF7P1ejk8HPq6zTZ//s0Ae5meSs8rGFB
	3eBijOlogjz3T2zfewGtlRVyodjC6R2OYMfZv/k6wnUV/O8oem+XjwA/8OY4+dov
	Wj+yg+iWkEEoduAuXBQItfqINCq/wz5u8m3GalOe6Q==
X-ME-Sender: <xms:YJP1ZjQlPi9qUxQ_JIwTV-R5kjKN1FZMoz2f6f84IB3pVXkqhd9G-A>
    <xme:YJP1ZkyryJ5Q6yNt9_pe6h-FEwvFbU-20UkRQ81G6yfuFMkKg3UgKiYNSQ-Iy9Kh4
    mRWiLusU2vVyV00WwQ>
X-ME-Received: <xmr:YJP1Zo2Px66EnqAhGY7XQnuxuotukpT9dKhMZxCx82TjPvEOVijB-Bmj9ur40sTLBvcMepJI8BFTuhA04dE6Ra0e9NyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddtjedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenfghrlhcuvffnffculddutddmnecujfgurhepfffhvfevuffk
    fhggtggujgesthdtredttddtvdenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepffdutedt
    ieduudetjeegjeeujeegjeeuheettdetieevvdevffekjeejueehgefhnecuffhomhgrih
    hnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttg
    dpnhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhh
    ohhrshhtvghnrdgslhhumhesthhosghluhigrdgtohhmpdhrtghpthhtohepkhgvnhhtrd
    hovhgvrhhsthhrvggvtheslhhinhhugidruggvvhdprhgtphhtthhopehrvghgrhgvshhs
    ihhonhhssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqsg
    gtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqhhgrrhguvghnihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:YJP1ZjA50JbPmn11HOaGx90eg5l2A_HqJ_cXA65O7YiwdCFKJM3tRw>
    <xmx:YJP1Zsg9jd54JyZMmJyvWWWQ-Z3gMZ3HPzYZlaypnzb-rRnxNNj7OQ>
    <xmx:YJP1Znqa64xuBCBB-QnK2FR8Hl4_gQ_hXxiaK4ZcyYr-F7NzYRPVOg>
    <xmx:YJP1ZnjzL1RCZc1dXAI2NJnJIqLbN1bgVkTtpscV3eUKlT2LhDBvBg>
    <xmx:YJP1ZnU_D4I5uTIGwx3eIaL5ka9OK4nm1VfVyp82D99TysISGgnQ39hp>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Sep 2024 13:01:19 -0400 (EDT)
Date: Thu, 26 Sep 2024 19:01:17 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: kent.overstreet@linux.dev, regressions@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZvWTXaqkmxP2E2dc@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>

On 26 18:09:57, Thorsten Blum wrote:
> On 26. Sep 2024, at 17:28, Thorsten Blum <thorsten.blum@toblux.com> wrote:
> > On 26. Sep 2024, at 17:14, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >> 
> >> Hi Kent,
> >> 
> >> found a strange regression in the patch set for 6.12.
> >> 
> >> First bad commit is: 86e92eeeb23741a072fe7532db663250ff2e726a
> >> bcachefs: Annotate struct bch_xattr with __counted_by()
> >> 
> >> When compiling with clang 18.1.8 (also with latest llvm main branch) and
> >> CONFIG_FORTIFY_SOURCE=y my rootfs does not mount because there is an erroneous
> >> detection of a buffer overflow.
> >> 
> >> The __counted_by attribute is supposed to be supported starting with gcc 15,
> >> not sure if it is implemented yet so I haven't tested with gcc trunk yet.
> >> 
> >> Here's the relevant section of dmesg:
> >> 
> >> [    6.248736] bcachefs (nvme1n1p2): starting version 1.12: rebalance_work_acct_fix
> >> [    6.248744] bcachefs (nvme1n1p2): recovering from clean shutdown, journal seq 1305969
> >> [    6.252374] ------------[ cut here ]------------
> >> [    6.252375] memchr: detected buffer overflow: 12 byte read of buffer size 0
> >> [    6.252379] WARNING: CPU: 18 PID: 511 at lib/string_helpers.c:1033 __fortify_report+0x45/0x50
> >> [    6.252383] Modules linked in: bcachefs lz4hc_compress lz4_compress hid_generic usbhid btrfs crct10dif_pclmul libcrc32c crc32_pclmul crc32c_generic polyval_clmulni crc32c_intel polyval_generic raid6_pq ghash_clmulni_intel xor sha512_ssse3 sha256_ssse3 sha1_ssse3 aesni_intel gf128mul nvme crypto_simd ccp xhci_pci cryptd sp5100_tco xhci_pci_renesas nvme_core nvme_auth video wmi ip6_tables ip_tables x_tables i2c_dev
> >> [    6.252404] CPU: 18 UID: 0 PID: 511 Comm: mount Not tainted 6.11.0-10065-g6fa6588e5964 #98 d8e0beb515d91b387aa60970de7203f35ddd182c
> >> [    6.252406] Hardware name: Micro-Star International Co., Ltd. MS-7D78/PRO B650-P WIFI (MS-7D78), BIOS 1.C0 02/06/2024
> >> [    6.252407] RIP: 0010:__fortify_report+0x45/0x50
> >> [    6.252409] Code: 48 8b 34 c5 30 92 21 87 40 f6 c7 01 48 c7 c0 75 1b 0a 87 48 c7 c1 e1 93 07 87 48 0f 44 c8 48 c7 c7 ef 03 10 87 e8 0b c2 9b ff <0f> 0b e9 cf 5d 9e 00 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90
> >> [    6.252410] RSP: 0018:ffffbb3d03aff350 EFLAGS: 00010246
> >> [    6.252412] RAX: 4ce590fb7c372800 RBX: ffff98d559a400e8 RCX: 0000000000000027
> >> [    6.252413] RDX: 0000000000000002 RSI: 00000000ffffdfff RDI: ffff98e43db21a08
> >> [    6.252414] RBP: ffff98d559a400d0 R08: 0000000000001fff R09: ffff98e47ddcd000
> >> [    6.252415] R10: 0000000000005ffd R11: 0000000000000004 R12: ffff98d559a40000
> >> [    6.252416] R13: ffff98d54abf1320 R14: ffffbb3d03aff430 R15: 0000000000000000
> >> [    6.252417] FS:  00007efc82117800(0000) GS:ffff98e43db00000(0000) knlGS:0000000000000000
> >> [    6.252418] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [    6.252419] CR2: 000055d96658ea80 CR3: 000000010a12c000 CR4: 0000000000f50ef0
> >> [    6.252420] PKRU: 55555554
> >> [    6.252421] Call Trace:
> >> [    6.252423]  <TASK>
> >> [    6.252425]  ? __warn+0xd5/0x1d0
> >> [    6.252427]  ? __fortify_report+0x45/0x50
> >> [    6.252429]  ? report_bug+0x144/0x1f0
> >> [    6.252431]  ? __fortify_report+0x45/0x50
> >> [    6.252433]  ? handle_bug+0x6a/0x90
> >> [    6.252435]  ? exc_invalid_op+0x1a/0x50
> >> [    6.252436]  ? asm_exc_invalid_op+0x1a/0x20
> >> [    6.252440]  ? __fortify_report+0x45/0x50
> >> [    6.252441]  __fortify_panic+0x9/0x10
> >> [    6.252443]  bch2_xattr_validate+0x13b/0x140 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> >> [    6.252463]  bch2_btree_node_read_done+0x125a/0x17a0 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> >> [    6.252482]  btree_node_read_work+0x202/0x4a0 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> >> [    6.252499]  bch2_btree_node_read+0xa8d/0xb20 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> >> [    6.252514]  ? srso_alias_return_thunk+0x5/0xfbef5
> >> [    6.252515]  ? pcpu_alloc_noprof+0x741/0xb50
> >> [    6.252517]  ? srso_alias_return_thunk+0x5/0xfbef5
> >> [    6.252519]  ? time_stats_update_one+0x75/0x1f0 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> >> 
> >> ...
> >> 
> >> 
> >> The memchr in question is at:
> >> https://github.com/torvalds/linux/blob/11a299a7933e03c83818b431e6a1c53ad387423d/fs/bcachefs/xattr.c#L99
> >> 
> >> There is not actually a buffer overflow here, I checked with gdb that
> >> xattr.v->x_name does actually contain a string of the correct length and
> >> xattr.v->x_name_len contains the correct length and should be used to determine
> >> the length when memchr uses __struct_size for bounds-checking due to the
> >> __counted_by annotation.
> >> 
> >> I'm at the point where I think this is probably a bug in clang. I have a patch
> >> that does fix (more like bandaid) the problem and adds some print statements:
> >> 
> >> --
> >> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> >> index 56c8d3fe55a4..8d7e749b7dda 100644
> >> --- a/fs/bcachefs/xattr.c
> >> +++ b/fs/bcachefs/xattr.c
> >> @@ -74,6 +74,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
> >>      enum bch_validate_flags flags)
> >> {
> >> struct bkey_s_c_xattr xattr = bkey_s_c_to_xattr(k);
> >> + const struct bch_xattr *v = (void *)k.v;
> >> unsigned val_u64s = xattr_val_u64s(xattr.v->x_name_len,
> >>  le16_to_cpu(xattr.v->x_val_len));
> >> int ret = 0;
> >> @@ -94,9 +95,12 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
> >> 
> >> bkey_fsck_err_on(!bch2_xattr_type_to_handler(xattr.v->x_type),
> >> c, xattr_invalid_type,
> >> - "invalid type (%u)", xattr.v->x_type);
> >> + "invalid type (%u)", v->x_type);
> >> 
> >> - bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
> >> + pr_info("x_name_len: %d", v->x_name_len);
> >> + pr_info("__struct_size(x_name): %ld", __struct_size(v->x_name));
> >> + pr_info("__struct_size(x_name): %ld", __struct_size(xattr.v->x_name));
> >> + bkey_fsck_err_on(memchr(v->x_name, '\0', v->x_name_len),
> >> c, xattr_name_invalid_chars,
> >> "xattr name has invalid characters");
> >> fsck_err:
> >> --
> >> 
> >> 
> >> Making memchr access via a pointer created with
> >> const struct bch_xattr *v = (void *)k.v fixes it. From the print statements I
> >> can see that __struct_size(xattr.v->x_name) incorrectly returns 0, while
> >> __struct_size(v->x_name) correctly returns 10 in this case (the value of
> >> x_name_len).
> >> 
> >> The generated assembly illustrates what is going wrong. Below is an excerpt
> >> of the assembly clang generated for the bch2_xattr_validate function:
> >> 
> >> mov r13d, ecx
> >> mov r15, rdi
> >> mov r14, rsi
> >> mov rdi, offset .L.str.3
> >> mov rsi, offset .L__func__.bch2_xattr_validate
> >> mov rbx, rdx
> >> mov edx, eax
> >> call _printk
> >> movzx edx, byte ptr [rbx + 1]
> >> mov rdi, offset .L.str.4
> >> mov rsi, offset .L__func__.bch2_xattr_validate
> >> call _printk
> >> movzx edx, bh
> >> mov rdi, offset .L.str.4
> >> mov rsi, offset .L__func__.bch2_xattr_validate
> >> call _printk
> >> lea rdi, [rbx + 4]
> >> mov r12, rbx
> >> movzx edx, byte ptr [rbx + 1]
> >> xor ebx, ebx
> >> xor esi, esi
> >> call memchr
> >> 
> >> At the start of this rdx contains k.v (and is moved into rbx). The three calls
> >> to printk are the ones you can see in my patch. You can see that for the
> >> print that uses __struct_size(v->x_name) the compiler correctly uses
> >> movzx edx, byte ptr [rbx + 1]
> >> to load x_name_len into edx.
> >> 
> >> For the printk call that uses __struct_size(xattr.v->x_name) however the
> >> compiler uses
> >> movzx edx, bh
> >> So it will print the high 8 bits of the lower 16 bits (second least
> >> significant byte) of the memory address of xattr.v->x_type. This is obviously
> >> completely wrong.
> >> 
> >> It is then doing the correct call of memchr because this is using my patch.
> >> Without my patch it would be doing the same thing for the call to memchr where
> >> it uses the second least significant byte of the memory address of x_type as the
> >> length used for the bounds-check.
> >> 
> >> 
> >> 
> >> The LLVM IR also shows the same problem:
> >> 
> >> define internal zeroext i1 @xattr_cmp_key(ptr nocapture readnone %0, ptr %1, ptr nocapture noundef readonly %2) #0 align 16 {
> >> [...]
> >> %51 = ptrtoint ptr %2 to i64
> >> %52 = lshr i64 %51, 8
> >> %53 = and i64 %52, 255
> >> 
> >> This is the IR for the incorrect behavior. It simply converts the pointer to an
> >> int, shifts right by 8 bits, then and with 0xFF. If it did a load (to i64)
> >> instead of ptrtoint this would actually work, as the second least significant
> >> bit of an i64 loaded from that memory address does contain the value of
> >> x_name_len. It's as if clang forgot to dereference a pointer here.
> >> 
> >> Correct IR does this (for the other printk invocation):
> >> 
> >> define internal zeroext i1 @xattr_cmp_key(ptr nocapture readnone %0, ptr %1, ptr nocapture noundef readonly %2) #0 align 16 {
> >> [...]
> >> %4 = getelementptr inbounds %struct.bch_xattr, ptr %1, i64 0, i32 1
> >> %5 = load i8, ptr %4, align 8
> >> [...]
> >> %48 = load i8, ptr %5, align 4
> >> %49 = zext i8 %48 to i64
> >> 
> >> Best Regards
> >> Jan
> > 
> > I suspect it's the same Clang __bdos() "bug" as in [1] and [2].
> > 
> > [1] https://lore.kernel.org/linux-kernel/3D0816D1-0807-4D37-8D5F-3C55CA910FAA@linux.dev/
> > [2] https://lore.kernel.org/all/20240913164630.GA4091534@thelio-3990X/
> 
> Could you try this and see if it resolves the problem?
> 
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index 1a957ea2f4fe..b09759f31789 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -413,7 +413,7 @@ struct ftrace_likely_data {
>   * When the size of an allocated object is needed, use the best available
>   * mechanism to find it. (For cases where sizeof() cannot be used.)
>   */
> -#if __has_builtin(__builtin_dynamic_object_size)
> +#if __has_builtin(__builtin_dynamic_object_size) && !defined(__clang__)
>  #define __struct_size(p)	__builtin_dynamic_object_size(p, 0)
>  #define __member_size(p)	__builtin_dynamic_object_size(p, 1)
>  #else
> 

Alright after looking at it in the debugger the code it generates now is
just wild.

I added one more printk before the call to memchr like so:

diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 56c8d3fe55a4..3c7c479ea3a8 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -96,6 +96,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
 			 c, xattr_invalid_type,
 			 "invalid type (%u)", xattr.v->x_type);
 
+	pr_info("__struct_size(x_name): %lu", __struct_size(xattr.v->x_name));
 	bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
 			 c, xattr_name_invalid_chars,
 			 "xattr name has invalid characters");
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index f14c275950b5..43ac0bca485d 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -413,7 +413,7 @@ struct ftrace_likely_data {
  * When the size of an allocated object is needed, use the best available
  * mechanism to find it. (For cases where sizeof() cannot be used.)
  */
-#if __has_builtin(__builtin_dynamic_object_size)
+#if __has_builtin(__builtin_dynamic_object_size) && !defined(__clang__)
 #define __struct_size(p)	__builtin_dynamic_object_size(p, 0)
 #define __member_size(p)	__builtin_dynamic_object_size(p, 1)
 #else


Here's the generated assembly for this:

	mov	rdi, offset .L.str.3
	mov	rsi, offset .L__func__.bch2_xattr_validate
	mov	r12, rdx
	mov	rdx, -1
	call	_printk
	mov	rax, r12
	movzx	esi, ah
	movzx	edx, byte ptr [r12 + 1]
	cmp	rsi, rdx
	jb	.LBB4_15
# %bb.11:
	lea	rdi, [rax + 4]
	xor	ebx, ebx
	xor	esi, esi
	call	memchr

So for the printk it hardcoded -1 (aka 0xFFFFF... 64 bit long int max)
as the result of __struct_size. But then for before call to memchr it does
the same stuff again and puts the second least significant byte of the memory
address of x_type in esi, only to then load the correct value of x_name_len
into edx and compares them for the bounds-check.

Best Regards
Jan
