Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BED05100B
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dl64HWtl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704727971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyZ9ykKVwDjwjTyEZxjnW8RFJF+tE4XmaX0xEE1SO0U=;
	b=Dl64HWtlk6Xzbn5JXizpsLpOupiguKKVuVVAjgvQUsEYo1t4uCqk4mswHN8/c2wDwv7+L1
	NFW/RcssX88l/TS34nAi7JPAPVhqv02CZilLXK8piArwFzgh6vRS2DE+LrUzyyFRLOylKg
	ONdpk1pP7HnDCJxTyxGXvLBbV0chttA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-180-aP-8pnKfMKSd3nS2iCjlqA-1; Mon,
 08 Jan 2024 10:32:42 -0500
X-MC-Unique: aP-8pnKfMKSd3nS2iCjlqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D34093806279;
	Mon,  8 Jan 2024 15:32:41 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.167])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D17E40C6EBA;
	Mon,  8 Jan 2024 15:32:41 +0000 (UTC)
Date: Mon, 8 Jan 2024 10:33:58 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 1/2] bcachefs: add fiemap delalloc extent detection
Message-ID: <ZZwV5ohFULB2Q2i9@bfoster>
References: <20231219140215.300753-1-bfoster@redhat.com>
 <20231219140215.300753-2-bfoster@redhat.com>
 <20231219235742.fmon4qqvbabuxq6c@moria.home.lan>
 <ZZagv/f2lWOSMUSn@bfoster>
 <5sttczrkktgkivq5ncusst3rrjqi7hgpx4nswq2vjqn6iqr4b2@25hi2ukb2rh7>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5sttczrkktgkivq5ncusst3rrjqi7hgpx4nswq2vjqn6iqr4b2@25hi2ukb2rh7>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Thu, Jan 04, 2024 at 06:41:26PM -0500, Kent Overstreet wrote:
> +cc btrfs folks
> 

-cc btrfs folks ;) (for unrelated discussion mostly around the variable
declaration thing...)

> On Thu, Jan 04, 2024 at 07:12:47AM -0500, Brian Foster wrote:
> > On Tue, Dec 19, 2023 at 06:57:42PM -0500, Kent Overstreet wrote:
> > > On Tue, Dec 19, 2023 at 09:02:14AM -0500, Brian Foster wrote:
> > > > +	start = bch2_seek_pagecache_data(vinode, start, end, 0, false);
> > > > +	if (start >= end)
> > > > +		return false;
> > > > +	end = bch2_seek_pagecache_hole(vinode, start, end, 0, false);
> > > > +
> > > > +	/*
> > > > +	 * Create a fake extent key in the buffer. We have to add a dummy extent
> > > > +	 * pointer for the fill code to add an extent entry. It's explicitly
> > > > +	 * zeroed to reflect delayed allocation (i.e. phys offset 0).
> > > > +	 */
> > > > +	bch2_bkey_buf_realloc(cur, c, sizeof(*delextent) / sizeof(u64));
> > > > +	delextent = bkey_extent_init(cur->k);
> > > > +	delextent->k.p = POS(ei->v.i_ino, start >> 9);
> > > > +	bch2_key_resize(&delextent->k, (end - start) >> 9);
> > > > +	bch2_bkey_append_ptr(&delextent->k_i, ptr);
> > > > +
> > > > +	return true;
> > > > +}
> > > 
> > > I don't like that this returns a delalloc extent when data is merely
> > > present in the pagecache - that's wrong.
> > > 
> > > bch2_seek_pagecache_dirty_data()?
> > > 
> > 
> > Technically it just returns a file offset range represented in an extent
> > key. I could tweak it to just return a range or something and make the
> > delalloc part a separate helper.
> > 
> > More to the broader point, I thought that technically this was all
> > somewhat racy wrt to folio state and I was a little concerned about
> > possibly showing weird/inconsistent state if this runs concurrently with
> > writeback. I'll have to take a closer look at the bch2_seek_* helpers
> > though to better quantify that concern...
> 
> Yeah, it does get tricky there; writeback will flip the folio state from
> dirty to allocated before it shows up in the btree.
> 
> To fix that we'd need to add a new state to BCH_FOLIO_SECTOR_STATE, and
> it seems like that's something we should strongly consider.
> 
> There may also be some lingering bugginess in the i_sectors accounting
> code, if we're touching this stuff we definitely want to be looking for
> ways to make that more rigoroous if we can - I thought I was done with
> that, but I have an assert patch in my garbage branch that was firing -
> hadn't had time to track it down:
> https://evilpiepirate.org/git/bcachefs.git/commit/?h=bcachefs-garbage&id=50010457597c6c30aec1195b0568868d2d30bb76
> 
> This is likely related to the warning that's been popping in the CI from
> time to time about i_sectors_delta being the wrong sign in writeback
> completion.
> 
> Not the main focus here, just wanted to bring it up in case you start to
> go down that rabbit hole
> 

Ok, thanks. I'll give it a look.

> 
> > > Now that we're not compiling in gnu89 mode anymore, I'm moving code away
> > > from this "declare all variables at the top" style - I want variables
> > > declared where they're initialized.
> > > 
> > > The reason is that bugs of the "I accidently used a var before I
> > > initialized it" are really common, and the compiler does a crap job of
> > > catching them.
> > > 
> > > Anywhere where we can write our code in a more functional style (in the
> > > SSA sense, variables are declared where they are initialized and never
> > > mutated) without it affecting the quality of the output is a big win.
> > > 
> > > (across function calls, we can't generally do this because C doesn't
> > > have return value optimization).
> > > 
> > 
> > Hmm.. not really sure I want to get into this. My initial reaction is
> > that this strikes me as odd formatting that makes the code incrementally
> > more annoying to read for marginal benefit. Has there been any broader
> > discussion on this sort of thing anywhere that I can catch up on?
> 
> Starting that discussion now :)
> 

Heh, Ok.

> Actually, this did come up not too long ago; there was a bug in some usb
> code where they were using the loop iterator after breaking out of the
> loop - which should have been ok, but for some horribly subtly reasons
> was not, and Linus brought up that it's probably time to switch to
> declaring the loop iterator in the for () statement to make those sorts
> of bugs impossible.
> 

That seems like a perfectly reasonable adjustment/policy to me.

It also seems like a decent opportunity to pose the idea of a broader
change to revisit how variables are declared, and solicit some initial
reactions..?

> More broadly, I regularly come across subtle bugs that should not have
> happened purely because of variable reuse; consider the way we declare
> int ret; at the top of a lot of functions, and then reuse it throughout.
> 
> That's error prone for a whole bunch of reasons, and the bugs it causes
> tends to be ones that get introduced in later refactoring - some code
> skips initializing ret where it's declared because _at the time that
> code was written_ it was immediately assigned to, or code will use it
> for something that wasn't an error code and then forget to set it back
> to 0.
> 

Yep.

> It's really much better to only declare variables when they're first
> assigned to, and only use them for one thing.
> 

That seems somewhat reasonable in principle, particularly the bit about
limiting purpose of variables, but I'm more skeptical about this in
practice. A few high level points come to mind..

1. I'm skeptical the invariant of "declaration at first use" will be
reliably maintained as time passes and development contributions scale.
Unless there is some tool or compiler option to address this
automatically (which I thought existed?), ISTM the existence of these
bugs (or not) still ultimately comes down to catching them during
development or review.

2. I wonder if a tradeoff for reducing these sorts of errors comes at an
indirect cost of making readability and review incrementally harder, and
thus less effective. For example, I'd probably get pretty annoyed fairly
quickly having to hunt around for variable declarations in a complex
function to grok type usage or whatever, or having to move them around
when hacking, etc.

3. Logistically, this is likely to be a bit awkward for pretty much
everybody who has a history of working with C code. In the context of
kernel development, something also tells me this has potential to be a
tinderbox for a flamewar, but who knows.. ;P

> You'll notice I've got a whole bunch of patches queued up for 6.8 that
> change almost all of our for loop macros to declaring the loop iter in
> the macro, and I will be going through and changing other variable uses
> to this style as it comes up.
> 

I think the loop thing makes sense, particularly because it's a small,
isolated change.

WRT moving all other vars around, IMO it would be preferable to perhaps
have more discussion and see if others have similar opinions on that
sort of change before going so far as to swizzle code around and/or
insist at code review time.

That's just my .02 of course; it's your project. ;)

> > > >  	bool have_extent = false;
> > > >  	u32 snapshot;
> > > >  	int ret = 0;
> > > > @@ -916,6 +952,19 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
> > > >  			continue;
> > > >  		}
> > > >  
> > > > +		/*
> > > > +		 * Outstanding buffered writes aren't tracked in the extent
> > > > +		 * btree until dirty folios are written back. Check holes in the
> > > > +		 * extent tree for data in pagecache and report it as delalloc.
> > > > +		 */
> > > > +		if (iter.pos.offset > start &&
> > > > +		    bch2_fiemap_scan_pagecache(vinode, start << 9,
> > > > +					       iter.pos.offset << 9, &cur)) {
> > > > +			cflags = FIEMAP_EXTENT_DELALLOC;
> > > 
> > > but cflags/plags are unnecessary, no? can't we just detected this in
> > > bch2_fill_extent when the ptr offset is 0?
> > > 
> > 
> > I thought (briefly) about if/how this state could be implied by the
> > helper (moreso out of laziness ;), but I feel that sort of logic is more
> > fragile than just being explicit about state.
> 
> The logic can be confined to one place - a helper with a good name -
> while the way you're doing it you're now spreading the state that's
> passed around across multiple variables.
> 
> The clean way to do what you're doing would be to have a wrapper type so
> we could store the bkey_buf with the fiemap flags in one variable.
> 

That's a good point. I'll clean that up if this logic ends up sticking
around. Thanks.

Brian

> > 
> > > > +			start = bkey_start_offset(&cur.k->k) + cur.k->k.size;
> > > > +			goto fill;
> > > > +		}
> > > 
> > > The goto fill is also a code smell.
> > > 
> > 
> > It's just basically a goto next pattern. I think the logical wart is
> > more how this post-processes the gaps/hoes in the extent offset ranges
> > and set_pos' the same start value repeatedly as we process delalloc
> > extents. Not really sure if that's what you mean here, but that's the
> > part that I didn't really love when hacking on this.
> > 
> > > The right way to do it would be to search, from the same position, both
> > > the btree and the pagecache: then compare those two extents, using
> > > delalloc extent if it comes first, and trimming the btree extent if it
> > > comes first but the delalloc extent overlaps.
> > > 
> > > Then there's no goto fill; after we've decided which extent to use the
> > > rest of the loop is unchanged.
> > > 
> > > (The btree iterator code works roughly this way, where it has to overlay
> > > keys from the journal and pending updates).
> > > 
> > 
> > Yeah, I thought that something like this would be necessary for changing
> > behavior of the "dirty data over existing COW blocks" case, if we ever
> > wanted to do that, but figured it wasn't worth the complexity unless we
> > go that direction. It might be improvement enough for the iteration
> > either way though. I'll try to take a fresh look at that. Thanks for the
> > review.
> 
> btrfs folks have probably looked at this as well - any notes from you
> guys on fiemap behaviour - has anything come up where a particular
> behaviour is important?
> 
> Also, someone (Darrick?) mentioned in the Tuesday meeting that maybe we
> actually can extend fiemap for multiple device filesystems, wonder if
> anyone's interested in that...
> 

