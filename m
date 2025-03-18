Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ED22260C
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 00:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742257661; cv=none; b=BreCovMaL1smtcKUZfAwgBm7EKL7y3pwNaySxcCvqQcYUCasZy3siifiZcxNSeVdubfkVaTSFKa/HslZqOaxzvXNioJFhwMNRSFR6cRFJ+U+KCs2w0asMds1jp6GlKPO49GXNgvzSkT54/UDv3cFDErsECZqU5TVMfZ0f5a5Xy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742257661; c=relaxed/simple;
	bh=4XQgHb3+iG4KY/95NxTaGbG/ca/uVMXQ5luUzGA+Z+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRZXY0k3kiawZF5UhSG+Ob+yiGfaMWNUVPi5dgNGPPEauiE10+zo288hicEZiWZa4ECH6NsBBUR6igTDFOH6kaznbfaXXfYF/8yOMcclJZs1a7V8Pfo4i5VaJeJGgDzxZUqzF6kp/Kuau8w6N2I/hVw+Doh2pRBC3DAoJp+BfUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o0RQYvUB; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o0RQYvUB"
Date: Mon, 17 Mar 2025 20:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742257646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=msGHYgLziAV/KnCnYfOi8Q9iOJf9m2mu/XhNQWn1dZU=;
	b=o0RQYvUBVpgY96oA3+JGvTACsyXcqPJr4fhYZUSMgBaBUV+YnVhYcoUsPErEvwhNvSxMUT
	awy7kVIRNQDMHc0Q7QxEfPR3S2I0eFe9TjC1i4HlA47A2Wf3+9kTAxSsyJEgENym0VIeNe
	kzVhpi+3Of/c2VDFTSBVxFDvHOj5QkY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Keith Busch <kbusch@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <nffu6uwqi7lshwlmw7why2mkckffnboosv6frrspe2ckaksphq@yql25ni5pzub>
References: <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 02:39:07PM -0600, Keith Busch wrote:
> On Mon, Mar 17, 2025 at 03:40:10PM -0400, Kent Overstreet wrote:
> > On Mon, Mar 17, 2025 at 01:24:23PM -0600, Keith Busch wrote:
> > > This is a bit dangerous to assume. I don't find anywhere in any nvme
> > > specifications (also checked T10 SBC) with text saying anything similiar
> > > to "bypass" in relation to the cache for FUA reads. I am reasonably
> > > confident some vendors, especially ones developing active-active
> > > controllers, will fight you to the their win on the spec committee for
> > > this if you want to take it up in those forums.
> > 
> > "Read will come direct from media" reads pretty clear to me.
> >
> > But even if it's not supported the way we want, I'm not seeing anything
> > dangerous about using it this way. Worst case, our retries aren't as
> > good as we want them to be, and it'll be an item to work on in the
> > future.
> 
> I don't think you're appreciating the complications that active-active
> and multi-host brings to the scenario. Those are why this is not the
> forum to solve it. The specs need to be clear on the guarantees, and
> what they currently guarnatee might provide some overlap with what
> you're seeking in specific scenarios, but I really think (and I believe
> Martin agrees) your use is outside its targeted use case.

You do realize this is a single node filesystem we're talking about,
right?

Crazy multi-homing stuff, while cool, has no bearing here.

>  
> > As long as drives aren't barfing when we give them a read fua (and so
> > far they haven't when running this code), we're fine for now.
> 
> In this specific regard, I think its safe to assume the devices will
> remain operational.
> 
> > > > If devices don't support the behaviour we want today, then nudging the
> > > > drive manufacturers to support it is infinitely saner than getting a
> > > > whole nother bit plumbed through the NVME standard, especially given
> > > > that the letter of the spec does describe exactly what we want.
> > > 
> > > I my experience, the storage standards committees are more aligned to
> > > accomodate appliance vendors than anything Linux specific. Your desired
> > > read behavior would almost certainly be a new TPAR in NVMe to get spec
> > > defined behavior. It's not impossible, but I'll just say it is an uphill
> > > battle and the end result may or may not look like what you have in
> > > mind.
> > 
> > I'm not so sure.
> > 
> > If there are users out there depending on a different meaning of read
> > fua, then yes, absolutely (and it sounds like Martin might have been
> > alluding to that - but why wouldn't the write have been done fua? I'd
> > want to hear more about that)
> 
> As I mentioned, READ FUA provides an optimization opportunity that
> can be used instead of Write + Flush or WriteFUA when the host isn't
> sure about the persistence needs at the time of the initial Write: it
> can be used as a checkpoint on a specific block range that you may have
> written and overwritten. This kind of "read" command provides a well
> defined persistence barrier. Thinking of Read FUA as a barrier is better
> aligned with how the standards and device makers intended it to be used.

Yeah, I got that. Again, a neat trick, but who in their right mind would
use that sort of thing when the sane thing to do is just write fua?

So I'm skeptical that that sort of thing is an actual use with any
bearing on the devices any single node filesystem targets.

Now, in crazy enterprise multi homing land, sure.

Now, if you're saying you think the standard should be interpreted in a
way such that read fua does what it seems you and Martin want it to do
in crazy enterprise multi homing land... now _that_ would be a fun
argument to have in a standards committee :)

But I mostly jest, because my suspicion is that there wouldn't be any
real conflict, just a bit of the "I hadn't thought to use it that way"
anxiety.

> > If, OTOH, this is just something that hasn't come up before - the
> > language in the spec is already there, so once code is out there with
> > enough users and a demonstrated use case then it might be a pretty
> > simple nudge - "shoot down this range of the cache, don't just flush it"
> > is a pretty simple code change, as far as these things go.
> 
> So you're telling me you've never written SSD firmware then waited for
> the manufacturer to release it to your users? Yes, I jest, and maybe
> YMMV; but relying on that process is putting your destiny in the wrong
> hands.

Nah, back when I was at an employer that did SSD drivers/firmware, it
was all in house - no waiting to ship required :)

And incidentally, it's been fun watching the "FTL host or device side"
thing go back and forth since then; we had the same back-and-forth
happen just between different generations of the internal stuff being
built at Google that's been happening now with NVME and ZNS.

The appeal of a host side FTL was fairly obvious back then, but the FTL
ended up moving from the host to the device because people wanted to do
complete kernel IO stack bypass. The AIO and DIO code were really bad
back then especially in certain multithreaded scenarios - profiles were
absolutely atrocious, and the performance gains of a host side FTL
only really happen if you can do it in combination with the filesystem,
cutting out a lot of redundancy and improving on GC efficiency (this is
a big one) because in the filesystem, you have a lot more information on
what goes with what, that's lost at the block layer. IO tail latency in
particular improves, especially on loaded machines.

But a filesystem meant for that didn't exist at the time, nor did
hardware with any kind of an open interface...

Since then the kernel IO stack has gotten massively faster, ZNS hardware
exists, and bcachefs was pretty much designed from the start for
directly driving flash. There's about a month of work left, max, for
finish that off and driving hardware I have sitting on my desk.

Which means there should be more interesting things happen in the NVME
transport area in the future. In particular, moving the FTL into the
filesystem ought to allow for much more gracefully degrading failure
modes instead of the whole SSD going offline (and signals to the user
about when flash is going bad! flash ECC algorithms give you this, it's
just not exposed!).

So should be fun times.
