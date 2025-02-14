Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101911FC7CD;
	Fri, 14 Feb 2025 23:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739575440; cv=none; b=iloKkSAyZJNDE3y2/PlBsLAk/xRgR6moiubqSH1tqGeA6UbK0uh8dYQhkE795EOqX+F4B/V47lDKLSB7xDa4qy/dte8vKRduq6cqWmsSC4t9wSIAaGbLsyYpc0zhUyG/5+HHsIc5bKXWmbmpWeLM8u8pP/C1TvGsv2PSmUUqF9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739575440; c=relaxed/simple;
	bh=uquje65lfVNhxDBtd/M1YwLF3IonJ/j52ndMQeyZb24=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=E4jcxJuFfxVxVsshFC/DWLT/dDL/Y8Z6tNtDvQ1IjzjdkuYcb563i7a8uEol+UhD7EMK5Q/qYg10cQZmD1ovftUvr5f3qA8+VLN7lAUEHU8aMU09BSK4gpbjL90W8E+G46KhpLZZ2C+PZabLxriAAFAE3n8TjytZj3KAeGPkzHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=alx/7Ojb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="alx/7Ojb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC326C4CED1;
	Fri, 14 Feb 2025 23:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739575439;
	bh=uquje65lfVNhxDBtd/M1YwLF3IonJ/j52ndMQeyZb24=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=alx/7OjbaNmGlUA264DyNZMiRHm93hlXuKIe+/0b1bVi8Js149kmksxNbqN99ZB/9
	 gD1QVZpCJe4OtCFPl/xaHeKjAT5mgx5oPJbD/NWhF62euR7Nn3O/mP3lIgY9JS4MHN
	 3/uK9IevgprsBy/CJ6/gDa2CjmhTelEVM7cAU4N0=
Date: Fri, 14 Feb 2025 15:23:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com>
Cc: chengming.zhou@linux.dev, hannes@cmpxchg.org, kasong@tencent.com,
 kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 muchun.song@linux.dev, roman.gushchin@linux.dev, ryncsn@gmail.com,
 sashal@kernel.org, shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com,
 willy@infradead.org, yuzhao@google.com, zhengqi.arch@bytedance.com
Subject: Re: [syzbot] [mm?] [bcachefs?] WARNING in lock_list_lru_of_memcg
Message-Id: <20250214152358.7ba29d10229e2155c0899774@linux-foundation.org>
In-Reply-To: <67af8747.050a0220.21dd3.004c.GAE@google.com>
References: <675d01e9.050a0220.37aaf.00be.GAE@google.com>
	<67af8747.050a0220.21dd3.004c.GAE@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Feb 2025 10:11:19 -0800 syzbot <syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following issue on:

Thanks.  I doubt if bcachefs is implicated in this?

> HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of https://g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=148019a4580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
> dashboard link: https://syzkaller.appspot.com/bug?extid=38a0cbd267eff2d286ff
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12328bf8580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-128c8f96.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a97f78ac821e/vmlinux-128c8f96.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f451cf16fc9f/bzImage-128c8f96.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/a7da783f97cf/mount_3.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5459 at mm/list_lru.c:96 lock_list_lru_of_memcg+0x39e/0x4d0 mm/list_lru.c:96

	VM_WARN_ON(!css_is_dying(&memcg->css));

>
> ...
>
