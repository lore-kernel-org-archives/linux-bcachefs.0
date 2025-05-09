Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9989D4B1E5D
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 May 2025 11:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746791165; cv=none; b=k2kZZSKwEN3bgX2jBK13EhhcxSXCzeFypTpdT+aDf5gE0BBigWgetsM89ImnmTe9OSD2qcCU8QPqhtMSufZh5Dee9pbUhdP3UfBc4njsI4Y3AFNP/I0+EAyLLcYvd9dqAN14KPoDLWckRK3Dr8f8LjkPLbdUrEkM/aERoPy7ibI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746791165; c=relaxed/simple;
	bh=CJzrH6ju8yp+ugu249WDLTxhqHJhhqxodVFJeINsAd0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nxm1qJScUHGeZ3GQc+XD1oRPDxenvmluGvRf7mC9X3xMZTfcwdLwNxerQ8jCa86OjKodTktl7u+dQG/LPq/zpyzYFel6Ay+8kVkQgeRScISbhnJrPTfvIK8c/Tj960mGBfJmaN/T1qpvYW2dpMFc47Muj05OVjl3Lrn37T5xA40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d922570570so23643295ab.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 09 May 2025 04:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746791162; x=1747395962;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=05HVGIk+v9zX6nTdbO/Nmu/sJr2wsL1zhuQLEm963g0=;
        b=RJ3EvRCAXKyrFCYPvGgb/b9HP2XP9PE6cnJ0UDZIRhShaj3LBvCcuLLXVq0H+LrDKj
         vc7AtC1s2wtas4IVqYljbNKhDDJFkbngMOJD5EG0EG2C3E+hiVsU5rhGAO/B1X0+cg0y
         rQd3vGw3k+sEC3mT145v8vwi7QT0z8TbyzYyohG8Al5ZnoAmB7b+r3W5yxiwNaSmyIq7
         ZnZm8RxlgR8EZLpE9CJzy1gAT5HU8fMb/eBGZYHnPDWd+pCffshNwEPJ9pHBU//5zVY2
         H40QcAa8fqGnnl6tfVUtcoIx2r8K003a1QCABSIsh+lDAcVBj1cFVs2iYwbY9A/0q/LV
         gHZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVG22XH32MWB8NLObqj3ckzHr10tfyxDD39h4mFdEMkNzpHOWcdR9LMFtH6r1yvDQB7sUEnuSwpsziOMubMFg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEKKeIzYSXOCVdNaP7I8x60Sa2P0sS0ojF+GDCSHMdCu8cx19Q
	7E9a1zBvH/H5IB0NYLQTy4i4wQO6vvABftm24boXn/R4YLJ9EStEm9jDxvsw+foxNUubohwmqBF
	ohJua3vu6bwS4XNETliRNah1uQhTR7ifpAzAHYaeeUZFZuc/covxj4E8=
X-Google-Smtp-Source: AGHT+IHgQ297aSznzBoXurVc4ahrJUr9qjBunxOwM+QaDAAumBGhyzPzXFQThUARwVKDxuJmE9RWQu/dU0y4NjzxiJOycTGkAu+V
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2a:b0:3d6:d162:be12 with SMTP id
 e9e14a558f8ab-3da7e213504mr41483895ab.21.1746791162743; Fri, 09 May 2025
 04:46:02 -0700 (PDT)
Date: Fri, 09 May 2025 04:46:02 -0700
In-Reply-To: <66f01abe.050a0220.3195df.009d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <681deafa.050a0220.a19a9.012e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_fs_release
From: syzbot <syzbot+08d08d52c3a09bfc70f7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 04e90891be26a240e41d51d1770de56e810fda5e
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Mar 20 15:41:07 2025 +0000

    bcachefs: Run bch2_check_dirent_target() at lookup time

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=115ed8f4580000
start commit:   a7f2e10ecd8f Merge tag 'hwmon-fixes-for-v6.14-rc8/6.14' of..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=620facf12ff15d10
dashboard link: https://syzkaller.appspot.com/bug?extid=08d08d52c3a09bfc70f7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d11e98580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114b1004580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Run bch2_check_dirent_target() at lookup time

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
