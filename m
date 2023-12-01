Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fsrfKCBB"
Received: from out-6.mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECB9F4
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 18:00:10 -0800 (PST)
Date: Thu, 30 Nov 2023 21:00:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701396009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZX/MNOmx00cy2Fdo9CtCQOqXCarPfBG2qiuNt6oOAkU=;
	b=fsrfKCBBfVXuJRKIV5debznWqU9tP2FO6mrQhYkCy5bRObz0fbCShKWjNDHsLrFJZ8MjFN
	BpApEDGgQnntOAaxbt9hd2JJmUdv4cPvi+4lhwpD4itFdRJasZyYOIVEJq787cr6pmRSRm
	fmubomz67TEE7mpufbXwKQ7S8/UY8ZU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: remove sb lock and flags update on explicit
 shutdown
Message-ID: <20231201020006.4i5gztfj6m2lr264@moria.home.lan>
References: <20231130191711.384300-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130191711.384300-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 30, 2023 at 02:17:11PM -0500, Brian Foster wrote:
> bcachefs grabs s_umount and sets SB_RDONLY when the fs is shutdown
> via the ioctl() interface. This has a couple issues related to
> interactions between shutdown and freeze:
> 
> 1. The flags == FSOP_GOING_FLAGS_DEFAULT case is a deadlock vector
>    because freeze_bdev() calls into freeze_super(), which also
>    acquires s_umount.
> 
> 2. If an explicit shutdown occurs while the sb is frozen, SB_RDONLY
>    alters the thaw path as if the sb was read-only at freeze time.
>    This effectively leaks the frozen state and leaves the sb frozen
>    indefinitely.
> 
> The usage of SB_RDONLY here goes back to the initial bcachefs commit
> and AFAICT is simply historical behavior. This behavior is unique to
> bcachefs relative to the handful of other filesystems that support
> the shutdown ioctl(). Typically, SB_RDONLY is reserved for the
> proper remount path, which itself is restricted from modifying
> frozen superblocks in reconfigure_super(). Drop the unnecessary sb
> lock and flags update bch2_ioc_goingdown() to address both of these
> issues.

Nice, I noticed a deadlock issue recently with s_umount here but didn't
have time to fully debug it - applied!
