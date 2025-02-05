Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEDF25765
	for <linux-bcachefs@vger.kernel.org>; Wed,  5 Feb 2025 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738745526; cv=none; b=YDDM1QHmAWIP3ng2BjISeGEmBa9PSWGND93zbN8dHq5z3r5hNTLYQ8w98AIO/uxCuMFCtcfmFBdKjOYmVHjsen4u7tTjiXVT1U1+dilb66P2g0ohnKlMzSX8c9l9rhzUfLu9LIta0R79a8QwxAwpr9ludCUXpI39n4wEO1A84t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738745526; c=relaxed/simple;
	bh=3rMbtXXkl6VX1pWFu09B/1FrKHNKlZlWEwEUq1fneko=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=sUleAmbwC1j3noM9HHbgkIhvW5YYaDZyfT+aanz1kGYRTUpv12xa3FfOXLz3X0zSxXda3OZuOWjDcFRC1pfrUbPc47rJO27cACcWLupKjVcMtAhHA0xZwPGBECIu+VaKK2Yzsuv7PXCR8+VGRDpFx6LjS0ksAKbg0NOsyLw1gok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d052db03a6so2251425ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 05 Feb 2025 00:52:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738745524; x=1739350324;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fWMi8f8UFZiTnjFB+mEtuSmquoY1j2DyxbT1jBkdz0=;
        b=azk5JxcqVjDF8czITeIVMC835JKjoSZJv6LESv6m24IJ+VArZGr+I1v3CGEuaI167m
         kjF7ONkaZRLMSzF2mHn4K4tMpidTMWV5ozqXGeQbBteXHVlfrhLXn+Kd5nDe1+1mciS3
         aNnl/X5rV9hws6KPi5M+KWm5xTqkySxYsjp4O+nhuFfBEZ4S3zrjjYYCUPaGBKT6ZMwC
         k9Max3hZfp56bGsRyBo/SUERc1XZ94T/OiYRhmEdryivM7wZK62m+5i0GSndWN8K8nDV
         i1U5bV+oSrj7jE7GVNvzaMTw27RXbbdZTNd95rRqjl/OrefxQApaoHOdJNUAuctQHTIK
         qWLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjqtNDJnH+RiCPeprWuKUpU/4OTOIxXRqy46sh0PgOizs37JTV7CBMNPT7GbaHy7nEvlnxCHCr/rgL26zukA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8qXQAv+q8rUbaXvDAR71/6Tv963CqARjdqTO0HTQB5usZYoQx
	IIOsXNgVmrK7xQrh187ojZSjNAHZOi3RBCibcUEp0i7kfzoz02msfn4/fDSEkIx37vi/Rda+Ez9
	+Ap8Hp5ndpm4X3VoC1wtuwv5Vvkt8YYA4RSntCeD13mW0Ktg8eBLASlM=
X-Google-Smtp-Source: AGHT+IFXwvIR8Y5vDZJu1HcEo1sYAmhe4IxQ2/lHtkREqhjv+6JvENalhRxL3qxuNwTig7EwWKnTRvQ8Ovznu/iirQZC5OEkbQe4
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2688:b0:3d0:2b88:116c with SMTP id
 e9e14a558f8ab-3d04f45aff3mr16373135ab.10.1738745524471; Wed, 05 Feb 2025
 00:52:04 -0800 (PST)
Date: Wed, 05 Feb 2025 00:52:04 -0800
In-Reply-To: <677b4e8d.050a0220.380ff0.0022.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a326b4.050a0220.50516.0013.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_btree_node_update_key
 (2)
From: syzbot <syzbot+5ef4c078ccd6970db1b6@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	peterz@infradead.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 66951e4860d3c688bfa550ea4a19635b57e00eca
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon Jan 13 12:50:11 2025 +0000

    sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11336318580000
start commit:   56e6a3499e14 Merge tag 'trace-v6.13-rc5' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba7cde9482d6bb6
dashboard link: https://syzkaller.appspot.com/bug?extid=5ef4c078ccd6970db1b6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144666c4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1244e8b0580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
