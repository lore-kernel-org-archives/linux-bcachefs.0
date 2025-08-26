Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1864D26A1D9
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 07:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756192415; cv=none; b=epNDikJ3wObPAahF3OUJEvAoCJSTuBTZDnFMEcpYxyPAVAdiUZ9oQIwz8XnJui+LwEjkdTIEARkjVVljOYlvn+WeIuzCTYq1gBAIBcPPbaLJVCOQCLePN8fVXSDzil9aWzD8uz1tHtl+tRzfoXHCV0N9xWGQY5V05mJ6pgSVxDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756192415; c=relaxed/simple;
	bh=e4+LN9VJ/FvXPbGXSjCrXOaZtrPB81yZlLjDGr42tfg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u1RJD6BoU7nNOO3HbeoMU8FL+uYodi9fzS/+Rve9xO+VaaiHolB/8qqCnMZsGjPhFeluU43IGcCepsx3S+HDp/ucMcT9Y4xdTegc4q2zLGwskUpfx8WCuNcDoyiu0/2ncvcui8dJcvz44vqIUgEgSdlVFTnl6EZLQx6B1LotAK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-88432ccc4f9so1203490139f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 00:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192413; x=1756797213;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OwtFk3OBEqmOdFmpz6iENBLxP923nbiGy1Q2vgm/Aso=;
        b=N1Q9Nmt1Ke2HOOz7FJeqMe2HshAPNMzmiMv98cUsRgQ/P+xXJdU5gO1s1cSMqNUC/W
         wxxZ98RQgzxs7Fa8+PoGoqhhq7g0djz/6smHnH+0x76F8vRTsSa+hGET3EDvuJXuu6nt
         s6BOzmfVq1yxAhXvQy/caW52v4ahTMbuc7EBxCwCeWmyxgtTZfqSOReiNjXeJjJwTqzK
         NYFYSPgU1QFPUnFfnB+UNXX70m0E30hEMlUgWDo2x88zCbszVMU2KXunQOB1IgjjDhE1
         GH4i4FqBsEhgYQLv9CAZy8dZEDhK6BlOgk0PcWXYmFlI4vxESrIDzJ1LOsj1Ak3APsHw
         HNNA==
X-Forwarded-Encrypted: i=1; AJvYcCXn6EG6chTbCEVoHSwS5aYIbWTOJWxfpFu+6tAub+DohvpeFUpM3NYP3HsSmQ8b7WKtVAbPEyxI4zhvJpCvbg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd13TZjo7xMM9x+Sh5UIGzk0EUE0UH/ZMiSsmxjAOdtgiycTZh
	YIuNRswtHCLpMcuEMDIFdixeCeqgcBee8JTcdoju5V2X0e2O1zrA/SxRA5/RtGEWCKK0REYZQ36
	sOnD3N6tBU29+pV6WmnUumocTLtwxGa0dBdDtmDlfTB2+hB1zzffvKiHjhGs=
X-Google-Smtp-Source: AGHT+IGX1ebrSxEjq825kfMpN9f16FdGDQBuyHxdo9Y3GMv4umkBvCfO6w7U6yk3DRcV3gAfkU0UKioHoLfwxwwaKTfZ6WD+fae2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a03:b0:3ee:66f4:a8c with SMTP id
 e9e14a558f8ab-3ee66f40bcdmr35154665ab.6.1756192413301; Tue, 26 Aug 2025
 00:13:33 -0700 (PDT)
Date: Tue, 26 Aug 2025 00:13:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ad5e9d.050a0220.37038e.00ad.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Aug 2025)
From: syzbot <syzbot+list55f13d56985d7df20cbc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 7 new issues were detected and 1 were fixed.
In total, 40 issues are still open and 224 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  4006    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<2>  1442    Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<3>  758     Yes   kernel BUG in bch2_quota_check_limit
                   https://syzkaller.appspot.com/bug?extid=8364d1e040a88ed5657d
<4>  483     Yes   WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<5>  369     Yes   WARNING in __bch2_truncate_folio
                   https://syzkaller.appspot.com/bug?extid=3d11e35eeafe176a6c5b
<6>  292     Yes   INFO: task hung in bch2_fs_read_only
                   https://syzkaller.appspot.com/bug?extid=c7aacacf99dcfd3475a7
<7>  241     Yes   WARNING in bch2_alloc_sectors_start_trans
                   https://syzkaller.appspot.com/bug?extid=23573dac1278bb26916d
<8>  125     Yes   general protection fault in put_pwq_unlocked (2)
                   https://syzkaller.appspot.com/bug?extid=aa930d41d2f32904c5da
<9>  120     Yes   kernel BUG in __bch2_trans_commit (3)
                   https://syzkaller.appspot.com/bug?extid=b6ef9edaba01d5b4e43f
<10> 69      Yes   KMSAN: uninit-value in LZ4_decompress_safe_partial
                   https://syzkaller.appspot.com/bug?extid=3c88ea590c13f5f92152

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
