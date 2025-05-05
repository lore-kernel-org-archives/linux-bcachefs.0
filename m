Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C954670;
	Mon,  5 May 2025 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746454018; cv=none; b=hVCXz78VHkO3HMVbi/lLaVAoRhxxZiLPouvp54C0WBVwCeyBDdPHTQy+1B1XlWz7yfuwE8f3fincl+6uErDbVMhLql20m6kkOu4Y4ZSqU2RhiiAA6bKs53qWX8hJFB3D8OlIwp4Nz32eeGk4+h40WOmI5InzZSFkVHQOz57oT6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746454018; c=relaxed/simple;
	bh=4yk0COCDs/croboSuTcvXVie79O3pi5hSv2UczCtjo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJXZ9SHDn1qehjCNKxP6ToEYt6LwG79qgTO7Rxfb1bj9psVuHZvmuYUmYmS0YjipuXaqC1Kqlqjja1KSydjzkKauDvz26oGwWDoTItjfpL4UZIyhS7p6bJx0rUQg8VlhN3d3TZBYtmY9ilNaIXMgjOlvocv7EXEx7G7k12u5GPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvCF32Ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvCF32Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70759C4CEEE;
	Mon,  5 May 2025 14:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746454017;
	bh=4yk0COCDs/croboSuTcvXVie79O3pi5hSv2UczCtjo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rvCF32HtSqGtnRqF+z8FLBdbRzkWTWgrgechM+O6U1CeR6muJMw5JfmQndjBXhFcA
	 K6wzpH1QyVvTWXxoljXAys4a/RBz+hi2B/FyrEbg9KVjh32KSJhYG62K9ZZ2kc7xqG
	 GegTvRgPhWZWs4IkhERHL+Pt+lg/CoH1gQaJFpH0=
Date: Mon, 5 May 2025 16:06:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.14.y
Message-ID: <2025050543-overkill-eradicate-2bdf@gregkh>
References: <hbrzmt73aol6f2fmqpsdtcevhb2sme6lz2otdn73vqpsmlstzt@egrywwkbtpfm>
 <2025050523-oversweet-mooned-3934@gregkh>
 <gjr5fogy6fuev264diupbdyoyat6pdwa2fklxaf6cvu4mr3vck@6vvfw7awb5qy>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gjr5fogy6fuev264diupbdyoyat6pdwa2fklxaf6cvu4mr3vck@6vvfw7awb5qy>

On Mon, May 05, 2025 at 09:54:24AM -0400, Kent Overstreet wrote:
> On Mon, May 05, 2025 at 10:32:49AM +0200, Greg Kroah-Hartman wrote:
> > On Fri, May 02, 2025 at 09:12:22PM -0400, Kent Overstreet wrote:
> > > 
> > > The following changes since commit 02a22be3c0003af08df510cba3d79d00c6495b74:
> > > 
> > >   bcachefs: bch2_ioctl_subvolume_destroy() fixes (2025-04-03 16:13:53 -0400)
> > > 
> > > are available in the Git repository at:
> > > 
> > >   git://evilpiepirate.org/bcachefs.git tags/bcachefs-for-6.14-2025-05-02
> > > 
> > > for you to fetch changes up to 52b17bca7b20663e5df6dbfc24cc2030259b64b6:
> > > 
> > >   bcachefs: Remove incorrect __counted_by annotation (2025-05-02 21:09:51 -0400)
> > > 
> > > ----------------------------------------------------------------
> > > bcachefs fixes for 6.15
> > > 
> > > remove incorrect counted_by annotation, fixing FORTIFY_SOURCE crashes
> > > that have been hitting arch users
> > > 
> > > ----------------------------------------------------------------
> > > Alan Huang (1):
> > >       bcachefs: Remove incorrect __counted_by annotation
> > > 
> > >  fs/bcachefs/xattr_format.h | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > You list 1 patch here, but if I pull this, I see 2 patches against the
> > latest linux-6.14.y branch.  When rebased, the "additional" one goes
> > away, as you already sent that to us in the past, so I'll just take the
> > one that's left here, but please, make this more obvious what is
> > happening.
> 
> That's because you're rebasing my patches.

Not really a "rebase", but rather a "cherry-pick", but we've been
through this before, so no need to go over it again :)

> > Also, I see a lot of syzbot fixes going into bcachefs recently,
> > hopefully those are all for issues that only affected the tree after
> > 6.14 was released.
> 
> Until the experimental label comes off I'm only doing critical
> backports - it really doesn't make any sense to do anything else right
> now.

Ok.

> The syzbot stuff has had zero overlap with user reported bugs, and since
> it's fuzzing the on disk image (and we don't support unprivilidged
> mounts - yet, at least) - they haven't been a security concern. There's
> been one security bug since 6.7, and you have that fix.

Great, thanks!

greg k-h
