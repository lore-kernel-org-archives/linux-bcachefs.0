Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B7C16E895;
	Fri, 27 Sep 2024 03:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727408470; cv=none; b=Nr0sTqyEB8eBRq/LCKz5ynXxAVNO92FNyaWTqAIiCCLlpz9hWA/saL2Cvo5T9UfAXZ+cG9/nJVdUQpbeNRc9icLT7++yGCRN48zXwvenO6Nya/JZVI/6alwnP/mdsSzsUSyWfG/R6wmhyCAAjz/8Srgd/Lr8AY7dxLD4w4nzkiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727408470; c=relaxed/simple;
	bh=CfM+8umYcgbeI5fPSxMGFAh7YcHh3hAgZxR9NQetyg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzPKXXdJxArSkBj+YlME5z8RbSO9o/iiqC8yk4sr0+vcLAm55V3pZv138O6biTmfXfuDx4IfJqLQDNV/kZ0D88V2l+OymtyvwZCsB+G+CiCWutspOzS3sPyxeK5JDGtwhUeLKQ4IeX06Aqt0qqnEYJeoiq5wmb6Ffnhy/gxtO9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=dhlBIa+w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LjSHIAqE; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="dhlBIa+w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LjSHIAqE"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3000011402F4;
	Thu, 26 Sep 2024 23:41:06 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 26 Sep 2024 23:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1727408466;
	 x=1727494866; bh=5X0WCO4A0mw0UpCdB2VJoM5+1iglP5iygbdf1R08AYw=; b=
	dhlBIa+wfwIXUUKqLebXOkNpxr/FcKnUOkuSPYLb5CAZuSSeJaLjeSFM30O7P1us
	6WVTmSQkA9OeNg5WHHKlJ08w7gYfPLeUYR0sJLiZt+yTz4VlomjYPsIcwIRh2R3g
	LcNZPEdHoWcUx6/CwJN8UBQnxBmi0aAcnGM1dXaTXHnpUQkOZbl/TfDtcWHhXHVA
	S7PHikPRC5Z1K9HMJmRBpYdEMfHrEn66VLb45skxNfj8/NlNoEVr2IU9bVjzplFk
	a/x8PzwwpKioHXVaNz4ysp59X3eVde+/LTO4Roq5hsOHt7+KCpQnT+7Kw1e8crkt
	1G7R3qccr43IfjimUthzIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1727408466; x=
	1727494866; bh=5X0WCO4A0mw0UpCdB2VJoM5+1iglP5iygbdf1R08AYw=; b=L
	jSHIAqE5K98VL5v2nlS/bkYtdbL+0/TTJbLxWfjAdHz3YSB8RB4N8Lkoc4B7/W6M
	Pmkhy0jN568xdpPmxAgOLMgo40PgAb2ssyMlxwjA3fURuqRdbrZl1obyUIlMzFVb
	G2Tq716UMkJUMmJ9lX9lmFtG95A0N4UiPR55dFYSKwB+EYgGpZzTRh3DSmaMAU21
	fwwVFeqknCvJTaowufDSwqK/rcTRjiy1SxGxePDM3CEPhIUu/srtCXEDz9iS7ydy
	+lua3iY7bqmkcmu1YqFP5PCuF8UQM36SJXRXtMKOhuiaP05iL/pREk/chCQ6abqS
	s3yamPMvgzL5isKW9g9lg==
X-ME-Sender: <xms:USn2ZvJxmmWbQ7jipu9f3RgvNQREoJK2BwEn6r7uV2oGI74pFcEZQQ>
    <xme:USn2ZjIMMDS8LfmjgLWeMsRRMWRSFkHqMQ2DVf5MpBjk3ocI5Y2g1oorJ8XtXsiPx
    Uwtcwb4MVQgw_ytWVU>
X-ME-Received: <xmr:USn2Znt14vQTMga4y-NNCsqt5fiIjn5heHe-jX0pK3cjL11TA5mmf2sKY7pA3cKUJvpvwwbFIUEvUG3X1wPwxqgURnsh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddtkedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhf
    gggtugfgjgesthekredttddtjeenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnheptdejveeg
    ffffjedtueeffeefudduueegudevieehgfetgeekueeuuddvhfeffeehnecuffhomhgrih
    hnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttg
    dpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhho
    rhgsohesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprghruggssehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehkvggvsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhh
    ohhrshhtvghnrdgslhhumhesthhosghluhigrdgtohhmpdhrtghpthhtohepkhgvnhhtrd
    hovhgvrhhsthhrvggvtheslhhinhhugidruggvvhdprhgtphhtthhopehrvghgrhgvshhs
    ihhonhhssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqsg
    gtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqhhgrrhguvghnihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:USn2ZobzP_ZLFfZL2jVHrcsMfgUTgdS6DNkEHkVW5QL0v6B72iiCPw>
    <xmx:USn2ZmbY0D1fDwjMcRYYvpEzmTaXtt-PIypY_wZrcGiAqNZyGYU9jg>
    <xmx:USn2ZsBjRmf3Ncp2veSaJis1XWfGyUToNNqlizXH3B4oQ_qz3PSKmw>
    <xmx:USn2ZkaKNB5oYowwk1N3X7O1UD9xKILrepjLlDyayw1jjqIoGR6dVw>
    <xmx:Uin2ZskB8bvK1wFra66KzOE1HspU9Lzdq-3VWpAul3p_CPsQMga4fIx0>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Sep 2024 23:41:04 -0400 (EDT)
Date: Fri, 27 Sep 2024 05:41:02 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Bill Wendling <morbo@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZvYpTkzJe2qKy-0N@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <ZvWTXaqkmxP2E2dc@archlinux>
 <ZvWd0aK7p_1rkb7E@archlinux>
 <CAMj1kXFV+Jck9Yf4w18rOzHckXvpXkhPhL-KrpBC8hqgXusw2g@mail.gmail.com>
 <CAGG=3QXG+Vsm7mjLV42Q-uA-EvgfOehSUeNQjKA3QQbw8vqSCg@mail.gmail.com>
 <CAGG=3QVWCQB-3sM=iwgTmX8zrU81H+F_A1icJwROvW_DSvsBeA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG=3QVWCQB-3sM=iwgTmX8zrU81H+F_A1icJwROvW_DSvsBeA@mail.gmail.com>

On 26 18:30:15, Bill Wendling wrote:
> On Thu, Sep 26, 2024 at 3:18 PM Bill Wendling <morbo@google.com> wrote:
> >
> > On Thu, Sep 26, 2024 at 12:58 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > (cc Kees and Bill)
> > >
> > > On Thu, 26 Sept 2024 at 19:46, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > > >
> > > > On 26 19:01:20, Jan Hendrik Farr wrote:
> > > > > On 26 18:09:57, Thorsten Blum wrote:
> > > > > > On 26. Sep 2024, at 17:28, Thorsten Blum <thorsten.blum@toblux.com> wrote:
> > > > > > > On 26. Sep 2024, at 17:14, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > > > > > >>
> > > > > > >> Hi Kent,
> > > > > > >>
> > > > > > >> found a strange regression in the patch set for 6.12.
> > > > > > >>
> > > > > > >> First bad commit is: 86e92eeeb23741a072fe7532db663250ff2e726a
> > > > > > >> bcachefs: Annotate struct bch_xattr with __counted_by()
> > > > > > >>
> > > > > > >> When compiling with clang 18.1.8 (also with latest llvm main branch) and
> > > > > > >> CONFIG_FORTIFY_SOURCE=y my rootfs does not mount because there is an erroneous
> > > > > > >> detection of a buffer overflow.
> > > > > > >>
> > > > > > >> The __counted_by attribute is supposed to be supported starting with gcc 15,
> > > > > > >> not sure if it is implemented yet so I haven't tested with gcc trunk yet.
> > > > > > >>
> > > > > > >> Here's the relevant section of dmesg:
> > > > > > >>
> > > > > > >> [    6.248736] bcachefs (nvme1n1p2): starting version 1.12: rebalance_work_acct_fix
> > > > > > >> [    6.248744] bcachefs (nvme1n1p2): recovering from clean shutdown, journal seq 1305969
> > > > > > >> [    6.252374] ------------[ cut here ]------------
> > > > > > >> [    6.252375] memchr: detected buffer overflow: 12 byte read of buffer size 0
> > > > > > >> [    6.252379] WARNING: CPU: 18 PID: 511 at lib/string_helpers.c:1033 __fortify_report+0x45/0x50
> > > > > > >> [    6.252383] Modules linked in: bcachefs lz4hc_compress lz4_compress hid_generic usbhid btrfs crct10dif_pclmul libcrc32c crc32_pclmul crc32c_generic polyval_clmulni crc32c_intel polyval_generic raid6_pq ghash_clmulni_intel xor sha512_ssse3 sha256_ssse3 sha1_ssse3 aesni_intel gf128mul nvme crypto_simd ccp xhci_pci cryptd sp5100_tco xhci_pci_renesas nvme_core nvme_auth video wmi ip6_tables ip_tables x_tables i2c_dev
> > > > > > >> [    6.252404] CPU: 18 UID: 0 PID: 511 Comm: mount Not tainted 6.11.0-10065-g6fa6588e5964 #98 d8e0beb515d91b387aa60970de7203f35ddd182c
> > > > > > >> [    6.252406] Hardware name: Micro-Star International Co., Ltd. MS-7D78/PRO B650-P WIFI (MS-7D78), BIOS 1.C0 02/06/2024
> > > > > > >> [    6.252407] RIP: 0010:__fortify_report+0x45/0x50
> > > > > > >> [    6.252409] Code: 48 8b 34 c5 30 92 21 87 40 f6 c7 01 48 c7 c0 75 1b 0a 87 48 c7 c1 e1 93 07 87 48 0f 44 c8 48 c7 c7 ef 03 10 87 e8 0b c2 9b ff <0f> 0b e9 cf 5d 9e 00 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90
> > > > > > >> [    6.252410] RSP: 0018:ffffbb3d03aff350 EFLAGS: 00010246
> > > > > > >> [    6.252412] RAX: 4ce590fb7c372800 RBX: ffff98d559a400e8 RCX: 0000000000000027
> > > > > > >> [    6.252413] RDX: 0000000000000002 RSI: 00000000ffffdfff RDI: ffff98e43db21a08
> > > > > > >> [    6.252414] RBP: ffff98d559a400d0 R08: 0000000000001fff R09: ffff98e47ddcd000
> > > > > > >> [    6.252415] R10: 0000000000005ffd R11: 0000000000000004 R12: ffff98d559a40000
> > > > > > >> [    6.252416] R13: ffff98d54abf1320 R14: ffffbb3d03aff430 R15: 0000000000000000
> > > > > > >> [    6.252417] FS:  00007efc82117800(0000) GS:ffff98e43db00000(0000) knlGS:0000000000000000
> > > > > > >> [    6.252418] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > > >> [    6.252419] CR2: 000055d96658ea80 CR3: 000000010a12c000 CR4: 0000000000f50ef0
> > > > > > >> [    6.252420] PKRU: 55555554
> > > > > > >> [    6.252421] Call Trace:
> > > > > > >> [    6.252423]  <TASK>
> > > > > > >> [    6.252425]  ? __warn+0xd5/0x1d0
> > > > > > >> [    6.252427]  ? __fortify_report+0x45/0x50
> > > > > > >> [    6.252429]  ? report_bug+0x144/0x1f0
> > > > > > >> [    6.252431]  ? __fortify_report+0x45/0x50
> > > > > > >> [    6.252433]  ? handle_bug+0x6a/0x90
> > > > > > >> [    6.252435]  ? exc_invalid_op+0x1a/0x50
> > > > > > >> [    6.252436]  ? asm_exc_invalid_op+0x1a/0x20
> > > > > > >> [    6.252440]  ? __fortify_report+0x45/0x50
> > > > > > >> [    6.252441]  __fortify_panic+0x9/0x10
> > > > > > >> [    6.252443]  bch2_xattr_validate+0x13b/0x140 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> > > > > > >> [    6.252463]  bch2_btree_node_read_done+0x125a/0x17a0 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> > > > > > >> [    6.252482]  btree_node_read_work+0x202/0x4a0 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> > > > > > >> [    6.252499]  bch2_btree_node_read+0xa8d/0xb20 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> > > > > > >> [    6.252514]  ? srso_alias_return_thunk+0x5/0xfbef5
> > > > > > >> [    6.252515]  ? pcpu_alloc_noprof+0x741/0xb50
> > > > > > >> [    6.252517]  ? srso_alias_return_thunk+0x5/0xfbef5
> > > > > > >> [    6.252519]  ? time_stats_update_one+0x75/0x1f0 [bcachefs 8361179bbfcc59e669df38aec976f02d7211a659]
> > > > > > >>
> > > > > > >> ...
> > > > > > >>
> > > > > > >>
> > > > > > >> The memchr in question is at:
> > > > > > >> https://github.com/torvalds/linux/blob/11a299a7933e03c83818b431e6a1c53ad387423d/fs/bcachefs/xattr.c#L99
> > > > > > >>
> > > > > > >> There is not actually a buffer overflow here, I checked with gdb that
> > > > > > >> xattr.v->x_name does actually contain a string of the correct length and
> > > > > > >> xattr.v->x_name_len contains the correct length and should be used to determine
> > > > > > >> the length when memchr uses __struct_size for bounds-checking due to the
> > > > > > >> __counted_by annotation.
> > > > > > >>
> > > > > > >> I'm at the point where I think this is probably a bug in clang. I have a patch
> > > > > > >> that does fix (more like bandaid) the problem and adds some print statements:
> > > > > > >>
> > > > > > >> --
> > > > > > >> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> > > > > > >> index 56c8d3fe55a4..8d7e749b7dda 100644
> > > > > > >> --- a/fs/bcachefs/xattr.c
> > > > > > >> +++ b/fs/bcachefs/xattr.c
> > > > > > >> @@ -74,6 +74,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
> > > > > > >>      enum bch_validate_flags flags)
> > > > > > >> {
> > > > > > >> struct bkey_s_c_xattr xattr = bkey_s_c_to_xattr(k);
> > > > > > >> + const struct bch_xattr *v = (void *)k.v;
> > > > > > >> unsigned val_u64s = xattr_val_u64s(xattr.v->x_name_len,
> > > > > > >>  le16_to_cpu(xattr.v->x_val_len));
> > > > > > >> int ret = 0;
> > > > > > >> @@ -94,9 +95,12 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
> > > > > > >>
> > > > > > >> bkey_fsck_err_on(!bch2_xattr_type_to_handler(xattr.v->x_type),
> > > > > > >> c, xattr_invalid_type,
> > > > > > >> - "invalid type (%u)", xattr.v->x_type);
> > > > > > >> + "invalid type (%u)", v->x_type);
> > > > > > >>
> > > > > > >> - bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
> > > > > > >> + pr_info("x_name_len: %d", v->x_name_len);
> > > > > > >> + pr_info("__struct_size(x_name): %ld", __struct_size(v->x_name));
> > > > > > >> + pr_info("__struct_size(x_name): %ld", __struct_size(xattr.v->x_name));
> > > > > > >> + bkey_fsck_err_on(memchr(v->x_name, '\0', v->x_name_len),
> > > > > > >> c, xattr_name_invalid_chars,
> > > > > > >> "xattr name has invalid characters");
> > > > > > >> fsck_err:
> > > > > > >> --
> > > > > > >>
> > > > > > >>
> > > > > > >> Making memchr access via a pointer created with
> > > > > > >> const struct bch_xattr *v = (void *)k.v fixes it. From the print statements I
> > > > > > >> can see that __struct_size(xattr.v->x_name) incorrectly returns 0, while
> > > > > > >> __struct_size(v->x_name) correctly returns 10 in this case (the value of
> > > > > > >> x_name_len).
> > > > > > >>
> > > > > > >> The generated assembly illustrates what is going wrong. Below is an excerpt
> > > > > > >> of the assembly clang generated for the bch2_xattr_validate function:
> > > > > > >>
> > > > > > >> mov r13d, ecx
> > > > > > >> mov r15, rdi
> > > > > > >> mov r14, rsi
> > > > > > >> mov rdi, offset .L.str.3
> > > > > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > > > > >> mov rbx, rdx
> > > > > > >> mov edx, eax
> > > > > > >> call _printk
> > > > > > >> movzx edx, byte ptr [rbx + 1]
> > > > > > >> mov rdi, offset .L.str.4
> > > > > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > > > > >> call _printk
> > > > > > >> movzx edx, bh
> > > > > > >> mov rdi, offset .L.str.4
> > > > > > >> mov rsi, offset .L__func__.bch2_xattr_validate
> > > > > > >> call _printk
> > > > > > >> lea rdi, [rbx + 4]
> > > > > > >> mov r12, rbx
> > > > > > >> movzx edx, byte ptr [rbx + 1]
> > > > > > >> xor ebx, ebx
> > > > > > >> xor esi, esi
> > > > > > >> call memchr
> > > > > > >>
> > > > > > >> At the start of this rdx contains k.v (and is moved into rbx). The three calls
> > > > > > >> to printk are the ones you can see in my patch. You can see that for the
> > > > > > >> print that uses __struct_size(v->x_name) the compiler correctly uses
> > > > > > >> movzx edx, byte ptr [rbx + 1]
> > > > > > >> to load x_name_len into edx.
> > > > > > >>
> > > > > > >> For the printk call that uses __struct_size(xattr.v->x_name) however the
> > > > > > >> compiler uses
> > > > > > >> movzx edx, bh
> > > > > > >> So it will print the high 8 bits of the lower 16 bits (second least
> > > > > > >> significant byte) of the memory address of xattr.v->x_type. This is obviously
> > > > > > >> completely wrong.
> > > > > > >>
> > > > > > >> It is then doing the correct call of memchr because this is using my patch.
> > > > > > >> Without my patch it would be doing the same thing for the call to memchr where
> > > > > > >> it uses the second least significant byte of the memory address of x_type as the
> > > > > > >> length used for the bounds-check.
> > > > > > >>
> > > > > > >>
> > > > > > >>
> > > > > > >> The LLVM IR also shows the same problem:
> > > > > > >>
> > > > > > >> define internal zeroext i1 @xattr_cmp_key(ptr nocapture readnone %0, ptr %1, ptr nocapture noundef readonly %2) #0 align 16 {
> > > > > > >> [...]
> > > > > > >> %51 = ptrtoint ptr %2 to i64
> > > > > > >> %52 = lshr i64 %51, 8
> > > > > > >> %53 = and i64 %52, 255
> > > > > > >>
> > > > > > >> This is the IR for the incorrect behavior. It simply converts the pointer to an
> > > > > > >> int, shifts right by 8 bits, then and with 0xFF. If it did a load (to i64)
> > > > > > >> instead of ptrtoint this would actually work, as the second least significant
> > > > > > >> bit of an i64 loaded from that memory address does contain the value of
> > > > > > >> x_name_len. It's as if clang forgot to dereference a pointer here.
> > > > > > >>
> > > > > > >> Correct IR does this (for the other printk invocation):
> > > > > > >>
> > > > > > >> define internal zeroext i1 @xattr_cmp_key(ptr nocapture readnone %0, ptr %1, ptr nocapture noundef readonly %2) #0 align 16 {
> > > > > > >> [...]
> > > > > > >> %4 = getelementptr inbounds %struct.bch_xattr, ptr %1, i64 0, i32 1
> > > > > > >> %5 = load i8, ptr %4, align 8
> > > > > > >> [...]
> > > > > > >> %48 = load i8, ptr %5, align 4
> > > > > > >> %49 = zext i8 %48 to i64
> > > > > > >>
> > > > > > >> Best Regards
> > > > > > >> Jan
> > > > > > >
> > > > > > > I suspect it's the same Clang __bdos() "bug" as in [1] and [2].
> > > > > > >
> > > > > > > [1] https://lore.kernel.org/linux-kernel/3D0816D1-0807-4D37-8D5F-3C55CA910FAA@linux.dev/
> > > > > > > [2] https://lore.kernel.org/all/20240913164630.GA4091534@thelio-3990X/
> > > > > >
> > > > > > Could you try this and see if it resolves the problem?
> > > > > >
> > > > > > diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> > > > > > index 1a957ea2f4fe..b09759f31789 100644
> > > > > > --- a/include/linux/compiler_types.h
> > > > > > +++ b/include/linux/compiler_types.h
> > > > > > @@ -413,7 +413,7 @@ struct ftrace_likely_data {
> > > > > >   * When the size of an allocated object is needed, use the best available
> > > > > >   * mechanism to find it. (For cases where sizeof() cannot be used.)
> > > > > >   */
> > > > > > -#if __has_builtin(__builtin_dynamic_object_size)
> > > > > > +#if __has_builtin(__builtin_dynamic_object_size) && !defined(__clang__)
> > > > > >  #define __struct_size(p)   __builtin_dynamic_object_size(p, 0)
> > > > > >  #define __member_size(p)   __builtin_dynamic_object_size(p, 1)
> > > > > >  #else
> > > > > >
> > > > >
> > > > > Alright after looking at it in the debugger the code it generates now is
> > > > > just wild.
> > > > >
> > > > > I added one more printk before the call to memchr like so:
> > > > >
> > > > > diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> > > > > index 56c8d3fe55a4..3c7c479ea3a8 100644
> > > > > --- a/fs/bcachefs/xattr.c
> > > > > +++ b/fs/bcachefs/xattr.c
> > > > > @@ -96,6 +96,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
> > > > >                        c, xattr_invalid_type,
> > > > >                        "invalid type (%u)", xattr.v->x_type);
> > > > >
> > > > > +     pr_info("__struct_size(x_name): %lu", __struct_size(xattr.v->x_name));
> > > > >       bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
> > > > >                        c, xattr_name_invalid_chars,
> > > > >                        "xattr name has invalid characters");
> > > > > diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> > > > > index f14c275950b5..43ac0bca485d 100644
> > > > > --- a/include/linux/compiler_types.h
> > > > > +++ b/include/linux/compiler_types.h
> > > > > @@ -413,7 +413,7 @@ struct ftrace_likely_data {
> > > > >   * When the size of an allocated object is needed, use the best available
> > > > >   * mechanism to find it. (For cases where sizeof() cannot be used.)
> > > > >   */
> > > > > -#if __has_builtin(__builtin_dynamic_object_size)
> > > > > +#if __has_builtin(__builtin_dynamic_object_size) && !defined(__clang__)
> > > > >  #define __struct_size(p)     __builtin_dynamic_object_size(p, 0)
> > > > >  #define __member_size(p)     __builtin_dynamic_object_size(p, 1)
> > > > >  #else
> > > > >
> > > > >
> > > > > Here's the generated assembly for this:
> > > > >
> > > > >       mov     rdi, offset .L.str.3
> > > > >       mov     rsi, offset .L__func__.bch2_xattr_validate
> > > > >       mov     r12, rdx
> > > > >       mov     rdx, -1
> > > > >       call    _printk
> > > > >       mov     rax, r12
> > > > >       movzx   esi, ah
> > > > >       movzx   edx, byte ptr [r12 + 1]
> > > > >       cmp     rsi, rdx
> > > > >       jb      .LBB4_15
> > > > > # %bb.11:
> > > > >       lea     rdi, [rax + 4]
> > > > >       xor     ebx, ebx
> > > > >       xor     esi, esi
> > > > >       call    memchr
> > > > >
> > > > > So for the printk it hardcoded -1 (aka 0xFFFFF... 64 bit long int max)
> > > > > as the result of __struct_size. But then for before call to memchr it does
> > > > > the same stuff again and puts the second least significant byte of the memory
> > > > > address of x_type in esi, only to then load the correct value of x_name_len
> > > > > into edx and compares them for the bounds-check.
> > > > >
> > > >
> > > >
> > > > __builtin_object_size should only ever be compile time known, right? So
> > > > it looks like this is pretty broken atm.
> > > >
> Right. It's __builtin_dynamic_object_size that's known during runtime.

Ok, so in the above example __struct_size was modified to use
__builtin_object_size instead of __builtin_dynamic_object_size. I would
expect clang to generate code that hardcodes the result of __struct_size
in that case. Why is it looking at any runtime values / pointers at all?


But this is getting a little bit off-track, as this was the code it
generated for a possible fix / workaround. Let's stick to the original problem
(as in my first mail in this thread):

The struct in question is

struct bch_xattr {
	struct bch_val		v;
	__u8			x_type;
	__u8			x_name_len;
	__le16			x_val_len;
	__u8			x_name[] __counted_by(x_name_len);
} __packed __aligned(8);

found in fs/bcachefs/xattr.c

Assume foo_ptr is a pointer to a struct bch_xattr:

My expectation is that __builtin_dynamic_object_size(foo_ptr->x_name, 0)
(aka __struct_size(foo_ptr->x_name)) will return the value of
foo_ptr->x_name_len known at runtime. This is also what the bounds-check of
memchr appears to be expecting:

__FORTIFY_INLINE __diagnose_as(__builtin_memchr, 1, 2, 3)
void *memchr(const void * const POS0 p, int c, __kernel_size_t size)
{
	const size_t p_size = __struct_size(p);

	if (__compiletime_lessthan(p_size, size))
		__read_overflow();
	if (p_size < size)
		fortify_panic(FORTIFY_FUNC_memchr, FORTIFY_READ, p_size, size, NULL);
	return __underlying_memchr(p, c, size);
}

found in include/linux/fortify-string.h

But instead clang is generating code that behaves like this:
(((u_int64_t)foo_ptr) >> 8) & 0xFF

The assembly it generates (see first mail) is this:
	movzx edx, bh
(before this rbx contains the address of foo_ptr, edx is used to pass
the output of __struct_size into a printk)


To illustrate the point I modified the function to read like this:

int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
		       enum bch_validate_flags flags)
{
	struct bkey_s_c_xattr xattr = bkey_s_c_to_xattr(k);
	unsigned val_u64s = xattr_val_u64s(xattr.v->x_name_len,
					   le16_to_cpu(xattr.v->x_val_len));
	int ret = 0;

	bkey_fsck_err_on(bkey_val_u64s(k.k) < val_u64s,
			 c, xattr_val_size_too_small,
			 "value too small (%zu < %u)",
			 bkey_val_u64s(k.k), val_u64s);

	/* XXX why +4 ? */
	val_u64s = xattr_val_u64s(xattr.v->x_name_len,
				  le16_to_cpu(xattr.v->x_val_len) + 4);

	bkey_fsck_err_on(bkey_val_u64s(k.k) > val_u64s,
			 c, xattr_val_size_too_big,
			 "value too big (%zu > %u)",
			 bkey_val_u64s(k.k), val_u64s);

	bkey_fsck_err_on(!bch2_xattr_type_to_handler(xattr.v->x_type),
			 c, xattr_invalid_type,
			 "invalid type (%u)", xattr.v->x_type);

	pr_info("x_name_len: %d", xattr.v->x_name_len);
	pr_info("__struct_size(x_name): %lu", __struct_size(xattr.v->x_name));
	pr_info("__struct_size(x_name): %llu", ((((u_int64_t)(xattr.v)) >> 8)) & 0xFF);
	bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
			 c, xattr_name_invalid_chars,
			 "xattr name has invalid characters");
fsck_err:
	return ret;
}

Here's the part of the code generated for the pr_info calls:

	mov	rdi, offset .L.str.3
	mov	rsi, offset .L__func__.bch2_xattr_validate
	mov	qword ptr [rbp - 40], rdx
	mov	edx, eax
	call	_printk                         # pr_info("x_name_len: %d", xattr.v->x_name_len);
	mov	rax, qword ptr [rbp - 40]
	movzx	ebx, ah
	mov	rdi, offset .L.str.4
	mov	rsi, offset .L__func__.bch2_xattr_validate
	mov	rdx, rbx
	call	_printk                         # pr_info("__struct_size(x_name): %lu", __struct_size(xattr.v->x_name));
	mov	rdi, offset .L.str.5
	mov	rsi, offset .L__func__.bch2_xattr_validate
	mov	rdx, rbx
	call	_printk                         # pr_info("__struct_size(x_name): %llu", ((((u_int64_t)(xattr.v)) >> 8)) & 0xFF);

You can see that the last two printks use the same value in rdx. So clang
clearly treats __struct_size(xattr.v->x_name) and ((((u_int64_t)(xattr.v)) >> 8)) & 0xFF
as equivalent. My first mail also contains the LLVM IR showing similar
behavior.

The output of this example is:
[    0.638109] bcachefs: bch2_xattr_validate() x_name_len: 10
[    0.641068] bcachefs: bch2_xattr_validate() __struct_size(x_name): 0
[    0.643178] bcachefs: bch2_xattr_validate() __struct_size(x_name): 0



> 
> > > > I think until this stuff is fixed in clang the only real option is:
> > > >
> > There seems to be an issue with how the offset to the flexible array
> > member is calculated internally. I'm looking into it now.
> >
> What Clang's doing is calculating the size of the object with this formula:
> 
>   size_t struct_size_including_flexible_array_members =
>     MAX(sizeof(struct posix_acl),
>         offsetof(struct posix_acl, a_entries) +
>         sizeof(struct posix_acl_entry) * count);
> 
> The various sizes and offsets are as follows:
> 
>   sizeof(struct posix_acl) == 32
>   sizeof(struct posix_acl_entry) == 8
> 
>   sizeof(a_refcount) == 4 :: offset == 0
>   sizeof(a_rcu) == 16 :: offset == 8
>   sizeof(a_count) == 4 :: offset == 24
>   offsetof(a_entries) == 28
> 
> The resulting "real" size (according to Clang) is MAX(32, 28 + 8 * 1)
> == 36. I believe it's padding that results in the size of 40 for the
> malloc size. Does that description jibe with what you're seeing?
> 
> (For what it's worth, I think Clang is correct here.)
> 
> -bw

This is relating to [1] I assume? Haven't looked at that one in-depth,
so I'm not 100% sure if it's the same / related or a different issue.

[1] https://lore.kernel.org/linux-kernel/3D0816D1-0807-4D37-8D5F-3C55CA910FAA@linux.dev/#t


Best Regards
Jan

