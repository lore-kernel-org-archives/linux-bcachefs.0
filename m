Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2011B81B
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Jan 2024 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276344; cv=none; b=bCxU7knBRY9MowB+9lzu9mvf/uxoCLSPN9qtO4jiIlDOW1EJdz0aI4B4DxHeEbcBQwzztHxVhy1V6zxIgVrZePuZHkjr8pvcD/FDh8ja5XW73atX8a5LsIB5cwiHC5uxt+q3t5Sz0m3nMcCzzTfi4AqWB/YT+IyKjH4n/qyfd8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276344; c=relaxed/simple;
	bh=Gr/SAYSUF4AB8zWZZFjavWIZkDAV/K1hDa2NhNFzNho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEhrxBHNxx8eRNCj4JkLs8hb8JkzyMH34VefsBHywzks/2TJ2yt7EJP/CNsRJuV6Ddm10wFR7waJb1Z2ePJCykxcp8T8tESTUEb9OK1JHcm5F5tnWwP0hkushni55xTaRuse7kL/xJHVpoVOPF+vcFze76B7DNdpvxAFhASEKrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h3vVM8se; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h3vVM8se"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706276341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M+HT3GxhlFSU+mJ6HY2Z7P+aHJT9QjUD+Y3cJNdjNMA=;
	b=h3vVM8sePgGInj3tDD9UTlSpSZvKmIUqappX6cHdtZPTGSAQrU78KfCyCZN544eFeb4Al1
	+3Aujo051AwbDT6MRssVdx2obHMbSPngmTNvFuvUcOuAkf7ch/S3t/Ws23iVtIsHQjp6i7
	Rz3GFetz1F+rmqQYsyal1x149R4gX9s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-9u9VihaAN76Ed02OitOiRA-1; Fri, 26 Jan 2024 08:38:58 -0500
X-MC-Unique: 9u9VihaAN76Ed02OitOiRA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C375085A597;
	Fri, 26 Jan 2024 13:38:57 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8439C492BC6;
	Fri, 26 Jan 2024 13:38:57 +0000 (UTC)
Date: Fri, 26 Jan 2024 08:40:15 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <l@damenly.org>
Cc: Su Yue <glass.su@suse.com>, fstests@vger.kernel.org,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] common/rc: improve block size support for bcachefs
Message-ID: <ZbO2P/SWDT2uGE/c@bfoster>
References: <20240117092309.1134595-1-glass.su@suse.com>
 <20240117092309.1134595-2-glass.su@suse.com>
 <ZagUdl+DlxIw+siv@bfoster>
 <h6jb49cm.fsf@damenly.org>
 <ZaqepfRjb1vU+nDw@bfoster>
 <cytv49hm.fsf@damenly.org>
 <Za6HuxcIl0TNlffY@bfoster>
 <34umi23g.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34umi23g.fsf@damenly.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Thu, Jan 25, 2024 at 10:10:48AM +0800, Su Yue wrote:
> 
> On Mon 22 Jan 2024 at 10:20, Brian Foster <bfoster@redhat.com> wrote:
> 
> > On Sun, Jan 21, 2024 at 12:00:47PM +0800, Su Yue wrote:
> > > 
> > > On Fri 19 Jan 2024 at 11:09, Brian Foster <bfoster@redhat.com>
> > > wrote:
> > > 
> > > > On Thu, Jan 18, 2024 at 10:59:14AM +0800, Su Yue wrote:
> > > > >
> > > > > On Wed 17 Jan 2024 at 12:55, Brian Foster > >
> > > <bfoster@redhat.com>
> > > > > wrote:
> > > > >
> > > > > > On Wed, Jan 17, 2024 at 05:23:09PM +0800, Su Yue wrote:
> > > > > > > For bcachefs, def_blksz is never assigned even > > > >
> > > MKFS_OPTIONS > >
> > > > > contains
> > > > > > > option
> > > > > > > '--block_size'. So block size of bcachefs on scratch > > > >
> > > dev is > >
> > > > > always
> > > > > > > 4096
> > > > > > > if _scratch_mkfs_sized is called without second > > > >
> > > parameter.
> > > > > > >
> > > > > > > Add the pattern to set def_blksz if '--block_size' is > > >
> > > > given > >
> > > > > in
> > > > > > > MKFS_OPTIONS.
> > > > > > >
> > > > > > > Signed-off-by: Su Yue <glass.su@suse.com>
> > > > > > > ---
> > > > > > > changelog:
> > > > > > > v2:
> > > > > > >     Born.
> > > > > > > ---
> > > > > > >  common/rc | 3 +++
> > > > > > >  1 file changed, 3 insertions(+)
> > > > > > >
> > > > > > > diff --git a/common/rc b/common/rc
> > > > > > > index 31c21d2a8360..6a01de69cf05 100644
> > > > > > > --- a/common/rc
> > > > > > > +++ b/common/rc
> > > > > > > @@ -950,6 +950,9 @@ _scratch_mkfs_sized()
> > > > > > >  	jfs)
> > > > > > >  		def_blksz=4096
> > > > > > >  		;;
> > > > > > > +	bcachefs)
> > > > > > > +		def_blksz=`echo $MKFS_OPTIONS | sed -rn > >
> > > > > 's/.*(--block_size)[
> > > > > > > =]?+([0-9]+).*/\2/p'`
> > > > > > > +		;;
> > > > > >
> > > > > > So if the default bcachefs block size is 512b, I wonder > > >
> > > if > this
> > > > > should
> > > > > > do something like what the udf branch does a few lines > > >
> > > above > and
> > > > > >
> > > > > mkfs.bcachefs decides block size by querying > >
> > > statbuf.st_blksize or
> > > > > BLKPBSZGET from the device if the option is not given.
> > > > >
> > > > > > override the hardcoded default of 4k. ISTM this whole > > >
> > > thing >
> > > > > would be
> > > > > > more robust if it just elided the param in the default > > >
> > > cases > and
> > > > > let the
> > > > > > associated mkfs tool use its own default, but that's > > >
> > > probably > a
> > > > > separate
> > > > > > issue. Hm?
> > > > > >
> > > > > Since there is no default block size of bcachefs, maybe we > >
> > > can let
> > > > > mkfs.bcachefs decide on its own but it will make chaos when > >
> > > somebody
> > > > > reports an unreproducible BUG due to the different > >
> > > block_size even
> > > > > we have same local.config. It just happened...
> > > > > So for now, I think 4096 is a resonable value of bcachefs > >
> > > block
> > > > > size.
> > > > >
> > > >
> > > > I think we run into this no matter what if we pick a size out > of
> > > a hat,
> > > > regardless of what the value is. If somebody is testing with >
> > > default
> > > > blocksize (i.e. based on mkfs) on a filesystem where the > default
> > > isn't
> > > > actually 4k, then it seems quite unexpected that >
> > > _scratch_mkfs_sized
> > > > would use something different from _scratch_mkfs when a block >
> > > size isn't
> > > > explicitly specified. That's exactly the situation we ran > into
> > > with the
> > > > generic/361 thing where I would have expected this test to > use
> > > 512b
> > > > blocks.
> > > >
> > > > ISTM that the 4k value in _scratch_mkfs_sized() is mainly a > last
> > > resort
> > > > default value so the $blocks calculation can work for any >
> > > filesystem
> > > > that might not be properly supported by the function. The >
> > > function looks
> > > > a little wonky overall, but I think there are at least a > couple
> > > options
> > > > to improve things for bcachefs. FWIW, it also looks to me > that
> > > nothing
> > > > actually passes a blocksize param to _scratch_mkfs_sized, so >
> > > perhaps we
> > > > could just drop that blocksize=$2 parameter across the board > as
> > > a
> > > > simplification?
> > > >
> > > Maybe it can be dropped. The only user is generic/466
> > > 
> > 
> > Ah, good point.
> > 
> Sorry for the late reply, was busy with other works.
> 

No worries, same..

> > So generic/466 clears MKFS_OPTIONS so the function will use the provided
> > block size over whatever exists in the config, yet generic/466 is the
> > only user of this param in the first place.
> > 
> > I wonder if a more useful change might be to change the
> > _scratch_mkfs_sized logic to prefer the provided block size over
> > whatever is in the config, but then again that might require further
> > changes for any of the places that continue to use MKFS_OPTIONS. :/
> > 
> I am wondering too...
> 
> > > > With that, I think bcache could either:
> > > >
> > > > 1. Do something like def_blksize=`blockdev --getpbsz >
> > > $SCRATCH_DEV` in
> > > > the first switch if no block size is specified in > MKFS_OPTIONS
> > > (or
> > > > whatever best mimics mkfs logic).
> > > >
> > > > OR
> > > >
> > > > 2. Do something like the following in the last switch:
> > > >
> > > > 	[ -n $def_blksize ] && > def_blksize="--block_size=$def_blksize"
> > > > 	$MKFS_BCACHEFS_PROG ... $def_blksize $SCRATCH_DEV
> > > >
> > > > ... to allow mkfs to determine the block size. I _think_ that >
> > > works
> > > > because the bcachefs format doesn't depend on $blocks at all, > so
> > > > whatever $blocksize was set to is irrelevent unless > $def_blksize
> > > was set
> > > > above, but I could be missing something. That also assumes >
> > > blocksize
> > > > wasn't set to something by the caller.
> > > >
> > > > If correct, option #2 seems a little cleaner to me, but other
> > > > thoughts/ideas?
> > > >
> > > Option 2 is preferable. I would code it as(on more varaiable for
> > > readability):
> > > 
> > > local blocksize_opt
> > > 
> > > [ -n $def_blksize ] && blockzie_opt="--block_size=$def_blksize"
> > > $MKFS_BCACHEFS_PROG ... $blocksize_opt $SCRATCH_DEV
> > > 
> > 
> > That seems reasonable to me. The only caveat is this was assuming the
> > blocksize param would go away and so could be ignored for bcachefs.
> > 
> > Without getting too far into the weeds on the higher level parameter
> > handling, I wonder if the blocksize parameter was initially put into a
> > separate variable (i.e. blocksize_param or some such), if that would at
> > least help bcachefs determine between the case where 4096 was requested
> > by the caller vs. picked out of a hat by the default handling logic
> > earlier in the function, and thus correctly determine when to set a
> > blocksize vs. use the mkfs (non-4k) default.
> > 
> After going through the call stack of _scratch_mkfs quickly, I did not
> found something global to describe blocksize.
> So I think blocksize_param is unnecessary?
> 

My concern was more that I think the original logic I posted didn't
properly handle the case where a blocksize param is passed in (and thus
my version removed the parameter, which was incorrect due to not
realizing that generic/466 used it), but it's also possible I confused
myself between the various options that have been discussed or am just
not expressing the concern clearly enough.

It's probably not worth getting further hung up on this point here. If
you have a patch along the lines of your most recent example, that
sounds like a good direction to me and so I can just take a fresh look
from there...

Brian

> --
> Su
> 
> > So then IOW the logic might look something like this..?
> > 
> > 	[ -n $blocksize_param ] &&
> > blocksize_opt="--block_size=$blocksize_param"
> > 	[ -n $def_blksize ] && blocksize_opt="--block_size=$def_blksize"
> > 	mkfs ...
> > 
> > Brian
> > 
> > > --
> > > Su
> > > >
> > > > Brian
> > > >
> > > > > --
> > > > > Su
> > > > > >
> > > > > > Brian
> > > > > >
> > > > > > >  	esac
> > > > > > >
> > > > > > >  	[ -n "$def_blksz" ] && blocksize=$def_blksz
> > > > > > > --
> > > > > > > 2.43.0
> > > > > > >
> > > > >
> > > 
> 

