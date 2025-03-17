Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95230F9DA
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 19:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742240423; cv=none; b=LtoLejyOBdNCGdecCaLl1CWx9FIw/mhz2o1jH9K1tsEknhMgzJt+pTSVAmyPk2d9d4S8161JFz+W53e25iDLwNxEgoNr8KOvqchwLaHzRYsB8AdfIHKkGx+RhDTyRC4rbepmT6BCtExuau5OsZ7Gr+Ol4kN1nuepRRYPnOaxcbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742240423; c=relaxed/simple;
	bh=H9XlVEy0oZT3ZRR/WkoXrrW1YYzLXO6KpSZVnpN3U3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CrxegeoEyorieYobFy3sYtpmSEs42JVRDIEi2SxjPwSsjvAMe6ySLo9GbRGLgVjSfni1Os6eWZ63H1WK0nrMg+cMrIf0hN1UDrKjRlIoBIqYX7yMvdm3jr6h5LXuIufjDqtR5HyyWIVQJRiuEV5P+SyOeKwx9JN2vJf5ssuNwvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iEyKypyT; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iEyKypyT"
Date: Mon, 17 Mar 2025 15:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742240414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XGTPEhkRy27CbB3bC8xL/SYm09XD2n2ZlATqwfYc5QI=;
	b=iEyKypyTcyn8RmGB/MWnQIRBdiQo+n9w9nN7UwHPIJhvKgM13n79tJHHFLL+b8KnOVM2/J
	HWUknCyEg2da1SwL7xTn2sX/2oFMuI63yOjFpMRu3Md+szN86nNR2N0E0vyki4OnxGyVSU
	siC0AaAy0LGEjgZuCCmMmcEjmvvs8vo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Keith Busch <kbusch@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
References: <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 01:24:23PM -0600, Keith Busch wrote:
> On Mon, Mar 17, 2025 at 02:21:29PM -0400, Kent Overstreet wrote:
> > On Mon, Mar 17, 2025 at 01:57:53PM -0400, Martin K. Petersen wrote:
> > > I'm not saying that devices are perfect or that the standards make
> > > sense. I'm just saying that your desired behavior does not match the
> > > reality of how a large number of these devices are actually implemented.
> > > 
> > > The specs are largely written by device vendors and therefore
> > > deliberately ambiguous. Many of the explicit cache management bits and
> > > bobs have been removed from SCSI or are defined as hints because device
> > > vendors don't want the OS to interfere with how they manage resources,
> > > including caching. I get what your objective is. I just don't think FUA
> > > offers sufficient guarantees in that department.
> > 
> > If you're saying this is going to be a work in progress to get the
> > behaviour we need in this scenario - yes, absolutely.
> > 
> > Beyond making sure that retries go to the physical media, there's "retry
> > level" in the NVME spec which needs to be plumbed, and that one will be
> > particularly useful in multi device scenarios. (Crank retry level up
> > or down based on whether we can retry from different devices).
> 
> I saw you mention the RRL mechanism in another patch, and it really
> piqued my interest. How are you intending to use this? In NVMe, this is
> controlled via an admin "Set Feature" command, which is absolutley not
> available to a block device, much less a file system. That command queue
> is only accesible to the driver and to user space admin, and is
> definitely not a per-io feature.

Oof, that's going to be a giant hassle then. That is something we
definitely want, but it may be something for well down the line then.

My more immediate priority is going to be finishing ZNS support, since
that will no doubt inform anything we do in that area.
  
> > But we've got to start somewhere, and given that the spec says "bypass
> > the cache" - that looks like the place to start. 
> 
> This is a bit dangerous to assume. I don't find anywhere in any nvme
> specifications (also checked T10 SBC) with text saying anything similiar
> to "bypass" in relation to the cache for FUA reads. I am reasonably
> confident some vendors, especially ones developing active-active
> controllers, will fight you to the their win on the spec committee for
> this if you want to take it up in those forums.

"Read will come direct from media" reads pretty clear to me.

But even if it's not supported the way we want, I'm not seeing anything
dangerous about using it this way. Worst case, our retries aren't as
good as we want them to be, and it'll be an item to work on in the
future.

As long as drives aren't barfing when we give them a read fua (and so
far they haven't when running this code), we're fine for now.

> > If devices don't support the behaviour we want today, then nudging the
> > drive manufacturers to support it is infinitely saner than getting a
> > whole nother bit plumbed through the NVME standard, especially given
> > that the letter of the spec does describe exactly what we want.
> 
> I my experience, the storage standards committees are more aligned to
> accomodate appliance vendors than anything Linux specific. Your desired
> read behavior would almost certainly be a new TPAR in NVMe to get spec
> defined behavior. It's not impossible, but I'll just say it is an uphill
> battle and the end result may or may not look like what you have in
> mind.

I'm not so sure.

If there are users out there depending on a different meaning of read
fua, then yes, absolutely (and it sounds like Martin might have been
alluding to that - but why wouldn't the write have been done fua? I'd
want to hear more about that).

If, OTOH, this is just something that hasn't come up before - the
language in the spec is already there, so once code is out there with
enough users and a demonstrated use case then it might be a pretty
simple nudge - "shoot down this range of the cache, don't just flush it"
is a pretty simple code change, as far as these things go.

> In summary, what we have by the specs from READ FUA:
> 
>  Flush and Read
> 
> What (I think) you want:
> 
>  Invalidate and Read
> 
> It sounds like you are trying to say that your scenario doesn't care
> about the "Flush" so you get to use the existing semantics as the
> "Invalidate" case, and I really don't think you get that guarantee from
> any spec.

Exactly. Previous data being flushed, if it was dirty, is totally fine.

Specs aren't worth much if no one's depending on or testing a given
behaviour, so what the spec strictly guarantees doesn't really matter
here. What matters more is - does the behaviour make sense, will it be
easy enough to implement, and does it conflict with behaviour anyone
else is depneding on.
