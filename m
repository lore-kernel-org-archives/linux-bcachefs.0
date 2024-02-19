Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330912031C
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 07:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328543; cv=none; b=bzV9jENtSeoF5EfvQXpGzi7yueEd6/gI1wRuczR19XuxL4tY7+9UsGU2TXIlh4jmgnJpJnbTMirUs0fYGp6tUQixXOD8V8oSB8bAdqrm+DrajUU3WAZM0iip4EqxNi50otmQHQ+Epc+asOjXtjB8T5aLyspJf/tAHhseFT341Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328543; c=relaxed/simple;
	bh=Pvo+Ek3Iy4IsTJjIeDIlt7UnU6DilP1jXSHFrD9iMeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bg1TKx8AtSLwRfmGyn/nsflZ+PlX/zp6ecAtjyuC7b774OH/Z2z/JYoKCgdxuej0WiCEVmaAZh9yJ6CDD4eG+rdZQp9Zjco8PTlAa9W6yV3MCjgncrdmIDB1vgeemx/CyDSfNsJD4ILRzK1LGQbii960NNnZ8MmnYOStObrOxLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DKO6m93L; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DKO6m93L"
Date: Mon, 19 Feb 2024 02:42:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708328534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xv1SsAErNeLDlReQiUOTwWoV7eXbrLbtvJ3wk244HwQ=;
	b=DKO6m93LludDXzuv/K+825dRWtoJRaz1i5qsTKYfz5z7XV+fl5Z+8HYm0+5fiQbpRCVFTA
	QcSmEfctqXPCMsFefinNCpmj3dicT42ZYfwAsB4Ek6miDsxW/B2hc209C6+TN80/WiMNob
	gNOGc2l2/84iKmOu5G7TBPJf8U9aq4Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: linux-kernel@vger.kernel.org, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] arm: Silence gcc warnings about arch ABI drift
Message-ID: <3qjukuaadpxvz2jwhozszq2rlnzymrbbvws3btlhh776aikph6@pabo2w4mr4ao>
References: <fe51512baa18e1480ce997fc535813ce6a0b0721.1708286962.git.jcalvinowens@gmail.com>
 <431dd956-ad31-4da8-ad42-34f7380824bb@app.fastmail.com>
 <ZdL7_-2VCJqjn634@gmail.com>
 <mtelhhn3z7qfo35odeb37doe3pqagesju46awcjnsyhq4xdk7t@ufoyklpskiyf>
 <ZdME6NUCBuy3yq7L@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZdME6NUCBuy3yq7L@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 18, 2024 at 11:36:08PM -0800, Calvin Owens wrote:
> On Monday 02/19 at 02:03 -0500, Kent Overstreet wrote:
> > On Sun, Feb 18, 2024 at 10:58:07PM -0800, Calvin Owens wrote:
> > > On Monday 02/19 at 07:21 +0100, Arnd Bergmann wrote:
> > > > On Mon, Feb 19, 2024, at 05:09, Calvin Owens wrote:
> > > > > 32-bit arm builds uniquely emit a lot of spam like this:
> > > > >
> > > > >     fs/bcachefs/backpointers.c: In function ‘extent_matches_bp’:
> > > > >     fs/bcachefs/backpointers.c:15:13: note: parameter passing for 
> > > > > argument of type ‘struct bch_backpointer’ changed in GCC 9.1
> > > > >
> > > > > Apply the arm64 change from commit ebcc5928c5d9 ("arm64: Silence gcc
> > > > > warnings about arch ABI drift") to silence them. It seems like Dave's
> > > > > original rationale applies here too.
> > > > >
> > > > > Cc: Dave Martin <Dave.Martin@arm.com>
> > > > > Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
> > > > > ---
> > > >
> > > > I think these should be addressed in bcachefs instead.
> > > 
> > > That seems reasonable to me. For clarity, I just happened to notice this
> > > while doing allyesconfig cross builds for something entirely unrelated.
> > > 
> > > I'll take it up with them. It's not a big problem from my POV, the notes
> > > don't cause -Werror builds to fail or anything like that.
> > 
> > Considering we're not dynamic linking it's a non issue for us.
> 
> [ dropping arm people/lists ]
> 
> Would you mind taking this then?
> 
> Thanks,
> Calvin
 
That looks like just the thing - thanks!

> ---8<---
> From: Calvin Owens <jcalvinowens@gmail.com>
> Subject: [PATCH] bcachefs: Silence gcc warnings about arm arch ABI drift
> 
> 32-bit arm builds emit a lot of spam like this:
> 
>     fs/bcachefs/backpointers.c: In function ‘extent_matches_bp’:
>     fs/bcachefs/backpointers.c:15:13: note: parameter passing for argument of type ‘struct bch_backpointer’ changed in GCC 9.1
> 
> Apply the change from commit ebcc5928c5d9 ("arm64: Silence gcc warnings
> about arch ABI drift") to fs/bcachefs/ to silence them.
> 
> Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
> ---
>  fs/bcachefs/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/Makefile b/fs/bcachefs/Makefile
> index 1a05cecda7cc..3433959d4f35 100644
> --- a/fs/bcachefs/Makefile
> +++ b/fs/bcachefs/Makefile
> @@ -90,3 +90,6 @@ bcachefs-y		:=	\
>  	xattr.o
>  
>  obj-$(CONFIG_MEAN_AND_VARIANCE_UNIT_TEST)   += mean_and_variance_test.o
> +
> +# Silence "note: xyz changed in GCC X.X" messages
> +subdir-ccflags-y += $(call cc-disable-warning, psabi)
> -- 
> 2.43.0
> 
