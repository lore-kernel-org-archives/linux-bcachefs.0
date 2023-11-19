Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wDIP4W+u"
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [IPv6:2001:41d0:203:375::b1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE6613A
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 15:10:06 -0800 (PST)
Date: Sun, 19 Nov 2023 18:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700435404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IDD1uPA0AsZPDcOZGF/voFJzzBsJ3khPr9x2LMymUWo=;
	b=wDIP4W+u+kIPynWJMV1jRmLbbQ3ht7u2snyq4Bi6g807jwIUCbwLrbH5UvW2S6Cb4mRzw/
	nWCyLvklfoldCf4jo+M1OQS9XItWRem39030Q2TFdZF54DVPtY95oj9FFnEBwvOkjdUjcI
	OQNhjFB4oh4ahICgj407e9L/5dQqZYM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Message-ID: <20231119231001.tb3teva5j4azqp7i@moria.home.lan>
References: <23311511.6Emhk5qWAg@lichtvoll.de>
 <4197014.1IzOArtZ34@lichtvoll.de>
 <20231118234205.24nzm7liawamgxhx@moria.home.lan>
 <2273246.iZASKD2KPV@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2273246.iZASKD2KPV@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 19, 2023 at 12:13:29PM +0100, Martin Steigerwald wrote:
> Take your time and have a great Sunday :)
> 
> Kent Overstreet - 19.11.23, 00:42:05 CET:
> > On Sun, Nov 19, 2023 at 12:15:19AM +0100, Martin Steigerwald wrote:
> > > Kent Overstreet - 18.11.23, 22:07:27 CET:
> > > > > As far as I understand one specific performance related aspect of
> > > > > BCacheFS would be low latencies due to the frontend / backend
> > > > > architecture which in principle is based on what has been there in
> > > > > BCache already. I am intending to explore a bit into that concept
> > > > > in
> > > > > my article.
> > > > 
> > > > The low latency stuff actually wasn't in bcache - that work came
> > > > later.
> > > 
> > > So the frontend / backend architecture is not that much of what makes
> > > BCacheFS unique? Important to know as it seems I may have
> > > misunderstood
> > > something here.
> > 
> > The "filesystem on top of a database" is the main thing that makes
> > bcachefs unique - you have that right.
> 
> Phew! Seems I did not get it completely wrong then :)
> 
> > bcache had much of the core btree design - log structured btree nodes
> > with eytzinger search trees; that's how we got a high enough performance
> > btree to make the "filesystem on top of a database" thing practical.
> > 
> > But the btree in bcache was, from a performance POV, prototype quality -
> > stable, but a lot of performance corner cases unfinished.
> > 
> > The latency work, real iterators, and the whole transaction layer came
> > later :)
> 
> So it is fair to say that being based on BCache enabled that low latency 
> work?
> 
> I am trying to find a balance here. The audience of the article are 
> experienced sys admins working in small and large organizations, but not 
> (primarily) kernel hackers. So I like to explain possible reasons to 
> consider BCacheFS while also having BTRFS and ZFS and XFS, but without 
> going into so much detail that one needs to be a kernel developer to 
> understand it. For XFS it is easy as while there was a proof of concept 
> with subvolumes and snapshots based on XFS in files on XFS, AFAIR from 
> Dave Chinner, some years back, it does not have those advanced features 
> (yet). For ZFS one can always argue it is not in the mainline kernel. But 
> regarding BTRFS it becomes important to really explain something. I 
> started to do some BCacheFS / BTRFS feature comparison chart, but I also 
> like to explain on the benefits BCacheFS can have in the text and a bit 
> about the background of those benefits. Of course also mentioning that 
> BCacheFS is in development for more than 10 years, even without taking all 
> the work for BCache itself into account.
> 
> So my idea currently is to explain that the BCache BTree and/or frontend/
> backend architecture, not sure how to best word it, enabled a database 
> approach to a filesystem to be feasible. And that in a sense it also 
> enabled the latency work. And I can mention sixlocks and all the nice 
> other stuff you mentioned. However… I may not explain exactly what those 
> nice things are and how they work for example. For two reasons: 1. I need 
> to understand those nice features myself, 2. limit of pages I may use and 
> scope of the article. Currently I understood that sixlocks for certain use 
> cases are the next best thing since the invention of a wheel or something 
> like that. But not much more :)
> 
> Would something like that be accurate enough in your opinion?

Yeah, that all sounds reasonable :)

It would be a great project to get all this stuff documented better...
when I have more free time... :)

> I will review the user manual once again, I read about the database 
> approach, and aim to find a good balance. Cause for certain I won't be 
> getting 24 pages for the article :)
> 
> 
> I got two setbacks regarding trying BCacheFS on my laptop yesterday and 
> today:
> 
> 1) Linux 6.7-rc1, as mentioned almost rc2, did not hibernate on ThinkPad 
> T14 AMD Gen 1. It just blanked screen and nothing happened. So I went back 
> to 6.6.1 temporarily. I do not really intend to do a git bisect between 
> rc1 and 6.6 on a production laptop. It would be very time-consuming and 
> possibly be dangerous. I may go back to 6.7 even without hibernation, just 
> using standby over night for a while. I bet BCacheFS is compatible with 
> hibernation (as in writing memory contents to encrypted swap and resuming 
> from it)?

I believe so - I have not tested hibernation specifically.

> 
> 2) But after I removed 6.7-rc1 yesterday night after having booted into 
> 6.6.1 this morning I was greeted by GRUB command line. As I had a meeting 
> scheduled my primary aim was to get things running again. I certainly did 
> not really get the humorous aspect about it. I thought I'd had copied etc 
> in the broken state to a another place, but do not find it anymore, maybe 
> I copied it to /root or the GRML live distro accidently and so it is gone. 
> Also I missed to copy the broken /boot to another place. So I am not 
> really able to do any forensic analysis of what might have happened. I do 
> not recall having seen any error messages either, but I may have missed 
> something. I reviewed hook and script for initial RAM disk in bcachefs-
> tools repo, but did not find anything in there that could have caused grub 
> 2 not finding its config file and modules anymore. Also it booted into 6.7 
> and even 6.6.1 then after having executed "make install" from bcachefs-
> tools directory. Also I see nothing being done with grub itself within 
> bcachefs-tools. So this really is quite the mystery for me. I am on Devuan 
> Ceres (based on Debian Sid) so maybe something else got messed up. Will 
> review their bug trackers. I really have no idea what went wrong here, 
> luckily I was able to recover with GRML. I use LVM on LUKS for BTRFS and 
> test BCacheFS filesystem.
> 
> Maybe I need to continue testing BCacheFS on a virtual machine, but I'd 
> really love to have a BCacheFS filesystem on my laptop and actually really 
> using it for something. Well I am going to leave it at that and probably 
> research on this after the weekend. Now it is time to have a Sunday off.

The Nixos install process with bcachefs as root is pretty smooth, just
make sure to set up a separate filesystem for /boot!
