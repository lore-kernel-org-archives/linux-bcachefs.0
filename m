Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A2A1802F
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MtH70f6H"
Date: Mon, 15 Jan 2024 12:32:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705339946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBcqMzDODhXAHoOyB9tIwwVocQW9n7c24sgSfHLLm0Y=;
	b=MtH70f6HhMR0+0zRuivsbx16GugpoUMZMJHZDvsm5s0tndxti2Uyz2di+BuPJ7Ok4Sc+bV
	SHlMClADkONyfXzuD4tNLLcqpjpIIK3frnI2hhb1SPgVV4VIfHBCGFvDj0367yYMoZJ5uD
	0lIv2tkNaaw6X2ii7sNuX+x5ms8NtQQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
Message-ID: <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
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

Nice work :)

I think there's some more rearraging we could do - it'd be cleaner if we
moved the C sources out of the top level directory, perhaps to c_src,
and then moved everything in rust-src/ to the toplevel.

Top level directory is getting a bit crowded, and then the new bcachefs
binary won't be quite so out of the way; I frequently build and run
without installing when I'm debugging.
