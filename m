Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rJfvLSmv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UuQqMjDv"
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862F1D53
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 18:13:59 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A545220F4;
	Fri,  8 Dec 2023 02:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702001637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlhykTqQSJTKS9rg/ajKlH2JLuwp125/EdvoLFqZ4Vw=;
	b=rJfvLSmvFb8XGsqgg95f94RnW3oTyAiPcl5nCxL9/8WF/lS3V4nhDvgAeUv+Y7L5J6L6wM
	sTONfQBpqWlXwj+Y3NxPHMi9j7MsS9XRHQsUzVEjU1sruyw1f36RpgoKF0HChzddS9LQgK
	Ch6UYjEuHGL4dm8ZN56DUVEJYEoXaj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702001637;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlhykTqQSJTKS9rg/ajKlH2JLuwp125/EdvoLFqZ4Vw=;
	b=UuQqMjDvq0dwqCJsUSGLMdFurXm9OMMcTy+xV6R5mYepuZ7nv6vojqZl7wG1bpcoyZkOZb
	2BzL8ZhXjQJAHCAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8716C13722;
	Fri,  8 Dec 2023 02:13:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r0GHCON7cmWHHAAAD6G6ig
	(envelope-from <neilb@suse.de>); Fri, 08 Dec 2023 02:13:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: "Donald Buczek" <buczek@molgen.mpg.de>, linux-bcachefs@vger.kernel.org,
 "Stefan Krueger" <stefan.krueger@aei.mpg.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
In-reply-to: <20231208013739.frhvlisxut6hexnd@moria.home.lan>
References: <20231129214328.efbfpl3javifvwk5@moria.home.lan>,
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>,
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>,
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>,
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>,
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>,
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>,
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>,
 <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>,
 <170199821328.12910.289120389882559143@noble.neil.brown.name>,
 <20231208013739.frhvlisxut6hexnd@moria.home.lan>
Date: Fri, 08 Dec 2023 13:13:48 +1100
Message-id: <170200162890.12910.9667703050904306180@noble.neil.brown.name>
X-Spamd-Result: default: False [-2.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -2.10

On Fri, 08 Dec 2023, Kent Overstreet wrote:
> On Fri, Dec 08, 2023 at 12:16:53PM +1100, NeilBrown wrote:
> > On Thu, 07 Dec 2023, Donald Buczek wrote:
> > > 
> > > I'd vote for the subvol-id.  I think, with bcachefs a u32 would do,
> > > but it could be return as u64 for future growth or other filesystems.
> > 
> > Probably a good choice.  Though I'd like to re-emphasise that even doing
> > this doesn't remove the need to make sure inode numbers are as unique as
> > they can possibly be made.  There are multiple places in /proc (for
> > example) where a file is identified by fsid and inode number.  It isn't
> > really practical to insert a volume-id in there (though maybe we could
> > duplicate all those interfaces....).
> > 
> > Inode numbers would need to be absolutely unique with a volume, and
> > mostly unique within a filesystem.  xor-ing the internal inode number
> > with a hash of the volume number is one way to achieve this.
> > 
> > i.e.: while enabling processes that use stat() family function is
> > clearly import, it does not solve all the problems caused by the
> > addition of a volume/subvol level between "filesystem" and "inode".
> 
> So, I'm hoping we can start pushing the NFS file handle as a standard
> interface for unique file ID, but since we clearly need something
> interim/for existing programs:
> 
> xoring in the subvolume ID sounds like it shouldn't have any real
> downside, do we want to make that the default?

The only downside is that it does not provide 100% uniqueness so it
could give people a false sense of security.
You would need to be careful that the xor doesn't result in any reserved
inode numbers - 0 in particular.  That isn't hard though.
If you are going to do it, then don't even make it an option - always do
it.

> 
> Another possibility: we do have the ability to restrict inode numbers to
> 32 bits, I've been contemplating using this to report the subvol ID in
> the top 32 bits. Not my preferred approach, since we currently use the
> top bits of the inode number for sharding by cpu ID and this would be
> incompatible with that option, but sounds like it might be worth adding.

I think this is far-and-away the best option - for bcachefs.  All the
problems disappear.
Can you really not use other bits to shard by cpu ID?

For btrfs, it would probably be better to stick with 64bit inode numbers
so that bcachefs and btrfs have similar problems and can present a joint
front in trying to solve them.

(The only reason btrfs cannot use just 32bits for inode numbers is that
 they never re-use inode numbers.  !?!?!?! )

> 
> For plumbing in an option for how to include the subvolume ID in the
> inode number - we'll add it to fs/bcachefs/opts.h as an OPT_STR() option
> (i.e. an enum), reserve a few bits in the superblock for it, specify in
> opts.h when it can be set (at mount, runtime, format time).
> 
> statx sounds like a no brainer. I don't have the bandwidth to get into
> that right now, but: inode_inum().subvol is the bcachefs interface for
> getting it. (Not bi_subvolume in the on disk inode, that's only set on
> subvolume roots).
> 
> How does that sound on the bcachefs side, Neil?
> 

I'm against making things optional, and don't think sharding (or not
reusing inode numbers) is a good excuse to cause Posix incompatibility. 
But other than that, it makes sense.

Thanks,
NeilBrown
