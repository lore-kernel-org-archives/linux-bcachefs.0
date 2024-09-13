Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3AA1D86EF
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Sep 2024 10:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726221805; cv=none; b=WbWZFhNMiYMep74RxURwAnTajL1AhNxw3rDQBO4dz2IEA7FmiB2PsdYlhaCBh6VYeIEl2cdsQdvNfu+ZNPEk2fq+g06mL61chTmE9GTRnirs3pY99FkZKirSNMil8OuAy5/coCahWOHhJB+6BCQr83cx/Ql17IwBOSg94HQ05UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726221805; c=relaxed/simple;
	bh=zYymGv12Tr78xYvb+Qs99O7J3EKDyeUWnGG27aGtl8M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=h1M9nKNtWIflWnK5E5/C5bWA/Shn1eE2XfDDVHoTQRloeJlJyZ09T1CVCY8LHTCkcs+weIW151tYMLjqxCPT+Y3Fpo6nnfvb8hTeGEToFRzLpN2xKXS9974TFwhsWwA5y795aqamlIs6+R0jDzxPx0Wt9CqsfPEIXhfZKU7u5og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82ced069d94so268444939f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Sep 2024 03:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726221802; x=1726826602;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hTW7fffnT0NAUWKKmZ5rWaFaiySrf4ux2bUW8dDX0HQ=;
        b=aHGDFEtvFZZZGawJmOVIWfJ9dMn+E5RTIWY8/7fsp0xWn8h16ZaRdi4SdMvsoaLPGO
         q8C9b4Ztjc5Np/MIA5BecYt1Xp39d+syB+E9yuuwDHlW1JmvQ4xB2QedwU1Krg9rdlGO
         7ieg+5aFVq/jeXhqQscsKTFYJ4W1uURDZyA97H6CBk9+lHT6IYk1/Y22ii/UlPLtikVi
         ChcN9CuhwZCc3c1dp8Pa9OzhulhVCaID5UL/pm/MN3FR0UTbiJG8kK5jSHNVqCJelWMC
         WBnCcBGShiBR0aFVQBZ81lptjEhHhpYfrc56wWwTRv4Q0JP15AFirB8lmRNiuc5vhr/X
         jwfg==
X-Forwarded-Encrypted: i=1; AJvYcCUT09IZZstvCGiPn6cSh0qJX+FXP6qMHoGF9S1TtpAWwwkS7v3/oZsBk9Pn7ly9HrnuDZ51iCJdXmZ5M/TfMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxaJq7E9Jry2VNB+i8DmTbDgejc3DiPIHjsqs14MjucKBZDrbdu
	/45ydU+6mJsR3M3DK4L7MVyGpKm1cjfjjQGlK6YY40oJNvC06smMRZ+xR+NRd2T/YIs/H/BDcx4
	X5xl/ZF54ZN6TwFdKysAVKnUFrJe8JwUxJHPlwXvTYYYcQRmAy0XR0vM=
X-Google-Smtp-Source: AGHT+IH2R+pS60StlaslZLR48bc2alPFnYOcBdqDHxhZY1GTuvoe2w2GtsVarKkEZdjwNzsufsDePd8rqNWP2DehEibd1gm+J5ts
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13a2:b0:39f:6180:afca with SMTP id
 e9e14a558f8ab-3a08491196bmr69740715ab.13.1726221802378; Fri, 13 Sep 2024
 03:03:22 -0700 (PDT)
Date: Fri, 13 Sep 2024 03:03:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000055a86f0621fd552d@google.com>
Subject: [syzbot] Monthly bcachefs report (Sep 2024)
From: syzbot <syzbot+list670a74b4fb1089527ea1@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 3 new issues were detected and 9 were fixed.
In total, 34 issues are still open and 77 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2992    Yes   WARNING in bch2_trans_srcu_unlock
                  https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<2> 2953    Yes   INFO: task hung in __closure_sync
                  https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3> 224     No    WARNING in bch2_trans_put
                  https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<4> 84      Yes   WARNING in __bch2_truncate_folio
                  https://syzkaller.appspot.com/bug?extid=3d11e35eeafe176a6c5b
<5> 55      Yes   kernel BUG in vfs_get_tree
                  https://syzkaller.appspot.com/bug?extid=c0360e8367d6d8d04a66
<6> 18      Yes   WARNING in bch2_prt_printf
                  https://syzkaller.appspot.com/bug?extid=4e41a25632658c77b441
<7> 5       Yes   general protection fault in bch2_checksum
                  https://syzkaller.appspot.com/bug?extid=dd3d9835055dacb66f35
<8> 4       Yes   KASAN: slab-out-of-bounds Read in journal_entry_dev_usage_to_text
                  https://syzkaller.appspot.com/bug?extid=05d7520be047c9be86e0
<9> 2       Yes   BUG: unable to handle kernel paging request in bch2_dirent_to_text
                  https://syzkaller.appspot.com/bug?extid=1a11884d9c9f1353942d

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
