Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A74C1474DA
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 01:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742259982; cv=none; b=knVLuaXsOdhcdnebGhRtTkaOoI6+XD8Ejy3S5r30kdnpbz6SWjW07fX+K0hOjPpaFNumQnRLiEz5XRYhocfpNPwG9IB1J3PRJ6e4vYC9ylnCfb5/jRrkIFNIP68r4fFDcR3o30GMBMcMJzaQLpAOK6M8zfovhpZwUbwviajohv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742259982; c=relaxed/simple;
	bh=Y2KvUn9mx+AOhbawnIaeHzTIGVcVoJ/EVksMjkNeEao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z1+FSp1/q2Uabj/78Bx3qsPrJkdioAgxxPVRBuEjHiDxEE1Qywwe1aqFPRr6dV+NxjMmlPT39tbgpCopzoBmbAailA51BqPoclt/DMw09e3COZix+pl1foqTXBPPFXsu7P8VTjAADpkNE0SxUPkp4Fn31ftWTCoUp6TIK6iXOTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NAAsMPge; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NAAsMPge"
Date: Mon, 17 Mar 2025 21:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742259977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fEM8kcDSSrh8lm8TTW680nIhFq7eS+MT+j83CVl7V4I=;
	b=NAAsMPgeBRdITv9puxCJCL/jrQ49Stpvc5lDZy8HgDxlhySzZLsVgcYXkuwpe3wMWKDYnj
	84M9BAYZwCPrdRfF9FArdMfQlx/9/tDyI268dj+FNXD92cwUEIK2kmBFFvO9B3hgUzb7x7
	me7gCVGYDgXQRXEZFh6Oer250UaynR0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Keith Busch <kbusch@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <4mqi7e74ji7j3pzfdhfncz2yz3vvvvb6jivtzry4pmljgygcg5@hd5pv2lddzeq>
References: <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
 <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 02:13:14PM -0700, Bart Van Assche wrote:
> On 3/17/25 1:39 PM, Keith Busch wrote:
> > On Mon, Mar 17, 2025 at 03:40:10PM -0400, Kent Overstreet wrote:
> > > If, OTOH, this is just something that hasn't come up before - the
> > > language in the spec is already there, so once code is out there with
> > > enough users and a demonstrated use case then it might be a pretty
> > > simple nudge - "shoot down this range of the cache, don't just flush it"
> > > is a pretty simple code change, as far as these things go.
> > 
> > So you're telling me you've never written SSD firmware then waited for
> > the manufacturer to release it to your users? Yes, I jest, and maybe
> > YMMV; but relying on that process is putting your destiny in the wrong
> > hands.
> 
> As far as I know in the Linux kernel we only support storage device behavior
> that has been standardized and also workarounds for bugs. I'm
> not sure we should support behavior in the Linux kernel that deviates
> from existing standards and that also deviates from longstanding and
> well-established conventions.

What bcachefs is doing is entirely in line with the behaviour the
standard states.

Keith and Martin are describing systems with a different interpretation,
because they want the side effect (flush cache) without the main effect
(possibly evict cache, but read comes from media).

It's an amusing state of affairs, but it'd be easily resolved with an
admin level NVME command to flip a state bit (like the read recovery
level we were also talking about), and anyways multihoming capable NVME
devices are an entirely different market from the conventional stuff.
