Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4DC54652
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742223015; cv=none; b=i+Cw7imynbv+u0EZYYYjNvEvIKaLEvcoExoqZq5735n1tqTz6NLsN3f1NLW6v7/eukoSpkSobIo3GnEe+oGIeiCShGBgNrECC4udS5+KJS74ZztbO2hmcoKoxsVgYkYGGdHF4VxjJkFprF1hy4cdSk+B7eaNatiTPPz6F/dNoB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742223015; c=relaxed/simple;
	bh=ii8rr7/fVEXM+qxLFj8b1Tz+X0ZoLXUhPPLzPozq6tQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FT1DK7yvTpPzAK3HMunEfovJR7ou6FHIAV3mE96+ny26Oxi2X/WbI4McrJxQJjC6jPYOO2m0O7x0gz3qxsqYnY2CArgK9Oswz6gMzoCH5lYy1cMCfPu0QH8ia1OuikK6bBSvio6aCjcjuVmXPScg8Lz7q/5oBar6s3qDhArtNaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RiH06duA; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RiH06duA"
Date: Mon, 17 Mar 2025 10:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742223001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWGKsAKJqpyZSzvsK8O05PgmjgiLt2JSMbr6M+1JUuI=;
	b=RiH06duA0wLvVdudVUiqT4rfR2S55oOGex0DA+1ubS6acg+1m/EiAHfZqEjxsiWeEd1pHd
	tx3EmR79E+hxrUB4sS3LmjViTowMQPjYP2VSdL/olPRCbJ79f4UiTcdA6G6EHAEiyEV3ZG
	HlDkaKg7oexQrTtQdj0XzRsMkXYckL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <ro2padvzarj6v2bsh6xlsz36qs67z6ubomsvaw77dw4elfqqu7@4acij7zk6g7z>
References: <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
 <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 08:13:59AM -0600, Keith Busch wrote:
> On Mon, Mar 17, 2025 at 08:15:51AM -0400, Kent Overstreet wrote:
> > On Sun, Mar 16, 2025 at 11:00:20PM -0700, Christoph Hellwig wrote:
> > > On Sat, Mar 15, 2025 at 02:41:33PM -0400, Kent Overstreet wrote:
> > > > That's the sort of thing that process is supposed to avoid. To be clear,
> > > > you and Christoph are the two reasons I've had to harp on process in the
> > > > past - everyone else in the kernel has been fine.
> > 
> > ...
> > 
> > > In this case you very clearly misunderstood how the FUA bit works on
> > > reads (and clearly documented that misunderstanding in the commit log).
> > 
> > FUA reads are clearly documented in the NVME spec.
> 
> NVMe's Read with FUA documentation is a pretty short:
> 
>   Force Unit Access (FUA): If this bit is set to `1´, then for data and
>   metadata, if any, associated with logical blocks specified by the Read
>   command, the controller shall:
> 
>     1) commit that data and metadata, if any, to non-volatile medium; and
>     2) read the data and metadata, if any, from non-volatile medium.
> 
> So this aligns with ATA and SCSI.
> 
> The concern about what you're doing is with respect to "1". Avoiding that
> requires all writes also set FUA, or you sent a flush command before doing any
> reads. Otherwise how would you know whether or not read data came from a
> previous cached write?

Line 1 is not the relevant concern here. That would be relevant if we
were trying to verify the integrity of writes end-to-end immediately
after they'd been completed - and that would be a lovely thing to do in
the spirit of "true end to end data integrity", but we're not ready to
contemplate such things due to the obvious performance implications.

The scenario here is: we go to read old data, we get a bit error, and
then we want to retry the read to verify that it wasn't a transient
error before declaring it dead (marking it poisoned).

In this scenario, "dirty data in the writeback cache" is something that
would only ever happen if userspace is doing very funny things with
O_DIRECT, and the drive flushing that data on FUA read is totally fine.
It's an irrelevant corner case.

But we do absolutely require checking for transient read errors, and we
will miss things and corrupt data unnecessarily without FUA reads that
bypass the controller cache.

> I'm actually more curious how you came to use this mechanism for recovery.
> Have you actually seen this approach fix a real problem? In my experience, a
> Read FUA is used to ensure what you're reading has been persistently committed.
> It can be used as an optimization to flush a specific LBA range, but I'd not
> seen this used as a bit error recovery mechanism.

It's not data recovery - in the conventional sense.

Typically, on conventional filesystems, this doesn't come up because a:
most filesystems don't even do data checksumming, and even then on a
filesystem with data checksumming this won't automatically come up -
because like other other transient errors, it's generally perfectly
acceptable to return the error and let the upper layer retry later; the
filesystem generaly doesn't have to care if the error is transient or
not.

Where this becomes a filesystem concern is when those errors start
driving state changes within the filesystem, i.e. when we need to track
and know about them: in that case, we absolutely do need to try hard to
distinguish between transient and permanent errors.

Specifically, bcachefs needs to be able to move data around - even if
it's bitrotted and generating checksum errors. There's a couple
different reasons we may need to move data:

- rebalance, this is the task that does arbitrary data processing in the
  background based on user policy (moving it to a slower device,
  compressing it or recompressing it with a more expensive algorithm)

- copygc, which compacts fragmented data in mostly-empty buckets and is
  required for the allocator and the whole system to be able to make
  forward progress

- device evacuate/removal

Rebalance is optional (and still needs to bitrotted extents to be
tracked so that it doesn't spin on them, retrying them endlessly), but
copygc and evacuate are not.

And the only way for these processes to handle bitrotted extents
(besides throwing them out, which obviously we're not going to do) is

- generate a new checksum
- mark them as poisoned, so that reads to userspace still return the
  appropriate error (unless it's a read done with a "I know there's
  errors, give me what you still have" API).

But the critical thing here is, marking an extent as poisoned will turn
a transient corruption into a permanent error unless we've made damn
sure there is no transient error with additional FUA retries.
