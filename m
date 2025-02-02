Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094301DDC3E;
	Sun,  2 Feb 2025 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738534298; cv=none; b=Ga+6IJoDdEGCGEu4fx4TIExmtRHJlVXe06Tbgs9z97/fyfyJCWeq74DBGB310J0eORYDEKXiEGrhDN70ViwaQpUN5cdniKnDNLX5wZUhr3OQ1JduLPyQQiSdHUk7CXPr4HW+c8y196Z0d6sktn5mMirRvmkgKZyNjtPJLZLxhA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738534298; c=relaxed/simple;
	bh=kWncMzN09JqbOCThf3B8FG7pCzH/jIkLNU8ET9Vf4TE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktpSECcuaF7jUZ2k9WyMGHmOnDR/zU0lRAvjY2nUjfmVMFYk6IGtxn/VlvPFbHgLjrTkVKV6daUN2sHnKKqYT5uzVgUt/pVHhERkPdC/4bDctGQQumw+yLm5JhKj9FSKd9bhWSdxW9KJTxyPnd8S3JTGrDtpxUorKv5/0mVaO0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KX5ZPOEo; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KX5ZPOEo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mTlTgYc6k9e1xlBVdWd6+0NDHrUmr3AONkRHg7X+qFM=; b=KX5ZPOEo6WWJ94Hkhxef0B3X2L
	8E2+4QuC0GVx5I1RmMlP6qnZi3GSZ+wrycDwBMb0TUsyfq5i7vFRWJ2d+IK8U6R2OS1xWIEW/1Q5e
	AvhoERVbOf2tFR/Bn3/TNkQU1VuU44uvhOCxoN4MNTTSPPOumsdU1dFf4iocQcaOn2I8YFtHJj0ER
	XyXWuS7/wVewq8aIt/mKMY41oatnNn7qY+2/IS796sBI2yxShQOvLS+XgXsplLAFn8h6sn92bd72g
	c147lTMjD5jnv3DfPLufnd3KOq9mmg09AhaPwzUIRsYovToOdHi2eN7+CR/S96+KqdNYSqfa8h/Rf
	joIyKcwA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1teiBg-0000000HXyC-2g6x;
	Sun, 02 Feb 2025 22:11:32 +0000
Date: Sun, 2 Feb 2025 22:11:32 +0000
From: Matthew Wilcox <willy@infradead.org>
To: syzbot <syzbot+a0ae55e3dde11d2d790c@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] [bcachefs?] UBSAN: shift-out-of-bounds in
 filemap_get_entry
Message-ID: <Z5_tlJZcIfANfmnV@casper.infradead.org>
References: <679fb148.050a0220.d7c5a.0074.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <679fb148.050a0220.d7c5a.0074.GAE@google.com>

On Sun, Feb 02, 2025 at 09:54:16AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    69e858e0b8b2 Merge tag 'uml-for-linus-6.14-rc1' of git://g..
> 
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in lib/xarray.c:147:16
> shift exponent 192 is too large for 64-bit type 'unsigned long'
> CPU: 0 UID: 0 PID: 2666 Comm: kworker/u4:9 Not tainted 6.13.0-syzkaller-09760-g69e858e0b8b2 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Workqueue: loop0 loop_rootcg_workfn
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  ubsan_epilogue lib/ubsan.c:231 [inline]
>  __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
>  get_offset lib/xarray.c:147 [inline]
>  xas_descend lib/xarray.c:207 [inline]
>  xas_load+0x583/0x5c0 lib/xarray.c:246
>  filemap_get_entry+0x1f0/0x3b0 mm/filemap.c:1860

This is an xarray issue.  I suspect it's a race condition, although it
could be somebody doing a misplaced DMA or something.  How easy is it to
reproduce?

(nb: I am on holiday for the next week, so I'm not going to be focused
on this, I just don't want other people wasting their time looking for a
bug somewhere that it isn't)
