Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7E616F825
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 12:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720788803; cv=none; b=fcCg1tQIeZSDxapUgf/1RTa1E8U6pqGCBbn6nCTUMsvuNfBNFwT6L/CwyYdjhv2of3EEqINCP8FJXCl/oFNviOnk9+P9+vbT1izvS+qvIJ4ertHroQDde6L2e91Svifzp1ldJy9urfYoxhUgn2IgAZYG93l8/k8hC+MxPEcGVE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720788803; c=relaxed/simple;
	bh=0zU0dnesDNO6/UoaCmox2MOvYlnQ+ed6qQjU5rQWhTk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Z3HlzUW7DyYAzil1/sA50uoJO1fKsrO3I4Ss/QXlvtb9JWvQKU78SpOMNaqDh24YuJuZ7OJJQ7fkpWLuhZ+V87zTBkF5B261x+3fbLA4adK2dcu6C98I5N2a2s+ZqUSrfPLWfAi9oVMzrDrj21fxVZo/3Ag+GXN4rQp/BAy0yCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8041a66f2ebso212921839f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 05:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720788801; x=1721393601;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NxqGbRT3LVL+0nPrwFQVVNOEcAeth5EOD0Me+bIoZgI=;
        b=WeGsU/lkLTtddLcWi/vjE4QH7Uwvvu+fywayn7LVfgzckhB1IDIyfOBL+07hJ8pXfY
         q99snt6HUYdJqOWKOVvWDPBafzKB9TLwWPoEYqyJCrBezSycqVAYp2OdzKBnADreiDSW
         YT7oz4Xp8dzotOd3G/b5jmVkNw6VhFNaFB3cNLaphJGFqnkjF0VcPL1A6trojY9jKJrr
         Oqkr6Cr7T5MBqRByHNRX5VfmoGBCVrqzGuG4gXG/BdAnu0Z1B5LZKxkdb2YO/SBpWAX1
         xa6c958Tr+pqcIZ4cQyBRHzV/t94GT6xSnNYLUOsmjQGrAh/XLK2bJE7fiTMB5jrFG0x
         q15g==
X-Forwarded-Encrypted: i=1; AJvYcCWVdnQgq+Z9tRNov55CTA8J5oxvBjClJrfo7J8G4puZuzEzQC09yPGl5AZjvSmXW3SmRdG6yU6HTbn+1zvgLZK7FOUN4Q+/2NRJ2e5Mv5A=
X-Gm-Message-State: AOJu0YxevZ5fKphN5K15ezbuiAAsZM/UWH0ss4u/m55ZMPjQnIQTn1x4
	cwq15DhFTt8ZXt7Nv6CST9z2dnAm+TDQpzUrIGHC/KLKE9ZerBJEA1SMdSRxqtCzCHBl6AoBxrf
	dS2K7NSAebt6/NXMPTHfdUqC5NsOZ70ulEYcfDU2tcZZoSkxvnkKhl+4=
X-Google-Smtp-Source: AGHT+IGjub6L3WCBvgOy2x0vV3c46oeVod9k9qcIbPFsr9/IXO96bBm9CyEelbZWlGaJJPVQfxle1JR4H443w2hVHyQENSx96/mD
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3797:b0:4bd:4861:d7f8 with SMTP id
 8926c6da1cb9f-4c0b2b3e265mr1027688173.4.1720788801253; Fri, 12 Jul 2024
 05:53:21 -0700 (PDT)
Date: Fri, 12 Jul 2024 05:53:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003b859a061d0c5d81@google.com>
Subject: [syzbot] Monthly bcachefs report (Jul 2024)
From: syzbot <syzbot+listb7d496953d366304c3b9@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 7 new issues were detected and 16 were fixed.
In total, 69 issues are still open and 50 have been fixed so far.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  2759    Yes   kernel BUG in bch2_fs_journal_stop
                   https://syzkaller.appspot.com/bug?extid=10b936c5eaee2819b49b
<2>  2696    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<3>  2424    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<4>  1100    Yes   BUG: MAX_LOCK_DEPTH too low! (4)
                   https://syzkaller.appspot.com/bug?extid=46405fa9afa07e6c8c40
<5>  240     No    INFO: task hung in bch2_readahead
                   https://syzkaller.appspot.com/bug?extid=a6060114362257e9798a
<6>  156     No    WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<7>  131     Yes   INFO: task hung in __bch2_fs_stop
                   https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
<8>  82      Yes   possible deadlock in bch2_gc_mark_key
                   https://syzkaller.appspot.com/bug?extid=050e797ad21ccc3f5d1a
<9>  80      Yes   WARNING in __bch2_truncate_folio
                   https://syzkaller.appspot.com/bug?extid=3d11e35eeafe176a6c5b
<10> 56      Yes   WARNING in bchfs_truncate
                   https://syzkaller.appspot.com/bug?extid=247ac87eabcb1f8fa990

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
