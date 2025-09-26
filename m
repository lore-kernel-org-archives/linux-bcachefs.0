Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A31246799
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Sep 2025 05:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758863673; cv=none; b=S0mZcN0AISedXIkxbWePfF3vr0B3e1na1UUF90/cJzfFelx8eMOLe6YXYNpeEBROXhRt595aEzji9LUEEmJR1H17BgmtYbyZGLKkA6SRDKB4xnA1hpg6X+8Ajlu0kkqELwpKi7QG8wbShU1NkEnTkOkd6sM+APgh6nqylduBrZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758863673; c=relaxed/simple;
	bh=9wRttYzh/Apy5zLesvQXpOQylmAT3nwzo7gE0t6VrVg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=D3NmIGBR+QZKeB5OJ6EKFm3G5WVRXGlIVQGv+gIeX+Yq+vHPZvotczQV17CIhJcOsFyGEPxPemWPaM7u+GMAlvqWk8RuT1eXxK90mAxSOyWaI/VDuEnCVKzFKHfYbVndLHF94smm9fpa6Imm1RE76FdaCP5DIPBrmHID3CAVris=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42591c9fca7so22584645ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 22:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758863670; x=1759468470;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hWx7q9CNnmoX39Q0wc2VjUaNCf9+s8bMRA2G0BcSoII=;
        b=We+WC8ctINRKVokOpDe/msc9h4Tnn28rp5aLYtH6WaxIDRdFtRsDKywquwDezzn8ua
         D6x112TegalpIoXaMi99ny44YELrD/RSlLqLM4punKnoOk81kNBvVKEdmWEMEPx4jbtK
         yaJhP2DjFBW/kBixgSnPJiQSHgJisLkoMaMUcnJnZv6mNoKmfzGO3DwlhtOUKs0zK/8p
         IubtcX7kBbgE7mUVgddnm7zvnieH1+RuditwoWwa6QC0cigmhuLkx1i+jg6jGBhOZsCD
         8kD42BTly80ZF/cCCdIvpIsEVl32FxwZdUpX0f/Ei0BaxVzQgwhBBkfuLwpgYheLmHkE
         W3Dg==
X-Forwarded-Encrypted: i=1; AJvYcCXhFCmrq6Tb2uIvbCofP0Thm57I25WZ7xWmFDQ3Hgcu1BUEHR1zKvLCe7nps8ZV37kzgMnbdOo98AWLhdNTLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkKq4/rrnLYP+Qa8Wt/0mMfdLiQ7DRNVIdGjzSggP5je41AnBM
	mqTgsUdmvghf4aIDht+8eqprPzuMhsuXbukBhJVtXKzjGe1VhAJVbNW5W8bnN62BvrNZqwC5eKG
	E2k1MyaGDORZDR8LxqfCWiXSglYbRnFj7VQLo2cwoPCwceATdVEYJR9OJyZs=
X-Google-Smtp-Source: AGHT+IGjwehvV9wruhqWRtwLbUujGLynWk+PLDvnx9XYNg3xvYkjJ9qQTmw3e/l120MIlAzW06MmTIkSFy/TTzD/etB9hmCkAntK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cd89:0:b0:425:79f5:2349 with SMTP id
 e9e14a558f8ab-42595654368mr73166385ab.24.1758863670656; Thu, 25 Sep 2025
 22:14:30 -0700 (PDT)
Date: Thu, 25 Sep 2025 22:14:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d62136.050a0220.3390a8.0005.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Sep 2025)
From: syzbot <syzbot+list1de35383332a7562f939@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 14 new issues were detected and 0 were fixed.
In total, 52 issues are still open and 224 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  4086    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<2>  1561    Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<3>  793     Yes   kernel BUG in bch2_quota_check_limit
                   https://syzkaller.appspot.com/bug?extid=8364d1e040a88ed5657d
<4>  758     Yes   INFO: task hung in btree_write_buffer_flush_seq
                   https://syzkaller.appspot.com/bug?extid=cf3d1015b55ff73dcdc8
<5>  503     Yes   WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<6>  395     Yes   WARNING in __bch2_truncate_folio
                   https://syzkaller.appspot.com/bug?extid=3d11e35eeafe176a6c5b
<7>  295     Yes   INFO: task hung in bch2_fs_read_only
                   https://syzkaller.appspot.com/bug?extid=c7aacacf99dcfd3475a7
<8>  293     Yes   WARNING in bch2_alloc_sectors_start_trans
                   https://syzkaller.appspot.com/bug?extid=23573dac1278bb26916d
<9>  288     Yes   kernel BUG in __bch2_trans_commit (3)
                   https://syzkaller.appspot.com/bug?extid=b6ef9edaba01d5b4e43f
<10> 221     Yes   kernel BUG in bch2_btree_path_level_init (4)
                   https://syzkaller.appspot.com/bug?extid=55c84106264e92ea9ada

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
