Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E9D29405;
	Thu, 17 Oct 2024 03:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729134274; cv=none; b=Zss+EmuKrySFXrGZfuOr5buLtf/Bnwk+ksdFGKQzptfq3VovSr3IKuhFkSMFI2n7ZA68hCuw3FUkGf4A2/tESpCmDkskXj4VHkLFGdBj82D7Cp++JM6jYj155dxG80FHpi92/KcQ8MdiPtcDW/6u2/VHDh+pGv/QLcBRghv7IGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729134274; c=relaxed/simple;
	bh=f4PJRLR/2fRgB4+Uq05RONoLYT4kehQXApRxwEsEiHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7isiSIhKyOfliLn2Y1pjb9AYuHDuzAbtAJnEM/mVhanxl0jHDMLCze2tYgotR1f4WiJ9nUa2wcCyLxhKrB+GofumfubLtVIqc0chqT/N0BLFBwe4felCvvcPqs9Rak3cOfpN5NcSk110WJF2xAf5GNRgyRdjoyf29hS86cQ8vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=iXIvJ4Jy; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L9Cg9s/D; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="iXIvJ4Jy";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L9Cg9s/D"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 207B2114017E;
	Wed, 16 Oct 2024 23:04:30 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 16 Oct 2024 23:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1729134270;
	 x=1729220670; bh=EFckjBgGmy34eVKuGSlvBNUk1hLb5Yr8WVXfUlVn8BU=; b=
	iXIvJ4JyZVFzxcRvmifpF1tP0Wmy0LOzjlLJlaQaQAnDwqpzHVukzH82ijDt36lf
	zZygntsKq4H0Jp3kVzxTW2UXwCBliRjrcYFq9hS1xgSMP1ra3w1Ha6mUPnx5nsT4
	bksuZhnzEdG2KwriQfuGG1uFvS5bBA1LgdpVJ/l+wGrvhcl6BzbK/+F18TG1tkpq
	MMO3D0dHliS9fliXQnOUdLI+xpnPC83QdYzOWDUSFE3GaNox1jIR7LCOmR9fQ+1O
	soYOQVUsTOTJEF1uj2GlPpUNbqgrbIbdAhiAj2q3i0PpfSDUxxaS4B+JkHWIpWyw
	53i3tOUe3L1d4bvOhiOFNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1729134270; x=
	1729220670; bh=EFckjBgGmy34eVKuGSlvBNUk1hLb5Yr8WVXfUlVn8BU=; b=L
	9Cg9s/DIcofGUVDtGjYlDVNAsecduxsOxQPFNVHW7wg2niw0LV1xux7Ui1GXIJqe
	0jgAKY5c/KEcAOoMi9gh1ByrWbqPVPndkFFmmfBaUle3wwz3zc5oSRBQih2WaDP4
	FphR1KGxSsDvh8l502r44R9dmpP+4vrGI4y+/Vbe97fSKi4IuENssIywO7o/2lYT
	GT3fFuhNrSM76IhUw2riw4NF2ypQBqrX0RfGr99Bse9QtkBBr3CwU2sujFJRsVvq
	MGeNjaxs/dwjQ5HnUwLpunW+GhkDwpCHpbHxuMPdwItvL3+SumV6MJEqrukvFf6W
	fa2zOj0Y0L2L255HTh67g==
X-ME-Sender: <xms:vX4QZ6rThT3hdFcDly4nSvNzqlQEcRZHLDHkAk23JT15WaWk6i6g3A>
    <xme:vX4QZ4r300K0AtljHgxtqnQ-l7raqbGv6YyyJxp5pUmo0QW6HyZuDKpxr10J5e3aD
    SOcc8vYZNBhq7ciGak>
X-ME-Received: <xmr:vX4QZ_O5Pruv93vTqy-da-nRK7dycO0_m6xQpSDkpc_nhTdz-w6gaUoKi8UV-tcxdke3LLO-Xip6Oj-cVoIVtAezZUk2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehtddgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhf
    gggtugfgjgesthekredttddtjeenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepheeigeet
    tdegvddvieejjeegiefgtddugfeiieekieegjedvtdehteevffelhedtnecuffhomhgrih
    hnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgpdhgnhhurdhorhhgnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlse
    hjfhgrrhhrrdgttgdpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtohepmhhorhgsohesghhoohhglhgvrdgtohhmpdhrtghpthhtohepkhgvvghsse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehthhhorhhsthgvnhdrsghluhhmsehtohgs
    lhhugidrtghomhdprhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuh
    igrdguvghvpdhrtghpthhtoheprhgvghhrvghsshhiohhnsheslhhishhtshdrlhhinhhu
    gidruggvvhdprhgtphhtthhopehlihhnuhigqdgstggrtghhvghfshesvhhgvghrrdhkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhhrghruggvnhhinhhgsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhr
    gh
X-ME-Proxy: <xmx:vX4QZ57qrH_-8Js7q1bAfXkb5wm_jbFCBogrMVGpx7cHEddAfoyu1A>
    <xmx:vX4QZ56dVUFy39TsqzQfGKKAtawlGg2T43JfRyKH7ohmXAt-priStw>
    <xmx:vX4QZ5isno_GRzq_tyPWDwXxtup9agGHJD5eL-Hnl3pLAdWYKs_F2w>
    <xmx:vX4QZz6eXRSFWOMEPD2cYbhl7TMo8ACo4yUkarKX3CybGE2O7GNsog>
    <xmx:vn4QZ-HuaXHMa5Rit1UycTRV9V8nvCvNVLcpjLc1i8ii5G4K7hRxXSp7>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Oct 2024 23:04:28 -0400 (EDT)
Date: Thu, 17 Oct 2024 05:04:26 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>, Thorsten Blum <thorsten.blum@toblux.com>,
	kent.overstreet@linux.dev, regressions@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, ardb@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZxB-uh1KzfD4ww2a@archlinux>
References: <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>

On 16 17:09:42, Bill Wendling wrote:
> On Wed, Oct 16, 2024 at 4:41 PM Bill Wendling <morbo@google.com> wrote:
> >
> > On Sun, Oct 6, 2024 at 8:56 PM Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > > > I want to separate several easily confused issues. Instead of just
> > > > saying __bdos, let's clearly refer to what calculation within bdos is
> > > > being used. There are 3 choices currently:
> > > > - alloc_size attribute
> > > > - counted_by attribute
> > > > - fallback to __bos (which is similar to sizeof(), except that FAMs are 0 sized)
> > > >
> > > > Additionally there are (for all intents and purposes) 2 size
> > > > determinations to be made by __bos and __bdos, via argument 2:
> > > > - containing object size (type 0) ("maximum size")
> > > > - specific object size (type 1) ("minimum size")
> > >
> > > "maximum" vs "minimum" size would by type 0 vs type 2, but I think you
> > > do mean type 0 and type 1 as those are the types currently used by
> > > __struct_size and __member_size. Those are both "maximum" sizes.
> > >
> > > >
> > > > For example, consider:
> > > >
> > > > struct posix_acl *acl = malloc(1024);
> > > > acl->a_count = 1;
> > > >
> > > > what should these return:
> > > >
> > > >       __bos(acl, 0)
> > > >       __bos(acl, 1)
> > > >       __bdos(acl, 0)
> > > >       __bdos(acl, 1)
> > > >       __bos(acl->a_entries, 0)
> > > >       __bos(acl->a_entries, 1)
> > > >       __bdos(acl->a_entries, 0)
> > > >       __bdos(acl->a_entries, 1)
> > > >
> > >
> > Thank you for this detailed write-up! I'm sorry for my late response.
> >
> [snip]
> >
> > So in conclusion, if turning off the calculation for a pointer to the
> > whole struct works, then I'm okay with it.
> >
> Here's a potential fix:
> 
>   https://github.com/llvm/llvm-project/pull/112636

Here's the patch to disable __counted_by for clang < 19.1.3. I'll submit
it properly when your PR is merged. I hope I got all the correct tags in
there as there were multiple reports of these issues. Let me know if
anything should be added, I'm new to the process.

From: Jan Hendrik Farr <kernel@jfarr.cc>
Date: Thu, 17 Oct 2024 04:39:40 +0200
Subject: [PATCH] Compiler Attributes: disable __counted_by for clang < 19.1.3

This patch disables __counted_by for clang versions < 19.1.3 because of
two issues.

1. clang versions < 19.1.2 have a bug that can lead to __bdos returning 0:
https://github.com/llvm/llvm-project/pull/110497

2. clang versions < 19.1.3 have a bug that can lead to __bdos being off by 4:
https://github.com/llvm/llvm-project/pull/112636

Cc: stable@vger.kernel.org
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409260949.a1254989-oliver.sang@intel.com
Link: https://lore.kernel.org/all/Zw8iawAF5W2uzGuh@archlinux/T/#m204c09f63c076586a02d194b87dffc7e81b8de7b
Signed-off-by: Jan Hendrik Farr <kernel@jfarr.cc>
---
 include/linux/compiler_attributes.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 32284cd26d52..7966a533aaec 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -100,8 +100,17 @@
  *
  *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
  * clang: https://github.com/llvm/llvm-project/pull/76348
+ *
+ * clang versions < 19.1.2 have a bug that can lead to __bdos returning 0:
+ * https://github.com/llvm/llvm-project/pull/110497
+ *
+ * clang versions < 19.1.3 have a bug that can lead to __bdos being off by 4:
+ * https://github.com/llvm/llvm-project/pull/112636
  */
-#if __has_attribute(__counted_by__)
+#if __has_attribute(__counted_by__) && \
+	(!defined(__clang__) || (__clang_major__ > 19) || \
+	(__clang_major__ == 19 && (__clang_minor__ > 1 || \
+	(__clang_minor__ == 1 && __clang_patchlevel__ >= 3))))
 # define __counted_by(member)		__attribute__((__counted_by__(member)))
 #else
 # define __counted_by(member)
-- 
2.47.0

