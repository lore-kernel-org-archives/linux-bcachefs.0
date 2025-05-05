Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF766D17;
	Mon,  5 May 2025 08:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746433973; cv=none; b=Jj7F50mbWcrCuHGmz7L0CuETxmw6R8a/dWamf+9fAhecsbwfWWzoSkVHHW9Y9pSVBQryWFwdYdlhUkRYmfZRAtXVqF496WMClup3JIyL7bijSagqzeRYWJLHEXfR4CBGVkhPjCVn97WG3MtARaKd+NS9fOOxnHC+vEM3gX98eR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746433973; c=relaxed/simple;
	bh=3RguQ/BVTfUAnKlvh1LfQn4Iwm7dwmJJ22uIIgIsJr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grZ+SFKhOjZDq+1JXYewoDxAnSgozl/j1ZMz0ur7/ww7g1XGyZWbth29M442JoGwtlCGpztpeGlVc08GQYIzEK1uByJuiQtLMg+Ruy8oNVz0M7QZR0oEB9ePRY+DrHJgd5pyzx/XslxNwN7paoCY9RaG/J0fjxElcRzji752wd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIsYAsAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIsYAsAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63358C4CEE9;
	Mon,  5 May 2025 08:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746433972;
	bh=3RguQ/BVTfUAnKlvh1LfQn4Iwm7dwmJJ22uIIgIsJr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rIsYAsAYpqd7mAqEOKIfoHmnigw6aO3fEyUZ4rrzlWA/hXos62NWEA+CxxLWEMZX+
	 Gfk3IFFjh7fkkxjztezJxxIAHe6S8RNXGWH8OA7oPHlPcg1PZVzH8TIxAVefXhnZRg
	 ID3A30vlw0bZiSagUrtYT1oTQ5/App2gv/X4f5U0=
Date: Mon, 5 May 2025 10:32:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.14.y
Message-ID: <2025050523-oversweet-mooned-3934@gregkh>
References: <hbrzmt73aol6f2fmqpsdtcevhb2sme6lz2otdn73vqpsmlstzt@egrywwkbtpfm>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hbrzmt73aol6f2fmqpsdtcevhb2sme6lz2otdn73vqpsmlstzt@egrywwkbtpfm>

On Fri, May 02, 2025 at 09:12:22PM -0400, Kent Overstreet wrote:
> 
> The following changes since commit 02a22be3c0003af08df510cba3d79d00c6495b74:
> 
>   bcachefs: bch2_ioctl_subvolume_destroy() fixes (2025-04-03 16:13:53 -0400)
> 
> are available in the Git repository at:
> 
>   git://evilpiepirate.org/bcachefs.git tags/bcachefs-for-6.14-2025-05-02
> 
> for you to fetch changes up to 52b17bca7b20663e5df6dbfc24cc2030259b64b6:
> 
>   bcachefs: Remove incorrect __counted_by annotation (2025-05-02 21:09:51 -0400)
> 
> ----------------------------------------------------------------
> bcachefs fixes for 6.15
> 
> remove incorrect counted_by annotation, fixing FORTIFY_SOURCE crashes
> that have been hitting arch users
> 
> ----------------------------------------------------------------
> Alan Huang (1):
>       bcachefs: Remove incorrect __counted_by annotation
> 
>  fs/bcachefs/xattr_format.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

You list 1 patch here, but if I pull this, I see 2 patches against the
latest linux-6.14.y branch.  When rebased, the "additional" one goes
away, as you already sent that to us in the past, so I'll just take the
one that's left here, but please, make this more obvious what is
happening.

Also, I see a lot of syzbot fixes going into bcachefs recently,
hopefully those are all for issues that only affected the tree after
6.14 was released.

thanks,

greg k-h
