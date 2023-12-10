Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cF5fuNOL"
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C952ED
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Dec 2023 20:28:28 -0800 (PST)
Date: Sat, 9 Dec 2023 23:28:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702182506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Du5d0ooF1TZLmrl4o8REnouSsa5k9JslLoZlIU2QslM=;
	b=cF5fuNOLO3oaJUldeeHjEOlRrdI11Qfz4qLN3Pq1rb8oXajr2kncv+M4ZsKB7tc9c0wxAq
	2EAQ1qsKa0AKeR5/lRBMqpFpCatH+DkBPIUG/CQR98cQ5a+cfJNFMvPmP65f9IGTXeHIcH
	ZgrtwB9xfPxpYDw7o/9a6feG5LzKk+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Chris Webb <chris@arachsys.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs-tools: Avoid glibc-specific mallinfo() in
 shrinker
Message-ID: <20231210042822.ojfcrz2rk3h4mw5c@moria.home.lan>
References: <2d7abd52206065d763691b082e089811e1e2b962.1702125906.git.chris@arachsys.com>
 <a954a56e0923e067d646f584fc3838bdeae9e2d7.1702125906.git.chris@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a954a56e0923e067d646f584fc3838bdeae9e2d7.1702125906.git.chris@arachsys.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Dec 09, 2023 at 12:50:31PM +0000, Chris Webb wrote:
> Before 326d7c1, the shrinker used freeram and totalram from a struct
> sysinfo (constructed from /proc/meminfo) to target 25% free physical
> memory. As well as the slowness of repeatedly reading /proc/meminfo,
> this was a problem as freeram rises when the system starts to swap.
> We don't want swapping to reduce our estimate of memory pressure.
> 
> To work around this, in 326d7c1 the shrinker started to use the total
> allocated heap from a glibc-specific interface mallinfo2(), aiming to
> shrink such that our heap is less than 80% of physical memory, unless
> overall free memory is less than 6% so that becomes the determining factor.
> 
> Unfortunately, a sign error in the calculation means this heuristic
> never worked. It would shrink aggressively when the process was small,
> and not at all when the process grew beyond 80% of physical RAM. Only the
> fallback test ensuring the free physical RAM doesn't fall below 6% would
> actually kick in under memory pressure. It also breaks portability to
> anything other than recent glibc.
> 
> Later, in 2440469 the mallinfo2() was replaced with the older mallinfo()
> to improve compatibility with older glibc. This is even more problematic:
> it's still not portable but also struct mallinfo has (signed) int fields
> which overflow for large processes on 32-bit machines with a 3G/1G split.
> 
> Rather than trying to use libc-specific debug interfaces and our own heap
> to inform the shrinker, use the information about free and total swap
> we already have from sysinfo(2) to explicitly compensate for swapping
> in our estimate of free physical memory. Target free memory of 6% of
> physical RAM adjusted for zero swap use when calculating the pressure
> on the shrinker, based on the effective behaviour of 326d7c1 in practice
> given the sign error.
> 
> As well as fixing portability to non-glibc systems, this loosens the
> assumption that we are the only process using significant memory when
> setting the shrinker target. It wouldn't be unreasonable to run two
> fsck jobs against independent devices on a large RAM machine and want to
> balance physical RAM between them.
> 
> Signed-off-by: Chris Webb <chris@arachsys.com>

Nice, applied.
