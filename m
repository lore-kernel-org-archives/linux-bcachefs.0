Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90F81EB25
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705496789; cv=none; b=ND0B/cMem9Q9uBBzpuLXpMTAKr5BhCEMyKugApA3z4PNWbb0imTqLCt7EnV2DSdS4Rlg6pThh33EinvniAhAJ1XIj4uCwEepd7LDta2KHI/ONSirJZxg0skeC9tY902n0fY4/Kpwpi95U6kwK801QtP2n9zmvqLEKKKzae6fgeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705496789; c=relaxed/simple;
	bh=38W5MneQfhi+PkMmiG1+xsJHLR7cL3eAkFMgz4boq9k=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Scanned-By; b=FK2s56hy6l9qelxAfLdyoAuKm+s1UlzpLZ/teDgNfpa/i6xq6I+8jCsBRICVM+b8DJH+OHINeJoZ6gW7OUT7GAtASe9kUHCuXL3FSaf3NuXg6DBwWrRlhfVh83f/EJQKhm2OiRUWNhg14OV/77SyU7l7XWB2yy8VFjSYuivMl+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fm7TuV8m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fm7TuV8m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705496786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UBM1e8Jpt+xJM1FY09T5hg2h6yCau7ag8H3c/fNH7s=;
	b=Fm7TuV8mTCXc1meau5+EuswRtvjH4HHSld+MrCye0JJdUGqxpKkHLZr6METu4EXf62q/v2
	CgaZJ+BbDIqn/FN7j/KxglDByjsjR2yhWsxlMkt+1WrAqFX2FUIgDSb7vboVlF6aGyAxFX
	W/5HYk6Hd54qwXBC4qxKVuddGANZ1Lg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-Um6eO6JTPheB6QQ5__Fo4Q-1; Wed, 17 Jan 2024 08:06:22 -0500
X-MC-Unique: Um6eO6JTPheB6QQ5__Fo4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A10F6185A781;
	Wed, 17 Jan 2024 13:06:20 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EC021BDB0;
	Wed, 17 Jan 2024 13:06:20 +0000 (UTC)
Date: Wed, 17 Jan 2024 08:07:38 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <l@damenly.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] general protection fault, probably for non-canonical
 address 0x280766500040001: 0000 [#1] PREEMPT SMP PTI
Message-ID: <ZafRGgsW9Z7oORtV@bfoster>
References: <ZaahtMNCEd42G3EP@bfoster>
 <ze74khldgkvbht5ryjq2bs5rjnm7eds2xytlwc76nqurjwf7tx@rpcyvnwbkglp>
 <Zaa74Ehk4idtZNwc@bfoster>
 <dbqhxiv7kxbaeilxyyqzqqpjlaobxh262u7czkg5koec2w35p4@2oznjzf466no>
 <bk9k60zw.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bk9k60zw.fsf@damenly.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Wed, Jan 17, 2024 at 12:20:55PM +0800, Su Yue wrote:
> 
> On Tue 16 Jan 2024 at 12:33, Kent Overstreet <kent.overstreet@linux.dev>
> wrote:
> 
> > On Tue, Jan 16, 2024 at 12:24:48PM -0500, Brian Foster wrote:
> > > On Tue, Jan 16, 2024 at 12:03:09PM -0500, Kent Overstreet wrote:
> > > > On Tue, Jan 16, 2024 at 10:33:08AM -0500, Brian Foster wrote:
> > > > > Hi Kent,
> > > > >
> > > > > JFYI, I'm seeing the following splat pretty reliably via > >
> > > generic/361 on
> > > > > an 80xcpu test box. The CI doesn't seem to produce this > >
> > > failure for
> > > > > whatever reason. This bisects down to commit 023f9ac9f70f > >
> > > ("bcachefs:
> > > > > Delete dio read alignment check"), before which the test > >
> > > still fails but
> > > > > the kernel doesn't explode.
> > > > >
> > > > > Brian
> > > > >
> > > >
> > > > Can you test the following?
> > > >
> > > 
> > > Still blows up... repeated a couple times to be sure.
> > 
> > That sounds like a driver bug then - what driver?
> 
> 
> I think it's not a drive bug. It's related to bcachefs block_size.
> I can reproduce it by running generic/361 with block_size 4096.
> 
> The test devices are normal qemu disks backing by files in host.
> The bug disappears after hanging mkfs block_size to 512.
> 

Hi Su,

Yes, I think this is the issue as block_bytes(c) is 4k in my test.
Thanks for testing/confirming.

The immediate reason for the crash appears to be bio_copy_data_iter()
going off the rails trying to copy a larger source bio into a smaller
destination bio with seemingly inconsistent size/bvec.

The broader context is we start with a sub-block sized read, so e.g. I
see a request for 1024 bytes at offset 4096. This results in a bio with
bi_size == 4096, however, because right after the alignment check that
was removed we do this:

	ret = min_t(loff_t, iter->count,
		    max_t(loff_t, 0, i_size_read(&inode->v) - offset));
	...
	shorten = iov_iter_count(iter) - round_up(ret, block_bytes(c));
	iter->count -= shorten;

... which appears to underflow the iter count and is presumably fixed up
somewhere to cap at the block size. I'm assuming this ends up in a
situation where an internally inconsistent iov_iter leads to a similarly
broken bvec_iter on the bio, or otherwise this gets further confused
when creating the bounce bio, but I haven't traced to that level of
detail.

In any event, we end up in bio_copy_data_iter() with a destination bio
of bi_size == 4k that only appears to have a single 1k sized bvec. The
first 1k copies as expected, but this doesn't reduce bi_size to zero and
so the iteration just continues to advance the bio vec index until it
finds some garbage data it can infer as a non-zero bv_len bvec to copy
into.

Brian

> --
> Su
> 

