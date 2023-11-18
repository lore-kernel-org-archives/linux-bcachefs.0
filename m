Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kGs4MLBQ"
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D249130
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 11:50:29 -0800 (PST)
Date: Sat, 18 Nov 2023 14:50:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700337027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rFFaj8GcGe1T64A2mHIfEp+AEEVGxkTt0xxsknQ5dVs=;
	b=kGs4MLBQ2LqjrMYffqfSCA6+a51qBanJ17cHim07ikGEv73oJeKJu85s+josImSEKW/w9i
	sWpFG56jugXF1a6P4cPl2WFe6IcqVdPVvvIo7hW8ElBuCyLPsi8drnrDXd+jhTKhjQN4tu
	r3fajaD60KdiXun394dCuPvBL/ueYtg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Message-ID: <20231118195024.qe2bjxeubhru3de5@moria.home.lan>
References: <23311511.6Emhk5qWAg@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23311511.6Emhk5qWAg@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Sat, Nov 18, 2023 at 08:15:50PM +0100, Martin Steigerwald wrote:
> Hi!
> 
> Awesome that BCacheFS is finally merged! Many thanks to everyone who made 
> this happen. I appreciate it!
> 
> I am writing an article about BCacheFS. I am willing to provide a link 
> once it is published. It will be in German language.
> 
> I do have a few questions:
> 
> 1) Is discard supported? fstrim says it is not. However /sys/fs/bcachefs/
> UUID/options/discard shows "1". BCacheFS User manual Principles of 
> Operations mentions it at a device option. I am not completely sure how 
> these work. Auto-detected and just IOCTL for fstrim missing?

Yes, it's supported. There's no need for fstrim support because we
discard buckets as soon as they become empty.

> 
> 2) What are the plans for scrubbing? Right now it is not yet implemented, 
> right?

Yes, it's very much planned.

> 3) Is the documentation of mount and other options in
> https://bcachefs.org/bcachefs-principles-of-operation.pdf complete? If 
> not, care to elaborate what is missing?

The master option list is here:
https://evilpiepirate.org/git/bcachefs.git/tree/fs/bcachefs/opts.h#n122

A few of these are hidden; OPT_FORMAT and OPT_MOUNT options are the
options you'll be looking for - and OPT_DEVICE for device specific
options.

> 4) What are the plans or ideas for documentation? I specially ask as there 
> does not seem to be a manpage like mount.bcachefs or mkfs.bcachefs yet. 
> There is no mention of bcachefs in mount manpage either. And no bcachefs 
> manpage in section 5 like with btrfs or xfs. There is a bcachefs manpage 
> in section 8 which for example for a complete list of mount options refers 
> to above Principles of Operation user manual. And it has information on 
> "bcachefs format" and some other sub commands. I bet it is still too early 
> or maybe you have different plans on how to go about documentation. 
> Anything you can share already regarding this?

I'm entirely too busy with just writing code - I'd love to have more
time for documentation, but it's hard :) But, there are people starting
to contribute to the man pages, so I expect that will improve.

> 5) Is the feature implementation status on bcachefs.org up-to-date? How 
> about the one in Principles of Operation user manual? Is any of these more 
> up-to-date? If anything is missing from these, care to elaborate?

Reasonably up to date, yes. The main areas that still need work and
testing are snapshots and erasure coding; with snapshots it's looking
like just minor bugs are left and fleshing out features, erasure coding
is improving but still needs quite a bit of work.

> 6) What is the status for xxhash checksums? They are mentioned as an 
> option in the output of "bcachefs format". Yet no mention of it in 
> bcachefs manpage nor in Principles of Operation user manual.

I initially had concerns about whether that code was actually solid - I
think it's been resolved; I'll just want to hear some positive feedback
from people using it before I add it to the documentation.

> 7) On mounting BCacheFS without compression enabled on 6.7-rc1, shortly 
> before rc2, commit 791c8ab095f71327899023223940dd52257a4173 also LZ4 
> compression modules  lz4hc_compress and lz4_compress are loaded. Why?

We just add hard dependencies on the compression modules because a) the
crypto interface (that lets you use them as runtime dependencies)
_sucks_ and the lz4 modules at least are pretty small. zstd is bigger
though, so making these runtime dependencies would be a worthwhile
enhancement for anyone who's interested.

> 8) Regarding bcachefs-tools. More out of curiosity, cause there is already 
> a bcachefs-tools package in Debian repo, albeit only version 1.2. I see a 
> "debian" directory, however version number is 1.0.8-2~bpo8+1 while 
> compiling via make gives version 1.33. So I suppose packaging information 
> is not up to date? For now I am going with "make install" from bcachefs-
> tools git repo, as package in Debian repo is outdated.

Yeah I'm in contact with the debian maintainer, it should be updated
soon.

> 9) What is the preferred way to report bugs? Mailing list? Kernel bug 
> tracker? Both? Anything else?

Mailing list is good, or the github bugtrackers (that really should be
linked on the website:

https://github.com/koverstreet/bcachefs/issues/
https://github.com/koverstreet/bcachefs-tools/issues/

> 10) Anything you think an article about BCacheFS should absolutely 
> mention?

Would personally love to see some non-phoronix benchmarks :)

I've put a ton of effort into performance, my goal is a COW filesystem
that can compete with XFS on performance and scalabality - which is a
tall order! but we're getting close.

With the btree write buffer rewrite (still not quite merged, any day
now) - I'm pushing _900k_ iops, 4k random writes - through the COW write
path.

This is in my benchmarking/profiling mode, with checksums off and data
reads/writes to the device turned off - i.e. just showing bcachefs
overhead. So not real world nummbers, but indicative of how well we can
scale.

Cheers,
Kent
