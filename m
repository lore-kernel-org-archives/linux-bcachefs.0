Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD679D8
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 02:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aeG9+LZq"
Date: Sun, 7 Jan 2024 21:37:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704681476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DuzC/7gYJE1184wKyl7zgjY1jXiPE9/xyf2uxUPgnJk=;
	b=aeG9+LZqxoFWP9GUxSLlSKDlU6VGpiElDDwkk/GRk20+ZlhHCEc43UAY91C9AKJSjacVBk
	22nG3Py3XS8PVwD6Ylxcw8lNnbAGu0JMXOEJeOz6nrF10wD22ZRc0bxjwkmAZ1Bur+SRL0
	z0opx1XbXRWVYKy6ZejhrEUvKKcWFGc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS] create common entry point for Rust commands
Message-ID: <haijgauamlu7pn2rrvjtk4hpskxxjjezrdzo5wtuvre3aihm4i@ncqgo4t2rilc>
References: <20240108013633.119160-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108013633.119160-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 07, 2024 at 06:36:33PM -0700, Thomas Bertschinger wrote:
> The bcachefs sub-commands that are implemented in Rust (completions,
> list, and mount) had separate entrypoints and thus had some differences
> in behavior.
> 
> This introduces a common entry point for the Rust sub-commands. This
> reduces duplicate boilerplate code like parsing argv and setting up
> logging, and will facilitate converting more sub-commands to Rust in
> the future.
> 
> An immediate benefit is that this fixes an issue with `bcachefs list`
> not reporting errors:
> 
> before:
> 
> $ bcachefs list /dev/typo
> $ echo $?
> 0
> 
> after:
> 
> $ bcachefs list /dev/typo
> ERROR - bcachefs_rust::cmd_list: Fatal error: "No such file or directory"
> $ echo $?
> 1

Applying this

If you feel like going the extra mile, maybe we could convert the top
level main() to Rust, that'd further improve our helptext...
