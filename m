Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19118367;
	Thu,  1 May 2025 19:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746127351; cv=none; b=bFhUQgxvdoBaXifJgoWv/rvx/TBVCldlvdV9/ejwGO1ma+vkkK326XnO3loIL/avfx/zURvTPPEDvNkH0Go/N4uiSa4ODziv67gk6Cm2lXxJx74aknyEKnprI0iKp+CU1UlqImSjt2Q8GoS8BK14EKMVdrbzC9smRTHuPtmS3V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746127351; c=relaxed/simple;
	bh=0ZFnWw1p4HwJh6zBYnRlMVfG4DKGIkSyeIwQWgrva2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFhcLv8IV9yg4nDXl2f4szo5IUTaoKN4fpmdfRXf6pyXWR9ubgVEd8GAGoJsUPdEfzAowZgk5K4PErQXAxArn+6bQziSLmT48tpayqQLHXXRZYR3bRLwBI0sD+mkEXu8ll0tLOdOEVEED6/il1EtvPqgfVZysqMIP73tHidvbfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=Dvtt3ieC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EULi4Sxp; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="Dvtt3ieC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EULi4Sxp"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 18E7C114014E;
	Thu,  1 May 2025 15:22:29 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 01 May 2025 15:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1746127349; x=1746213749; bh=wAG2dSa0xN
	uAqKOwHas/SiqnuAe7DgkYYO8tL/tba80=; b=Dvtt3ieCMdB5/gXV906kCLKEW6
	Q3ZOI2qqbWL4hydm3p1dAJDVWAvL6VzuqfdfxUOLcy7if2flOGxAATTqBUMDyA7G
	6uHByBHBeEfNsXV5jwHkJ2yGW+P6x10jTYk6ZcIL9W0Xk4aXZGzIW9df7BwEnCkD
	H6ilUVkQWItmtTWZodTb2LWJkU7sxFkOUGMdRij9MrOLFyX5lhYpBQQ585Olp6v1
	WYbj4SSWpN6JVzukIpAzqM5rwSx/9keM3cK30Pl6CjD3YlropuYgkUP1mlMuWHi/
	SPNTq/+FzvaZE3CDImJHLSO/5IQHyLzr0WVTcXTZ8vGWrkvHtbDVrtE8F6iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746127349; x=1746213749; bh=wAG2dSa0xNuAqKOwHas/SiqnuAe7DgkYYO8
	tL/tba80=; b=EULi4SxpJuF31z3eB7Oa3txvQzGxO672ZYTSUigb8LPzJoo9h2L
	kfntl9qbcJnm4i7A0BkQJZ5PPW66mYtvdC4ANiJualzyZueTiNsbldCxaZ2/6cPb
	0ZST74Yu7WJjnJiIrBrAjcZNvSPDITMwDofZV+T48gBi1j11RgT7xocWmWlOyU1s
	Fs7Dla22CHw4v4qBsMXzP/QG8ANtd7mejxW41BMh3wabszFTr+KxuX70T3AE1kNy
	ngz64jM7aDYdOL9qEzaV2oMemwm/bKinf3Vks97b5jwh2WZIYBqX7ER4aN7RwDMO
	gRyW+/ZLbAU/a/loHS9yPpJWnyCyajNDMPQ==
X-ME-Sender: <xms:9MkTaHrwqH4tCtoVB6W_hxu7PqmTiy7NI6PxufurSQAO4dijHGzaIw>
    <xme:9MkTaBocanqXBqktSQepyDLr1LHuynSkpEj0d1yJYrz8L1ignTwwEQC4o96qPuEqP
    c6-V-j6tqKMW00U6F8>
X-ME-Received: <xmr:9MkTaEOrxd8z8O8PCso_KV9VJxONXkZWfE9tyQ5kFZv9EqWXnxzfkajVlwi0CXr93bytylOmOkIo_gB93C8VR9FXSJSY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvjedtgeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefu
    kfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrg
    hrrhcuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpefgtdev
    vdffgeeugeekvddvffekvefhtdduhefftdelteevvdffteeluedvieetfeenucffohhmrg
    hinhepkhgvrhhnvghlrdhorhhgpdhprhhivhgrthgvsghinhdrnhgvthenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkvghrnhgvlhesjhhfrg
    hrrhdrtggtpdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtghpthhtoh
    epmhhmphhgohhurhhiuggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepkhgvvghssehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehguhhsthgrvhhorghrsheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumhesthhosghluhigrdgtohhm
    pdhrtghpthhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqhhgrrhguvghnihhnghesvhhgvghrrdhkvghr
    nhgvlhdrohhrgh
X-ME-Proxy: <xmx:9MkTaK6Jrx_3IbL1PLUY8IKXkfWxbJ_3YT8C-5nqmKRn_qtdeMIpvQ>
    <xmx:9MkTaG63G0CXLQWdPaD-v27pk6X11freJa-QqPeXyvL73bkQlcCssQ>
    <xmx:9MkTaCiK6DD48cWlnpKTGMh0aeMHK-po8rhWcXLEUgQRnEUTfjZL2A>
    <xmx:9MkTaI5UoD6Xwi47Gco-YDeuaBYIO7coWnENwY5vctkqZgaETO8OVA>
    <xmx:9ckTaHB9p_F6fXBjXIwN0f8_MgJO_bAAAaSNzf6kf4zU6uTUVIcOruzU>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 May 2025 15:22:27 -0400 (EDT)
Date: Thu, 1 May 2025 21:22:26 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Alan Huang <mmpgouride@gmail.com>, kees@kernel.org,
	gustavoars@kernel.org, thorsten.blum@toblux.com,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] Revert "bcachefs: Annotate struct bch_xattr with
 __counted_by()"
Message-ID: <aBPJ8ueDzztmDOSO@archlinux>
References: <20250501184150.200319-1-mmpgouride@gmail.com>
 <wsymhks7o6zbsjvac7bmi6vhjkk56ovp2vclrla64sqcquda2x@ikfk7tt76gec>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wsymhks7o6zbsjvac7bmi6vhjkk56ovp2vclrla64sqcquda2x@ikfk7tt76gec>

On 01 15:16:55, Kent Overstreet wrote:
> On Fri, May 02, 2025 at 02:41:50AM +0800, Alan Huang wrote:
> > This reverts commit 86e92eeeb23741a072fe7532db663250ff2e726a.
> > 
> > After the x_name, there is a value. According to the disscussion[1],
> > __counted_by assumes that the flexible array member contains exactly
> > the amount of elements that are specified. Now there are users came across
> > buffer overflow caused by the __counted_by here[2], so revert that.
> > 
> > [1] https://lore.kernel.org/lkml/Zv8VDKWN1GzLRT-_@archlinux/T/#m0ce9541c5070146320efd4f928cc1ff8de69e9b2
> > [2] https://privatebin.net/?a0d4e97d590d71e1#9bLmp2Kb5NU6X6cZEucchDcu88HzUQwHUah8okKPReEt
> > 
> > Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> > ---
> >  fs/bcachefs/xattr_format.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
> > index c7916011ef34..e9f810539552 100644
> > --- a/fs/bcachefs/xattr_format.h
> > +++ b/fs/bcachefs/xattr_format.h
> > @@ -13,7 +13,7 @@ struct bch_xattr {
> >  	__u8			x_type;
> >  	__u8			x_name_len;
> >  	__le16			x_val_len;
> > -	__u8			x_name[] __counted_by(x_name_len);
> > +	__u8			x_name[];
> 
> this needs a comment, so we don't make the same mistake again

Better yet: change x_name to x_name_and_value

> 
> >  } __packed __aligned(8);
> >  
> >  #endif /* _BCACHEFS_XATTR_FORMAT_H */
> > -- 
> > 2.48.1
> > 
