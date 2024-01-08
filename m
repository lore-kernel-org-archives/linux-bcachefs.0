Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A45D29417
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 03:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DOSCtMm7"
Date: Sun, 7 Jan 2024 22:24:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704684251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RnPCia1NNWGSTcxjvuKsoVEKAu8Mavk49zdrQWSUZMw=;
	b=DOSCtMm7Rxe4OGe+jmbM/vMxWzyi1xtn+aOKW3B6nLpF+JCd5/GBGjVqTaNZ+8NJ3iIwUg
	/6X90z5GuCMlORqJiMtcNn6RrInJ/I/qNfpfiCpcnol7HHdPRc48CXFOWoJ7uQz0wOLHMK
	m1Cnj8hvbj49GUAz1Oanm2M8hVPjqr4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS] create common entry point for Rust commands
Message-ID: <2dzey52pqpmi3mwdhcfhj2wvbssdeipxap6di5jttcms3c4ivq@zz2ej62lspyf>
References: <20240108013633.119160-1-tahbertschinger@gmail.com>
 <haijgauamlu7pn2rrvjtk4hpskxxjjezrdzo5wtuvre3aihm4i@ncqgo4t2rilc>
 <20240108031003.GB120162@fedora-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108031003.GB120162@fedora-laptop>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 07, 2024 at 08:10:03PM -0700, Thomas Bertschinger wrote:
> On Sun, Jan 07, 2024 at 09:37:53PM -0500, Kent Overstreet wrote:
> > Applying this
> > 
> > If you feel like going the extra mile, maybe we could convert the top
> > level main() to Rust, that'd further improve our helptext...
> 
> I thought about that, I wasn't sure if it made sense to do it now or wait
> until more stuff is done on the Rust side. Are there plans to move all
> the commands over to Rust at some point?
> 
> I'd be willing to give this a shot and send a patch if it'd be useful.
> 
> Is it important to keep a C top level main() around for compiling
> without Rust, BCACHEFS_NO_RUST defined? Or is Rust considered a hard
> requirement at this point?

It will be soon enough anyways, we can drop that now.
