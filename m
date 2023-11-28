Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f1tdbhGa"
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [IPv6:2001:41d0:203:375::bb])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700FD19A
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 14:08:09 -0800 (PST)
Date: Tue, 28 Nov 2023 17:08:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701209286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KiG2ZLUZIYryoahzgpDwOqhgzA8L9usVCOQbpWDpdkw=;
	b=f1tdbhGa3PAEk44dvN0osFg/qDz0LNkfuVBDIl3SFzXud/Zh+Lt/R4shubnAGxwj3OCsdp
	YPVYJlG1ADY9cG8YQe85DSgrNg7RAKBz0kczJNImpsThWEmvaNCGya0he7d1PlBGT0ZlHx
	b+yoYnNnHpH1YbZR9d/5MHLrOSagX7g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nick Terrell <terrelln@meta.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	Nick Terrell <nickrterrell@gmail.com>
Subject: Re: Zstd write past end reproducer
Message-ID: <20231128220802.jnila3ztpphs244v@moria.home.lan>
References: <F9E55704-6BF2-4ABD-9DB6-62D908EB97DC@meta.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F9E55704-6BF2-4ABD-9DB6-62D908EB97DC@meta.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 10:04:02PM +0000, Nick Terrell wrote:
> Hi Kent,
> 
> I see in the bcachefs compression code this comment [0]:
> 
> 	Additionally, the ZSTD code seems to have a bug where it will
> 	write just past the end of the buffer - so subtract a fudge
> 	factor (7 bytes) from the dst buffer size to account for
> 	that.
> 
> This is very unexpected, as zstd is extensively fuzzed for these types of bugs.
> It doesn’t look like bcachefs is using zstd in a way that would trigger a unique
> code path, so my first suspicion is that there is a bug in the way that bcachefs
> is calling zstd.
> 
> I spent some time trying to reproduce the issue by calling zstd in the same way
> that bcachefs called zstd when the workaround was landed, but so far haven’t
> been successful in triggering the bug.
> 
> If you can provide a reproducer, I will look into the issue further. If you can
> provide the input data, the size of the output buffer used, and the parameters
> used (or the level & estimated source size used to derive the parameters), I
> will definitely be able to debug the issue, and get it fixed if it is a problem with
> zstd.

Which bug? the write past end of buffer, or the -ENOMEM?
