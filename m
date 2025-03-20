Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA94209F5E
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 10:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742466506; cv=none; b=Ihx2+vG8CCn9H9y5QrYSchNio3SP+wmNUD9aRjxgYgGlQHeoX6/h9oJl4RrLqV8n8UTZBDGDwNW5M9w1WMTm06Kcd+RYdG7+9KJjxULkAh2Nzh4J/L/xIZ34e+1aq073SmayC1EaU/3TkW2nBfhvxLv2BiZwAq7pJ4U2Hj+YfLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742466506; c=relaxed/simple;
	bh=J7wsQei5Jvv3rc9OfhfzjWzPOrQ93NlcxGqqycKNfFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NslyzGUM/MgQJKN3NJiuUA92FRo4wzBtIeVwIrez1EOl9uPW4/0jIHLffzEuPJrY4NQg9YrwK5Fu2QsSypOIgBifjxkv25HICLrJ4lHGH04rlV+xFljhaO3criyLa6XFn6BmNcwf7+IHj5UI3v6m3+7SKck5t2ClnOPdLhqDz6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sXasm3/M; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sXasm3/M"
Date: Thu, 20 Mar 2025 06:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742466499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hKkmTlPdjL5yWb2hU/bKjk/s2siqxaNI4P74wFGaO1s=;
	b=sXasm3/Mmy+26eFEtYplujYizkL07/GrGDJZUBdVFC+8xN2TPlXpk0FszVApkAb5dyyPlm
	TTY2ciYyitFcr+mUMDsGs3XZYawsM8gl/rmPilwA10+HlnoidGE4V4N/+7GtszW6r/Pt7X
	vigznRTLjpWqhA7qgN8WJgiKrAdudFw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <kbusch@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <6fbiaellaiveldpywvrqlss6zovgastnqrkpkuwh4nhgoqx3wj@2lamdytlkg5v>
References: <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
 <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
 <4mqi7e74ji7j3pzfdhfncz2yz3vvvvb6jivtzry4pmljgygcg5@hd5pv2lddzeq>
 <18b03fe9-1f57-48ac-92e3-308d27c5d144@acm.org>
 <t4zch7xnj5j3ifnivw3fkhkjpjldk2mozk3ouhogi224ntalab@3jjt2j6crbxe>
 <Z9m3KSGxyt_HQ5oD@kbusch-mbp>
 <Z9uqZS7QmjSvMlA5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9uqZS7QmjSvMlA5@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 19, 2025 at 10:40:53PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 18, 2025 at 12:10:49PM -0600, Keith Busch wrote:
> > Maybe just change the commit log. Read FUA has legit uses for persisting
> > data as described by the specs. No need to introduce contested behavior
> > to justify this patch, yah?
> 
> While not having a factually incorrect commit message is a great
> start I still don't think we want it.  For one there is no actual
> use case for the actual semantics, so why add it?  Second it still
> needs all the proper per-driver opt-in as these sematncis are not
> defined for all out protocols as I've already mentioned before.
> 
> But hey, maybe Kent can actually find other storage or file system
> developers to support it, so having an at least technically correct
> patch out on the list would be a big start, even if I would not expect
> to Jens to take it in a whim.

Chistoph,

You're arguing over nothing. Go back and reread, you and I have the same
interpretation of what read fua should do.

You all really are a surly and argumentative lot...
