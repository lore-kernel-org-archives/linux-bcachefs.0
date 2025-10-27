Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1AA23BD1A
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Oct 2025 12:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761569426; cv=none; b=anNBXznu/dlH4VDW5QKw1ZWbrX9EQO55k5iE+8zohUIUFUqmmtfMJDwR/oK2qsHvV6t413qg74pWi5e3K++M2YV6gY/6NoPK7VUmgqfEziRdPE8F1b5YMmMH2YONHBco3PCV/wb/cZaq2i7FbrinJjRJUB4nsJLgGDLn63LK2k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761569426; c=relaxed/simple;
	bh=/6jms8hP/eQHjTorIaMNk14twucXBZ/VsMxazDiXRoE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u5cdFO39K3wDH8iaZ1RsThvY7jHL34keqQUXEGLl9dSDM+CJCSrG0dN6EM1G9fX4mJGnM0sPHlhuty0LJOBqHNKbwrvi73SjfdYULKxpc9dy6R0pQzJVKY2df3vDouvir07aeTDmBBMm4dIO6fRDS5tfI2+eAralLg7Y10VFa7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-93e7f4f7bb1so387603539f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 27 Oct 2025 05:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761569424; x=1762174224;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bFhJ1WPgQ0gOO3MDukEG+hFs09fqZnICt7HaXQmaIDg=;
        b=vIQvbbtDKANqXX8riKlGHRFSXPG9CrCey1V1xEkHRDlR6SW6EmuO2bqFyHGp3xWlaX
         WRgtC1aEz5/IxJnBwl7ul6oStC7svrqY/Pk/xt3nA6z04zel25l6eBmvjXFUhUHOLTek
         xtDvctZxHhgqglBeb72gFkSVuGVxGLfinbDUOVfJdBigcakXecQf6b70i57znWNO+N2L
         gkUs1aO6lT7Kata2PcLFrIgxgkg4K0z4bzkXAAE9QjxlUWyGs3KS/ZLc9la6TDArKKQN
         SQhq35zOXgFJQ3PdYitX46TjVfL+z4ioBA8vNEvP1I7EUzRrc0ygxetIN4YDYV744apK
         zNfg==
X-Forwarded-Encrypted: i=1; AJvYcCUnC26rRsxfV+g85g+ZtIEFlHIhmYxFnDo41UKiUb33lkL7gKqArs8TZe1Nzrfv5fn3m9zdwtbmBO1boVnYVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw78Lk//heM5pkYdz94x8tGXNFITOURxvK7bZfxbfvYnnOND+DJ
	N7xxLh1QYc9MSQcYZ3exZJcbZcDNvdjZndmvTx/+aoyfwhR721kIgtqoZ0nY1ZfV+2kYfENBhPv
	r+Kq1jKYwzP4UCHaY5eiMwp/a56UfcfUg+QHp+Sb2rDntVcPE/fnPk0SF7gQ=
X-Google-Smtp-Source: AGHT+IHnuRLzQQP7XFAZVPiFkDTMpA7JrF5PPKLtr1Wl9AfmaJ5TAh3aGshzbCOjbG368UdHhty7D28QdPo9Y7Nb2DMVaqXjzzBV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda3:0:b0:430:b4ca:2696 with SMTP id
 e9e14a558f8ab-430c514e290mr535726415ab.0.1761569424127; Mon, 27 Oct 2025
 05:50:24 -0700 (PDT)
Date: Mon, 27 Oct 2025 05:50:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ff6a90.050a0220.3344a1.0391.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Oct 2025)
From: syzbot <syzbot+list04627eb870b6c8bfc804@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 4 new issues were detected and 1 were fixed.
In total, 53 issues are still open and 225 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  4145    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<2>  806     Yes   kernel BUG in bch2_quota_check_limit
                   https://syzkaller.appspot.com/bug?extid=8364d1e040a88ed5657d
<3>  771     Yes   INFO: task hung in btree_write_buffer_flush_seq
                   https://syzkaller.appspot.com/bug?extid=cf3d1015b55ff73dcdc8
<4>  519     Yes   WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<5>  332     Yes   kernel BUG in __bch2_trans_commit (3)
                   https://syzkaller.appspot.com/bug?extid=b6ef9edaba01d5b4e43f
<6>  304     Yes   WARNING in bch2_alloc_sectors_start_trans
                   https://syzkaller.appspot.com/bug?extid=23573dac1278bb26916d
<7>  40      Yes   INFO: task hung in bch2_run_recovery_passes
                   https://syzkaller.appspot.com/bug?extid=c2294ae43bae606e3c7d
<8>  7       Yes   WARNING in bch2_recovery_pass_want_ratelimit
                   https://syzkaller.appspot.com/bug?extid=3bf8b0169d7fcc0ebcd5
<9>  7       Yes   kernel BUG in __bch2_trans_get
                   https://syzkaller.appspot.com/bug?extid=3a42e4989f9047772c6d
<10> 7       Yes   kernel BUG in bch2_trans_update_by_path (2)
                   https://syzkaller.appspot.com/bug?extid=e7b9dfa79acffd3aabdd

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
