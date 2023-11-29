Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zp5QFP7n"
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442918E
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 16:15:47 -0800 (PST)
Date: Tue, 28 Nov 2023 19:15:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701216945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nphDhd1L54nPfY4iiHcfrK9K/brtNeSx1QAJlnAXtu0=;
	b=Zp5QFP7n8guJ9/Yt6l5ayI11+J9pl8kEPJoqrxFpxHdfeo8MuY/oQrE80I/W0mfD8acSUg
	eRDAEsdElSBWnyd3+87Xk/93VQJHcX3OkWn8WYN9chEXzcRFsojdKIafUnmDQNQ7oO6Rys
	8J0WF7BWj1iIWVkrjqAOBRfaCmH1MQQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nick Terrell <terrelln@meta.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	Nick Terrell <nickrterrell@gmail.com>
Subject: Re: Zstd write past end reproducer
Message-ID: <20231129001541.vitkrn6lmn3ahzet@moria.home.lan>
References: <F9E55704-6BF2-4ABD-9DB6-62D908EB97DC@meta.com>
 <20231128220903.up7chj4mw5r6glbf@moria.home.lan>
 <9E69EEFF-73DB-478F-9927-30BF98F08039@meta.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9E69EEFF-73DB-478F-9927-30BF98F08039@meta.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 11:51:58PM +0000, Nick Terrell wrote:
> 
> 
> > On Nov 28, 2023, at 2:09 PM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  This Message Is From an External Sender
> > 
> > |-------------------------------------------------------------------!
> > 
> > On Tue, Nov 28, 2023 at 10:04:02PM +0000, Nick Terrell wrote:
> >> Hi Kent,
> >> 
> >> I see in the bcachefs compression code this comment [0]:
> >> 
> >> Additionally, the ZSTD code seems to have a bug where it will
> >> write just past the end of the buffer - so subtract a fudge
> >> factor (7 bytes) from the dst buffer size to account for
> >> that.
> >> 
> >> This is very unexpected, as zstd is extensively fuzzed for these types of bugs.
> >> It doesn’t look like bcachefs is using zstd in a way that would trigger a unique
> >> code path, so my first suspicion is that there is a bug in the way that bcachefs
> >> is calling zstd.
> >> 
> >> I spent some time trying to reproduce the issue by calling zstd in the same way
> >> that bcachefs called zstd when the workaround was landed, but so far haven’t
> >> been successful in triggering the bug.
> >> 
> >> If you can provide a reproducer, I will look into the issue further. If you can
> >> provide the input data, the size of the output buffer used, and the parameters
> >> used (or the level & estimated source size used to derive the parameters), I
> >> will definitely be able to debug the issue, and get it fixed if it is a problem with
> >> zstd.
> >> 
> >> Best,
> >> Nick Terrell
> >> 
> >> [0] https://github.com/torvalds/linux/blob/v6.7-rc3/fs/bcachefs/compress.c#L588
> > 
> > Sorry, just saw the subject - I haven't looked at the end of buffer bug
> > in quite awhile, that was many kernel releases ago. It's entirely
> > possible it's been fixed since then (but it was a nasty source of memory
> > corruption for a good while).
> 
> If you do ever happen by a reproducer, let me know. The zstd code in the
> kernel hasn’t been significantly updated since October 2022, so nothing has
> changed on that side.
> 
> I will spend a bit more time trying to reproduce the issue, since any out of
> bounds write is a top priority issue for us, but I really think the issue isn’t in zstd,
> since this is widely used code that is also heavily fuzzed for this exact scenario.
> 
> > I never had a reproducer for it, only tracked it down through end user
> > reports.
> 
> Do you happen to have a link to these reports?

these might be relevant:

https://github.com/koverstreet/bcachefs/issues/120
https://github.com/koverstreet/bcachefs/issues/4
