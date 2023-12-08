Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GubSEhno"
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [IPv6:2001:41d0:203:375::ad])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C06611D
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 12:02:54 -0800 (PST)
Date: Fri, 8 Dec 2023 15:02:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702065772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3xgPQs3NyU6JmhXmEr7IpG8AtHx1jNDByjszYFUtuzE=;
	b=GubSEhnokWqn1X/BaUHoshvtWr5/9sP7zyRSGR94YtXkB7kG8/TWIU2cC7GA9PKrc93m0R
	JQl2P09xM34GkYv55jl+rkhWnPJecp7owPVY5W/GYedIONZYwBpawRWkKmxktYJX0QRP4K
	/mWtGJ6+b1ok7PXleK/rCmXVUaLlmYQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Donald Buczek <buczek@molgen.mpg.de>
Cc: NeilBrown <neilb@suse.de>, linux-bcachefs@vger.kernel.org,
	Stefan Krueger <stefan.krueger@aei.mpg.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
Message-ID: <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
References: <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>
 <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>
 <170199821328.12910.289120389882559143@noble.neil.brown.name>
 <20231208013739.frhvlisxut6hexnd@moria.home.lan>
 <170200162890.12910.9667703050904306180@noble.neil.brown.name>
 <20231208024919.yjmyasgc76gxjnda@moria.home.lan>
 <630fcb48-1e1e-43df-8b27-a396a06c9f37@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <630fcb48-1e1e-43df-8b27-a396a06c9f37@molgen.mpg.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 08, 2023 at 12:34:28PM +0100, Donald Buczek wrote:
> On 12/8/23 03:49, Kent Overstreet wrote:
> 
> > We really only need 6 or 7 bits out of the inode number for sharding;
> > then 20-32 bits (nobody's going to have a billion snapshots; a million
> > is a more reasonable upper bound) for the subvolume ID leaves 30 to 40
> > bits for actually allocating inodes out of.
> > 
> > That'll be enough for the vast, vast majority of users, but exceeding
> > that limit is already something we're technically capable of: we're
> > currently seeing filesystems well over 100 TB, petabyte range expected
> > as fsck gets more optimized and online fsck comes.
> 
> 30 bits would not be enough even today:
> 
> buczek@done:~$ df -i /amd/done/C/C8024
> Filesystem         Inodes     IUsed      IFree IUse% Mounted on
> /dev/md0       2187890304 618857441 1569032863   29% /amd/done/C/C8024
> 
> So that's 32 bit on a random production system ( 618857441 == 0x24e303e1 ).
> 
> And if the idea to produce unique inode numbers by hashing the filehandle into 64 is followed, collisions definitely need to be addressed. With 618857441 objects, the probability of a hash collision with 64 bit is already over 1% [1].

Oof, thanks for the data point. Yeah, 64 bits is clearly not enough for
a unique identifier; time to start looking at how to extend statx.
