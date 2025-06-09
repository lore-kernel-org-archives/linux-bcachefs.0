Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA53527FD40
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Jun 2025 03:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749439151; cv=none; b=TsXO+cPVUsHnaeM0nq9zQRDedkzbdTIxlDoNe+GD4Qv0CglgIgFpgjMMnGr8KrAw7shrlaZHzxqopmYk6sEbLQz4EeJa56bpITZj7UrAHmBU2mYzrEynsnaqfE53RaDuMMLE9FWa70jhIlvlY7B+soyDTVkcXuneTYAqHynalmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749439151; c=relaxed/simple;
	bh=AywIOjbbUcuQi1uyIa9Cl/kZJv4bwm/u8Gmf7oZaOV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rk21JWAiBEs+31q0LrNpgGhFUJ4VAI3pz8A14RqUrg0YNep4JqcYWkPDtrIrdeMIuMzD0zVZZBEj9X5juZhBk7ybJe8zGD/HpHOl1S8I9Q3c9+KEuRw3nmZNKyZYWXg2bNsi8MEDb7jjVs0vAdZzG+x6UPJbYRzx4BCM4U4hFA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B+DI9QXJ; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B+DI9QXJ"
Date: Sun, 8 Jun 2025 23:18:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749439137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YymDTXPcYia5YG7vkrdN3yPoUHlGdwfgqgPigiYUebU=;
	b=B+DI9QXJD0bgV7Fm47583f2cPC98J/ashGQRJzoPuOM+LFyxnM+3DxvjyMQAfZGsQGzS2o
	dF11yVWFL698u/yfCcf58nW1fLVQhhswCFmAEe8clc1GPHQsz9te6NxBJe9QmtmMiJXnJZ
	Z9Lr1V6j2TDm213urhUD6Qako2gdT1o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+e37a1730d63d207fe403@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, gregkh@linuxfoundation.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	tj@kernel.org
Subject: Re: [syzbot] [kernfs?] general protection fault in
 kernfs_dop_revalidate
Message-ID: <esjz6hewatxgaiqdluqf2sdorpybqxcwr4c77y2fozs6plj3yx@bkpt7rrtzdid>
References: <6745a8df.050a0220.1286eb.0015.GAE@google.com>
 <684650c6.050a0220.d8705.0018.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684650c6.050a0220.d8705.0018.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 08, 2025 at 08:11:02PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit f7643bc9749f270d487c32dc35b578575bf1adb0
> Author: Kent Overstreet <kent.overstreet@linux.dev>
> Date:   Wed Apr 17 05:26:02 2024 +0000
> 
>     bcachefs: make btree read errors silent during scan

syzbot bisections have been looking _very_ unreliable
