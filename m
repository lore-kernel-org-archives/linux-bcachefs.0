Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753557BAEC;
	Sun, 29 Sep 2024 19:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727639972; cv=none; b=i1cTiEH9CoYDIJ2o2OEiCAFBQ+CtAbs4+abiOLqhJInIcfFm75yfVF50dTCYbEAsQCbANt+Jf2YVT4vQxRHbFcDT9Ux7O1lzmLHOybrpznZTzZHfoKKNnUnA4UKbE6zKhLCVSpn/VabElac+GspUYBv8Y3G9/8q6tMRkG/sYSO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727639972; c=relaxed/simple;
	bh=ZEiw6Vdio/TP2WrUL+Vf/mhXL1ax469ODYxcNdnlWC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pxK4K+Qm39a8/1BnIKpmzcBqotOttI/VI+cZg99YSqqOoV2e26H30njqb4JyVTxpDJVdzxTNe3oWBNpUoxdNVv+obJXY28yfMp6OoT5fMCcMbzn/N7kNvAIZQ5E3MMGJRT/aWLDB9c4kEyantZacs1Vjr01KklMVi/QL5o4rS2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=zLO1xvhU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SUqLrlSG; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="zLO1xvhU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SUqLrlSG"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 8C3A8138025B;
	Sun, 29 Sep 2024 15:59:29 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Sun, 29 Sep 2024 15:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1727639969;
	 x=1727726369; bh=wjelk38W9mGSPjR1nvLcSCdYm0WK8pYBKRnjg05bhwE=; b=
	zLO1xvhUNtnuTskHs4uOir8G6dEbx5fsn4gxqD6rvf4GKH8r+vsrmwY/eiM/kync
	BgV3oztllypRlAUzpDaxtFGsTsID9xNM4kgHMZtHD9rpSIefylUlWF3MFs3sHGeU
	N7yNn/Jr/ZzR71uYcgrdcCi/4otvAwlBMLF1lGiKgUg8PaZrXW5s9aLANRvk0Ytv
	ZiGp6yURW77t7EX893gYsH3B0lihri8oRDvVx6lQI6NxWVBzOLI3cEMJKU7bhY5Z
	wLywFNbOA0Mj5gvXk9kMWdQvSCYW8pnjoPLX6WIlq6vAwDbX7PJo3gu9XV3Ykvdg
	5l2dtPuxVCmsp7StUONKPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1727639969; x=
	1727726369; bh=wjelk38W9mGSPjR1nvLcSCdYm0WK8pYBKRnjg05bhwE=; b=S
	UqLrlSGqUSSppwfVYPyb0sLAaYSr16qH8ASkKYZG3USwVfkvQND8AHiXdQZqhDJh
	2I80BdgDND2JXs/7rIloFk0W2Q7hgZJL5fJvH04+BNOnvhy4kNTSwZr6dE1Z3kai
	4L/p6uv22jf/QGrGW6AxDG5TQuPmh28yPSB/LYb5yoDnWV4iR9UOrCJevz00JOi/
	xWwHBMD1l4a2e9t2nK2YV+FbAjK9MnWH+EriFgp4PTGyr+FPpV+BhQo9dOqvipUg
	JE2bEfO3u2VLu/Lh5rJ4UVpCgvTTQ8WOj4tuWsEZXkSzxI1+lh8Rq3GljV89MSmf
	LY1rBUhgV3zB6hnevriMQ==
X-ME-Sender: <xms:obH5ZncGYFwsveKawsM78ViPH6JfgId4eMEmBZYrCOiQlZCGLydozw>
    <xme:obH5ZtPGWwrg165XAdOEOKMiFpcJehegDSAOJ82PQ8njgnnl3UXOBoXvKALV8bzZa
    NxJNbFhf_fQOGBGTL4>
X-ME-Received: <xmr:obH5ZgiSmRkdSgJjtSNdKHK4tEg4hkible3M4a45ijNym1jqTJ27tduZFcNECyWDWgcwaZCl4SeIvsd9XOdPtQn9EHT7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddufedgudegiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenfghrlhcuvffnffculddutddmnecujfgurhepfffhvfevuffk
    fhggtggugfgjsehtkeortddttdejnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrg
    hrrhcuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpeetjeej
    udefveetgeehgfetleduudfhieegleetjeffudehkeeukeeigffffeeuffenucffohhmrg
    hinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkvghrnhgvlhesjhhfrghrrhdrtg
    gtpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehk
    vggvsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhhorhgsohesghhoohhglhgvrd
    gtohhmpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhopeht
    hhhorhhsthgvnhdrsghluhhmsehtohgslhhugidrtghomhdprhgtphhtthhopehkvghnth
    drohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtghpthhtoheprhgvghhrvghs
    shhiohhnsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqd
    gstggrtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhhrghruggvnhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:obH5Zo_J2bN6ZDT_QjZLHe0tV1PBChCnX9RvagpE0YQBCI_dw5IEKA>
    <xmx:obH5ZjsQ6UxCA3TG2LqiAJHhTuPwouIpxY7d3REw0va0FdGp_UOnDA>
    <xmx:obH5ZnGHG8Utf5lRr7LwHSRFMxC9ei0kT46jQMS_fCT5zMk5yYJO0Q>
    <xmx:obH5ZqPCMfVdVjsbvlnaFCdWrxem_tgGk-U3-BMIpomliV-nEbMJNg>
    <xmx:obH5ZhJswG8A-TuWonqtoZRfoRAkni790OVx25gFhrEZoqjGyM_T0m-7>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 29 Sep 2024 15:59:28 -0400 (EDT)
Date: Sun, 29 Sep 2024 21:59:26 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Kees Cook <kees@kernel.org>
Cc: Bill Wendling <morbo@google.com>, Ard Biesheuvel <ardb@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZvmxntpAHrAwcKaH@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <ZvWTXaqkmxP2E2dc@archlinux>
 <ZvWd0aK7p_1rkb7E@archlinux>
 <CAMj1kXFV+Jck9Yf4w18rOzHckXvpXkhPhL-KrpBC8hqgXusw2g@mail.gmail.com>
 <CAGG=3QXG+Vsm7mjLV42Q-uA-EvgfOehSUeNQjKA3QQbw8vqSCg@mail.gmail.com>
 <CAGG=3QVWCQB-3sM=iwgTmX8zrU81H+F_A1icJwROvW_DSvsBeA@mail.gmail.com>
 <202409281335.5EE231B9C7@keescook>
 <ZviSURL7kaxZPkSN@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZviSURL7kaxZPkSN@archlinux>

On 29 01:33:40, Jan Hendrik Farr wrote:
> On 28 13:50:12, Kees Cook wrote:
> > On Thu, Sep 26, 2024 at 06:30:15PM -0700, Bill Wendling wrote:
> > > On Thu, Sep 26, 2024 at 3:18 PM Bill Wendling <morbo@google.com> wrote:
> > > >
> > > > On Thu, Sep 26, 2024 at 12:58 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > > >
> > > > > (cc Kees and Bill)
> > > > >
> > > > > On Thu, 26 Sept 2024 at 19:46, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > > > > >
> > > > > > On 26 19:01:20, Jan Hendrik Farr wrote:
> > > > > > > On 26 18:09:57, Thorsten Blum wrote:
> > > > > > > > On 26. Sep 2024, at 17:28, Thorsten Blum <thorsten.blum@toblux.com> wrote:
> > > > > > > > > On 26. Sep 2024, at 17:14, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > > [...]
> > > > > > > > >> [    6.252375] memchr: detected buffer overflow: 12 byte read of buffer size 0
> > > [...]
> > > > > > >       bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
> > > > > > >                        c, xattr_name_invalid_chars,
> > > > > > >                        "xattr name has invalid characters");
> > > [...]
> > 
> > The thing going wrong is that __bdos(xattr.v->x_name, 0) is returning 0.
> > This looks exactly like the bug I minimized here:
> > https://lore.kernel.org/all/202409170436.C3C6E7F7A@keescook/
> > 
> > Since there wasn't an LLVM open bug yet, I've created:
> > https://github.com/llvm/llvm-project/issues/110385
> > 
> > -Kees
> > 
> I found a fix for the issue. Fixes both the issue in this thread as well
> as your reproducer. First thought they might not actually be the same
> issue, but they indeed are. Haven't tested against the issue Thorsten
> linked.
> 
> Havn't run the clang tests on it yet, but it does successfully compile
> my kernel and fix the issue.
> 
> I'll open a PR and give more explanation tomorrow, it's getting
> pretty late over here in CEST.
> 
> 
> Here's the patch to be applied on top of
> https://github.com/llvm/llvm-project
> 
> --
> diff --git a/clang/lib/CodeGen/CGExpr.cpp b/clang/lib/CodeGen/CGExpr.cpp
> index 9166db4c7412..143dd3fcfcf8 100644
> --- a/clang/lib/CodeGen/CGExpr.cpp
> +++ b/clang/lib/CodeGen/CGExpr.cpp
> @@ -1164,15 +1164,15 @@ llvm::Value *CodeGenFunction::EmitLoadOfCountedByField(
>      Res = EmitDeclRefLValue(DRE).getPointer(*this);
>      Res = Builder.CreateAlignedLoad(ConvertType(DRE->getType()), Res,
>                                      getPointerAlign(), "dre.load");
> -  } else if (const MemberExpr *ME = dyn_cast<MemberExpr>(StructBase)) {
> -    LValue LV = EmitMemberExpr(ME);
> -    Address Addr = LV.getAddress();
> -    Res = Addr.emitRawPointer(*this);
>    } else if (StructBase->getType()->isPointerType()) {
>      LValueBaseInfo BaseInfo;
>      TBAAAccessInfo TBAAInfo;
>      Address Addr = EmitPointerWithAlignment(StructBase, &BaseInfo, &TBAAInfo);
>      Res = Addr.emitRawPointer(*this);
> +  } else if (const MemberExpr *ME = dyn_cast<MemberExpr>(StructBase)) {
> +    LValue LV = EmitMemberExpr(ME);
> +    Address Addr = LV.getAddress();
> +    Res = Addr.emitRawPointer(*this);
>    } else {
>      return nullptr;
>    }


Here's the PR: https://github.com/llvm/llvm-project/pull/110437

I hope the way I added the CHECK tags in the test is good and that they if
they don't need manual cleanup, not familiar with the llvm test system.


Best Regards
Jan
