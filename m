Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D3C1DFD89
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Feb 2025 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739636524; cv=none; b=ZM00ZXYQjvzLpo2cAIBcat0NRc5DmCaPFk4laz0r731DqPKIlms4Tw/0eBZ4Q512mIYSxDC0gx0OqAC2d6o/u3a4qQ73WC5XBvBljP0JqkI3MZBaPwfjtxPj7G+n9zL4Uqc12z/uwqe+iOJf5aBUs0u2qvLqimUCG8cEP4FLBJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739636524; c=relaxed/simple;
	bh=IG/5jApV2sOSl8a3GEyu/nbUQiVzZuOltqY088VSr6s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nBlycaci+pguVUfvfO/nJqFI9GX/JQ3u+Yoh6z86UGlw5X+a14+LyN8vlW5q+FzX3aVtFLN5ClGNSeBap/AuPGPl86/CCdwh5PFV6AFvueGuLEtIpJGCK6w+/barziLf0ad/zoxkKFRHW39SQXD1kn00pJ6wpRXSLbjIlCjANcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d158477b5fso21444405ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Feb 2025 08:22:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739636521; x=1740241321;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0qTm4qCvLRYalG9z/HrHmtBGe5kHsJD0r/taF4MuuQ=;
        b=nDWSxCqjjlR60ispRX+oXMAWc99XUioznQcKxGG3aXAXslTuuBJqqfDwolvnLGB7FJ
         7qhACHDANBivCJMCS39yQ+gEszXdBfRCYk6d5FKY4JBL12YxIhx/S3+YzTb4pffXhUyu
         NFZOdD8EvxdWY7rv68jDT73EKaRMSn8wt01ADNEc5aSiy/QdFDGpFCdWsnybxhzVdy24
         bWzLBNLF4juBLHtOlM7VXb4HTKfJ33HgBSppgAKGRf7K0v1+b7b2AW2D/4Hu7iqBrhgO
         6FgSYq36Tu6B7+LRIjOyT59KWgZ3G4WaAX3oo9Dn99K6NSOZJZfmnuRtym5dtShxyj1s
         0Jbw==
X-Forwarded-Encrypted: i=1; AJvYcCU2PcGgkf+ri3V2W9/n7etBuUDvv8iy9b3H8NYwMqj4toDx6LpAduxCDjlnaMClgBRNEEK1V658SFeL8pxWvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnjMW0PJOBLU8nr90hxK20J6THOq4yWjQK+HUR+AxOROyZgB4Z
	huuQVYTLbTuT+YP419N05JTASki7hOQ7AgAG1aE2V56Q8/SNKQ+gl6DtRCzUAj2Z8lqWcKBL1hJ
	9ic+hToE3XLy3dw7eabLafJgEInky/s7dLEZQvaLf2/UZG5Ckf6gkpWw=
X-Google-Smtp-Source: AGHT+IHRq8GM6tfXpOlFN58zTXBcLQBL4mQaH5rBniMTJZY2Z7rN/MmFFcpQeaxnOqe9pRomS/ZoliUh7/cmnvphsSIgdzUvAVrp
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c3:b0:3d1:946c:e69b with SMTP id
 e9e14a558f8ab-3d28078ed3fmr19259425ab.8.1739636521714; Sat, 15 Feb 2025
 08:22:01 -0800 (PST)
Date: Sat, 15 Feb 2025 08:22:01 -0800
In-Reply-To: <67afa09f.050a0220.21dd3.0054.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b0bf29.050a0220.6f0b7.0010.GAE@google.com>
Subject: Re: [syzbot] [kernfs?] [bcachefs?] UBSAN: shift-out-of-bounds in radix_tree_delete_item
From: syzbot <syzbot+b581c7106aa616bb522c@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	gregkh@linuxfoundation.org, horms@kernel.org, kent.overstreet@linux.dev, 
	kuba@kernel.org, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152659a4580000
start commit:   09fbf3d50205 Merge tag 'tomoyo-pr-20250211' of git://git.c..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=172659a4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=132659a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c516b1c112a81e77
dashboard link: https://syzkaller.appspot.com/bug?extid=b581c7106aa616bb522c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e449b0580000

Reported-by: syzbot+b581c7106aa616bb522c@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
