Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uwm74l8o"
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884B112D
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 15:20:05 -0800 (PST)
Date: Sun, 19 Nov 2023 18:20:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700436003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6VRxLm8XASCtHjMkVSEC7SuJf3Q5tIGt1itj7/ai2Ds=;
	b=Uwm74l8omPEIQyBPWfr/befhyDFiP98rkKG1BrhiqtmOWx7lEQzu7++YKtB/mNku4uQx/C
	MPqdmwdHqs7yMGoc5u/SP7RMT3zBnA0JMBVaGJKIrDiBQEYG87oLHL3eXiGOaAlPVHj1NT
	aSgFFemlisk7zrXQpyKYGeDIG+4dEfA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Finn Behrens <me@kloenk.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATH TOOLS] nix: add bcachefs-fuse package
Message-ID: <20231119232000.rlvnbt254y2hl32l@moria.home.lan>
References: <20231119211314.301361-1-me@kloenk.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231119211314.301361-1-me@kloenk.de>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 19, 2023 at 10:13:14PM +0100, Finn Behrens wrote:
> Add a fuseSupport argument and bcachefs-fuse as flake output with fuse enabled.
> 
> Signed-off-by: Finn Behrens <me@kloenk.de>

We can't do this just yet, not until the fuse support is getting more
attention; it's been frequently failing to build lately.

There have been people getting interested in that code though, so -
soon, perhaps?
