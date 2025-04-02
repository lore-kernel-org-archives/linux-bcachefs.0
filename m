Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA8B15575B
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 16:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743611920; cv=none; b=ihh5m3+U16E5c5rghzsPKYJv7TLlN98UUJCYJtocacnx44F+J9LLI3sYd7KJY/RLAXCiJNUMSSVeOX18yD0Ys+FCk5xQ4slYpRAaIGyblnGhLVBge3C0iMrG2RT2y763hW7Z3Sao1qenv8xhyQtjUTrnsOyiXm+arxufO0CwMQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743611920; c=relaxed/simple;
	bh=rgBha65hW5dtc03g876KusDpvr8NdK4C0yB4SGa0zfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBeIfllRJdEd1Ye9LhsO9piDsvP4UIuNX7PK284tsDmysaEfQEKeyOUdjPgR5T8hfjvu4bizBhyaJ9E5q4LJEwiUxMIAe1G/3ShG4VdZFaXXE3K/rV3DdTiphp5OHJXXQjQGvKHA76KN0gldi0dGCGJiSPl3yC/aN/kU57PT8hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VzZECpFV; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VzZECpFV"
Date: Wed, 2 Apr 2025 12:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743611917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1TjLropfZUyAcV9MBx+pByuu0YArP/C8m8u8knL0Q+o=;
	b=VzZECpFVwyNp9OGMzBuIGRi1/avOc1x9/MKr8NksUhdhSOaEfubgCslZxt3Bv2aERqzuMe
	0m9FLWJnPw0WXMn4Uxat0QBNQDWPfbAzhCT4B8L5QYF4V+7bPSLzLuOh8pFg7wEbOYrYWu
	2YiUkAgXxAMQbqUNDlsY+0BTDUxWjeI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: don't call sleeping funcs when handling
 inconsistency errors
Message-ID: <ciw5ocj6io5q5p2tsv3sqpga2ff73eqwhlrrug4el63ggolcho@iviprrqsaemj>
References: <20250402161043.161795-1-bharadwaj.raju777@gmail.com>
 <zjqewsg6ijvol3x3rdjfyjeji3wy24nw45yb6mkqj7vwsk7mrn@yxnvgpj4i24k>
 <CAPZ5DTEGi8RXBMui823bwnt96PcqZSavH8AQ+LPhRs=sJ-Br1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPZ5DTEGi8RXBMui823bwnt96PcqZSavH8AQ+LPhRs=sJ-Br1Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 02, 2025 at 10:03:10PM +0530, Bharadwaj Raju wrote:
> On Wed, Apr 2, 2025 at 9:47 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Wed, Apr 02, 2025 at 09:40:40PM +0530, Bharadwaj Raju wrote:
> > > In bch2_bkey_pick_read_device, we're in an RCU lock. So, we can't call
> > > any potentially-sleeping functions. However, we call bch2_dev_rcu,
> > > which calls bch2_fs_inconsistent in its error case. That then calls
> > > bch2_prt_print on a non-atomic printbuf, as well as uses the blocking
> > > variant of bch2_print_string_as_lines, both of which lead to calls to
> > > potentially-sleeping functions, namely krealloc with GFP_KERNEL
> > > and console_lock respectively.
> > >
> > > Give a nonzero atomic to the printbuf, and use the nonblocking variant
> > > of bch2_print_string_as_lines.
> >
> > Sorry, beat you to it :)
> >
> > You also missed the one the syzbot report actually hit -
> > bch2_inconsistent_error().
> 
> Oops, thank you.
> 
> If I'm not wrong, though, the bch2_print_string_as_lines
> still needs to be changed to bch2_print_string_as_lines_nonblocking?
> 
> In my testing that also produces the same BUG warning.
> 
> Should I make a patch for that?

Yeah, you're right - please do.

If you're feeling particularly adventurous - print_string_as_lines() is
a hack, I think we should be able to do something more robust by
skipping printk (that's where the 1k limit comes from) and calling
something lower level - that will require digging into the printk
codepath and finding lower level we can call.

I also just noticed that print_string_as_lines() needs to check for
being passed a NULL pointer - in case the printbuf memory allocation
fails. Want to get that one too?
