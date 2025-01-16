Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139E11E86E
	for <linux-bcachefs@vger.kernel.org>; Thu, 16 Jan 2025 10:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737022283; cv=none; b=Bu9GlD0Wa7fXjYNmkDMmaqnuv09Ow0dlz/t1ifJnyGQRaGurlOrermhNuApSHk+LmY8yOIeYYE/nTEDgHoxMIjNd6YDMwewHf7XwHPIQwZlkqC2w0DOjSZ02MtajecaxcwcHSgVQaAK6VqflO7ngUKVwZyQaOEnXwTueFwS6QLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737022283; c=relaxed/simple;
	bh=8v4bD0ZipOabKoEc39uM0vD6DcLh5kLuNPFsmeTbIpc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jrBkqUYpZLwAjfO2RczaSiimE0IBh5TDPAuicHqHNETocbeE2PKm0DNQWiPIhzTbKauyGzKzqQFCC9gU8KgMek0e+aT0FbZTy8cqDINIiv8VrI6/Fy26bQj+jaZT0LB6x2vnqevuFW/BzhgGgFIvGLqQ+zg52cq7V7ARUawQBDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ce8868a7a5so5716105ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 16 Jan 2025 02:11:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737022281; x=1737627081;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TV+4g/wDgMuEv47gQ+m4ZPL+ynhSnSdL/xdnAAmdqLA=;
        b=w+iBE96L5iP7tUzOTXZ6rxheCgg/4YX2cvKzAIe1UH+OMiCOUA57p2J1TV6P+kbDiK
         U/rkuy19DqjfE+Yi1mkRkIEwHDWfoyOQ/VGytA9QHuUTz98kZ6a3Jzn0jMz3ky2HNY7l
         UJjaZNbo2Yg7oCrJ/6D9c6/r/VLlLrmRjJzXZVmxeqpqsGUbC9l2H4pnZrt0u6ZHbzyl
         /HcBMehxk5lWQaqkpdDq0R8Aw3iOysASpCbTW+KQn8dJH3xHeFdlTcXBIP5cq9d9kfhT
         poUuoPpcLobGvILSW47Xj0cZ6CPxk6frIPDhUVlfp5HMEPobsQr4H/F5WCgSP4NZzzdS
         SVZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS2jKmisatrUzmzBIfqlPcn1ZBaSccik9JDtM3Oic+WlCAsc6AF91CM1Y6RVxibjKFYMTub9D0UnhAPIykzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzczuWcRD5YnTemHmX4P1mBTtfkxvPnlywJ+UxzjWBXRzFOk/EM
	WhuG/S+WJo2Jn2A4x8NVCr8IyIY/bOcCrY0OLFYdLFVWwzipUTCvqaPR5FQ2FQZwyu259oWe2VC
	3xXs9QUAqFMZxyyn3ICzLzeSILP45j8KEx+oe77jtJ38xs2+bDvd/bV8=
X-Google-Smtp-Source: AGHT+IEEWIuhzRH1uXote7rkcsdXILrUQjOy2R5iZ7IY9or9kxPuTBVEHfBdzjwNLr9llLKF5XqUkYMI0v+mDrSkexBQ5VfO2pdy
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:154d:b0:3ce:793e:2766 with SMTP id
 e9e14a558f8ab-3ce84a1810emr46389485ab.8.1737022281381; Thu, 16 Jan 2025
 02:11:21 -0800 (PST)
Date: Thu, 16 Jan 2025 02:11:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6788db49.050a0220.20d369.0029.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Jan 2025)
From: syzbot <syzbot+list3513ad8218cc4be5cfe8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 16 new issues were detected and 0 were fixed.
In total, 122 issues are still open and 110 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  28728   Yes   INFO: task hung in bch2_copygc_stop
                   https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
<2>  7014    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3>  5318    Yes   KMSAN: uninit-value in bch2_inode_v3_validate
                   https://syzkaller.appspot.com/bug?extid=3cd97352d16f0e6066d9
<4>  3400    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<5>  1840    Yes   KMSAN: uninit-value in rw_aux_tree_set (2)
                   https://syzkaller.appspot.com/bug?extid=ed52fb987e4b52cbfad9
<6>  1779    Yes   KASAN: slab-use-after-free Read in percpu_ref_put (2)
                   https://syzkaller.appspot.com/bug?extid=905d719acdbd213bf67e
<7>  1287    Yes   INFO: task hung in __bch2_fs_stop
                   https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
<8>  849     No    possible deadlock in bch2_symlink
                   https://syzkaller.appspot.com/bug?extid=7836a68852a10ec3d790
<9>  570     Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<10> 402     Yes   KMSAN: uninit-value in bch2_alloc_v4_validate (2)
                   https://syzkaller.appspot.com/bug?extid=8dd95f470e7cd0ff4b66

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
