Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IB8RudnR"
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [IPv6:2001:41d0:203:375::b8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE380173B
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 12:34:04 -0800 (PST)
Date: Fri, 8 Dec 2023 15:33:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702067642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h11KbIL/WR5dQWL1F6l7g7kI70ZhCOqA4CuGwr0XQK8=;
	b=IB8RudnRi/H4zaXe6QQ4vGGhCizXLpx8wEXXCtimKO6KDSX521aWq7vVPddOYhKcKM3a1p
	QObvYTB5tG6wJlJp/6b6fv2pRbwvtzDOMz4Jm7MhmucIDPnPr8gRamchImlfFT1RSyiZ6O
	w6/HfZyMBaE8tcF7ezdXNsIXlVcnjmE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 5/6] bcachefs: BCH_IOCTL_FSCK_OFFLINE
Message-ID: <20231208203359.adh2j3fsjwqfkxzr@moria.home.lan>
References: <20231206203313.2197302-1-kent.overstreet@linux.dev>
 <20231206203313.2197302-6-kent.overstreet@linux.dev>
 <ZXN8DXEWJ7WbjxHV@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXN8DXEWJ7WbjxHV@bfoster>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 08, 2023 at 03:26:53PM -0500, Brian Foster wrote:
> On Wed, Dec 06, 2023 at 03:33:09PM -0500, Kent Overstreet wrote:
> > This adds a new ioctl for running fsck on a list of devices.
> > 
> > Normally, if we wish to use the kernel's implementation of fsck we'd run
> > it at mount time with -o fsck. This ioctl lets us run fsck without
> > mounting, so that userspace bcachefs-tools can transparently switch to
> > the kernel's implementation of fsck when appropriate - primarily if the
> > kernel version of bcachefs better matches the filesystem on disk.
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  fs/bcachefs/bcachefs_ioctl.h |  13 +++
> >  fs/bcachefs/chardev.c        | 206 ++++++++++++++++++++++++++++++++++-
> >  fs/bcachefs/recovery.c       |   6 +-
> >  3 files changed, 219 insertions(+), 6 deletions(-)
> > 
> ...
> > diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
> > index 8e3ac2d32298..03082a001036 100644
> > --- a/fs/bcachefs/chardev.c
> > +++ b/fs/bcachefs/chardev.c
> ...
> > @@ -193,8 +196,196 @@ static long bch2_ioctl_incremental(struct bch_ioctl_incremental __user *user_arg
> >  }
> >  #endif
> >  
> ...
> > +
> > +static const struct file_operations fsck_thread_ops = {
> > +	.release	= bch2_fsck_thread_release,
> > +	.read		= bch2_fsck_thread_read,
> > +	.llseek		= no_llseek,
> > +};
> > +
> > +static int bch2_fsck_offline_thread_fn(void *arg)
> > +{
> > +	struct fsck_thread *thr = container_of(arg, struct fsck_thread, thr);
> > +	struct bch_fs *c = bch2_fs_open(thr->devs, thr->nr_devs, thr->opts);
> > +
> > +	thr->thr.ret = PTR_ERR_OR_ZERO(c);
> > +	if (!thr->thr.ret)
> > +		bch2_fs_stop(c);
> > +
> 
> Looks pretty neat. Mainly just curious if I'm following this right...
> Basically it looks like we wire up the log output redirect to c->output
> via options, then start/stop the fs which runs "mount time" fsck (?),
> but feeding the message output to the redirect (and then fed to
> userspace via the fd/read handler just above). Hm?

Yup, just that. I still need to wire up input so that the ask_yn()
responses can get passed in, but I'm going to leave that later since I'm
focusing more on online fsck now.
