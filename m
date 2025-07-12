Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA8223328
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Jul 2025 08:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752307866; cv=none; b=cAa66xOaojEylWRd3QdKyGFqQRDQeRS1XyMN0rSF+ueTGO91EwTWeQAcTm5WRICpd/GIrW3fhx5KKWpHno8FpLUECcyXhLoglQRavU6nGw0eIhE4mwD/YskpKtCVw9DFjhdpmMgDPsLAqyErMusPlL3N9E1iZNlxb2z+esQZIJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752307866; c=relaxed/simple;
	bh=O/gIJ+Byoe1HUgWMazz1k6JA1RNPRnQOwiyHA7/6NNc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UPMwD9LarF72YPK7hsrGt+6QUejqriAu9cpjaTDtATiC+RSYewUVpNGpyGDcM0i2kPpMeQFzjVl28MM0pdebu2eVLaeBZvnuUSr1B+IpZiZyWoPDmMEeqDAJSlVQffpyCNStZWAXeJ8nfeNMHr9m5mdE1L+SqYcH7ED3KEGybUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-86d01ff56ebso454940139f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Jul 2025 01:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752307863; x=1752912663;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yxA0bw6vzcwyTokn6nubSR1PJByh+GO35DS4D+OYI64=;
        b=wyiz4P1ngAoMhoHHjKtVND9O85+rBwYJzSf4UDqOQMaPg/JhFOGX5g/aIPm/xDJZs9
         6Wk7BLHOW0VA4jGR2iKMwlLrku6Z6Qxgj/bwhymu1VAmL8qmOFHMqD7bZ+TyLclCe6L3
         VR79E/CrAx91hC8rGmq+qu4iPKQXYmlAZnX5maTX6a7SjlQfO3WS/tvxu3EFc/2bCK71
         zAwHdcJlZHlV41jp/AfWkkz2wunIY50NC4Y3cFjMriFITVthFZJuTUSKe2qMHJ3qrL6a
         Ijw+YKJIu1bPuXkcHvZOQ4IA1nFcd7Mdcm5EQ4R+1aLOFCaeLL+StbWMR/q8hw0NKQTv
         yVVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxpOPOKvkTO6KzRv6G2wNu39LMhcvW3pUiRUM9X6/lG9LzXm5v9r+MtuKf6boUyahP9FfSukYgO1wtgWE2uQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzesi9T1xLngdzRKdA14VQ8URJ7xGwEFhZ/P73Ql5MUXn7FR0lj
	ebai/JsfqBAZNzO9kGFK2v9U+ldS3ljTpCKaK7YiW0qHhr5mbpV4O3PNv/E/jenowi6BEQXQhsp
	k9HexDT6xik4p7U1J9W9O5wPMuQZQoXlh4z9xc45XWDOsbQpYjj8OXQOdDnA=
X-Google-Smtp-Source: AGHT+IFI68HskVufu9pRsd1ogtwtVNXBvQiTh+Crm9J2fzblk+KFTeqnRdfvoYxEDjdTjW7a2y48hMvItbBMP6IYb+ilNXWQIOqH
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:36cf:b0:86a:93c:f5fb with SMTP id
 ca18e2360f4ac-879787a0c07mr679285539f.1.1752307863615; Sat, 12 Jul 2025
 01:11:03 -0700 (PDT)
Date: Sat, 12 Jul 2025 01:11:03 -0700
In-Reply-To: <683dad17.a00a0220.d8eae.0054.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68721897.a00a0220.26a83e.0073.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_bkey_pack_pos_lossy (2)
From: syzbot <syzbot+a6af6dbf934175da5161@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 263561649ee5875a922f4358e96d3deb17a91021
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Jun 7 18:27:35 2025 +0000

    bcachefs: Don't persistently run scan_for_btree_nodes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=141eae8c580000
start commit:   90b83efa6701 Merge tag 'bpf-next-6.16' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae6d9a7dd3ac8772
dashboard link: https://syzkaller.appspot.com/bug?extid=a6af6dbf934175da5161
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159907f4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1758a482580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Don't persistently run scan_for_btree_nodes

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
