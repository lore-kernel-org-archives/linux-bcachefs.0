Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QRBJHuEi"
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095021AD
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 15:42:16 -0800 (PST)
Date: Sat, 18 Nov 2023 18:42:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700350935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qglip7vTd3UVNdiF0CIxp3RNVorSWwPnlStU+LpIkOA=;
	b=QRBJHuEiPKgqGbJ6twVreeMAb6OdZ7wbBaFdl2vpsGaiJP6Kiet5yizF1VgyEH8awyXufN
	dqB+MlMRvmzYNcEdV6Y9IukJMWGMvAEo53pZk7fMHtMd6i+JrNCYMbgFZmVHMXXBockswA
	mEDj62dAMQ5wm6XNOyLs8SFNJ5156BU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Message-ID: <20231118234205.24nzm7liawamgxhx@moria.home.lan>
References: <23311511.6Emhk5qWAg@lichtvoll.de>
 <2210413.NgBsaNRSFp@lichtvoll.de>
 <20231118210727.6s7bi3e4lldnrpoj@moria.home.lan>
 <4197014.1IzOArtZ34@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4197014.1IzOArtZ34@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 19, 2023 at 12:15:19AM +0100, Martin Steigerwald wrote:
> Thanks again, Kent.
> 
> Kent Overstreet - 18.11.23, 22:07:27 CET:
> > > As far as I understand one specific performance related aspect of
> > > BCacheFS would be low latencies due to the frontend / backend
> > > architecture which in principle is based on what has been there in
> > > BCache already. I am intending to explore a bit into that concept in
> > > my article.
> > 
> > The low latency stuff actually wasn't in bcache - that work came later.
> 
> So the frontend / backend architecture is not that much of what makes 
> BCacheFS unique? Important to know as it seems I may have misunderstood 
> something here.

The "filesystem on top of a database" is the main thing that makes
bcachefs unique - you have that right.

bcache had much of the core btree design - log structured btree nodes
with eytzinger search trees; that's how we got a high enough performance
btree to make the "filesystem on top of a database" thing practical.

But the btree in bcache was, from a performance POV, prototype quality -
stable, but a lot of performance corner cases unfinished.

The latency work, real iterators, and the whole transaction layer came
later :)
