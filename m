Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A98D1DF73C
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Mar 2025 21:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741471153; cv=none; b=S9U5ALV4ZNttDlQoG+mSmGEYiR5Z3YcEXTGijrhYh5QsCraket37c1bEBU/ExdpSU7O6aSilomb7/4oIo7qjwMQ1W3jeVJEZuY0ynq5cLqZYEv7N5kCqaCBqQ8fPEN27bPC8RxRON9hDawkVFQm8L6vG55SK+yB23np4+CwX1dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741471153; c=relaxed/simple;
	bh=p86EgVLWBe8WTppLDti2AJM2Jw1wFafEgiZOs169sE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2+FtQfQpnb6v69AtKTob5Cz2N3EftmbjIj8wWpj1EO/+vLMHbpTllY4t/aptYuqf66bmCI/wf/tZNW/hYUOdS8QWmIyiqpVsoSOI1dWdOcz7Pueddxbze19WQQ+wbTE8t1W/JFaF+1hpF0V+6iBAcnm3XGTlQ79O7imW6rRQdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vWK9xA8I; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vWK9xA8I"
Date: Sat, 8 Mar 2025 16:58:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741471137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Au7fJ9XgM21AaQJVoKb8P3+31pAT4gKK4Tj3RdgQ0uk=;
	b=vWK9xA8IZX7bBOLGG76yt6cBd9DGDYg4PLo+q/15kzkwmKGxtLHxZyDhmfF1m12pKCcOGV
	zSnbcQ0QtlDDEepRUTQCgqinXfP7PSiJKqPNgwMzmZ106bsiGd+8q9e1kLZGaJi9EgMxfJ
	vRH/svthsoc4nxJWNEWHgkJZ/or+TVU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Hector Martin <marcan@marcan.st>, 
	syzbot <syzbot+4364ec1693041cad20de@syzkaller.appspotmail.com>, broonie@kernel.org, joel.granados@kernel.org, kees@kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] general protection fault in proc_sys_compare
Message-ID: <wkn3delpogj7ay7irqjemviubsnvnnd72yaywqr4ibtbfjxfif@efp5mfvixwp5>
References: <67ca5dd0.050a0220.15b4b9.0076.GAE@google.com>
 <239cbc8a-9886-4ebc-865c-762bb807276c@marcan.st>
 <ph6whomevsnlsndjuewjxaxi6ngezbnlmv2hmutlygrdu37k3w@k57yfx76ptih>
 <20250307133126.GA8837@mit.edu>
 <a5avbx7c6pilz4bnp3iv7ivuxtth7udo6ypepemhumsxvuawrw@qa7kec5sxyhp>
 <20250308215305.GB69932@mit.edu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308215305.GB69932@mit.edu>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 08, 2025 at 04:53:05PM -0500, Theodore Ts'o wrote:
> On Fri, Mar 07, 2025 at 09:33:11AM -0500, Kent Overstreet wrote:
> >
> > > Maybe this is something Syzbot could implement?
> > 
> > Wouldn't it be better to have it in 'git bisect'?
> 
> "Git bisect" is the wrong layer of abstraction.  It doesn't know
> anything about (a) how build the software package (which might not be
> the kernel, remember), nor how to run a test, nor how to tell whether
> a test run was successful or a failure.

Eh?

It has a mode for automatic bisections, you just give it a test that
runs pass/fail.

This works with my ktest, which runs tests in a VM and in non
interactive gives you that pass/fail in the exit code - I've used it
that way before.

> > If only we had interns and grad students for this sort of thing :)
> 
> The lightweight test manager (ltm) for gce-xfstests was implemented by
> an intern.  And the kernel compilation service (kcs), git branch
> watcher, and git bisection engine for gce-xfstests was done by a group
> of undergraduates at a unversity in Boston as part of a software
> engineering class project.
> 
> Mentoring interns and undergraduates was incredibly fulfilling, and I
> very much enjoyed the experience.  I'd like to think I helped them to
> become better software engineers.  However, mentoring students takes a
> significant amount of time, and on net, it's not clear it was a win
> from a personal time ROI perspective.
> 
> We did manage to recruit the intern to become a SWE at Google after he
> graduated, so that was definitely considered a win from my company's
> perspective.  :-)

Cool :)
