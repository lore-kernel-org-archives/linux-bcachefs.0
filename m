Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3166D17;
	Mon,  5 May 2025 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746434079; cv=none; b=Wfl+w0ZMCzW38whz2/bJntm5AcDcJe7ikC4tC6FU6h2oWpDsCl1m9jt3COfDqwZqm3bQQ62MQ4Rss9jRq7AqsCAZwu2KqBBlUel4BTJ8vMduBjrMiblkhP4PS4NB9debG1TZpVLfxOhQIy5ZUEH4H/pe784/xEcLdWe2BlLwMTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746434079; c=relaxed/simple;
	bh=cF7CtMTOva/omrFd2GBGNkHwlmdeYOLnMVfYsgMyro8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AtgwddGUduA8BH920slpr8XnpjsRXcfjICganxh24JXhBLxMP8JKVQ3mwZYRn0M9HpSHVqFMetvU9C1KKkms8UmjJLmyI6X5hmup2okk4hvp7vhDZBO/UcMgCiFeiQ5Oa5eUH77RcdfSh5Yo1mntMj63yL9DVHur0LtGzTMJjUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pk7rq0n8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pk7rq0n8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B041C4CEE4;
	Mon,  5 May 2025 08:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746434078;
	bh=cF7CtMTOva/omrFd2GBGNkHwlmdeYOLnMVfYsgMyro8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pk7rq0n86kUCFe8Qo65jT+JsvqJT6B39o0Z1coFyRrruNgyOmNUCtJmh32RqE1mxu
	 0BXJVNl+ko1IJePM6rdrBYnp+x5BdsRowEmcwmdkIOqyq5+T9hgm1F0TsSInsp4MmK
	 F6dICg8wXakuK9rPGpvGkObaf5niEPxvkviGdcoM=
Date: Mon, 5 May 2025 10:34:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.14.y
Message-ID: <2025050558-subtly-swifter-fbed@gregkh>
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

Also, as this single commit is a revert of something in 6.12.y, should
it also be applied there to remove any false-positives happening with
those users?

thanks,

greg k-h
