Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDBB152178
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Jun 2024 08:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094448; cv=none; b=Cm12J3jT6FWQf2nw+ydIVlNl3xPD+2ixXFaJs3nyWRQCL1P5qesV+6F1vckvBDXHx6dFpqZqtIL96dD07Q2CsCoW5WFYue9RcA8AVJvcdFbx/BK1l/Cog2LMfm9MywXBraFNFrUqQLWBQeBjHbZ0C0/z3EIwdo9AGvPkdDEsNCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094448; c=relaxed/simple;
	bh=4846dXCi+LLa+oRqvFIzMnMlIKpDWNszKOj8xaC2DZY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YS1AdLMzaXJOow+LHu4y6gskPvrpmuuKGAf3HX00iQYxFfkEjNbutLtPcW+8TBGkWTp2kJRz9lNQM8P/ytrtaVaPcubs+SY6qD8r+K7GAWyhKlSAlWGofl4NnWqr1hgJSNuvKLW3VQYsN1RWcLRaeR8eAaJ++k2/zF4MEbmXke4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-374b2adee08so54652025ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 11 Jun 2024 01:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718094446; x=1718699246;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i5XKnkHLsIoqOGAS3OERR6bhoari0fo/c4MqVHhGMVA=;
        b=EZQlGU01XZWbIHQtMvifcs0i64xDx/L01rA4JSAJDU/NDjs7A0ZSfbTxbNdpPQihCO
         ustNOYwo/e9ZnpU958zh/p+n6qO5vMNX8y1hktY9yeKzYaSTVyIsZNAbx6x/sqH3VAzg
         0P93z6+gsUpKXl1dxjrZlInI+iqp4iXIl6GVyicrq0fbnGUy0IArnG6YZj2FcnwpEVaJ
         fr+7L1P5ETIDd1sYyno3CGdmwy9r5QSxA8Y9FbAqMTe7n5hgdxmLyo4cG/201kNnakVT
         aCQtJYuB6N4+pTxOmP3lGYL+DV2ceNr6kNiUnDBDnwEcV5qXTnt6lVXo7xT/neyMbHK+
         CVeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/Xh2jBQ/IllL/6t8v7gzMhsSUzzbIjT1ArWCS6fLnE+39VtMtES8jn0oaIUx8nvTwMo5Lw4XWdT32OLTiMaj3OMkVNHu/FQ3zPp6uJyg=
X-Gm-Message-State: AOJu0YxE5Wdkg+fwDYitO5Ap+mU+q9B2ZxRI3g9PjsUshEf9mTe3f2mp
	HJBKlafVyzvIpFzxG4SxiRYAW4ZuiJim5oQ20Cay0zCvTS7cFULdzOOrync1oFWm0AXt2uR5+Ng
	/O+KdBdsd48Knb7BIg9cl6WCQDw2CXkfHWFAuyFfOHxoMJhvWMJtlBm4=
X-Google-Smtp-Source: AGHT+IHNQFjX7nXtcEGVrCfUjJQTGAwh53HEqyZkAYPKF01NcC8BWO2SzrSRycYpJoEOKitThluVmUtW2DwOM/ljmxzKGAzvXeKU
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214a:b0:373:8d04:28b2 with SMTP id
 e9e14a558f8ab-375b30d379dmr1024555ab.0.1718094445998; Tue, 11 Jun 2024
 01:27:25 -0700 (PDT)
Date: Tue, 11 Jun 2024 01:27:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002502d7061a9909cf@google.com>
Subject: [syzbot] Monthly bcachefs report (Jun 2024)
From: syzbot <syzbot+liste26a67e46fe73e904149@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 37 new issues were detected and 15 were fixed.
In total, 59 issues are still open and 30 have been fixed so far.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  2800    No    WARNING in cleanup_srcu_struct (4)
                   https://syzkaller.appspot.com/bug?extid=6cf577c8ed4e23fe436b
<2>  1722    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<3>  1620    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<4>  1070    Yes   KMSAN: uninit-value in bch2_inode_v3_invalid
                   https://syzkaller.appspot.com/bug?extid=d3803303d5b280e059d8
<5>  578     Yes   BUG: MAX_LOCK_DEPTH too low! (4)
                   https://syzkaller.appspot.com/bug?extid=46405fa9afa07e6c8c40
<6>  221     Yes   kernel BUG in gc_bucket
                   https://syzkaller.appspot.com/bug?extid=246b47da27f8e7e7d6fb
<7>  187     No    INFO: task hung in bch2_readahead
                   https://syzkaller.appspot.com/bug?extid=a6060114362257e9798a
<8>  185     Yes   KMSAN: uninit-value in bch2_alloc_v4_invalid
                   https://syzkaller.appspot.com/bug?extid=3b2968fa4953885dd66a
<9>  148     Yes   kernel BUG in bch2_fs_journal_stop
                   https://syzkaller.appspot.com/bug?extid=10b936c5eaee2819b49b
<10> 104     Yes   INFO: task hung in bch2_fs_read_only_work
                   https://syzkaller.appspot.com/bug?extid=8996d8f176cf946ef641

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
