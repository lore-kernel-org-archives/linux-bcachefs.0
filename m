Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iBzgvoRk"
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bd])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E951712
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 17:37:43 -0800 (PST)
Date: Thu, 7 Dec 2023 20:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701999462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8vKJxiu/fitzBTeMMoln5wZPyg4ejKrm27RMNb+8Kc=;
	b=iBzgvoRkKaY9FgnLIhDmxW11bgQ1qtsOssRNRZ26pgrABfsfo6hgx4za7v+OEe8RaazMQ4
	I5Td1Arq3PGhVLFgyHJH34ZUrT+b32hYE3TwHcv+m+s7NVafwtSIdsGsA8o/1482KqPch5
	N9NR6bYZ8lG0fTjjrP1LlyRZETrRVoE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: NeilBrown <neilb@suse.de>
Cc: Donald Buczek <buczek@molgen.mpg.de>, linux-bcachefs@vger.kernel.org,
	Stefan Krueger <stefan.krueger@aei.mpg.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
Message-ID: <20231208013739.frhvlisxut6hexnd@moria.home.lan>
References: <20231129214328.efbfpl3javifvwk5@moria.home.lan>
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>
 <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>
 <170199821328.12910.289120389882559143@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170199821328.12910.289120389882559143@noble.neil.brown.name>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 08, 2023 at 12:16:53PM +1100, NeilBrown wrote:
> On Thu, 07 Dec 2023, Donald Buczek wrote:
> > 
> > I'd vote for the subvol-id.  I think, with bcachefs a u32 would do,
> > but it could be return as u64 for future growth or other filesystems.
> 
> Probably a good choice.  Though I'd like to re-emphasise that even doing
> this doesn't remove the need to make sure inode numbers are as unique as
> they can possibly be made.  There are multiple places in /proc (for
> example) where a file is identified by fsid and inode number.  It isn't
> really practical to insert a volume-id in there (though maybe we could
> duplicate all those interfaces....).
> 
> Inode numbers would need to be absolutely unique with a volume, and
> mostly unique within a filesystem.  xor-ing the internal inode number
> with a hash of the volume number is one way to achieve this.
> 
> i.e.: while enabling processes that use stat() family function is
> clearly import, it does not solve all the problems caused by the
> addition of a volume/subvol level between "filesystem" and "inode".

So, I'm hoping we can start pushing the NFS file handle as a standard
interface for unique file ID, but since we clearly need something
interim/for existing programs:

xoring in the subvolume ID sounds like it shouldn't have any real
downside, do we want to make that the default?

Another possibility: we do have the ability to restrict inode numbers to
32 bits, I've been contemplating using this to report the subvol ID in
the top 32 bits. Not my preferred approach, since we currently use the
top bits of the inode number for sharding by cpu ID and this would be
incompatible with that option, but sounds like it might be worth adding.

For plumbing in an option for how to include the subvolume ID in the
inode number - we'll add it to fs/bcachefs/opts.h as an OPT_STR() option
(i.e. an enum), reserve a few bits in the superblock for it, specify in
opts.h when it can be set (at mount, runtime, format time).

statx sounds like a no brainer. I don't have the bandwidth to get into
that right now, but: inode_inum().subvol is the bcachefs interface for
getting it. (Not bi_subvolume in the on disk inode, that's only set on
subvolume roots).

How does that sound on the bcachefs side, Neil?
