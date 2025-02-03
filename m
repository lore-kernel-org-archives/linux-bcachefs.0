Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40F370809
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Feb 2025 04:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738557016; cv=none; b=TUBh+1XeDaSV1T67iphSf8SvKLSuBh+TGq1+DJCZum+yPzGvuQujvujCG5vIeIH69pkCXAOPCQa5IObgcG9sZS0fPNmgcyzDbW/t/+5fogmsby8D2NlQIqAOf4x9u5EyMw/jbNf7LCgTJ+o+cskFm9/To+Xb65K+OUg4uYeNC7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738557016; c=relaxed/simple;
	bh=ZkX2monZcAC75aVKIyTMj6Kv0Bf5wghcrOCsnwIJVA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Edb6jnVkYMH2yRJRD2+bKzQAiWAKlSdKDwSdQ1kmr5pewafB34M7o4ub+ssYJvJ5DuSzjMur7kNQg8q8gtKnsEXcXq+iMK2wac/xSc4Hitac0p0yaVNxrwt0d9eHGTyrKvW8ox34gRo7++v0c4Q+0BhYQ3nKEP+L3bSe51QmJ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QwPWyA8A; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QwPWyA8A"
Date: Sun, 2 Feb 2025 23:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738557005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LSek/aw1RhbQazdMucH99fMhafUeVbuXI/DmPJuxos8=;
	b=QwPWyA8Aa3ZDAulTtrwivT2Ijv0b1E6Yo44peGm6CwTZtLO+roBh/zYf4Tt4vdQ57MfD9U
	j0MIjvrO2vAzLsS3jstUq6KLCHKeIqfpTpsyLT5gxkWLGg7WvHWK7U5akr9BpkIy4iBEoE
	Tr7Gqb5qCXv1kpT1YeTfIgstgy+psj0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: syzbot <syzbot+a0ae55e3dde11d2d790c@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, hughd@google.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] [bcachefs?] UBSAN: shift-out-of-bounds in
 filemap_get_entry
Message-ID: <x7nvluwr6yz3liezjpgry3db6jehus4inkcoesmrltya2eq7gy@gcr5ekmthdwd>
References: <679fb148.050a0220.d7c5a.0074.GAE@google.com>
 <Z5_tlJZcIfANfmnV@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5_tlJZcIfANfmnV@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 02, 2025 at 10:11:32PM +0000, Matthew Wilcox wrote:
> On Sun, Feb 02, 2025 at 09:54:16AM -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    69e858e0b8b2 Merge tag 'uml-for-linus-6.14-rc1' of git://g..
> > 
> > ------------[ cut here ]------------
> > UBSAN: shift-out-of-bounds in lib/xarray.c:147:16
> > shift exponent 192 is too large for 64-bit type 'unsigned long'
> > CPU: 0 UID: 0 PID: 2666 Comm: kworker/u4:9 Not tainted 6.13.0-syzkaller-09760-g69e858e0b8b2 #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > Workqueue: loop0 loop_rootcg_workfn
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> >  ubsan_epilogue lib/ubsan.c:231 [inline]
> >  __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
> >  get_offset lib/xarray.c:147 [inline]
> >  xas_descend lib/xarray.c:207 [inline]
> >  xas_load+0x583/0x5c0 lib/xarray.c:246
> >  filemap_get_entry+0x1f0/0x3b0 mm/filemap.c:1860
> 
> This is an xarray issue.  I suspect it's a race condition, although it
> could be somebody doing a misplaced DMA or something.  How easy is it to
> reproduce?
> 
> (nb: I am on holiday for the next week, so I'm not going to be focused
> on this, I just don't want other people wasting their time looking for a
> bug somewhere that it isn't)

It's got a C reproducer, and you already use ktest, so

build-test-kernel run -IP ~/ktest/tests/syzbot-repro.ktest a0ae55e3dde11d2d790c

(it's the extid from the dashboard link)

If that doesn't work ping me and the syzbot folks, there are some
improvements that could be made and I'm going to need them anyways since
I have a ton of syzbot bugs to start cranking through soon.
