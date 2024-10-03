Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89EE1A01BC;
	Thu,  3 Oct 2024 21:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727992104; cv=none; b=o4t80hpDFlRTfHfn7IbMeDErYfpSp4yBCjiPtU+R7VWt8J09xqpUoU/YJa/QmcJnu6phreWI/5LR9aWCgLkyciUmpC9QeMGF/BcF8ZwDlDfM9SYd1Rnv3w5yGo/8wD7zQuh6Y0MsHvJaf5H7GI+U+dOas6OwQGL3fwCQIrjJCj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727992104; c=relaxed/simple;
	bh=YJ50vYM/u/Wi3SemAhvs0Nspplu4fWX+h6JYN+mxIqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qx0BkO9K7TukB300RwzB6wgQ2RsmTqrrhrYuYgtHsBspEbzOcAhyzPieoYHq52JOdAlXE/F6ODb3HEeuvRqcbXucdPCK4fWW81wLTD+TUiwHUHr+vhBrHxZvoUP+wCZwWnH2hIH12wNEXUA0BNqNfoK8AGdYgkj5RlUFq54BSWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=YYmgoO5T; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JUoEtNX9; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="YYmgoO5T";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JUoEtNX9"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E73A9114005B;
	Thu,  3 Oct 2024 17:48:21 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 03 Oct 2024 17:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727992101; x=1728078501; bh=sxhZZlorlZ
	1zlcyfcdxkQm0SN1r5ERKj2wycvGmA2X0=; b=YYmgoO5T9U/OrryUAM563Oi3Mj
	lxOSAlOkV43gW2bpa9UE2lj3HkwBv1pLBrQKw/XVhHIcee1IZ7lzLhaZ4yI9SeUr
	94VQS6diOJmOIxrxoTvdMJiEHRBgFr63JCODLKvzWc/2qbHphdA9BC5olsOGPJJr
	i6jJjIjP9h4g1qSJRt9Wns3xn7/aFyJrBShLSq42kW7B0zJff/k+MtkZoBy6RdQl
	xyp8jiPDGG2CYxfJfKy29s9xL0QXzCB/a8LiZ9WQMTJioMtReaVXGhY3uRLXKYPU
	BaT0Iit4ZEQbZkni7sL4snWE0yY3V/llaeCUWx0/G2+/WyibiepXGhGj3ydw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727992101; x=1728078501; bh=sxhZZlorlZ1zlcyfcdxkQm0SN1r5
	ERKj2wycvGmA2X0=; b=JUoEtNX9K8MgTE5BIi4+CIXq817aUI+vml58/5Ak12/Y
	mZd/KyNAdlEos3OPZkmlLPCbABTF1RzCWQCHiBtfwZ9LKkESKp0ggAoqiY+StnNH
	utuEDjwhRivqKxfKJ7uBoYYgAt2oIxqCAq5DmjGCpXLhVFbEZ9tRgCPUOTA2VDXq
	UClnf1dkm7iv410uZdWFT6YE+7KZutm3gYHJ3yIJdUxPgIKg3YAr3u6KXzIsvKsb
	N6t6pCy30X4j5tDGmgk9PD+vBkBicp6xMQpQ/AUk3uiVV3x4vGkUHSRO/q42r8dz
	P2GYnD2gDdA62aJ1bqsWIfFBWDk3KXeEFw4uLc9kSw==
X-ME-Sender: <xms:JRH_Znr0tVd09-NZMPMVrjBNSEVrt1DkVuuyM12udBaAA8N_J-RovA>
    <xme:JRH_ZhrQjEY3b5v6aG_UHRVR94ulvqlkebaYT5CZELOvSK8dvNom-IaMHRjejjR5Z
    D_AV8Xk7kqhCfDMwhM>
X-ME-Received: <xmr:JRH_ZkNPROiDYXBZgPZZ8Wt8Px4hlfM1FEtTLgVGwcSKeCYBSo-mJ3TdT254R8csmouCOPpbMwiHVELT3VEJ7rObaUTS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvvddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdludehmdenucfjughrpeffhffvvefukfhf
    gggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrghrrh
    cuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpefffeejffev
    geejudeiveektdeiveefgefghfffveeujeefhfefffdvvdfgiedvheenucffohhmrghinh
    epghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttgdpnhgspghrtghpthhtoheple
    dpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehthhhorhhsthgvnhdrsghluhhmsehtohgslhhugidrtghomhdprh
    gtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtghp
    thhtoheprhgvghhrvghsshhiohhnsheslhhishhtshdrlhhinhhugidruggvvhdprhgtph
    htthhopehlihhnuhigqdgstggrtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhhrghruggvnhhinhhgsehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hmohhrsghosehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:JRH_Zq5d87SozioJm15PIeCgIZR1wRDQTg03FCs41D1FjSoy4D4HyA>
    <xmx:JRH_Zm77dC4FkELMj5XYc5Kg8xvw8uUViEsTZ6j483o16dm1pTazFw>
    <xmx:JRH_Zih-ApDH5R5wSmvzPJIDpuI9jros20A_BAKylYGNZMlOyuEOTQ>
    <xmx:JRH_Zo445f1p9dGwmUuBax6JmnGLGy8V25ScP_vII71JT27boBj4Dg>
    <xmx:JRH_ZvFFc6iEKEI6_F3f4IK-xBi4wz9iAsZYGLtjp7Sg5jaGYV1wke7E>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Oct 2024 17:48:20 -0400 (EDT)
Date: Thu, 3 Oct 2024 23:48:18 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zv8RIs-htdc-PtXB@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202410031424.45E5D19@keescook>

On 03 14:28:01, Kees Cook wrote:
> On Thu, Oct 03, 2024 at 05:17:08PM +0200, Jan Hendrik Farr wrote:
> > gcc currently says that the __bdos of struct containing a flexible array
> > member is:
> > 
> > sizeof(<whole struct>) + sizeof(<flexible array element>) * <count>
> > 
> > clang however does the following:
> > 
> > max(sizeof(<whole struct>), offsetof(<flexible array member>) + sizeof(<flexible array element>) * <count>)
> 
> Clang's calculation seems very wrong. I would expect it to match GCC's.
> 

I was on the very same train of thought, but I have since changed my
mind a bit. A struct containing a flexible array member can be allocated in
two ways:

(1):

struct posix_acl *acl = malloc(sizeof(struct posix_acl) + sizeof(struct posix_acl_entry) * 1);
acl.a_count = 1;

or (2):

struct posix_acl *acl = malloc(offsetof(struct posix_acl, a_entries) + sizeof(struct posix_acl_entry) * 1);
acl.a_count = 1;

Both are valid ways to allocate it. __bdos does not know which of these
methods was used to allocate the struct whose size it has to determine,
so it's giving the lower bound that doesn't include the (potential)
padding at the end.

So it comes down to false positives vs false negatives...
More details here:
https://github.com/llvm/llvm-project/pull/111015

Clangs current behavior would essentially force kernel code to always
assume option (2) is used. So

struct posix_acl *
posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
{
	struct posix_acl *clone = NULL;

	if (acl) {
		int size = sizeof(struct posix_acl) + acl->a_count *
		           sizeof(struct posix_acl_entry);
		clone = kmemdup(acl, size, flags);
		if (clone)
			refcount_set(&clone->a_refcount, 1);
	}
	return clone;
}
EXPORT_SYMBOL_GPL(posix_acl_clone);

from linux/fs/posix_acl.c would have to turn into something like:

struct posix_acl *
posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
{
	struct posix_acl *clone = NULL;

	if (acl) {
		int size = offsetof(struct posix_acl, a_entries) + acl->a_count *
		           sizeof(struct posix_acl_entry);
		clone = kmemdup(acl, size, flags);
		if (clone)
			refcount_set(&clone->a_refcount, 1);
	}
	return clone;
}
EXPORT_SYMBOL_GPL(posix_acl_clone);

Which is actually safer, because can you actually be sure this posix_acl
wasn't allocated using method (2)?


After looking at the assembly produced by gcc more, it actually looks
like it's using the allocation size if it's known in the current context
(for example if the struct was just malloced in the same function)
and otherwise returns INT_MAX for the __bdos of a struct containing a
flexible array member. It's only returning the size based on the
__counted_by attribute of you ask it for the __bdos of the flexible
array member itself.

