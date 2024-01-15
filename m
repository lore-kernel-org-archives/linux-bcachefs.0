Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C42918646
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="maBzWLov"
Date: Mon, 15 Jan 2024 13:45:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705344325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Psn/ZavdnSlW6bX0xyPozU9b/S+Ys0omupthUgUhGMU=;
	b=maBzWLovakcSOmtUBQPW9ACS/1/r0odxT3D6ihJFvtDRQnL9XrTJbXW+Yehb/Bu2K0tNUM
	fS3WIzYDrLNJlHFajjpuqufRgS1E5g7yhg75VXG2O4grcXUAbbrFGqlN6fEg2Vzn/btQYY
	zzMUJ2pFYctTwG03tkFE7f5S0vcQY48=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
Message-ID: <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115175509.GA156208@fedora-laptop>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 15, 2024 at 10:55:09AM -0700, Thomas Bertschinger wrote:
> On Mon, Jan 15, 2024 at 12:32:23PM -0500, Kent Overstreet wrote:
> > I think there's some more rearraging we could do - it'd be cleaner if we
> > moved the C sources out of the top level directory, perhaps to c_src,
> > and then moved everything in rust-src/ to the toplevel.
> > 
> > Top level directory is getting a bit crowded, and then the new bcachefs
> > binary won't be quite so out of the way; I frequently build and run
> > without installing when I'm debugging.
> 
> I agree this makes sense. I'll work on a v2 that does this.
> 
> Thoughts on keeping Make as the top-level build tool vs. using Cargo? I
> am still fairly new to Rust/Cargo so I'm not sure how easy it would be
> to replicate all of the Makefile targets in Cargo. It does appear to be
> possible to use Cargo to invoke gcc to build the C library.
#
> I can see three approaches:
> - keep Make as the primary build tool
> - hybrid: use Cargo for source code building but keep the Makefile around
>   for the supplemental targets like "make doc", "make rpm", etc.
> - use Cargo for everything (not sure if this is easy / possible, but I
>   could look into it if desired)
> 
> I'm leaning towards keeping Make as the primary build tool for now and
> perhaps a future patch can move towards using Cargo. But other opinions
> are welcome.

Let's hold off on that for now.

I'm planning on pullling the Rust code in bch_bindgen into the kernel
soon, and I want to see how that interacts with the kernel build system.
If there's potential for commonality with the kernel build system, we
might want to take advantage of that.

(Also, if you're interested in that project, let me know! Getting that
ready for the next merge window is a high priority item, but I have a
lot of high priority items at the moment... :)
