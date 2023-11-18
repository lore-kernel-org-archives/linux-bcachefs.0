Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 6117 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Nov 2023 12:57:53 PST
Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016F411D
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 12:57:52 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id C4FB2815EF7;
	Sat, 18 Nov 2023 21:57:50 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Date: Sat, 18 Nov 2023 21:57:50 +0100
Message-ID: <2210413.NgBsaNRSFp@lichtvoll.de>
In-Reply-To: <20231118195024.qe2bjxeubhru3de5@moria.home.lan>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de>
 <20231118195024.qe2bjxeubhru3de5@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Kent.

Thanks for answering so timely. Feel free to skip answering during rest of 
the weekend :)

Kent Overstreet - 18.11.23, 20:50:24 CET:
> > 10) Anything you think an article about BCacheFS should absolutely
> > mention?
> 
> Would personally love to see some non-phoronix benchmarks :)

I see. Well thing is, I am not really satisfied about Samsung 980 Pro 2 TB 
NVME SSD performance on this ThinkPad T14 AMD Gen 1 under Linux, so not 
sure whether performance benchmarks would be suitable on that setup. At 
least not without going about a firmware upgrade again and hoping it helps 
this time, if available. However I remember not really liking to dig out 
the firmware upgrade from an ISO image for Samsung not providing via LVFS. 
Also benchmarking may more be in scope of a later article if at all, cause 
I think even with just explaining about BCacheFS the article will become 
long enough :). It is challenging to get benchmarking right and obtain 
actually meaningful results. And before getting it wrong, I'd rather skip 
or delay that. But anyway: Any suggestion for a specific benchmark?

Any advice about Phoronix benchmarks? I bet the one I saw was with some 
debug option on, that may better be off. I think it has been: 
CONFIG_BCACHEFS_DEBUG_TRANSACTIONS? I did not check whether Michael 
Larabel did a new one already with that turned off.

As far as I understand one specific performance related aspect of BCacheFS 
would be low latencies due to the frontend / backend architecture which in 
principle is based on what has been there in BCache already. I am 
intending to explore a bit into that concept in my article.

> I've put a ton of effort into performance, my goal is a COW filesystem
> that can compete with XFS on performance and scalabality - which is a
> tall order! but we're getting close.
> 
> With the btree write buffer rewrite (still not quite merged, any day
> now) - I'm pushing _900k_ iops, 4k random writes - through the COW write
> path.
> 
> This is in my benchmarking/profiling mode, with checksums off and data
> reads/writes to the device turned off - i.e. just showing bcachefs
> overhead. So not real world nummbers, but indicative of how well we can
> scale.

Interesting. Only thing regarding performance I noticed so far that 
deleting an almost 8 GiB large DVD ISO image file took a bit longer than 
instant, but I was using Dolphin on Plasma, so not sure whether this tiny 
delay was filesystem or GUI related.

Also I found that free space with "df -hT" was only 35,8 GiB initially, 
now 36 GiB of 40 GiB instead of the initial 37 GiB after making the 
filesystem, but I bet that may just be related to allocation behavior. 
Some kind of chunk allocated but not freed again so it can be reused 
later. But I need to dig into this a bit deeper. I read about some 
reservation as well, but need to dig that up again.

I'd really love to dig a bit into what makes BCacheFS unique, also in 
comparison with BTRFS and maybe a bit also ZFS. Also to explain: "Why yet 
another filesystem?" to the reader :). My own hope is that indeed BCacheFS 
will improve on some of the performance issues with BTRFS. And also with 
BCacheFS you can have cache devices which AFAIK is still not implemented 
for BTRFS. There was VFS Hot Data Tracking + BTRFS part patches on BTRFS 
mailing list some longer time ago, but AFAIK they never went in.

Best,
-- 
Martin


