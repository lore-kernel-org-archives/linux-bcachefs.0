Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1579143C49
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Jun 2024 21:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719352353; cv=none; b=M0cNWyX9JXib5C/UxTN5tCfw0TRE8MZsonAcCA3aPFW2q+R4ew7nbPgnQdfuEN2hMBxbCQsIJsK3rwqx5wdwWej31Hr+rpQrEamUj+woGRJXAS4N7BxFPTwxMXequk8jwXzw7mtTflFzZ+B+VQiXz24y22D/XAXAxIssEjUQC5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719352353; c=relaxed/simple;
	bh=SUCCAfjJbxB1fBIzgA3DbjmnKHuIJgVpCERu6tzl5+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxhCWDMEAsf7CkelA4uIeASW2wMzatq3eUB53S8adJMWLwu9gRWRhG+2230HiOTTBid4WSGA5g48nmdhCeudsZLZZd+brslSdOz10BvEMxfWRVPPWYTyHvkmLsxqTWX68sLq9ApVNWgwNDtZ5qDVUgWnSSD5lFEAXwWgaj3QQcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DN/fooTa; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DN/fooTa"
X-Envelope-To: peili.dev@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719352349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q9ySen9ODooOKtVmjb6drkNQAb9Lmhj/yj/CTshQASI=;
	b=DN/fooTaIzJS2qhQyQZN/K0cQILZVNwgg3snOpvO/NAgh3JQKchQz8//ocq3bg9DhUgGjl
	lphzgGSg7p3ihsDcxXdQprmMRiMR6d3Ln/Ik36OlMzkbaOON04sHtFemPgngUh5AhT+Cz0
	4IqgIWbcA1GP8aZUO+znv3jnCD/Xqkw=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: skhan@linuxfoundation.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
X-Envelope-To: syzbot+a2bc0e838efd7663f4d9@syzkaller.appspotmail.com
Date: Tue, 25 Jun 2024 17:52:24 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Pei Li <peili.dev@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com, 
	syzbot+a2bc0e838efd7663f4d9@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: slab-use-after-free Read in
 bch2_sb_errors_from_cpu
Message-ID: <yylyynqrcvpx2wptnstqo3v7fqizxakwjmbqivb5rwqfs3szub@hyjfokkufyol>
References: <20240625-bug2-v1-1-73f89535d3a0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625-bug2-v1-1-73f89535d3a0@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 25, 2024 at 01:04:59PM -0700, Pei Li wrote:
> Acquire fsck_error_counts_lock before accessing the critical section
> protected by this lock.
> 
> syzbot has tested the proposed patch and the reproducer did not trigger
> any issue.
> 
> Reported-by: syzbot+a2bc0e838efd7663f4d9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a2bc0e838efd7663f4d9
> Signed-off-by: Pei Li <peili.dev@gmail.com>
> ---
> Syzbot detected we are accessing free'd memory in
> bch2_sb_errors_from_cpu().
> 
> It is caused by race condition when another task is freeing the array
> protected by fsck_error_counts_lock.
> 
> This patch acquires fsck_error_counts_lock before accessing the entries
> and get the current number of elements in the array.
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Tested on:
> 
> commit:         55027e68 Merge tag 'input-for-v6.10-rc5' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1790a501980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b9ee98d841760c
> dashboard link: https://syzkaller.appspot.com/bug?extid=a2bc0e838efd7663f4d9
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=1272faae980000
> 
> Note: testing is done by a robot and is best-effort only.

Looks good - applied
