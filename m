Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y8Mhsq1t"
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA39FF4
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Dec 2023 16:38:37 -0800 (PST)
Date: Fri, 1 Dec 2023 19:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701477515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ndh0q6hknmNqO3AcT8ZIgD4pO+HyGuFWYjO+keNOVuI=;
	b=Y8Mhsq1tIkXTV6yG0Bx07zYJ7Skp49BmPauaYbzB18GEI3FmHhHPlga1HY9NAQM76IRVo8
	DdJ7gEeEIJpKXFR7c+iyw8owiZfiXAFxJoXclcTq19XFk6tofYdpyYERr1Tm0FreSbPjgn
	mCTxh7u0UK8SbkomdXtHJE4dASNYcTw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: remove sb lock and flags update on explicit
 shutdown
Message-ID: <20231202003832.siuozvioahjhwhnq@moria.home.lan>
References: <20231130191711.384300-1-bfoster@redhat.com>
 <20231201020006.4i5gztfj6m2lr264@moria.home.lan>
 <ZWnjGOvxSLUfUos2@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWnjGOvxSLUfUos2@bfoster>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 01, 2023 at 08:43:52AM -0500, Brian Foster wrote:
> On Thu, Nov 30, 2023 at 09:00:06PM -0500, Kent Overstreet wrote:
> > On Thu, Nov 30, 2023 at 02:17:11PM -0500, Brian Foster wrote:
> > > bcachefs grabs s_umount and sets SB_RDONLY when the fs is shutdown
> > > via the ioctl() interface. This has a couple issues related to
> > > interactions between shutdown and freeze:
> > > 
> > > 1. The flags == FSOP_GOING_FLAGS_DEFAULT case is a deadlock vector
> > >    because freeze_bdev() calls into freeze_super(), which also
> > >    acquires s_umount.
> > > 
> > > 2. If an explicit shutdown occurs while the sb is frozen, SB_RDONLY
> > >    alters the thaw path as if the sb was read-only at freeze time.
> > >    This effectively leaks the frozen state and leaves the sb frozen
> > >    indefinitely.
> > > 
> > > The usage of SB_RDONLY here goes back to the initial bcachefs commit
> > > and AFAICT is simply historical behavior. This behavior is unique to
> > > bcachefs relative to the handful of other filesystems that support
> > > the shutdown ioctl(). Typically, SB_RDONLY is reserved for the
> > > proper remount path, which itself is restricted from modifying
> > > frozen superblocks in reconfigure_super(). Drop the unnecessary sb
> > > lock and flags update bch2_ioc_goingdown() to address both of these
> > > issues.
> > 
> > Nice, I noticed a deadlock issue recently with s_umount here but didn't
> > have time to fully debug it - applied!
> > 
> 
> Thanks!
> 
> Hmm.. got a reference to that observed deadlock handy? I'd be a little
> cautious associating here because 1. I dont think any test tooling
> currently uses the default shutdown mode for the ioctl and 2. the
> non-ioctl emergency shutdown paths dont set SB_RDONLY, so shouldn't
> trigger the freeze issue.

No, only observed it once and I was looking at other stuff at the time,
alas.

> So IOW while this path was broken in the ways described in the commit
> log, it still seems rather unlikely for a normal use or test case to
> trigger this. It would be good to know if there's still a lingering
> issue to resolve..

Touching a VFS lock here at all was always a bit suspect; I have no idea
where I originally cribbed that from. I generally try to keep a clearer
separation between VFS locks/state and filesystem locks/state...
