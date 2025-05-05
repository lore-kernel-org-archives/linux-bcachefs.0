Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8BF1FDD
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 May 2025 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746453281; cv=none; b=Sy195yrMvUmd5zEO6bjcnAY/7PVSaSU/EEoHYtKkPn5ANBBjRMk/2Nr3EB0Pikb4nN3yuyIvfJR588EwMoiiL/JWp42V+SdysQhcq9dsl6333kVSj3EQvq7tjpzKEakhKvOY5aIMctQGpQq2YzF+PinFWWPO1GeRTW0/+E2fEBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746453281; c=relaxed/simple;
	bh=R5bWPSq6iChBwej7BA+lUpmdz+4rU2dlhioIRQ/SImA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMT2w24fIlxN/ksJpUNs6qRUhcgv1U2vWWhOd9c6Amf3SSsK2F0UPez5moKuglDquP14FHEpAez162sghEiI9Dl/Iivt060aEV3rvRPHk8KCEX8PjllReHJrozjsuCJanWcV/CM4Ux3AShnxsmRfTOwtJwgrKTYSdKy0CG8Z2Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TCpzQuvL; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TCpzQuvL"
Date: Mon, 5 May 2025 09:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746453267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7mOzKSB+hmQwmNxlUWpy7IdyLav7Gggc/fjNSPZIKm0=;
	b=TCpzQuvLi/0O5TyBL2s3J9YXki01jxUpdhNs9L3XzDtSzScsRNAFcU4Cqzl/mKCESTs9GI
	CK6R1L6/4JTIUVn+efqb3DbFSIWbIBHLbraq/LuSHMaL/XU13+HTlODMluuGSd6xVUiz75
	qyW0MAVu7LQ0QQiNTMAzxlw0I9RTszA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-bcachefs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.14.y
Message-ID: <gjr5fogy6fuev264diupbdyoyat6pdwa2fklxaf6cvu4mr3vck@6vvfw7awb5qy>
References: <hbrzmt73aol6f2fmqpsdtcevhb2sme6lz2otdn73vqpsmlstzt@egrywwkbtpfm>
 <2025050523-oversweet-mooned-3934@gregkh>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025050523-oversweet-mooned-3934@gregkh>
X-Migadu-Flow: FLOW_OUT

On Mon, May 05, 2025 at 10:32:49AM +0200, Greg Kroah-Hartman wrote:
> On Fri, May 02, 2025 at 09:12:22PM -0400, Kent Overstreet wrote:
> > 
> > The following changes since commit 02a22be3c0003af08df510cba3d79d00c6495b74:
> > 
> >   bcachefs: bch2_ioctl_subvolume_destroy() fixes (2025-04-03 16:13:53 -0400)
> > 
> > are available in the Git repository at:
> > 
> >   git://evilpiepirate.org/bcachefs.git tags/bcachefs-for-6.14-2025-05-02
> > 
> > for you to fetch changes up to 52b17bca7b20663e5df6dbfc24cc2030259b64b6:
> > 
> >   bcachefs: Remove incorrect __counted_by annotation (2025-05-02 21:09:51 -0400)
> > 
> > ----------------------------------------------------------------
> > bcachefs fixes for 6.15
> > 
> > remove incorrect counted_by annotation, fixing FORTIFY_SOURCE crashes
> > that have been hitting arch users
> > 
> > ----------------------------------------------------------------
> > Alan Huang (1):
> >       bcachefs: Remove incorrect __counted_by annotation
> > 
> >  fs/bcachefs/xattr_format.h | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> You list 1 patch here, but if I pull this, I see 2 patches against the
> latest linux-6.14.y branch.  When rebased, the "additional" one goes
> away, as you already sent that to us in the past, so I'll just take the
> one that's left here, but please, make this more obvious what is
> happening.

That's because you're rebasing my patches.

> Also, I see a lot of syzbot fixes going into bcachefs recently,
> hopefully those are all for issues that only affected the tree after
> 6.14 was released.

Until the experimental label comes off I'm only doing critical
backports - it really doesn't make any sense to do anything else right
now.

The syzbot stuff has had zero overlap with user reported bugs, and since
it's fuzzing the on disk image (and we don't support unprivilidged
mounts - yet, at least) - they haven't been a security concern. There's
been one security bug since 6.7, and you have that fix.
