Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17572168A2
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jan 2024 20:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BP8P2gVZ"
Date: Fri, 12 Jan 2024 15:03:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705089822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cZvfhh2FKJuDhc8TVoY8YmtXbEywMhrygFeox1FhJtA=;
	b=BP8P2gVZyYgAfPCit6RcNlSJmZLNAplb+BmfvZtu490mdsi8OTQ4WRsdN7V5aXihrOJ3JE
	Q4YTOzLT/EeMaSqaWvBL8TZ1y7xlIzeRRpw77W4sDqtNzPOv+uhKlVNG3Ka4JricNO/bx6
	hlMNu2jRvGnRRdCgTPV05i5BqqrPlkQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS] fix invalid write in pop_cmd()
Message-ID: <ozo2qrwys2dciao53rujt4rduzzkgydxu6irsgvr2ryecxfo74@zelohtemex4i>
References: <20240112065730.261392-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112065730.261392-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 11, 2024 at 11:57:29PM -0700, Thomas Bertschinger wrote:
> The memmove() in pop_cmd() reads and writes beyond the end of argv.
> 
> This is basically harmless in the current C program; the environment
> variable list immediately follows argv so all this does is unnecessarily
> copy the beginning of that list.
> 
> However, this will become problematic once we start calling C functions
> like fs_cmds() from Rust code. Then argv will be a Vec<String> (as
> *mut *mut i8) and the memory layout will be different--in particular,
> I don't think we can assume that a Vec<String> will be NULL-terminated
> like argv always is--, meaning the invalid write could lead to heap
> corruption.
> 
> Also, it doesn't look like full_cmd ever gets used after calling
> pop_cmd() so I'm removing it here since it looks unneeded to me.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Thanks - applied
