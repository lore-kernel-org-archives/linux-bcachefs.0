Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDC5215191;
	Thu,  1 May 2025 19:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126550; cv=none; b=NbZ4v73eE5+fgCBVq34mvm1AAtnlGfYwSlMl5iGmBV4ENL8Yrvtx/rYuaCefK8t+XH5NDATlFadUJtZHPyz/JOsR0coDzZL+iN2zltm5q6Ze+uO/CBDJ6BIe9EjB7hD7UPCgeMunFK1rPnJL0dAu9+ccO7v01tXzW9IcePLwSKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126550; c=relaxed/simple;
	bh=ju6VQPJpM0+dgvUpz0HYv18v3DU4LaOg5C5Rl1D0ZaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSkbmUJ6OVdqP5qnM1aTc5XXQ/ZJrMIB2omHNVA7OinsBa6+2hpLT9F8tAuHf+mygYLn6EYNoLpHmvTHFsxh6jjh7Y53lnl++yuBmQ/6EMz3ZP1W0rd+5R1LssxWl3v+UUnob4Q2u2O/IPa+uah2tPo7QYn3IgR/w/7NkXKDkN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=n11eb65k; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eBBGUvBe; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="n11eb65k";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eBBGUvBe"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 71B991380ED4;
	Thu,  1 May 2025 15:09:07 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 01 May 2025 15:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1746126547; x=1746212947; bh=L1HG6KnG2k
	LNtVjkg+XpQvOjsr8pwf6JxAUFt6fkPSg=; b=n11eb65k+nuFz95EBy9ZFuPiZW
	C1K4OsjlZ0yKrp2R+lsOEEQv0vk9NV3E4Z9c0dY+k1xVpnAH7kftY0wtq2mgkQxc
	ZehJAEGPj+zGGZiEzUP+qJyHXKbhailyKV2A3JHV0yu4lMqIWavWUlWvdQ83B+00
	14xmKuDAGV0e6t9Z8nRwMu6Fvw1FqDu+uEBQjMFTMpxN2lylCiW5DwhksOyV2q9E
	ikLyWqyN5OEop9n9cQHqVNp2vG9cqAv19KAtu3t7248mSAfphO8q4PxcWbll6o2e
	v/CR1jf5AWi1rKAMxxV99Z7izQl9M5ynakK5AkSxgdOi0t1IbQvQAF7suQaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746126547; x=1746212947; bh=L1HG6KnG2kLNtVjkg+XpQvOjsr8pwf6JxAU
	Ft6fkPSg=; b=eBBGUvBeUn4w6H4JqAEN9vXwzUp9GtY8d+17eC8vGtxSopuXU8v
	Jk1vbWqIjd/I7U029I9CFeAM9h7oDQioEOvGG9tqT8ui4P6inX0cAhkdJag3gYT9
	mEstbnqDCPodTk5nTslshP2t6zL4HtG1OkcFH8s/b+ptSUldtNeh9em9A9ZtDeYO
	YLl/n3msOs48iO0NhFOj3Y/h67Ln5FW9SbUmomihUgi7/lzbIbqSUR2/kI7NZ5ep
	gVTvUtM5D6mCa8a+eV9CtYEJjfn9laPCu1EWTMucEixtlc6zsiUhVJ4ZfVXryP6V
	xZ+7RgXi+AjDeJa9RPwjZXI37PkC3JW1Oow==
X-ME-Sender: <xms:08YTaNUHvTXY1jw_TnuzPAGUiV7kKtddf5KDzW6YRHdVBaxlirf9sg>
    <xme:08YTaNnP1-yBPjENNsZ-vQCLCCcJOYrQO4SGzRGIA-Bw-2r4e_ncI-4ROgTIbaJXZ
    aNM_HcNjAC6Zy0Tn4E>
X-ME-Received: <xmr:08YTaJbNDH6-VbWV6HzzdV95L2Xhq-TJPYE8DT5hWT5A06zwu2xUoQS6Xec7Uw9_aUV1TNPifzdXZHJEAfayVKFOU4qY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvjedtfeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffuc
    dluddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhm
    peflrghnucfjvghnughrihhkucfhrghrrhcuoehkvghrnhgvlhesjhhfrghrrhdrtggtqe
    enucggtffrrghtthgvrhhnpefgtdevvdffgeeugeekvddvffekvefhtdduhefftdelteev
    vdffteeluedvieetfeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhprhhivhgrth
    gvsghinhdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehkvghrnhgvlhesjhhfrghrrhdrtggtpdhnsggprhgtphhtthhopeejpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehmmhhpghhouhhrihguvgesghhmrghilhdr
    tghomhdprhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdguvg
    hvpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehguhhs
    thgrvhhorghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhhohhrshhtvghnrd
    gslhhumhesthhosghluhigrdgtohhmpdhrtghpthhtoheplhhinhhugidqsggtrggthhgv
    fhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqhhgrrh
    guvghnihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:08YTaAW5UwvT5J_JejBW2VGdRgowpWfEgU48KGZnzP387HCrB43eMg>
    <xmx:08YTaHkJwC1illhn1D2yX8W17dRMRGvFJzSqfxZfnd2ZvrERAjmsTA>
    <xmx:08YTaNdauS17vhKSHzY4KeOANe_BsxoiC9-YpOPBwOXIt8_tHnGPfw>
    <xmx:08YTaBFpWqLE58nWF7NStaW9fa94OMJpXg1_StOpkP3s8D8Mniqn4w>
    <xmx:08YTaM3HobRSDunovDbkLFf_YWKmuMbivBR2CzhHmOb1QcOtIjR7BT7p>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 May 2025 15:09:05 -0400 (EDT)
Date: Thu, 1 May 2025 21:09:04 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Alan Huang <mmpgouride@gmail.com>
Cc: kent.overstreet@linux.dev, kees@kernel.org, gustavoars@kernel.org,
	thorsten.blum@toblux.com, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] Revert "bcachefs: Annotate struct bch_xattr with
 __counted_by()"
Message-ID: <aBPG0OqCCM6weLMZ@archlinux>
References: <20250501184150.200319-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501184150.200319-1-mmpgouride@gmail.com>

On 02 02:41:50, Alan Huang wrote:
> This reverts commit 86e92eeeb23741a072fe7532db663250ff2e726a.
> 
> After the x_name, there is a value. According to the disscussion[1],
> __counted_by assumes that the flexible array member contains exactly
> the amount of elements that are specified. Now there are users came across
> buffer overflow caused by the __counted_by here[2], so revert that.

Nit: It's not causing a buffer overflow. It's causing a false positive
detection of an out of bounds write.

> 
> [1] https://lore.kernel.org/lkml/Zv8VDKWN1GzLRT-_@archlinux/T/#m0ce9541c5070146320efd4f928cc1ff8de69e9b2
> [2] https://privatebin.net/?a0d4e97d590d71e1#9bLmp2Kb5NU6X6cZEucchDcu88HzUQwHUah8okKPReEt
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/xattr_format.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
> index c7916011ef34..e9f810539552 100644
> --- a/fs/bcachefs/xattr_format.h
> +++ b/fs/bcachefs/xattr_format.h
> @@ -13,7 +13,7 @@ struct bch_xattr {
>  	__u8			x_type;
>  	__u8			x_name_len;
>  	__le16			x_val_len;
> -	__u8			x_name[] __counted_by(x_name_len);
> +	__u8			x_name[];
>  } __packed __aligned(8);
>  
>  #endif /* _BCACHEFS_XATTR_FORMAT_H */
> -- 
> 2.48.1
> 
