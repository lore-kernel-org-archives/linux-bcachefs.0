Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6614712836F
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Feb 2024 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707934341; cv=none; b=YI1PFCJkJhGMO3xJoujImVLETEWWj47mdnoQ1YtZYC1N7J5qpyHErYRFtytEcKfc30A5gsmn6UtGS3Y7uzXXgf7YDmmh3e4PRpRAsLzIuryd2wCQaaGxk7KnqtrKudIuVUfkLbJ6rDvfvHjYrB5mWH18rjQcWdNnzckCUPL95VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707934341; c=relaxed/simple;
	bh=alKj2okcl6YHQsfmVlazJEnQfZhXyjc1E7pSt1csz3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHb6MpT8LhPz1yWNaes1ju1LqCnRTmUnsfOATRReZg3YJS5P1dBFAXUFX2hZv4KyxrFKpdWwHvAAZ/aG6cJ53q7gFUAOFLomoHQjrfWmiHA1+4OxA2ZmxwlSF9yheuxPedd31fTe7xAmRl5n8bbehDLe/meLmzhvd+63nJSNK5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DfQhTKcU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DfQhTKcU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707934338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9FogLmZZ74GV8NolbejryLc31PPnYcCxnUdvYpTKv3c=;
	b=DfQhTKcUK/8gBcvuxuFB0XPQbyOHiGW/NcFbuJHwzrs1Jy7R4HHqSU5EvZB4vwBbP1jsax
	c47d99HT/Iru3a1IaaJIfa5fIQc14TK1Ok0GSCoX/Yv9PF1dk4rhxRD/GL2bBGBXAfFRv2
	gZMW57UukNm/EUGIfIHIMxZtNeOHoA4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-33Y4xSe1MmCKMdNleNFtZA-1; Wed,
 14 Feb 2024 13:12:14 -0500
X-MC-Unique: 33Y4xSe1MmCKMdNleNFtZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8358C380662E;
	Wed, 14 Feb 2024 18:12:14 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.56])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 531C2200B3D9;
	Wed, 14 Feb 2024 18:12:14 +0000 (UTC)
Date: Wed, 14 Feb 2024 13:13:51 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <l@damenly.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix iov_iter count underflow on sub-block dio
 read
Message-ID: <Zc0C32sbI2zjSDgL@bfoster>
References: <20240205154814.910664-1-bfoster@redhat.com>
 <4fdyk3to57izolmljjiehnn5kt5dxckhh2oodo7vk6gssgqbsb@6gsjfytnv2xy>
 <ZcE5JY279PGUrP9F@bfoster>
 <il2yfjaa.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <il2yfjaa.fsf@damenly.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Fri, Feb 09, 2024 at 10:39:43AM +0800, Su Yue wrote:
> 
> On Mon 05 Feb 2024 at 14:38, Brian Foster <bfoster@redhat.com> wrote:
> 
> > On Mon, Feb 05, 2024 at 02:15:36PM -0500, Kent Overstreet wrote:
> > > On Mon, Feb 05, 2024 at 10:48:14AM -0500, Brian Foster wrote:
> > > > bch2_direct_IO_read() checks the request offset and size for >
> > > sector
> > > > alignment and then falls through to a couple calculations to >
> > > shrink
> > > > the size of the request based on the inode size. The problem > is
> > > that
> > > > these checks round up to the fs block size, which runs the > risk
> > > of
> > > > underflowing iter->count if the block size happens to be > large
> > > > enough. This is triggered by fstest generic/361 with a 4k > block
> > > > size, which subsequently leads to a crash.
> > > >
> > > > After some discussion, the original purpose of the shorten > logic
> > > in this
> > > > path is not totally clear. It appears to be intended as an >
> > > optimization
> > > > of limited value, so simplify things and avoid the underflow >
> > > problem by
> > > > removing it.
> > > 
> > > Thinking about this a bit more...
> > > 
> > > All that we're avoiding with the shorten is zeroing out the rest of
> > > the
> > > read, which will happen in bch2_read_extent(); we won't be issuing
> > > any
> > > IO, since that would require real data extents above i_size, which
> > > is of
> > > course not allowed.
> > > 
> > > But zeroing out the rest of the read is actual work that's being
> > > avoided, since if we return a short read (which is what we're doing
> > > here) it's undefined what happens to the rest of the buffer.
> > > 
> > > So... maybe we should keep it, for the crazy but inevitable
> > > application
> > > that uses a 1MB read buffer for everything, including O_DIRECT reads
> > > to
> > > 4k files?
> > > 
> > 
> > I had another change around that basically just protected against the
> > underflow. I.e., something along the lines of the following, to also
> > cover the additional use of shorten later in the function:
> > 
> > 	if (shorten >= iter->count)
> > 		shorten = 0;
> > 
> 
> The change is a clean fix without breaking logic in bch2_direct_IO_read.
> If without shroten, the next loop counting on iter->count must be altered.
> I'd like the simpler way.
> 

Hi Su,

I'm not quite following your comment on the "next loop counting on
iter->count." Can you elaborate? Also, which option are you calling more
simple? :) Thanks.

Brian

> --
> Su
> 
> > ... and IIRC that seemed to work as well. But I'll probably have to take
> > a closer look at that large buffer case to grok what's happening and the
> > original purpose of this logic.
> > 
> > Brian
> 

