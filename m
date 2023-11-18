Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B1hkYmYg"
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A072DD8
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 13:07:33 -0800 (PST)
Date: Sat, 18 Nov 2023 16:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700341651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yaRnjmoaF5Oo35BZwoYyVtA5lMWCYfHTNn0gSWe+jTU=;
	b=B1hkYmYgIUQHbpVsNXhOe3ZQ07lLuBfZAKIpIppbOiBWEa5X6xw7L66VSvwyyoNMytPkPN
	Bd4B73PXDhIYEZyQ1YOBQTq1Av0UcbHZn6ori3HIMrbE8nmVVlaWWHnfk8/RPjQe/QXKnc
	3hGV7S63h35N4gcJg+JzFhRbvJC/hzA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Message-ID: <20231118210727.6s7bi3e4lldnrpoj@moria.home.lan>
References: <23311511.6Emhk5qWAg@lichtvoll.de>
 <20231118195024.qe2bjxeubhru3de5@moria.home.lan>
 <2210413.NgBsaNRSFp@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2210413.NgBsaNRSFp@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Sat, Nov 18, 2023 at 09:57:50PM +0100, Martin Steigerwald wrote:
> Hi Kent.
> 
> Thanks for answering so timely. Feel free to skip answering during rest of 
> the weekend :)
> 
> Kent Overstreet - 18.11.23, 20:50:24 CET:
> > > 10) Anything you think an article about BCacheFS should absolutely
> > > mention?
> > 
> > Would personally love to see some non-phoronix benchmarks :)
> 
> I see. Well thing is, I am not really satisfied about Samsung 980 Pro 2 TB 
> NVME SSD performance on this ThinkPad T14 AMD Gen 1 under Linux, so not 
> sure whether performance benchmarks would be suitable on that setup. At 
> least not without going about a firmware upgrade again and hoping it helps 
> this time, if available. However I remember not really liking to dig out 
> the firmware upgrade from an ISO image for Samsung not providing via LVFS. 
> Also benchmarking may more be in scope of a later article if at all, cause 
> I think even with just explaining about BCacheFS the article will become 
> long enough :). It is challenging to get benchmarking right and obtain 
> actually meaningful results. And before getting it wrong, I'd rather skip 
> or delay that. But anyway: Any suggestion for a specific benchmark?
> 
> Any advice about Phoronix benchmarks? I bet the one I saw was with some 
> debug option on, that may better be off. I think it has been: 
> CONFIG_BCACHEFS_DEBUG_TRANSACTIONS? I did not check whether Michael 
> Larabel did a new one already with that turned off.
> 
> As far as I understand one specific performance related aspect of BCacheFS 
> would be low latencies due to the frontend / backend architecture which in 
> principle is based on what has been there in BCache already. I am 
> intending to explore a bit into that concept in my article.

The low latency stuff actually wasn't in bcache - that work came later.

Things like
 - six locks - so we have intent locks that don't block readers, and
   only need to take write locks for the actual btree node update

 - asynchronous interior btree node updates; in bcache when we split a
   node we have to wait for writes to complete before updating the
   parent node, in bcachefs work after IO completion is fully
   asynchronous

 - the big one that no other filesystem has: a 'btree_trans' object that
   tracks all btree locks, and can be unlocked and then relocked when we
   do an operation that might block (at the cost of a potential
   transaction restart at relock() time) - we never have to block with
   btree locks held.

> > I've put a ton of effort into performance, my goal is a COW filesystem
> > that can compete with XFS on performance and scalabality - which is a
> > tall order! but we're getting close.
> > 
> > With the btree write buffer rewrite (still not quite merged, any day
> > now) - I'm pushing _900k_ iops, 4k random writes - through the COW write
> > path.
> > 
> > This is in my benchmarking/profiling mode, with checksums off and data
> > reads/writes to the device turned off - i.e. just showing bcachefs
> > overhead. So not real world nummbers, but indicative of how well we can
> > scale.
> 
> Interesting. Only thing regarding performance I noticed so far that 
> deleting an almost 8 GiB large DVD ISO image file took a bit longer than 
> instant, but I was using Dolphin on Plasma, so not sure whether this tiny 
> delay was filesystem or GUI related.

It could be that we still have work to do; there are plenty of higher
level filesystem operations that I haven't specifically benchmarked. If
you do happen to do a head to head comparison with other filesystems and
find that unlink (or anything else) is slow - please report it!

> Also I found that free space with "df -hT" was only 35,8 GiB initially, 
> now 36 GiB of 40 GiB instead of the initial 37 GiB after making the 
> filesystem, but I bet that may just be related to allocation behavior. 
> Some kind of chunk allocated but not freed again so it can be reused 
> later. But I need to dig into this a bit deeper. I read about some 
> reservation as well, but need to dig that up again.

That's the copygc reserve.

> I'd really love to dig a bit into what makes BCacheFS unique, also in 
> comparison with BTRFS and maybe a bit also ZFS. Also to explain: "Why yet 
> another filesystem?" to the reader :). My own hope is that indeed BCacheFS 
> will improve on some of the performance issues with BTRFS. And also with 
> BCacheFS you can have cache devices which AFAIK is still not implemented 
> for BTRFS. There was VFS Hot Data Tracking + BTRFS part patches on BTRFS 
> mailing list some longer time ago, but AFAIK they never went in.

Performance with more than a few snapshots is a big selling point vs.
btrfs - Dave Chinner did some comparisons awhile back, bcachefs beats
the pants off of btrfs in snapshot scalability :)
