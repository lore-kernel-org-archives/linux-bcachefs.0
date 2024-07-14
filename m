Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F32F2572
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720988477; cv=none; b=s7DiQy/nKN1lrNqXP+M2zVr/nEChAZiwbu74IW3mzfoL8TdZaJT0x9mymn9Wjn1h8oVxlUpzn+ig33qEVVa4+yzczghvwKtI76yIaQUgJo24c8BoJNOHjRKQWXFOWbcMlGr6C98917/19BtCBFtzTpUxrc9sfAgZffWG0rRYcX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720988477; c=relaxed/simple;
	bh=+46Fgj58mRtxOJhb3pkNWfNmU+69QQENK5RELG0A/zI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdAEo0gTFaUmd+pseba++4BM3lOuJbJTKMAepNaP4pEGn6N9EA5aZJmDZDnDfZ4l07hyd1J6ERaxUESfWqUKjRiOXKmjU5URVsVP5kcecWHlreWqrADpkwyN5SeJQ8iXyH/YFCEtXWFSZnNLO150Iy9zryiX2I8EnGm6oHQnBpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EWHnDNx1; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EWHnDNx1"
X-Envelope-To: tahbertschinger@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720988474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z57iehHsT2YT9LsoTXtMW/mGtrvYdThMbID2Q81CZ6k=;
	b=EWHnDNx1uJgybYEH7/SC7MD7gkc5u9pyTz1ebTbmv5QIXBlMfW6our8LO9ItOVF7BiVHGK
	xHviak7cKxjDHRwi5u9DcKVifxTAgu7WXRc42b2o+mdW7zd63Bh6ZOJvJBblsfZK3x43JY
	Ex7d+CQiCbrVSUNNzTZFGJ6VWMqiZHc=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: bfoster@redhat.com
Date: Sun, 14 Jul 2024 16:21:13 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS v2 0/5] new debug command
Message-ID: <q5lo3qxwyeha3lmpnpw53sx3taoy7scgjioyxhyyl62kyjy22m@guykwory2rdq>
References: <20240714200226.746471-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240714200226.746471-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jul 14, 2024 at 02:02:21PM GMT, Thomas Bertschinger wrote:
> This introduces a new command, "debug", to the bcachefs tool.

Background: this is what will let us do comprehensive error injection on
our on disk images and rigorously test our repair paths.

Thanks Thomas!

> 
> Changes in v2:
> - minor fixups
> - added "field+=value" to increment a field's value, in addition to
>   "field=value"
> 
> Thomas Bertschinger (5):
>   include debuginfo in bcachefs binary by default
>   update minimum Rust version to 1.74.0
>   introduce "list_bkeys" command
>   introduce "debug" command and "dump" subcommand
>   introduce new "debug update" command
> 
>  Cargo.lock                       | 374 ++++++++++++++++++++++---------
>  Cargo.toml                       |   9 +-
>  c_src/bcachefs.c                 |   4 +-
>  c_src/cmd_debug.c                | 145 ++++++++++++
>  c_src/cmds.h                     |  18 ++
>  src/bcachefs.rs                  |   5 +-
>  src/commands/debug/bkey_types.rs | 340 ++++++++++++++++++++++++++++
>  src/commands/debug/mod.rs        | 173 ++++++++++++++
>  src/commands/debug/parser.rs     | 105 +++++++++
>  src/commands/mod.rs              |   3 +
>  10 files changed, 1061 insertions(+), 115 deletions(-)
>  create mode 100644 c_src/cmd_debug.c
>  create mode 100644 src/commands/debug/bkey_types.rs
>  create mode 100644 src/commands/debug/mod.rs
>  create mode 100644 src/commands/debug/parser.rs
> 
> --
> 2.45.2
> 
