Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B32928694
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 21:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705700278; cv=none; b=VIa2VH4JLobfXMUGWtBC7t4z374qeZGKzA17Z/MUKkISjfiYyd6hl3vbZFhrsi2gJKiSkM1rBzBJRO9jczwxtAEZ7qaI+8NlnWdqWdIRmFoYryaUDCsushqGu1VSgJLzx4UCx2pXGvpjzBOHMgLUyprheOkN9kiwWVOVLqWPfAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705700278; c=relaxed/simple;
	bh=LYR/8pO9B/EwsT7tLSbksV4tTD7gu6fr0vMf7s61+Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpWYl4UVV+VdRnvZG3dQMpA+xY/pBUu5I6G7HHVUemjf8mHeJQ0eQpZKmnTSmQi5cWhUtjh+/asStl1sY4aQAuHN9l2G5IR3MBPAWb62xddn5CVUiLFZLs6aIj26GAPnfyNIuNGA7DAnKLY5mjEtpPvv7vwzFNZd6+Nw9ODxBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gxJ5T4Bw; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gxJ5T4Bw"
Date: Fri, 19 Jan 2024 16:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705700274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yZ8mmWCTWo70F+Vvl3dTbBTdGKB5+EfUM/Xu5KMB1C0=;
	b=gxJ5T4BwB4UsBE9c8az8v99n3iDx57TZZdyu+iqOq72N4teSMbA/gxzRKY7nixjqaBKqSo
	gng5L5tZ9GAX++HGa8ZFqsoKbXsPA190WNAfimBeZdq1Qr4ACD+kGALk3G4j2SXN+nEQ5K
	9THSXtwK4zGI6jhtAxntql+j/zZhLM0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Trevor Gross <tmgross@umich.edu>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, 
	linux-bcachefs@vger.kernel.org, bfoster@redhat.com, Miguel Ojeda <ojeda@kernel.org>, 
	rust-for-linux@vger.kernel.org, Benno Lossin <benno.lossin@proton.me>
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
Message-ID: <gpokpnqgj6c2pcmtpiu46jy3kb3tom4xkp3fykg26zx6e3c2qe@zrnl2653qwsk>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop>
 <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
 <20240115191022.GC156208@fedora-laptop>
 <z7ajmttuzbvtxn4onwoxph6mevqt2rje2nga6cpux73geffias@p5kk7pqnswf6>
 <CALNs47t6qjYZeQKC+ahAaG6iNDGGNe8o+Q8tKhpRynYLWL3R8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALNs47t6qjYZeQKC+ahAaG6iNDGGNe8o+Q8tKhpRynYLWL3R8Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 19, 2024 at 01:05:17PM -0600, Trevor Gross wrote:
> On Mon, Jan 15, 2024 at 1:22 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Mon, Jan 15, 2024 at 12:10:22PM -0700, Thomas Bertschinger wrote:
> > > On Mon, Jan 15, 2024 at 01:45:22PM -0500, Kent Overstreet wrote:
> > > > On Mon, Jan 15, 2024 at 10:55:09AM -0700, Thomas Bertschinger wrote:
> > > > > I'm leaning towards keeping Make as the primary build tool for now and
> > > > > perhaps a future patch can move towards using Cargo. But other opinions
> > > > > are welcome.
> > > >
> > > > Let's hold off on that for now.
> > > >
> > > > I'm planning on pullling the Rust code in bch_bindgen into the kernel
> > > > soon, and I want to see how that interacts with the kernel build system.
> > > > If there's potential for commonality with the kernel build system, we
> > > > might want to take advantage of that.
> > > >
> > > > (Also, if you're interested in that project, let me know! Getting that
> > > > ready for the next merge window is a high priority item, but I have a
> > > > lot of high priority items at the moment... :)
> > >
> > > Sure, I would definitely be interested in helping out with that. I don't
> > > want to make any promises regarding timeline, since this combines two
> > > worlds--Rust, and Linux Kernel development--that are both still very
> > > new to me. But I can certainly give it an honest try :) as long as you,
> > > or someone else experienced, can help with any questions I might run
> > > into.
> >
> > Of course :)
> >
> > Join the IRC channel - irc.oftc.net#bcache, we've got quite a few people
> > acquainted with Rust there.
> >
> > The main thing that needs to be sorted out is that we require a patched
> > version of bindgen (since rustc can't yet handle types that are both
> > packed and aligned); we need to talk to the rust-for-linux people about
> > whether they'll be ok with switching the kernel to the patched bindgen
> > until we can get a proper fix into rustc.
> >
> 
> Do you have a link to the patches needed? We are wondering if this is
> something that could be upstreamed.

The current workaround is to just drop #[repr(align)] if the type is
both packed and aligned - but that leads to rustc and gcc disagreeing on
the memory layout of certain types; it only works as long as we're not
mutating types where this matters from rust code.
