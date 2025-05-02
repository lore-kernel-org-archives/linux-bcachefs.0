Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F92B1D554;
	Fri,  2 May 2025 01:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746150956; cv=none; b=MYbS/aGKg0NxXF30TYcf7xqrKGXc3fnRsYbn2GBxcy/j8wGPwVzgCsy7Tv4b7D9pu3JuQ9EkVXPJY0/J5rZrTUS8xVrldrsF5Z1crQ/866JcCF7WUU4GPlICb1fKiUDTNp7mbtRSU5BYhLA07V7mfIR/ARoWEjs9qg+E45Tx1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746150956; c=relaxed/simple;
	bh=z3rdCUvpte8A7S4AviTyKEtkjzCDVLldKOS5YgSi2Dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2IjPANa7bo9L4v2+dQbH2EiiYZdSEhBsLnIGki2H8KwPl3CXi5rpg/I1XhC1XQlvKMoL0qo+QNfftfQ6YuRlDlLTwFDcCap6bGZDkNxfWcU9Sq4cGwPPaIyQxUTWOVZzz8nC4SFhNt6GeAHzu5W/EJSsdvSCbsZm5HBhI8mxEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=LCqVvfRv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=W596VzjR; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="LCqVvfRv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="W596VzjR"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 06B541380FA2;
	Thu,  1 May 2025 21:55:52 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 01 May 2025 21:55:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1746150952; x=1746237352; bh=2ZvaVB/aFJ
	pZ0cfeauWW5J7RW8vTa4RcSV8JmZ3BCRk=; b=LCqVvfRv9YOwUEcQBiuJYJ22MF
	s/FjpN9vDzqjLpyCrdS2c97SAQ4PnmpQ8IQ5nR++fY/51/puE/cBRdbXf8PGjn3s
	gCgfXRYXiES+opuosVZTSqKIVMOTphTWNK0gk+cLrhk6ZrMj+M98ozD88lD/UbT1
	Nji37ImQXOfZFick1/408vvnby7xqGJSKELo45qPnwy/D0dG27/m7tWzF0kI9laX
	2ePDppiCFS0j2JyWyvIjmoyg6TWROM1LxsvSev6sWY+rKonACR4apW7l7xnezRRi
	DXuTMTgdlj5tN2RGn8l0NbTdFqr05/21E1mZsDruvtp4ZX0DJ6ko3KnpqRiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746150952; x=1746237352; bh=2ZvaVB/aFJpZ0cfeauWW5J7RW8vTa4RcSV8
	JmZ3BCRk=; b=W596VzjRVa+LY6Q4HCtwtIxaAvRHidR/4OmNxZyP28Z5aCTmSr+
	GyznZlTSkztnzieqDYmHrh+w49kbvWwFFMSerP5LpbFh/G4qmfzYKY7D7vMjVV4+
	DYRx8mm1yXVjzswHBHdBR3xyqrNojA1LEDWz5ZEzZv63v8kTimBD7+kqIO2dRw6Z
	3JhjJsRqcMqVhOj+d9/G6hxDoqlQh95jSJ3OWn3ey7/P/xQlDNgIIPRLfRG9zSst
	wO7xTHtCDJ6PrMWjSDhx2PTi78yz044M3H7RDUBGxTJZ0o8gWk+g4/RaD3JEdziT
	/Uv5NdzqH6wZkkYRLQVRkXEG0vfHgkcgYOA==
X-ME-Sender: <xms:JyYUaJubht81BeADGEWbwJZ-nKDGC3428bkhnRBgrig1-3t0O81TnQ>
    <xme:JyYUaCef90BP8KaUbE9DCvvf2QEZDm7kkXaaz2X2zjjuY7JVIJ1jR5q36Ui0ZhxmH
    liCAksy3vRZl4nQBLo>
X-ME-Received: <xmr:JyYUaMwlwKPWHpCt9diPDs4BqzhsISYvYXTt0Vhr3BT7-_byHzEUjpPZvC6DIAyYCFIjDeDP2pNpGXUtPvPSh_TnJTFV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvjeduudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffuc
    dluddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhm
    peflrghnucfjvghnughrihhkucfhrghrrhcuoehkvghrnhgvlhesjhhfrghrrhdrtggtqe
    enucggtffrrghtthgvrhhnpeegveffgfelkeeludejtedujeetuddtveetieevleelleef
    kefhkeetkeefkeefffenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhprhhivhgrth
    gvsghinhdrnhgvthdpghhouggsohhlthdrohhrghenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehkvghrnhgvlhesjhhfrghrrhdrtggtpdhnsg
    gprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmmhhpghho
    uhhrihguvgesghhmrghilhdrtghomhdprhgtphhtthhopehkvghnthdrohhvvghrshhtrh
    gvvghtsehlihhnuhigrdguvghvpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehguhhsthgrvhhorghrsheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepthhhohhrshhtvghnrdgslhhumhesthhosghluhigrdgtohhmpdhrtghpthhtohep
    lhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhinhhugidqhhgrrhguvghnihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:JyYUaAPMuF_bBnSl17HY4aF_MhGv-muGp7jPho1J3-l655zXQ3c-hg>
    <xmx:JyYUaJ9TAbJt_xIzUm2SVvzErcCPHWuo6D0ek2CRJkZD0JFgZNVNpA>
    <xmx:JyYUaAURLHU5rZ48l1oWb426dNFHk0_UNA-CjAlX5bu6TuPPK7fTFQ>
    <xmx:JyYUaKdOR_S8RgTAzoOt0U-PYbxrucOd3oZBcnLDTR6w1guxsW9N9w>
    <xmx:JyYUaGtmJPVXkcxpKLCqC20H-gkWSQjfmUJgPu_7nm55VfO_OphSjg4N>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 May 2025 21:55:50 -0400 (EDT)
Date: Fri, 2 May 2025 03:55:48 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Alan Huang <mmpgouride@gmail.com>
Cc: kent.overstreet@linux.dev, kees@kernel.org, gustavoars@kernel.org,
	thorsten.blum@toblux.com, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: Remove incorrect __counted_by annotation
Message-ID: <aBQmJIXygwIwj5Yy@archlinux>
References: <20250501200132.216859-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501200132.216859-1-mmpgouride@gmail.com>

On 02 04:01:31, Alan Huang wrote:
> This actually reverts 86e92eeeb237 ("bcachefs: Annotate struct bch_xattr
> with __counted_by()").
> 
> After the x_name, there is a value. According to the disscussion[1],
> __counted_by assumes that the flexible array member contains exactly
> the amount of elements that are specified. Now there are users came across
> a false positive detection of an out of bounds write caused by
> the __counted_by here[2], so revert that.
> 
> [1] https://lore.kernel.org/lkml/Zv8VDKWN1GzLRT-_@archlinux/T/#m0ce9541c5070146320efd4f928cc1ff8de69e9b2
> [2] https://privatebin.net/?a0d4e97d590d71e1#9bLmp2Kb5NU6X6cZEucchDcu88HzUQwHUah8okKPReEt
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Reviewed-by: Jan Hendrik Farr <kernel@jfarr.cc>

> ---
>  fs/bcachefs/xattr_format.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
> index c7916011ef34..67426e33d04e 100644
> --- a/fs/bcachefs/xattr_format.h
> +++ b/fs/bcachefs/xattr_format.h
> @@ -13,7 +13,13 @@ struct bch_xattr {
>  	__u8			x_type;
>  	__u8			x_name_len;
>  	__le16			x_val_len;
> -	__u8			x_name[] __counted_by(x_name_len);
> +	/*
> +	 * x_name contains the name and value counted by
> +	 * x_name_len + x_val_len. The introduction of
> +	 * __counted_by(x_name_len) caused a false positive
> +	 * detection of an out of bounds write.
> +	 */

In my estimation the comment isn't strictly needed with the name
change in Patch 2/2, but it can also stay.

> +	__u8			x_name[];
>  } __packed __aligned(8);
>  
>  #endif /* _BCACHEFS_XATTR_FORMAT_H */
> -- 
> 2.48.1
> 

I was able to reproduce this issue with gcc 15.1.1 and bcachefs as
rootfs (and verify that this fixes it), but wasn't able to reproduce
using clang 19.1.7. Turns out there is one more difference in how
gcc and clang do __bdos. clang apparantly doesn't handle pointer
arithmetic done using + symbol instead of [] for the __counted_by
case. Here's a reproducer:
https://godbolt.org/z/136T98Wdz

Best Regards
Jan

