Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j8vcB5AZ"
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BAC19A
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 14:09:06 -0800 (PST)
Date: Tue, 28 Nov 2023 17:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701209345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ddN76D14LUKvaYU/VUz8fqe+A2KVTMUTWd46yZfejAo=;
	b=j8vcB5AZL+Otc/WXLL1hvr6Qh3jRuzXkzQ77hZW43eRWRiDSGH+KsZDCn6qiK3PMSHKh7S
	6ndTMLibBo+lZQeqzooOZDYipA1xSg2gvHrRSMX60+l2qasfrKGH0JVDZ39HX28US2cDaV
	nqcqtBEYV9q8dz3OPTtmfTVyBV8P0vw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nick Terrell <terrelln@meta.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	Nick Terrell <nickrterrell@gmail.com>
Subject: Re: Zstd write past end reproducer
Message-ID: <20231128220903.up7chj4mw5r6glbf@moria.home.lan>
References: <F9E55704-6BF2-4ABD-9DB6-62D908EB97DC@meta.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F9E55704-6BF2-4ABD-9DB6-62D908EB97DC@meta.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 10:04:02PM +0000, Nick Terrell wrote:
> Hi Kent,
> 
> I see in the bcachefs compression code this comment [0]:
> 
> 	Additionally, the ZSTD code seems to have a bug where it will
> 	write just past the end of the buffer - so subtract a fudge
> 	factor (7 bytes) from the dst buffer size to account for
> 	that.
> 
> This is very unexpected, as zstd is extensively fuzzed for these types of bugs.
> It doesn’t look like bcachefs is using zstd in a way that would trigger a unique
> code path, so my first suspicion is that there is a bug in the way that bcachefs
> is calling zstd.
> 
> I spent some time trying to reproduce the issue by calling zstd in the same way
> that bcachefs called zstd when the workaround was landed, but so far haven’t
> been successful in triggering the bug.
> 
> If you can provide a reproducer, I will look into the issue further. If you can
> provide the input data, the size of the output buffer used, and the parameters
> used (or the level & estimated source size used to derive the parameters), I
> will definitely be able to debug the issue, and get it fixed if it is a problem with
> zstd.
> 
> Best,
> Nick Terrell
> 
> [0] https://github.com/torvalds/linux/blob/v6.7-rc3/fs/bcachefs/compress.c#L588

Sorry, just saw the subject - I haven't looked at the end of buffer bug
in quite awhile, that was many kernel releases ago. It's entirely
possible it's been fixed since then (but it was a nasty source of memory
corruption for a good while).

I never had a reproducer for it, only tracked it down through end user
reports.
