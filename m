Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sXUJ+eMB"
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553D5F4
	for <linux-bcachefs@vger.kernel.org>; Wed, 13 Dec 2023 15:24:22 -0800 (PST)
Date: Wed, 13 Dec 2023 18:24:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702509860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LyxtolnsYNE8avkrj65eDIgccxme1SdvJlTWkOvfxnI=;
	b=sXUJ+eMBnONnddjVQXMRJ4UmeKjbDuLrszDhWtD1a477Jq87xo97L1RL25xeFj2gmor2JD
	XPnxx2Hh+pxhFnDi5ltEl30NogULjBnS0O1t6lgxMx4NaqHazSbJYOwFrnu5Nl4B5NQW02
	9Y6/Kv6APyq+5whwQiU2xWx7TI+9Veo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andreas Dilger <adilger@dilger.ca>
Cc: NeilBrown <neilb@suse.de>, David Howells <dhowells@redhat.com>,
	Donald Buczek <buczek@molgen.mpg.de>,
	linux-bcachefs@vger.kernel.org,
	Stefan Krueger <stefan.krueger@aei.mpg.de>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
Subject: Re: file handle in statx (was: Re: How to cope with subvolumes and
 snapshots on muti-user systems?)
Message-ID: <20231213232416.dwdveqpwtapmcfud@moria.home.lan>
References: <20231208024919.yjmyasgc76gxjnda@moria.home.lan>
 <630fcb48-1e1e-43df-8b27-a396a06c9f37@molgen.mpg.de>
 <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
 <170233460764.12910.276163802059260666@noble.neil.brown.name>
 <2799307.1702338016@warthog.procyon.org.uk>
 <20231212205929.op6tq3pqobwmix5a@moria.home.lan>
 <170242184299.12910.16703366490924138473@noble.neil.brown.name>
 <20231212234348.ojllavmflwipxo2j@moria.home.lan>
 <170242574922.12910.6678164161619832398@noble.neil.brown.name>
 <ECCDEA37-5F5F-4854-93FB-1C50213DCA6D@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ECCDEA37-5F5F-4854-93FB-1C50213DCA6D@dilger.ca>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 13, 2023 at 03:45:41PM -0700, Andreas Dilger wrote:
> It should be possible for userspace and the kernel to increase the size of
> struct statx independently, and not have any issues.  If userspace requests
> a field via STATX_* flags that the kernel doesn't understand, then it will
> be masked out by the kernel, and any extended fields in the struct will not
> be referenced.  Likewise, if the kernel understands more fields than what
> userspace requests, it shouldn't spend time to fill in those fields, since
> userspace will ignores them anyway, so it is just wasted cycles.

It's not the kernel <-> userspace boundary that's the problem, it's
userspace <-> userspace if you're changing the size of struct statx and
passing it across a dynamic lib boundary.
