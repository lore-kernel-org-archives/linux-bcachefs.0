Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49635757E3
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 18:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718043185; cv=none; b=u5CjKEQOV0vUstd8e7wVHc4Qzb4zWY7Ndx2S5/LbWuywrFjQdRGH6pRWPO3CpGKgUQWQBNe9kXf7SCpQdB1SYGdVGYV2go5+cLa73nVBoqrQSiPiM0BoeZ2tAPYrX3E/OhgkAEFHQ8s2Zn2EQIYWIQ/P+wHrTBodFzDhYIPo6Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718043185; c=relaxed/simple;
	bh=gNfcIhbrCGMLIvIPqSIa39l1ZFPS9OmnTQs3k/fdcTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YiR7MOZxcq7lqVrb+rakMZGqfzrMqPxprlQX6oCxA5WMpgt3j3fWcsMGSBTO0jEyDN1r2JT/ZbsbWeEsMjIxzZQvnpBuQNKrU2+LyWkMvyAAY8NHm8viCutWSrF9h3RcZArCCZUaAEW4zTOJocuJgeurvKFzBS/vLjNJCgzsTXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O1cs/lQ2; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O1cs/lQ2"
X-Envelope-To: mjguzik@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718043180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ge7TloVuzWXGD7Le2ll7JnNPaTJFHuTJOvT5SJAvZlI=;
	b=O1cs/lQ2Y42mSW9u6c1+a/4qpf9OJb3b0HMnMyNsCIVA6vUgW6GhVBqW9iZBTzW39tj+TN
	8Jj1chQ6alSzJrlZTBp7x2dEnxNVQuRq5iquODX/EZdCihLAlaCIyP7ng76CeFqzQywGkJ
	s+dO7gaTvheP8y/ER3gPKtuILLqxP2A=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Mon, 10 Jun 2024 14:12:56 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <gskaw3ud7aicys3kq3j5nlf66ihcisfrnkwo2wlb5hji5svhvf@vvbuomk2fhmm>
References: <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
 <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
 <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
 <ngsytb3begcqgyfc5tiqjqdj6fp7kdeiwvd2jfq7ahwge2dr7c@fjcawnco7ssk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ngsytb3begcqgyfc5tiqjqdj6fp7kdeiwvd2jfq7ahwge2dr7c@fjcawnco7ssk>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 08, 2024 at 11:24:37AM +0200, Mateusz Guzik wrote:
> On Fri, Jun 07, 2024 at 02:10:05PM -0400, Kent Overstreet wrote:
> > Does the following patch help? I think the hammering on the key cache
> > lock may be correlated with the key cache being mostly empty (and it
> > looks like the shrinker code is behaving badly and trying very hard to
> > free from a mostly empty cache)
> > 
> > [snip the patch]
> 
> I see you committed the patch along with some other stuff.
> 
> I git pulled to 46eb7b6c7420c2313bde44ab8f74f303b042e754 ("bcachefs: add
> might_sleep() annotations for fsck_err()").
> 
> For me the problem is still there.
> 
> This time around I populated the fs and *rebooted*, then did walktrees
> test in a loop. So the first run has 0 state cached.
> 
> It looked like this:
> # while true; do sh walktrees /testfs 20; done
> 3.17s user 605.22s system 1409% cpu 43.150 total
> 2.77s user 887.92s system 693% cpu 2:08.34 total
> 3.05s user 726.20s system 777% cpu 1:33.77 total
> 3.19s user 600.90s system 1476% cpu 40.904 total
> 3.10s user 956.80s system 599% cpu 2:40.19 total
> 3.15s user 575.78s system 1331% cpu 43.464 total
> 3.30s user 865.48s system 1386% cpu 1:02.64 total
> 2.79s user 470.09s system 1404% cpu 33.666 total
> 2.78s user 884.00s system 718% cpu 2:03.36 total
> 2.95s user 568.63s system 1439% cpu 39.714 total
> 3.02s user 964.90s system 729% cpu 2:12.72 total
> 2.95s user 829.68s system 703% cpu 1:58.44 total
> 2.77s user 597.92s system 1486% cpu 40.403 total
> 
> So the time varies wildly and there is tons of off cpu time -- with 20
> workers eating 100% cpu for the duration it would be 2000%.
> 
> I also started seeing splats in dmesg (example at the end of the mail).

this confirms that the SRCU splats we've been seeing are partly caused
by this, as I suspected

> That is to say I would suggest you also leave it running in a loop.
> Expected setting is that it approaches complete CPU usage for the period
> and takes in the ballpark of 40s (well shorter on your hw, but you get
> the idea).

Yeah, I do see it with more iterations.

I'm redoing the key cache to get rid of the key cache lock - that solves
it nicely. If you want to take a look at what I'm working on,

https://evilpiepirate.org/git/bcachefs.git/log/?h=bcachefs-vfs-inodes-rhashtable

this is unfinished - I'm going to be switching back to the polling srcu
interface (so we can allocate from pending frees), and the patch to
switch vfs inodes to an rhashtable currently breaks writeback - but it's
much faster.
