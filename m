Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADA51D63C2;
	Thu,  1 May 2025 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746120141; cv=none; b=hrwFkNLA53OmP8za2+Zlrj5qNpy4zZbxKsunHBlRTD+gztOZ1ZaiwAshyvE8U6fGcWQ7uzX+CTNpcEm9EuIdiEnI1YdLX310Hj2Z4/oZ1p6a3ny2LiSGsmL5vca2Rb8VEw1JprT9cjVQKqS+YEBZRMyxU/BLgXEKH4iS7VMbHHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746120141; c=relaxed/simple;
	bh=xw/6FUGO5aan5e2p2E5mHLoPfq8iX5kYy7ZB4ZU5noM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4rxVioFcah9dMvmHFcyutmw8gIflONZ70mfwSSrSIYsv6fqW8J68I93hzO6h6k8DlPv1K9WYOSPXlAziEer+eE7EIWzYmuqG7k4aRBa9wvSH3vxsloWIqrcgELj8qAX+MGqSFvtnuw1c+jHBwtm+41nVevR33cYE+HrdsSPJuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=G1m1LA41; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=E1ILxkCf; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="G1m1LA41";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="E1ILxkCf"
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 79C3C25401FC;
	Thu,  1 May 2025 13:22:18 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 01 May 2025 13:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1746120138; x=1746206538; bh=tiBeuouXaP
	QYjkwDBhEQzbBOp8P7ZvCtU9vF4rARNNI=; b=G1m1LA41p3CgAO0C8AlCH1Wiu5
	Ha3yFrUL/wpjcP6zZUyl+OcwtHfgDM9wUsvPOq3GPeEsPnFSHATqV87yu6xjOZKM
	lDrWV6vwk52aDuE4FtawSEPcw2vo16bvO95HwQCplg6qc5mUQStsv/ui5qve6D3L
	TB+yoAgBZDbLZmMOP4raj6IRBDdfX1H8ursGxYP/fpnZLWEI8Lf0n3S9Nf285oNk
	V1pVAbW0EeTxtlVfH4qD2BVBdtsz6mL/jg3KjVjzFAOCeemkJBGAPZXMsWRsDEmG
	IgDZIxWhBoxlCB5Tk54hxd62s+ON/kRKS0BaU3XWeiFq3bFkuBihMkv0FHVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746120138; x=1746206538; bh=tiBeuouXaPQYjkwDBhEQzbBOp8P7ZvCtU9v
	F4rARNNI=; b=E1ILxkCfvLU/m2CPKSwujvgUea9xR/Eficp1KprflbBXNc1mTtX
	s3eESGJ8DkduQqvQ+ruAHR6aJ/wrRonq1GAS9UlrKx1057sZmphBN1zOLDjxZQpK
	SS9El2U7aMrzDHTwWgqhWQYeAE5jED2oq8ZrAr2w+W+7MbA0dSDd2qVCnBxyv5rw
	c87q8dpKVfYHmlJAvAuEbSFHILeV+jfQnI2MxlSiNKdLZdAuy+VKp88RIzXfecPp
	e8OVqYIs+FJC2ayIcSFUGFprs+vQnDFBddleJmr+8P8XEstN2VSc/T5HvfJjIj7e
	jZ6HHGa15roigOewofTv7CpI3R4M5F2CoFA==
X-ME-Sender: <xms:yq0TaELI3WMFrrwKD8_3TBPEGmLWxm3BihBGnY_oWPZYRcTRrg8T2w>
    <xme:yq0TaEKsJ-h8mJVemuT7uE4mzEzbRG2sHxvKAtEC6KKmPqGRlxv6nC_LR61IqRgMj
    3xCRtmpa1LJPg9C3oA>
X-ME-Received: <xmr:yq0TaEv83317PPevSzhYP9lqj6rlCwRwxgLVoEpUdREIdoEGUodLgzvemz-JveydQRf47SYYMXk7URVKhJS7NYVnrY1Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvjedtudeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnegfrhhlucfvnfffucdlfedtmdenucfjughrpeffhffvvefu
    kfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrg
    hrrhcuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpedukeeg
    ffdtfeeihfehteevvdeiueetteelgfefvdfhleeufeegieduieduhfekieenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkvghrnhgvlhesjhhf
    rghrrhdrtggtpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhrtg
    hpthhtohepmhhmphhgohhurhhiuggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepkhgv
    nhhtrdhovhgvrhhsthhrvggvtheslhhinhhugidruggvvhdprhgtphhtthhopehthhhorh
    hsthgvnhdrsghluhhmsehtohgslhhugidrtghomhdprhgtphhtthhopehmihhguhgvlhdr
    ohhjvggurgdrshgrnhguohhnihhssehgmhgrihhlrdgtohhmpdhrtghpthhtohepnhgrth
    hhrghnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdr
    tghomhdprhgtphhtthhopehkvggvsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprh
    gvghhrvghsshhiohhnsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehl
    ihhnuhigqdgstggrtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:yq0TaBY6EbmBTNilkXzn-FfhYMXjqHnICh6YtsUCDBrpC9f4jJWETw>
    <xmx:yq0TaLZDESOtImJafyCkBpk9Os6C2oJjtPSJPXNt-Zu-U7R07S_Q8g>
    <xmx:yq0TaND03THhnesbck8iBfYOaZTKSYviph_Xs4ikVHxlMA5YKddYkg>
    <xmx:yq0TaBau0SfvebMs2U5YFtHqnPV299uecr-06vnEL4d6OyxDvs-8Zg>
    <xmx:yq0TaMNiwApryIZb71BjvI43-ym-UX2_XAYENtSF6i553LmdDn_Lb0_b>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 May 2025 13:22:16 -0400 (EDT)
Date: Thu, 1 May 2025 19:22:14 +0200
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
Message-ID: <aBOtxplvvpgHed7o@archlinux>
References: <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux>
 <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux>
 <20241025011527.GA740745@thelio-3990X>
 <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
 <Zxu4yhmxohKEJVSg@archlinux>
 <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>

> 
> I wonder if the __counted_by(x_name_len) in struct bch_xattr is needed, since there is also a value after x_name.

Wait a minute. Are you saying that the value with length x_val_len
is behind the name (of length x_name_len) at the end of the struct.
So essentially the flexible array member x_name has a length of
x_name_len + x_val_len and contains both the name and value?

If that's the case:

1. that's not at all clear from the struct definition
2. __counted_by(x_name_len) is not correct in that case


Best Regards
Jan
