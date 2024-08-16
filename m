Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173911BE85F
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 16:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723826739; cv=none; b=AJByTGY+sANPXiMyFBMVZhmT+WXkaRb0ct5cpwhrVtmLBGMktUY6wo0gVbwxqh/FRB+MUfdqiv4Df+ufUNKUmlQ2SsBtQXdIu5f2JI0Np8V0UPew0n6NvM0VBPrZ31kL3GW4V/No8+SpXdiYY7athS308wgLGihmNm/2X67mjXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723826739; c=relaxed/simple;
	bh=yWT2HWDpE1AXjMnZlD/P4LoksIybv/KhU4Q3WE06bj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TsCEe0tdYVH1obj5pi1nSBS4ZzCtdeIuD+qSsMgz7+n+ogs3MGEHxbwYCaSiEVzSuf0EAfMjoaNN4e3H1kL90y3H5xK21T85QsG0+eF/i9etcp+fMBeQPEB7pctbOmPakROLdA/OncIBkVuK2tdRTYJCwfZn6AqoC7aDCQZ03Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oj0Wq8Fj; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oj0Wq8Fj"
Date: Fri, 16 Aug 2024 12:45:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723826735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nt4uXNF14Foh/MiOwim0/r4EomYcBUZg9s50uUCaq40=;
	b=oj0Wq8Fj8IYZrOnTmEFAoIjF4QvqWDT9WpylAOMvZShB+DhHvkQYrHnGaohsB4ZWOLRY4s
	yotOll0M36EC1XD9qnvOtFcZ6Dlx41AeMOiZk0N0SEBFWtIx3k8eLmSJs40PfB5LXCSXBX
	Cxy/zguhjPuIg52miR7JcRVf1nLQsB8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in discard_new_inode
Message-ID: <4rzqsege6o4chfyrldyghjytgl5kxt24zw33ilglcyxixlgpvi@dabfrcbbbptd>
References: <0000000000005bb657061fc9e31e@google.com>
 <ho6vtmwtscjszkoceusnf6rff72svhtbj6kbbqupl76dkvpybv@zmjaeybnmqsw>
 <CANp29Y6S=qD8-j869gHcNYM3ArXs03BxYBEB0c=Zb9mJvDGCCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y6S=qD8-j869gHcNYM3ArXs03BxYBEB0c=Zb9mJvDGCCA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 16, 2024 at 06:43:38PM GMT, Aleksandr Nogikh wrote:
> On Fri, Aug 16, 2024 at 6:30 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Aug 16, 2024 at 02:50:23AM GMT, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    d7a5aa4b3c00 Merge tag 'perf-tools-fixes-for-v6.11-2024-08..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=131e27c5980000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=95e40eae71609e40d851
> > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150be3c5980000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165c93cb980000
> > >
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d7a5aa4b.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/af15738cca6c/vmlinux-d7a5aa4b.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/62dacb1384ee/bzImage-d7a5aa4b.xz
> > > mounted in repro: https://storage.googleapis.com/syzbot-assets/92de1b01cc1a/mount_0.gz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+95e40eae71609e40d851@syzkaller.appspotmail.com
> > >
> > > R13: 00007f7d2a233210 R14: 0000000000000001 R15: 0032656c69662f2e
> > >  </TASK>
> >
> > Dmitry, this bug has been fixed upstream, and I've been seeing others
> > where syzbot appears to be generating reports for bugs that have been
> > fixed (e.g. BUG() in bch2_fs_journal_stop() long after that was changed
> > to a warning).
> >
> > I don't know what's going on, but the report appears to be in error.
> 
> Did those fixes already reach the latest torvalds?
> I've just tried to run the C reproducer from the report on
> d7a5aa4b3c00 several times and it eventually did crash the kernel.
> 
> [   42.746251][ T5239] ------------[ cut here ]------------
> [   42.747210][ T5239] WARNING: CPU: 0 PID: 5239 at fs/inode.c:1143
> discard_new_inode+0x217/0x2a0
> [   42.748401][ T5239] Modules linked in:
> [   42.748948][ T5239] CPU: 0 UID: 0 PID: 5239 Comm: repro Not tainted
> 6.11.0-rc3-syzkaller-00156-gd7a5aa4b3c00 #0
> [   42.750331][ T5239] Hardware name: QEMU Standard PC (Q35 + ICH9,
> 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   42.751806][ T5239] RIP: 0010:discard_new_inode+0x217/0x2a0

found it, i_state != i_flags - sorry to bother you guys :)
