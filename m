Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1B41DFF0;
	Sat, 28 Sep 2024 23:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727566424; cv=none; b=Sc1/2uvvR0MY20ciT3Th0srE5Xu2Vr82Jpr+2ofg9b8VTyKxq/oIXUKQY+St3QCUnjY+fXFZ5+tOA4Wcsf3PpY3nb4xcAN84mcKLHsBOUmLanNfjPXcNgQUnhA/kS+DSwfNm++4I5Kx3/XcrgnYEjdLshQV6DADPYcwVBmAVGVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727566424; c=relaxed/simple;
	bh=PHkkvQkJc6JI2zl2MnZr30jDS4ppY8cDh4JJQ5fr6Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIQxiId1dGDQnN1xMdnAMr2T8wzSikQ1ULiUFvDNjOK9HU+JTx2JWR4MgZT0+mnsF6s4rsrxYX5B9wnVDYWRpGm2QPnLs0wXPgT25ph0JCU+EOQBBAUMa3skmU4yZjfRGuMrr1LQX4rN/mbMpTiIjlsqYu+Ky2TTOgTx4xc4qiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=qUTEZf4Q; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=n3q8vA2p; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="qUTEZf4Q";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="n3q8vA2p"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 332B91140196;
	Sat, 28 Sep 2024 19:33:40 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sat, 28 Sep 2024 19:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1727566420;
	 x=1727652820; bh=1on8eXvP9p4hIW54Ypcwhpe4cMgbbs7J3C6kLOiZgm8=; b=
	qUTEZf4QOqUd2E7oesIN9tYG29skZIXDSHpNQ8W3BNS03CrU5hlkEnZ5ClpLF5mW
	qAFfA5SXPgfXMEIIjzqr+vcST8HWJWK7ytfxuqFKJShvZEYivY3jQdUUW1yDnZV9
	b3YwYTmeHJYyYlnpeW+LbHQKUXJMDyFpfJWTU7NalvuPYQ7yzhFg0OBgkBOtePsT
	M87Gj8IeuihijeM4mz3sqM6tdDNs2YgQY/fXCLV+L/HTrDysX0Y3PgDNZWLR+JRR
	aiNxA3c601zbbg/gfDjJpqQxAD60aFNSHO77SY5GLxRd/fTwJe+zRWluaGFA9UzP
	X9Yy9Mw6Z87LumVHls/7pQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1727566420; x=
	1727652820; bh=1on8eXvP9p4hIW54Ypcwhpe4cMgbbs7J3C6kLOiZgm8=; b=n
	3q8vA2pMOqyXpFgZm6cZpZxnEUgjXHrXJ6NtqlWFYA/rniVivatLjJnN42NMEyE1
	Ciems5PkAkKwQtf9ioaNJNL/KzNGCjaUOB+8FgkYqVzaQlYc3wZqi9Wd2IBFNirL
	a+TEhUdcJCLd7ZScJ8thQOJVqUm05mBYbUszG/eexj8+CqYbo2HSMekAm6LMdVzJ
	xkOba8kziwHu07z8DVhLQ20hv9mTEJq0oWpL4rvmA6gUelkYSqaOooROLMbCR5HU
	EhijjzqZoosL6MQh2uWLDLNVB0s/2VBcitwU+qD/3kpszedVwbqJr3K4pxdtoeiM
	fpSKvrfCWq9RNIoOhye/Q==
X-ME-Sender: <xms:U5L4Zk6QcaDcOYNljw1R3a6bHEs5F9rbWRcZOc28ARQdetmX8WpzbA>
    <xme:U5L4Zl6h3ktl4MmZBVC3nxOyzlYGAjnJLJgs6T15P-ZYvasKkKDTs4v42_QXJIS99
    Sxk878WcQxx5rS6WZ0>
X-ME-Received: <xmr:U5L4ZjeBzZChNmOc0zKsrdsQnCn06okR3H18vBUssn27b8_1wN_gq8CtoZIObAZ_YbzvkTDahbkAiqG8a0jHz2btUCKh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdduvddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhf
    gggtugfgjgesthekredttddtjeenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepfeejieet
    gfegiedtkeeigffgkeelvddtfedttddtleelffdtudevjedvleelvdelnecuffhomhgrih
    hnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttg
    dpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgv
    vghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdrtg
    homhdprhgtphhtthhopegrrhgusgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhh
    ohhrshhtvghnrdgslhhumhesthhosghluhigrdgtohhmpdhrtghpthhtohepkhgvnhhtrd
    hovhgvrhhsthhrvggvtheslhhinhhugidruggvvhdprhgtphhtthhopehrvghgrhgvshhs
    ihhonhhssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqsg
    gtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqhhgrrhguvghnihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:VJL4ZpLaLl8NOmgesctsC_FDuzNISvh79vR7kHZU9tpQoOsL0vmRJQ>
    <xmx:VJL4ZoIALvZ97TQHVo1UdZgcyzy2iB-vjvQNqsnrBkhhAWZvA5v7Aw>
    <xmx:VJL4ZqyfydrCxw56U2_4A0YqVvDB0eFPeNASkj5Haz2Ef9y6frTL-A>
    <xmx:VJL4ZsIVexrPqsAvTmJDIFlGU39_YcoszMf5ryLIjL7JIxf6d-Z2yQ>
    <xmx:VJL4ZtXD129tY4ai2UbKnJsXeOT43nIOBUsrL2rWcyiTzrQFEKg4xcLV>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 28 Sep 2024 19:33:38 -0400 (EDT)
Date: Sun, 29 Sep 2024 01:33:37 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Kees Cook <kees@kernel.org>
Cc: Bill Wendling <morbo@google.com>, Ard Biesheuvel <ardb@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZviSURL7kaxZPkSN@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <ZvWTXaqkmxP2E2dc@archlinux>
 <ZvWd0aK7p_1rkb7E@archlinux>
 <CAMj1kXFV+Jck9Yf4w18rOzHckXvpXkhPhL-KrpBC8hqgXusw2g@mail.gmail.com>
 <CAGG=3QXG+Vsm7mjLV42Q-uA-EvgfOehSUeNQjKA3QQbw8vqSCg@mail.gmail.com>
 <CAGG=3QVWCQB-3sM=iwgTmX8zrU81H+F_A1icJwROvW_DSvsBeA@mail.gmail.com>
 <202409281335.5EE231B9C7@keescook>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202409281335.5EE231B9C7@keescook>

On 28 13:50:12, Kees Cook wrote:
> On Thu, Sep 26, 2024 at 06:30:15PM -0700, Bill Wendling wrote:
> > On Thu, Sep 26, 2024 at 3:18 PM Bill Wendling <morbo@google.com> wrote:
> > >
> > > On Thu, Sep 26, 2024 at 12:58 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > (cc Kees and Bill)
> > > >
> > > > On Thu, 26 Sept 2024 at 19:46, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > > > >
> > > > > On 26 19:01:20, Jan Hendrik Farr wrote:
> > > > > > On 26 18:09:57, Thorsten Blum wrote:
> > > > > > > On 26. Sep 2024, at 17:28, Thorsten Blum <thorsten.blum@toblux.com> wrote:
> > > > > > > > On 26. Sep 2024, at 17:14, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > [...]
> > > > > > > >> [    6.252375] memchr: detected buffer overflow: 12 byte read of buffer size 0
> > [...]
> > > > > >       bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
> > > > > >                        c, xattr_name_invalid_chars,
> > > > > >                        "xattr name has invalid characters");
> > [...]
> 
> The thing going wrong is that __bdos(xattr.v->x_name, 0) is returning 0.
> This looks exactly like the bug I minimized here:
> https://lore.kernel.org/all/202409170436.C3C6E7F7A@keescook/
> 
> Since there wasn't an LLVM open bug yet, I've created:
> https://github.com/llvm/llvm-project/issues/110385
> 
> -Kees
> 

I found a fix for the issue. Fixes both the issue in this thread as well
as your reproducer. First thought they might not actually be the same
issue, but they indeed are. Haven't tested against the issue Thorsten
linked.

Havn't run the clang tests on it yet, but it does successfully compile
my kernel and fix the issue.

I'll open a PR and give more explanation tomorrow, it's getting
pretty late over here in CEST.


Here's the patch to be applied on top of
https://github.com/llvm/llvm-project

--
diff --git a/clang/lib/CodeGen/CGExpr.cpp b/clang/lib/CodeGen/CGExpr.cpp
index 9166db4c7412..143dd3fcfcf8 100644
--- a/clang/lib/CodeGen/CGExpr.cpp
+++ b/clang/lib/CodeGen/CGExpr.cpp
@@ -1164,15 +1164,15 @@ llvm::Value *CodeGenFunction::EmitLoadOfCountedByField(
     Res = EmitDeclRefLValue(DRE).getPointer(*this);
     Res = Builder.CreateAlignedLoad(ConvertType(DRE->getType()), Res,
                                     getPointerAlign(), "dre.load");
-  } else if (const MemberExpr *ME = dyn_cast<MemberExpr>(StructBase)) {
-    LValue LV = EmitMemberExpr(ME);
-    Address Addr = LV.getAddress();
-    Res = Addr.emitRawPointer(*this);
   } else if (StructBase->getType()->isPointerType()) {
     LValueBaseInfo BaseInfo;
     TBAAAccessInfo TBAAInfo;
     Address Addr = EmitPointerWithAlignment(StructBase, &BaseInfo, &TBAAInfo);
     Res = Addr.emitRawPointer(*this);
+  } else if (const MemberExpr *ME = dyn_cast<MemberExpr>(StructBase)) {
+    LValue LV = EmitMemberExpr(ME);
+    Address Addr = LV.getAddress();
+    Res = Addr.emitRawPointer(*this);
   } else {
     return nullptr;
   }
