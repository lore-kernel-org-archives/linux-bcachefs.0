Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAEB146588;
	Mon, 17 Mar 2025 20:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742243950; cv=none; b=E9kWicQXFOiTYZ34msB+yVEPXdnVDEmkRqQe2A/sfs0gNCQAXj6yspQhOfTggp1GxC/tbRBetwKe3BEloLYSJBBKK4m71cGnVsAQEeJIfMwoZmALkmhRuU3mi47zY52W9h7ansbi356bCbydHDX91fPUXlAOQ4f4LK5A+giCinc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742243950; c=relaxed/simple;
	bh=8X2NmdyPuY4DdxqALj/FVxjZR06pGA112Q2x8CGkeVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3jQx4vVbp6arJsg1UEySDmarFhzh06eUCECr7ZP0Ul50oUoxtzLo822Cq2yVtDstlxNDbf2lKHo4EICBlN0HhC6betBJP82OGrwrAVk42fx+jgdDNU2dzajHhremE3MYd8d7mF3aZ4OO4Oxbqi0oxbNBCtZWRghZ51FHvvZQPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsdYMUMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsdYMUMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470E7C4CEE3;
	Mon, 17 Mar 2025 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742243949;
	bh=8X2NmdyPuY4DdxqALj/FVxjZR06pGA112Q2x8CGkeVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BsdYMUMIYPJb4P2gDEtQSK/7k/odDLkD3EcRbTt+lrQlU2SI0sNrk1ctGaQYFhxGX
	 ZH5VbTsxz/n//mer/BI7CJ+zL1MwxguQRD2txV8x8lohXgmKZqrrYOyKGQwf3ZW84Y
	 zNaDBXGJNI26hkTvFgUhmTdFM/5XzCK3fpBuLeRQEmFRM11HVuJ6r5cONQvzylWeyZ
	 qryg3df4a48Bdv76zQUoQ+aLQv45WyqzTUmMuFcidvJG5wPNlMmlAj82wwB+1WkgGO
	 wIjpjLK4zh8XAaB9P7dr79DkNl2uRKZggL+DCwRM3/FivlcdjMehTmXJeEW2n7dtll
	 TD3sJiT/uTLvg==
Date: Mon, 17 Mar 2025 14:39:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
References: <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>

On Mon, Mar 17, 2025 at 03:40:10PM -0400, Kent Overstreet wrote:
> On Mon, Mar 17, 2025 at 01:24:23PM -0600, Keith Busch wrote:
> > This is a bit dangerous to assume. I don't find anywhere in any nvme
> > specifications (also checked T10 SBC) with text saying anything similiar
> > to "bypass" in relation to the cache for FUA reads. I am reasonably
> > confident some vendors, especially ones developing active-active
> > controllers, will fight you to the their win on the spec committee for
> > this if you want to take it up in those forums.
> 
> "Read will come direct from media" reads pretty clear to me.
>
> But even if it's not supported the way we want, I'm not seeing anything
> dangerous about using it this way. Worst case, our retries aren't as
> good as we want them to be, and it'll be an item to work on in the
> future.

I don't think you're appreciating the complications that active-active
and multi-host brings to the scenario. Those are why this is not the
forum to solve it. The specs need to be clear on the guarantees, and
what they currently guarnatee might provide some overlap with what
you're seeking in specific scenarios, but I really think (and I believe
Martin agrees) your use is outside its targeted use case.
 
> As long as drives aren't barfing when we give them a read fua (and so
> far they haven't when running this code), we're fine for now.

In this specific regard, I think its safe to assume the devices will
remain operational.

> > > If devices don't support the behaviour we want today, then nudging the
> > > drive manufacturers to support it is infinitely saner than getting a
> > > whole nother bit plumbed through the NVME standard, especially given
> > > that the letter of the spec does describe exactly what we want.
> > 
> > I my experience, the storage standards committees are more aligned to
> > accomodate appliance vendors than anything Linux specific. Your desired
> > read behavior would almost certainly be a new TPAR in NVMe to get spec
> > defined behavior. It's not impossible, but I'll just say it is an uphill
> > battle and the end result may or may not look like what you have in
> > mind.
> 
> I'm not so sure.
> 
> If there are users out there depending on a different meaning of read
> fua, then yes, absolutely (and it sounds like Martin might have been
> alluding to that - but why wouldn't the write have been done fua? I'd
> want to hear more about that)

As I mentioned, READ FUA provides an optimization opportunity that
can be used instead of Write + Flush or WriteFUA when the host isn't
sure about the persistence needs at the time of the initial Write: it
can be used as a checkpoint on a specific block range that you may have
written and overwritten. This kind of "read" command provides a well
defined persistence barrier. Thinking of Read FUA as a barrier is better
aligned with how the standards and device makers intended it to be used.

> If, OTOH, this is just something that hasn't come up before - the
> language in the spec is already there, so once code is out there with
> enough users and a demonstrated use case then it might be a pretty
> simple nudge - "shoot down this range of the cache, don't just flush it"
> is a pretty simple code change, as far as these things go.

So you're telling me you've never written SSD firmware then waited for
the manufacturer to release it to your users? Yes, I jest, and maybe
YMMV; but relying on that process is putting your destiny in the wrong
hands.
