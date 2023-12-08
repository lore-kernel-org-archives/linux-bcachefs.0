Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LivpCbUC"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FB5199D
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 04:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702038104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=31RqlE6xztNtPFz8gPs9MAtzK06i3ZIKGoCXhydV0JY=;
	b=LivpCbUC0AimsCV23YuBxjryodo0MDqz9dBI3dWnmdYZPE3lmBix0Eugw6sKffl7BTaqBg
	TSmes2OiFOYCLlud1O7uRGhKHCeGlhZ78L9ttTr8WS8P+AHySJEtIV2RBN54YjQtec57Xd
	Gl8eD1ZbjeW/SLDPhZXx5tobJ7MmcG4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-bujo5XdHPDSofGqgWbzcGg-1; Fri, 08 Dec 2023 07:21:42 -0500
X-MC-Unique: bujo5XdHPDSofGqgWbzcGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37A07185A782;
	Fri,  8 Dec 2023 12:21:42 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B2E01C060AF;
	Fri,  8 Dec 2023 12:21:41 +0000 (UTC)
Date: Fri, 8 Dec 2023 07:22:37 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Steve Smith <tarkasteve@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [bug]: fiemap returns zero extents for all files
Message-ID: <ZXMKjclDEvhx/e3E@bfoster>
References: <CAHLWS5EiGVn_-BFm2X1PKZ2m0EJq6VjckLdOuVqL2zWibxYUqA@mail.gmail.com>
 <ZW85rKUfEXeaWqsL@bfoster>
 <CAHLWS5GOqsSZH5rZ4yobzUH+RbhznoQW0z1E_T=rTTJAXqXVTw@mail.gmail.com>
 <ZXDE7gn7xw5Hsli+@bfoster>
 <20231206224209.d6xkiv6v3t2qbozg@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206224209.d6xkiv6v3t2qbozg@moria.home.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Wed, Dec 06, 2023 at 05:42:09PM -0500, Kent Overstreet wrote:
> On Wed, Dec 06, 2023 at 02:01:02PM -0500, Brian Foster wrote:
> > On Wed, Dec 06, 2023 at 10:26:14AM +1100, Steve Smith wrote:
> > > Hi Brian,
> > > 
> > > Thanks for the suggestion. Yes, the ioctl call that xfs_io makes is
> > > basically identical to the one the test makes, except it has the SYNC
> > > flag set. Adding this flag (or calling fsync) results in expected
> > > behaviour (mapped_extents > 0).
> > > 
> > 
> > Ah..
> > 
> > > I assume that the bcachefs fiemap impl ignores unwritten data and only
> > > responds with flushed extents? I'm not sure if this is correct; for
> > > comparison, XFS, Btfs, zfs, and ext4, all return the extent map
> > > immediately after write without syncing.
> > > 
> > 
> > Ok, thanks for digging into the difference. I can reproduce what you
> > observe by just removing the sync flag from the xfs_io command.
> 
> Whoops, yes, this is missing.
> 
> > 
> > I know that XFS basically looks up extents in the in-core extent tree,
> > which will include things like delayed allocation (i.e. buffered writes
> > that have not yet been physically allocated and flushed to disk). It
> > looks like bcachefs fiemap just walks the extents btree for associated
> > inode keys. I suspect the buffered write path is just not updating the
> > tree in any way, which means fiemap won't see extents until dirty data
> > is flushed out. FWIW, this can also be observed by doing buffered
> > overwrites and observing that the underlying block range does not change
> > until the file data is flushed.
> 
> Correct - the only place dirty data can be found is in the pagecache
> (which means the buffered write path doesn't have any other data
> structures to update).
> 

Ok, thanks.

> Don't know if it'll be useful, but the lseek() (SEEK_DATA, SEEK_HOLE)
> also has to do this "check both the extents btree and the pagecache at
> the same time" thing - might be worth looking at that to see if any of
> that code can be abstracted/reused.
> 

Yeah that sounds like a decent idea. I'd think we'd just need to merge
data seeks over holes in the btree and then we'd at least have accurate
hole vs. allocated ranges without having to sync.

One thing that still isn't clear is if/how to handle the case of
allocated blocks with dirty pagecache where the latter will COW at
writeback time. I ran a quick test on btrfs out of curiosity and I see
it does show delalloc similar to how XFS does, but also seems to handle
the overwrite case exactly how bcachefs does now. Which is to say the
extent data is subtly inaccurate until writeback (assuming cow mode). I
wonder if it would be preferable here to just treat this as delalloc and
as long as there is pending dirty data, report the extent exactly as if
it were delalloc over a hole...

Brian

