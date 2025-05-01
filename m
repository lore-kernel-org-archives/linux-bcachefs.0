Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562EE1D54C0;
	Thu,  1 May 2025 17:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746122340; cv=none; b=lg50URG98be1FnGrjJCgRy+zI48B/43FCGn6mKQK1bimRLl0kRzYELwwF0F7wAEtYFZZ1UQmZJz8ADWWXfBtHINN1tVLOtsfwjuyC0MQKpIacIWy0EJahUT9IJfGH8Amxzo3Se5b5r0I9Y4Jr20xnIo/qjebLE2d3Xh0uGIU3d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746122340; c=relaxed/simple;
	bh=O6FxVeJ6quxOLCb5kkNL3zltkHabRVogsNd4AY7OiyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6xHYJE7PPKKpv+accXYzkjW1qJyuKbGldiuFzBnxCq6v8C8/XQV1plaq19n4uUPci0wHAnFALcZR6FCoRDYzrY7b7vyIJSX2dnU5W3QV/4kd90DbBUsNyCYVSd54nnei3h0pYMlBeyRikkOnFOhnc3B+NRlCodWQ7D0YjUHknA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=Xd12O4yG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=A95OZfQD; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="Xd12O4yG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="A95OZfQD"
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 2B7391140229;
	Thu,  1 May 2025 13:58:57 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 01 May 2025 13:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1746122337;
	 x=1746208737; bh=Lo8uFd/JrEURLSV5QwjaecQM+R2ekxdui+L5Hju4I84=; b=
	Xd12O4yGNSftlXg84rjcejPSoCACpCG86pxuNamz0GzK5F706OXo4Fm53vjsQRp6
	aK+E/2KnkvXdpn83UaEesbkt6wvIF/XFUfJjjYQcIT4zmvph7EnbRPsS7tyLeFE7
	0exixJK5THHbxrG9dyk6hsJiBP+VlhAw6Rbw5c1mRSACU7zZiWgr9996471Pkb5Q
	09gJMYe0r9jr6Di8UTm/9W3L0hPDKNS2vsIVFew0rPCtb5giLVSMMWu2pc4bhYN7
	7nhJ7ESGW5I/PDfd1JBKxXDx56gJ710OYXs6pmN5xRAH69ls2nvvOAV+ES+DGt/o
	aL/kAhsIstpzJLAF/AlohA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1746122337; x=
	1746208737; bh=Lo8uFd/JrEURLSV5QwjaecQM+R2ekxdui+L5Hju4I84=; b=A
	95OZfQDa9ssGz/UuxLdJ1VFN/IjHIwjuuVGw6iq+Awp+NJOKsO5jWLISoShEsAH5
	Tz4htJ2Ks8ojaRH64a0yE6L+dt39gyJdRrfKz/6/W7/8D3WrOYQeMhks3TjVpbpr
	mUG92OzqfJef194DgKmiKl/WUu/8mMVLquTIlyzxmMtlttabl7DWlWT1TBGYTcZg
	xAAeE/mDh2XK6/m5rj82xer6+Pri5ppFkoVY/490qKz45UIovQNvnhIbyjouLC02
	I0QXrAGE7rhVsSBFFTryHCzts//al1+bX6X8d651Cpb07WvP3h/Vewq91Te6c1Ws
	rD5v7CDlrj8u9vwax5eBw==
X-ME-Sender: <xms:YLYTaFBHDE4PBC-xsfYKDGRu5qTftpEusJqRnoGfbxEhBb05Uh75Hw>
    <xme:YLYTaDhZAqn5Z1eS7N_Fpf_T6eLkKzCEokkbdu17KvbQ55SrQfEwqKSsS1k1Hs_it
    AZZm54KYNDbIsnUCi0>
X-ME-Received: <xmr:YLYTaAmlKNmR7i8T0AtD179feUDPZun3zh5N_yAGT1yuTLjr-PLukIYr1t-ABT1UnwrBbwFrtP-apwCzF_3L_AVfTgtT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvjedtvdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefu
    kfhfgggtugfgjgesthekredttddtjeenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhf
    grrhhruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepfeev
    leejueffgeetvdfgieefgeefudejffevjeduffevteffkeelleehteehtedtnecuffhomh
    grihhnpehgihhthhhusgdrtghomhdplhhlvhhmrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttg
    dpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehm
    mhhpghhouhhrihguvgesghhmrghilhdrtghomhdprhgtphhtthhopehkvghnthdrohhvvg
    hrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtghpthhtohepthhhohhrshhtvghnrdgs
    lhhumhesthhosghluhigrdgtohhmpdhrtghpthhtohepmhhighhuvghlrdhojhgvuggrrd
    hsrghnughonhhishesghhmrghilhdrtghomhdprhgtphhtthhopehnrghthhgrnheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepmhhorhgsohesghhoohhglhgvrdgtohhmpdhrtg
    hpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrvghgrhgvshhs
    ihhonhhssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqsg
    gtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:YLYTaPzGwzHZ4MIYVeeQWNSpIvmYUbd-w6mb_3-S_dOaMrjIIMiT8A>
    <xmx:YLYTaKTltUnhVs4aXSqrH19rgJo1E2N9sYqO35t8XWWcP6TJDfHJ4g>
    <xmx:YLYTaCa72jqQ3I8-_DDBX4rn2GDOBc4rK0CuZjNiTbH05YG0xyXZsg>
    <xmx:YLYTaLRk64A9poCGxmYZcjnbBNyNP5eS0vy0tHwBLh0gA4kEdua9Cw>
    <xmx:YLYTaOnH1IjTmdDbpiWiHcADFO_CBDr_wHRhR1tndLXo7eyn0ef5gGsG>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 May 2025 13:58:55 -0400 (EDT)
Date: Thu, 1 May 2025 19:58:53 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Alan Huang <mmpgouride@gmail.com>
Cc: kent.overstreet@linux.dev, Thorsten Blum <thorsten.blum@toblux.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, ardb@kernel.org,
	ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <aBO2XVSisMXtU8nD@archlinux>
References: <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux>
 <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux>
 <20241025011527.GA740745@thelio-3990X>
 <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
 <Zxu4yhmxohKEJVSg@archlinux>
 <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>
 <aBOtxplvvpgHed7o@archlinux>
 <D9967EB7-7F4D-4122-9470-DB14700FD906@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D9967EB7-7F4D-4122-9470-DB14700FD906@gmail.com>

On 02 01:28:28, Alan Huang wrote:
> 
> Thanks,
> Alan
> 
> 
> 
> > On May 2, 2025, at 01:22, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > 
> >> 
> >> I wonder if the __counted_by(x_name_len) in struct bch_xattr is needed, since there is also a value after x_name.
> > 
> > Wait a minute. Are you saying that the value with length x_val_len
> > is behind the name (of length x_name_len) at the end of the struct.
> > So essentially the flexible array member x_name has a length of
> > x_name_len + x_val_len and contains both the name and value?
> 
> Yes.

I assume you can't easily change the struct such that there exists a member
that contains the result of x_val_len + x_name_len, correct?

In that case the only available course of action at this time is to
remove the __counted_by, because it is incorrect.

In addition I would recommend changing the name of x_name to something
like x_name_and_val or similar. It's very misleading to call it x_name
when it also contains the value.

> 
> > 
> > If that's the case:
> > 
> > 1. that's not at all clear from the struct definition
> > 2. __counted_by(x_name_len) is not correct in that case
> > 
> 
> Both clang and gcc say:
> 
>     • p->array has at least p->count number of elements available all the time. 
> 
> Note the at least here. Though I think the counted_by is misleading here.
> 

Here's how clang defines __bdos language extension [1]. Also note the
attribute reference for __counted_by [2]. It assumes that the flexible array
member contains exactly the amount of elements that are specified.

I guess your quote from the gcc docs is misleading, as gcc's behavior
is like clang's.

The kernel uses the type & 2 == 0 case.

So let's say you have a simple struct like so:

struct foo{
	int val_len;
	char val[] __counted_by(val_len);
}

If val_len is 10 then foo->val[10] will be considered out of bounds.
Even if you did a malloc for enough space.

[1] https://github.com/llvm/llvm-project/blob/3b88805ca20018ae202afd3aea39f4fa856a8c64/clang/docs/LanguageExtensions.rst?plain=1#L5502-L5507
[2] https://clang.llvm.org/docs/AttributeReference.html#counted-by-counted-by-or-null-sized-by-sized-by-or-null


Best Regards
Jan

