Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14721EE7B7
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Apr 2025 17:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744306678; cv=none; b=N2YtqkbJZwbllnwoIlu3BTOE+R7ptZLekp2pyj8RfoUHLG1FCaLAD0+S9KBz2en5Rh/hzGc+qcu6qguSMw3QxkNc1Thv6/WFAvDnBMpcFQBXEMitly4iwizaN1NndELPw0w4oV4S3i4ksWLK2trNCkzG2RMcD9RPy7yyhm5yKyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744306678; c=relaxed/simple;
	bh=KlYhjzoWMTJtzOi0EFNUW0qs9nKHXtzgjETzLPnhNRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNTBTBqd4CTK5V4SZNcN/9zqgQxu2Bt8RzGo2ZIFu+yETg+Uiizzi5qdAZkelkSdqZYzEtFx1xDehafG0FRlT2hZPnQkzLJbttqXIUBAfc/BsHB/BYfsVkIveHZUkDyY9Gb0RX5FepnmWXu2rzTzuyWHHoR13Qpt4Off6zlJVkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bjeyn0FY; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bjeyn0FY"
Date: Thu, 10 Apr 2025 13:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744306673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GxxXlL4Kr06wA5eFqcJuiKfCZO200YoQkEtN4MJSrvw=;
	b=bjeyn0FYj9qn1X6E7FHLxnpDbXLXfqOl7zQkEbwX1OIq/WsSanJ7oYqiN8Y0xKAdMHvDqb
	vYlRRt7lGLqKAqGiEhAvUPVTm+/rzxzcJmz2CFOiU+sOCe+TlFayvP/naQcDuUE/rXBBwF
	fyMooCKuDbliaKxPkkz5NX+R0JCjFkg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+86b24455266617775c21@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, luto@kernel.org, mingo@redhat.com, 
	mmpgouride@gmail.com, peterz@infradead.org, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Subject: Re: [syzbot] [bcachefs?] kernel BUG in qlist_free_all
Message-ID: <7s7255xojjbkgxwrzmfyfa7bqhhsuzdavta6uwag67nwztvpwv@sure7v6szaoy>
References: <674083af.050a0220.3c9d61.0190.GAE@google.com>
 <67f7ed5b.050a0220.355867.0006.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67f7ed5b.050a0220.355867.0006.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 10, 2025 at 09:10:03AM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 3a04334d6282d08fbdd6201e374db17d31927ba3
> Author: Alan Huang <mmpgouride@gmail.com>
> Date:   Fri Mar 7 16:58:27 2025 +0000
> 
>     bcachefs: Fix b->written overflow
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=102a9d78580000
> start commit:   69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
> dashboard link: https://syzkaller.appspot.com/bug?extid=86b24455266617775c21
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14034b24580000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
#syz fix: bcachefs: Fix b->written overflow
