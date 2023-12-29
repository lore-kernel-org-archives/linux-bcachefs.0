Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E0F1426F
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id E0F78140DED0F
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 13:03:28 -0800 (PST)
Date: Fri, 29 Dec 2023 13:03:28 -0800 (PST)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <393502900.553.1703883808727@mail.carlthompson.net>
In-Reply-To: <1082805315.289.1703800789271@mail.carlthompson.net>
References: <1082805315.289.1703800789271@mail.carlthompson.net>
Subject: Re: Manipulation of bcachefs subvolumes and snapshots breaks s2idle
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite

This one is still an issue even with today's fixes.

Thanks,
Carl

> On 2023-12-28 1:59 PM PST Carl E. Thompson <list-bcachefs@carlthompson.net> wrote:
> 
>  
> Hello, there appears to be a bug in bcachefs in which certain changes to subvolumes and snapshots can result in an inability to suspend the system. Specifically, if a bcachefs snapshot is taken of a subvolume, then a file is removed or modified in either the subvolume or snapshot, then the subvolume and snapshot are deleted, then after that s2idle will fail until the system is rebooted. This is 100% reproducible on my laptop running rc7. 
> 
> Here is a short example of something that will trigger the bug:
> ---
> [carl@clip test]$ bcachefs subvolume create subvol
> 
> [carl@clip test]$ touch subvol/file
> 
> [carl@clip test]$ bcachefs subvolume snapshot subvol snapshot_of_subvol
> 
> [carl@clip test]$ rm subvol/file
> 
> [carl@clip test]$ bcachefs subvolume delete subvol
> 
> [carl@clip test]$ bcachefs subvolume delete snapshot_of_subvol
> ---
> 
> After this suspending the system will fail and produce kernel messages like the following:
> ---
> [10898.793676] Freezing remaining freezable tasks
> [10918.797255] Freezing remaining freezable tasks failed after 20.003 seconds (0 tasks refusing to freeze, wq_busy=1):
> [10918.797270] Showing freezable workqueues that are still busy:
> [10918.797273] workqueue events_freezable: flags=0x4
> [10918.797277]   pwq 28: cpus=14 node=0 flags=0x0 nice=0 active=0/0 refcnt=2
> [10918.797289]     inactive: pci_pme_list_scan
> [10918.797309] workqueue bcachefs_write_ref: flags=0x4
> [10918.797314]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=2/0 refcnt=3
> [10918.797322]     in-flight: 12451:bch2_subvolume_wait_for_pagecache_and_delete [bcachefs] bch2_subvolume_wait_for_pagecache_and_delete [bcachefs]
> [10918.797519] workqueue bcachefs_io: flags=0x1c
> [10918.797525]   pwq 9: cpus=4 node=0 flags=0x0 nice=-20 active=0/0 refcnt=2
> [10918.797532]     inactive: journal_write_work [bcachefs]
> [10918.797616] workqueue bcachefs_write_ref: flags=0x4
> [10918.797620]   pwq 18: cpus=9 node=0 flags=0x0 nice=0 active=2/0 refcnt=3
> [10918.797626]     in-flight: 17562:bch2_subvolume_wait_for_pagecache_and_delete [bcachefs] bch2_subvolume_wait_for_pagecache_and_delete [bcachefs]
> [10918.798386] Restarting kernel threads ... done.
> [10918.799643] OOM killer enabled.
> [10918.799647] Restarting tasks ... done.
> [10918.803749] random: crng reseeded on system resumption
> [10919.295422] PM: suspend exit
> ---
> 
> - I have only tested this on bcachefs filesystems with 4k blocks. If this is related to the issue causing one of my other bug reports today then it's possible in may not happen on filesystems with 512 byte blocks (untested).
> 
> Thank you,
> Carl Thompson
