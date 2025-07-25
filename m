Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807DC2EBB80
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Jul 2025 12:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753447173; cv=none; b=AlyqfKLUsMopBLd1hLYhN+JAI+I7zdteIYmHZJ5/dO9XhHb4M/YqAohhZKD2JPf6WKUIIYa93gvtsLJeYuaD1kmGqidvQ7b+cyYiAYZoQCIGqjkrTEBLAMM3TZvrE8YDznv/P8xkVex9NfVSocIDDW00x0SeAN9e40qHR/70Mwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753447173; c=relaxed/simple;
	bh=47PWfLsb7WIHOIfZ8N5wd/mezbynrdCOU1Neh7k/pbA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KXaTXos4tuw8RqlKzwTOsZOblA3eoW5BdWsUEMppC7/+qeGjaZVuEw4eAujWmYjaIFYmGaVw7NoUS/iEgZCbzXZZIm2tTK4TcFZ7UIpa1lEe6ZjP2HSIiILIVJYMJztoJbuMzh/zlDKbQKeCykU+uZEMaEmWyZwxYRi8MtWdg20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-87c0e531fc4so478346339f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Jul 2025 05:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753447170; x=1754051970;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=43M45r7jDz0F+41JzcKntix5q+AocqyxYgrMo/k6Heg=;
        b=bBU+QjWQQBj742asGLfDDBYnHPJAWpqk33vUBqp8ryp0pb3OUWgz28LHJjoRHYrpQ8
         +VS058aB335qvcmejNvHBslyGZ4CGywa1TIavk2NImwfw7HDGAH8MesvlGCxt4m5bJVh
         t7mRYbU/r/2XIpNaFHAsS8y/Rk0JmePqDMANrQalDR+257X+c/Jw/E9EdyrlCW+rnC4w
         AJidY0aY3XbLYpLt5E0MvcQS3SSs7D7pdxDcErcr5CQwdeups9LfVDx8FqOilbPf4Rcn
         bZUf2pUpNVuVq2UVAhRdjikXlC752d9QqveaerjlpHjej+dqnC2oYws62XlLoKYVTfic
         4l0w==
X-Forwarded-Encrypted: i=1; AJvYcCXXx6IAh7xwCjAJx0tgBRLm+hlhAxDvmAqg2dyNg3iX5QgZRngD6MRAFIJ3ZOSX2BB3FePL/MrvqRxmgs9ckQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyV7C/I59+bqGftFFJF7RbfDVtzQCwcsPZ4h92Zc+sNOjHs8SSl
	5HYLfbMeuoMH1pSpxBS5XRLLff43FjtNx/42v9gEhKN/XnX8bX4rxYPcWkTodXvDD/qaIDAXPXj
	d2F8Ri5994vLxgJDD1O2SfxEQ0ytuEF/4Pa/Dy81wnDZfUEJHvaTi3mrJYB4=
X-Google-Smtp-Source: AGHT+IELeZyn8Oqqw7eA0AUVpj3X4LgKnm1woF6F27PmmpB7spYp+ZYUSAiAnQ/hVNgI4NCtQmd1MPG3uMFN7cHu0QLmULYnXkeV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:9c41:0:b0:87c:44ce:248d with SMTP id
 ca18e2360f4ac-8800f1960a1mr213351839f.7.1753447170572; Fri, 25 Jul 2025
 05:39:30 -0700 (PDT)
Date: Fri, 25 Jul 2025 05:39:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68837b02.a00a0220.2f88df.004d.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Jul 2025)
From: syzbot <syzbot+list2d3cd42628405a68164a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 5 new issues were detected and 13 were fixed.
In total, 52 issues are still open and 220 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  3934    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<2>  1253    Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<3>  853     Yes   kernel BUG in bch2_trans_update_by_path
                   https://syzkaller.appspot.com/bug?extid=210dfbddd64294066983
<4>  754     Yes   kernel BUG in bch2_quota_check_limit
                   https://syzkaller.appspot.com/bug?extid=8364d1e040a88ed5657d
<5>  459     Yes   WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<6>  346     Yes   INFO: task hung in bch2_readahead
                   https://syzkaller.appspot.com/bug?extid=a6060114362257e9798a
<7>  335     Yes   WARNING in __bch2_truncate_folio
                   https://syzkaller.appspot.com/bug?extid=3d11e35eeafe176a6c5b
<8>  158     Yes   WARNING in bch2_alloc_sectors_start_trans
                   https://syzkaller.appspot.com/bug?extid=23573dac1278bb26916d
<9>  124     Yes   general protection fault in put_pwq_unlocked (2)
                   https://syzkaller.appspot.com/bug?extid=aa930d41d2f32904c5da
<10> 62      Yes   KMSAN: uninit-value in LZ4_decompress_safe_partial
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
