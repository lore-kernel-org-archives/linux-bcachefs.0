Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882BF18E08
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BinedNru"
Date: Mon, 15 Jan 2024 14:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705346539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0cFfGNvNwHaVnXCGRXXiKfCUv7+b/z4XZlEWY2jUHco=;
	b=BinedNruxYvBGjX7GXPUWQyjOGIDe47W1lweyhiPVQw4BMUfIF5U7o/b66/Vi2DjTGZPh4
	WUwIVmS8p5CLGj2z+sGowke6yigJIbzcYr7Ani+IUdsLYMroGOmjpojys/8EeEqZ7wNHkG
	PDpiMs67wU6lfTPvF+XoN+qoT+Sph88=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com, 
	Miguel Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
Message-ID: <z7ajmttuzbvtxn4onwoxph6mevqt2rje2nga6cpux73geffias@p5kk7pqnswf6>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop>
 <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
 <20240115191022.GC156208@fedora-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115191022.GC156208@fedora-laptop>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 15, 2024 at 12:10:22PM -0700, Thomas Bertschinger wrote:
> On Mon, Jan 15, 2024 at 01:45:22PM -0500, Kent Overstreet wrote:
> > On Mon, Jan 15, 2024 at 10:55:09AM -0700, Thomas Bertschinger wrote:
> > > I'm leaning towards keeping Make as the primary build tool for now and
> > > perhaps a future patch can move towards using Cargo. But other opinions
> > > are welcome.
> > 
> > Let's hold off on that for now.
> > 
> > I'm planning on pullling the Rust code in bch_bindgen into the kernel
> > soon, and I want to see how that interacts with the kernel build system.
> > If there's potential for commonality with the kernel build system, we
> > might want to take advantage of that.
> > 
> > (Also, if you're interested in that project, let me know! Getting that
> > ready for the next merge window is a high priority item, but I have a
> > lot of high priority items at the moment... :)
> 
> Sure, I would definitely be interested in helping out with that. I don't
> want to make any promises regarding timeline, since this combines two
> worlds--Rust, and Linux Kernel development--that are both still very
> new to me. But I can certainly give it an honest try :) as long as you,
> or someone else experienced, can help with any questions I might run
> into.

Of course :)

Join the IRC channel - irc.oftc.net#bcache, we've got quite a few people
acquainted with Rust there.

The main thing that needs to be sorted out is that we require a patched
version of bindgen (since rustc can't yet handle types that are both
packed and aligned); we need to talk to the rust-for-linux people about
whether they'll be ok with switching the kernel to the patched bindgen
until we can get a proper fix into rustc.
