Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kYKWreBT"
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39720171D
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 18:49:25 -0800 (PST)
Date: Thu, 7 Dec 2023 21:49:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702003763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S9s9pRJYjOvEQmZ3rivpTHC9BrM/oRQ/b+ANs/eANbE=;
	b=kYKWreBTVpgEru0cyYUXpNP0c17vGluCdxQfVv55yq/49SpEsZ18bOtINO59te9O5pS9Fv
	RnqY15B/p25GZEoGCpcuBzZs1QXmDCkf65L0gKW2MLTfGMD9L57sJem+bEb0bOFQrCVfqH
	/GrSL+4bV/vjpxxZEt8iZQ/Akc23Ly4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: NeilBrown <neilb@suse.de>
Cc: Donald Buczek <buczek@molgen.mpg.de>, linux-bcachefs@vger.kernel.org,
	Stefan Krueger <stefan.krueger@aei.mpg.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
Message-ID: <20231208024919.yjmyasgc76gxjnda@moria.home.lan>
References: <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>
 <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>
 <170199821328.12910.289120389882559143@noble.neil.brown.name>
 <20231208013739.frhvlisxut6hexnd@moria.home.lan>
 <170200162890.12910.9667703050904306180@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170200162890.12910.9667703050904306180@noble.neil.brown.name>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 08, 2023 at 01:13:48PM +1100, NeilBrown wrote:
> On Fri, 08 Dec 2023, Kent Overstreet wrote:
> > On Fri, Dec 08, 2023 at 12:16:53PM +1100, NeilBrown wrote:
> > > On Thu, 07 Dec 2023, Donald Buczek wrote:
> > > > 
> > > > I'd vote for the subvol-id.  I think, with bcachefs a u32 would do,
> > > > but it could be return as u64 for future growth or other filesystems.
> > > 
> > > Probably a good choice.  Though I'd like to re-emphasise that even doing
> > > this doesn't remove the need to make sure inode numbers are as unique as
> > > they can possibly be made.  There are multiple places in /proc (for
> > > example) where a file is identified by fsid and inode number.  It isn't
> > > really practical to insert a volume-id in there (though maybe we could
> > > duplicate all those interfaces....).
> > > 
> > > Inode numbers would need to be absolutely unique with a volume, and
> > > mostly unique within a filesystem.  xor-ing the internal inode number
> > > with a hash of the volume number is one way to achieve this.
> > > 
> > > i.e.: while enabling processes that use stat() family function is
> > > clearly import, it does not solve all the problems caused by the
> > > addition of a volume/subvol level between "filesystem" and "inode".
> > 
> > So, I'm hoping we can start pushing the NFS file handle as a standard
> > interface for unique file ID, but since we clearly need something
> > interim/for existing programs:
> > 
> > xoring in the subvolume ID sounds like it shouldn't have any real
> > downside, do we want to make that the default?
> 
> The only downside is that it does not provide 100% uniqueness so it
> could give people a false sense of security.
> You would need to be careful that the xor doesn't result in any reserved
> inode numbers - 0 in particular.  That isn't hard though.
> If you are going to do it, then don't even make it an option - always do
> it.

Well, see below.

> > Another possibility: we do have the ability to restrict inode numbers to
> > 32 bits, I've been contemplating using this to report the subvol ID in
> > the top 32 bits. Not my preferred approach, since we currently use the
> > top bits of the inode number for sharding by cpu ID and this would be
> > incompatible with that option, but sounds like it might be worth adding.
> 
> I think this is far-and-away the best option - for bcachefs.  All the
> problems disappear.
> Can you really not use other bits to shard by cpu ID?

Hmm. Actually doing the math, maybe we can make this work...

We really only need 6 or 7 bits out of the inode number for sharding;
then 20-32 bits (nobody's going to have a billion snapshots; a million
is a more reasonable upper bound) for the subvolume ID leaves 30 to 40
bits for actually allocating inodes out of.

That'll be enough for the vast, vast majority of users, but exceeding
that limit is already something we're technically capable of: we're
currently seeing filesystems well over 100 TB, petabyte range expected
as fsck gets more optimized and online fsck comes.

So I can't bake in a limit like that, we need to keep our options open
:)

> For btrfs, it would probably be better to stick with 64bit inode numbers
> so that bcachefs and btrfs have similar problems and can present a joint
> front in trying to solve them.
> 
> (The only reason btrfs cannot use just 32bits for inode numbers is that
>  they never re-use inode numbers.  !?!?!?! )

That is a !?!?!?. bcachefs certainly can, and it's not hard, we leave
around an inode_generation key when we delete an inode.

> I'm against making things optional, and don't think sharding (or not
> reusing inode numbers) is a good excuse to cause Posix incompatibility. 
> But other than that, it makes sense.

I just don't think posix compatibility is realistically possible in all
situations we've got coming - especially with overlayfs to consider.
People are also starting to want to do fun things with container
filesystems, that's becoming a hot topic as well and depending on how
it's done the problem of combining inode numbers from multiple
filesystems into one coherent "view" may come up again.

So I think we also need to be designing something that we know is going
to work and relaxing our constraints a bit.
