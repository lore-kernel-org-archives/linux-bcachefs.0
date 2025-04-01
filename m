Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22B03FC7
	for <linux-bcachefs@vger.kernel.org>; Tue,  1 Apr 2025 00:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743467592; cv=none; b=SN7dEwrocAKl4SULZBi69miQAm1gbRysy9WuNLANctuMHYXKN6FgrcXQNHrVg+mq57RccDjgZeyq2z31XQyBnAiAhv1IGIPs9IlKnI3jcdbt7k23XLGOZfPldJc3pfuWvWLAFeQlp9ZBXbixJ6OvwVjob1qQkqSPTiXCRFFVqwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743467592; c=relaxed/simple;
	bh=p3vZ9KKLpnfcTvpmwOOhUM2jt0vTny2fs1IIi/CJ92Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJ4i9PufEC6/D/gRM91byn/lz0Zr1qO+rBtwcN7mPq8NJhi4OGMD2pL92Zptm+I38HPJLNDZHTPJri2ThdBCjGDzitSx7qHoyBsyG3d/TQuVJf9cM9fTaE26isUOfx0AGuxcmIQvd5VWPpp0kHoptz6X5NutCAPhA2rLB9uPKvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X98JxaEr; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X98JxaEr"
Date: Mon, 31 Mar 2025 20:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743467586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9eBIY6XHSvfjH5+2PCi+OedpVJYSZL0eQcjG/yMAZY=;
	b=X98JxaEr59WNI03IrC2yAMywpm//lLU9T1+GjEjdu7aGnwL9IjtWDbCo1yZJpyCkE92MIh
	FSzkYEiS14tGNcuMQfsRJfwzFBJT4Ei2Y/Trk8pjLgqylmOpOqDZrPK4lep9dS5OXHb058
	xdzzOzLqw2nBIXuFjN4B6EjFI9CTo0k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas =?utf-8?Q?M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/2] bcachefs-tools: get most of CI to pass again
Message-ID: <s5sfaasrww3yptjsay4nauw7iqsyyauybhvvfqwvclantgxecr@fzeslnaeb25r>
References: <20250331234744.428142-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250331234744.428142-1-tmuehlbacher@posteo.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 31, 2025 at 11:47:42PM +0000, Thomas Mühlbacher wrote:
> Ok, so I have now tried to minimize the patch from the last patch set to
> at least have most of the CI (except for i686 builds) pass.
> 
> I threw out the pedantic automatic clippy fixes, so the `Bpos`
> instantiation change from before is gone. I am pretty sure that wouldn't
> have changed anything about the binary layout of that structure, though.

Err, do we actually have different types for Bpos on the C and Rust
side? Bpos and bpos? I may have to look over that code - I was concerned
about the potential for a bug there

> 
> I know you don't like formatting commits and I wish they wouldn't pick
> up anything except for what I changed. However, since `clippy --fix`
> doesn't format itself, I previously had that in there as part of a
> commit that only includes tool-generated changes.

I see :/

How much of a chore will it be to keep up with manually formatting
clippy fixes?

> 
> I also now just avoid the ugly transmute annotations and just suppress
> the lint instead for that function. This also requires changing the MSRV
> CI check, because that lint did not yet exist for the MSRV Rust version.
> 
> Thomas Mühlbacher (2):
>   fix(nix): allow msrv test to have warnings
>   refactor: make bch_bindgen pass clippy
> 
>  bch_bindgen/src/bcachefs.rs |  5 +++++
>  bch_bindgen/src/bkey.rs     |  3 ++-
>  bch_bindgen/src/btree.rs    | 25 +++++++++++++------------
>  bch_bindgen/src/fs.rs       |  2 +-
>  bch_bindgen/src/lib.rs      | 19 ++++++-------------
>  flake.nix                   |  2 +-
>  6 files changed, 28 insertions(+), 28 deletions(-)
> 
> -- 
> 2.48.1
> 
