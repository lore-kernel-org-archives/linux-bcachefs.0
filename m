Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FF11D4356
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742235699; cv=none; b=Tte+hAMOLp9XXYde9fKtVT09YfxaGEY1KN6usByQffvUsSNJ6QtJGHUp0rMTNCfA5hkOuFqtklRBvHZbZQVF/sGzciCgYzlCooH/pzKGPvmoaCT1QzXX2a4f21zlxpky8zJ0bIv5elpQdT3+quHVfGKtzzrYfXSKv5TtZmJhIvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742235699; c=relaxed/simple;
	bh=y7PiawXMLjhJAHEtPEANtUgbmlPj8uz7tgQ/uKONMdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RW3rzjw4tdPwxnQcbxabLYeuM/bckdIb5iGlVyUnck188sI60cjXOSLGUx+2nmKLcIwUs+O4U7mUVFo2m/EE820v7CJ380Tb4VDR2HKaZFl/P7Rn1vALotr+m3Vlz7RoX71Mocvez9y7f9y3BEsnkJJDbk8afD0Zp0KZNr8n4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n5yQ/gwH; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n5yQ/gwH"
Date: Mon, 17 Mar 2025 14:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742235694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Egdu7lu2alx2YW0th9IMSNOYWGB3ViakICF9fWwb8vY=;
	b=n5yQ/gwHVTVVdWlOiJ+XVaqS7K6k2mjgYqXha0qdPUFupQyqa0l0ruezRNtVzm621MA7yK
	seyQBoe29Or7osboe5o3nxYyFO2zcPshWZ9dVniHt2dMlPXL1eMOvHiYK475tv69fjGiQ3
	JXFxdyWf9fm8OiC37upy/ReiVVjpoB4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
References: <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 01:57:53PM -0400, Martin K. Petersen wrote:
> 
> Kent,
> 
> >> At least for SCSI, given how FUA is usually implemented, I consider
> >> it quite unlikely that two read operations back to back would somehow
> >> cause different data to be transferred. Regardless of which flags you
> >> use.
> >
> > Based on what, exactly?
> 
> Based on the fact that many devices will either blindly flush on FUA or
> they'll do the equivalent of a media verify operation. In neither case
> will you get different data returned. The emphasis for FUA is on media
> durability, not caching.
> 
> In most implementations the cache isn't an optional memory buffer thingy
> that can be sidestepped. It is the only access mechanism that exists
> between the media and the host interface. Working memory if you will. So
> bypassing the device cache is not really a good way to think about it.
> 
> The purpose of FUA is to ensure durability for future reads, it is a
> media management flag. As such, any effect FUA may have on the device
> cache is incidental.
> 
> For SCSI there is a different flag to specify caching behavior. That
> flag is orthogonal to FUA and did not get carried over to NVMe.
> 
> > We _know_ devices are not perfect, and your claim that "it's quite
> > unlikely that two reads back to back would return different data"
> > amounts to claiming that there are no bugs in a good chunk of the IO
> > path and all that is implemented perfectly.
> 
> I'm not saying that devices are perfect or that the standards make
> sense. I'm just saying that your desired behavior does not match the
> reality of how a large number of these devices are actually implemented.
> 
> The specs are largely written by device vendors and therefore
> deliberately ambiguous. Many of the explicit cache management bits and
> bobs have been removed from SCSI or are defined as hints because device
> vendors don't want the OS to interfere with how they manage resources,
> including caching. I get what your objective is. I just don't think FUA
> offers sufficient guarantees in that department.

If you're saying this is going to be a work in progress to get the
behaviour we need in this scenario - yes, absolutely.

Beyond making sure that retries go to the physical media, there's "retry
level" in the NVME spec which needs to be plumbed, and that one will be
particularly useful in multi device scenarios. (Crank retry level up
or down based on whether we can retry from different devices).

But we've got to start somewhere, and given that the spec says "bypass
the cache" - that looks like the place to start. If devices don't
support the behaviour we want today, then nudging the drive
manufacturers to support it is infinitely saner than getting a whole
nother bit plumbed through the NVME standard, especially given that the
letter of the spec does describe exactly what we want.

So: I understand your concerns, but they're out of scope for the moment.
As long as nothing actively breaks when we feed it READ|FUA, it's
totally fine.

Later on I can imagine us adding some basic sanity tests to alert if
READ|FUA is behaving as expected; it's pretty easy to test latency of
random vs. reads to the same location vs. FUA reads to the same
location.

So yes: there will be more work to do in this area.

> Also, given the amount of hardware checking done at the device level, my
> experience tells me that you are way more likely to have undetected
> corruption problems on the host side than inside the storage device. In
> general storage devices implement very extensive checking on both
> control and data paths. And they will return an error if there is a
> mismatch (as opposed to returning random data).

Bugs host side are very much a concern, yes (we can only do so much
against memory stompers, and the RMW that buffered IO does is a giant
hole), but at the filesystem level there are techniques for avoiding
corruption that are not available at the block level.  The main one
being, every pointer carries the checksum that validates the data it
points to - the ZFS model.

So we do that, and additionally we're _very_ careful when moving around
data to carry around existing checksums, and validate the old after
generating the new (or sum up new checksums to validate them against the
old directly) when moving data around.

IOW - in my world, it's the filesystem's job to verify and authenticate
everything.

And layers above bcachefs do their own verification and authentication
as well - nixos package builders and git being the big ones that have
caught bugs for us.

It all matters...
