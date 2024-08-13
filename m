Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B4016DEBD
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 08:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723539207; cv=none; b=iypdmFKwUEja+oXClYk7T7vzzklhs95M8C7buAgNeds+LTsMmIr2mxYPjFHAOlt+YlzesnessOy2sxKgCwqum9TyokZypUDualt/is/KX91/NDOHMwQCyEUEbnDpE35UZiEKENN4VhV0VKgr5xetuE3DRZYjLqBEzZx6bAhhmMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723539207; c=relaxed/simple;
	bh=YjYGmZ8crfTZIYfPTthho7tbXsQd1/fl/xSECo88FXs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gVni5GRmBLk+jC5qt4uR2UOvNmQDc5SEpt8A4fT6q/LL9FrYABv2jUQa4vPv4NawuApHoUku4KUj14efOjeETnMW97GR716dZSN7pIBxm9TXTXtmbcY7Y9+NOzPwvdZO9MwHOtUNy0SMceZ57dlvwO9L58QCsSLbLdGQadckM6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39b3f65b494so69759975ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 01:53:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723539205; x=1724144005;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mAMXFIFRKJpj/G/fvrDcZKD/wh5ArnCaafeSsdLbFlU=;
        b=fyiYFNUSvWvar03e/EeQkY2JIu9kXDlwy3DD4klhA6c46F02Vg5bGxlcBOmsXKw4VD
         HkCUOREGUZnAcNU7Y1O3lUKd9PkI3N8GiwKsKS7O51wEJSBtSc6krAdl9tv/DLER8QkM
         isIPK6Ct+HyosZmTLHr3dr2SrscG0lVh+PEwlpie9AAoFOBI2CVeNTBL4MXq6rEYJnvn
         g1waDhxxeOp2RT0v0m+KhosRilbHAEDktcatt1LVDZu/BA7o5C2YahHK1CrFM2+MsZe4
         EKv9HGPtRrJbbPHPwQ4GJcMCAsM2zINCo6UyXJJcZ+I8q3biMwu2Rabg59jEXNwBNGs+
         WfSw==
X-Forwarded-Encrypted: i=1; AJvYcCVEvMWRm58iNIKBsis5FQXnhwNCk4v9EUuaHupXOer/h8tJhnoP8HyBoEcb6ufnCHUvycuf9KErU7GtfsekLNd5EDtMUhtvE75zaUdAbJM=
X-Gm-Message-State: AOJu0YyNy/d/F6lZEpGhIHC4F6lHpuiPSFFO8nJuE15/kSRJ+XuwFz7W
	H9jEsM34D1oT9jLtFKgpYFOukGQsWVtFpkiLHP/lvRLqTelJ8Bfbd4eIxwRSQL1kaBYXUDfwxk9
	l4SOPbHwsVODMZc2RnolXOWoCa5d7QrQCOh6I4haZelZkvRSwYEGpOyA=
X-Google-Smtp-Source: AGHT+IGgUBDALvrCrch7SF4UhE1THnJLvppqL5MqTLE/qhTaObGjrIme1a5PEaBE0wlQoNOxDYlfySuDnncaQ2rH5K+aYMwnzddx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160f:b0:376:417e:c2ab with SMTP id
 e9e14a558f8ab-39c47912e84mr1765715ab.5.1723539205554; Tue, 13 Aug 2024
 01:53:25 -0700 (PDT)
Date: Tue, 13 Aug 2024 01:53:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001a9128061f8cbee7@google.com>
Subject: [syzbot] Monthly bcachefs report (Aug 2024)
From: syzbot <syzbot+list88c61bedfe3e28153b24@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 5 new issues were detected and 1 were fixed.
In total, 71 issues are still open and 52 have been fixed so far.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  4330    Yes   kernel BUG in bch2_fs_journal_stop
                   https://syzkaller.appspot.com/bug?extid=10b936c5eaee2819b49b
<2>  2944    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3>  1364    Yes   BUG: MAX_LOCK_DEPTH too low! (4)
                   https://syzkaller.appspot.com/bug?extid=46405fa9afa07e6c8c40
<4>  398     Yes   KMSAN: uninit-value in bch2_alloc_v4_invalid
                   https://syzkaller.appspot.com/bug?extid=3b2968fa4953885dd66a
<5>  246     No    INFO: task hung in bch2_readahead
                   https://syzkaller.appspot.com/bug?extid=a6060114362257e9798a
<6>  221     No    WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<7>  215     Yes   INFO: task hung in bch2_fs_read_only_work
                   https://syzkaller.appspot.com/bug?extid=8996d8f176cf946ef641
<8>  138     Yes   INFO: task hung in __bch2_fs_stop
                   https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
<9>  86      Yes   possible deadlock in bch2_gc_mark_key
                   https://syzkaller.appspot.com/bug?extid=050e797ad21ccc3f5d1a
<10> 82      Yes   WARNING in __bch2_truncate_folio
                   https://syzkaller.appspot.com/bug?extid=3d11e35eeafe176a6c5b

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
