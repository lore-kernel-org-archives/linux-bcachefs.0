Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D6B1803D
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 17:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UtQ2h7Da"
Date: Mon, 15 Jan 2024 12:48:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705340911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBQTXI+Sdi6qBfKu0k6iv6C1b1UXYnkB1paMl6RLZmg=;
	b=UtQ2h7DaWX7lx2q9t4j2tplhaa/RZ7RtiXxYGqr8YRPNfnwdTdQxNf+aYGSn9mDPg3DyAB
	4RL3vtL4jpM0oIxH5Gq8vxc7ZY/uidoAlX5SZcKIDOm0SXoKJVY2HBO/XhK6oMrnaLB7Rx
	Yuf6BPguSJGtQzKN0GiH9gJoEWZTyBg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
Message-ID: <gmunf5rk52zg47zabt6i6635r7ddspvujq5bu2kirffwozjfm3@wj3ehlzwzuwc>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115052451.145611-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 14, 2024 at 10:24:49PM -0700, Thomas Bertschinger wrote:
> This converts the top-level main() of the bcachefs command line tool
> from C to Rust.
> 
> The first patch does all the work of implementing a new main(), updating
> the build process, and making things look for the executable in its new
> location which is now rust-src/target/release/bcachefs.
> 
> The second patch removes the Library crate from the Rust package. This
> was needed previously to allow the C program to link in the Rust
> functions, but that doesn't happen anymore.
> 
> It seems likely that a bcachefs-tools library will be needed in the
> future; for example see this request [1] on GitHub. This library will
> have a different external-focused API as opposed to the previous library
> that provided an internal API for the bcachefs tool itself. Considering
> Rust's structure of one library crate per package, removing the current
> library makes room for that requested library.
> 
> I tried to update everything to account for the new location of the
> bcachefs executable, but let me know if anyone sees something I missed.
> I could not figure out how this is set for the Debian package so it's
> possible I missed something there...
> 
> [1] https://github.com/koverstreet/bcachefs-tools/issues/188

We've got a new CI failure; it looks like perhaps the MSRV environment
variable isn't being set correctly in the test environment. Can you take
a look?

https://github.com/koverstreet/bcachefs-tools/actions/runs/7532280737/job/20502558560
