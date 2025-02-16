Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D0223CE
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Feb 2025 21:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739742866; cv=none; b=fE5kjCd2AeSsjsKu/w1LK1lRdrn7GpXQy7nq8BVDWQEwwWYjAvn/tis6UBX7tFXyn+bO1K7SonOQo3XEbPCFFwB3TRhFOnKvk9it9yQM+lQjF6EQ330hPu94tkuQLDOhBC2FnHbjd7PYmUc9AxdcoLErARkx1EhxXMSw3J21spc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739742866; c=relaxed/simple;
	bh=xVDCXXcspN54ObCOA7TlaRlKfcwYiDr1XHehL0iDPNw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qvR8QMaNkrE/aRaWrDoU93qQRpNkMF2YMUUZFOOqZ/R8WGzWpgBDqA1R/Do5iRCysFg+c+9B80xqz5OdqsdxE53Et5PtCLSSh5/4fUWY0dEBZt36y1BUTEtiMD6nuuq3zOBjAYXMdGd/n9ulDBxX1n7rAJ14W8/UjA2NJNEWkFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d18fbafa4dso21848505ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 16 Feb 2025 13:54:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739742864; x=1740347664;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cAfc/Bqjj1W01z/JmTwGR17l7AbYfdp7RR3w4otaT1I=;
        b=oLDauPmz0EaKPbaBiWa9AX/KWr59F/SSQZXW9UnTXCp7cv38ksgOd8mi9VqZNjyV45
         efHVRGETm3L7IDr0YmkjGSsWujjy3NyV2NaQBHyEwP992aWw3lRx3Vqqze2KMlp/6Fg6
         H2t9kDU/cR3b9xVdNLLoS4tPKXOVqOV+g+HpIkbp7GUhTPinPmzTDhNEisOgBz/r63NN
         ZW1SyZZOggJGEbVx9C5jAtP8TwH7ipRxc1j9W7LmgJjRPXvcmBwpjbBYEUeAtCezo/yI
         5TCbLxDCpxQY76PGpFEGnPMCI4aVzSYifNCoXWEsNLWQadZ0fB3Lod6IhqoZnNFNbh2b
         ap3A==
X-Forwarded-Encrypted: i=1; AJvYcCVD+SODJ5tvEHwS+w2uEBN2sVoBOGqaUq+SMGLvActSadUJG9W7hxhMSRAGNtCLU4Kjb8S9acSjaIZ2XzebIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbF6CRF0p5v7HD5UZCr3GRuPPREKJxqgjqCxel0s/5M1zb82aV
	vLTcp7safbvZuPDjpqjy0KNnCNZ4NFZVa+fr3y3Ppc/jqayoMh4iqwSMpf09izHon8+J69FjgEi
	2wkf0SuiCAX93XUuumCbFDS5O6nBXSEvxieRdwFxv9H2I8SYnWhxKHOQ=
X-Google-Smtp-Source: AGHT+IH8yHRrPTRqWGjNBj77ogFuzDmITqcRlQtqilX35p027C/cnkKZZTo5Qo3tQFU1Zkv5BH7tkCLauuG4xkWLQRh6r2/ZIJo7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4d:b0:3d1:a34b:4d01 with SMTP id
 e9e14a558f8ab-3d28078f2e5mr62249145ab.8.1739742863818; Sun, 16 Feb 2025
 13:54:23 -0800 (PST)
Date: Sun, 16 Feb 2025 13:54:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b25e8f.050a0220.173698.0017.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Feb 2025)
From: syzbot <syzbot+list57e38899ff0c2990791e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 27 new issues were detected and 0 were fixed.
In total, 147 issues are still open and 135 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  29252   Yes   INFO: task hung in bch2_copygc_stop
                   https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
<2>  7250    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3>  3473    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<4>  2458    Yes   KASAN: slab-use-after-free Read in percpu_ref_put (2)
                   https://syzkaller.appspot.com/bug?extid=905d719acdbd213bf67e
<5>  2231    Yes   KMSAN: uninit-value in rw_aux_tree_set (2)
                   https://syzkaller.appspot.com/bug?extid=ed52fb987e4b52cbfad9
<6>  1644    Yes   KMSAN: uninit-value in bch2_write_inode
                   https://syzkaller.appspot.com/bug?extid=c17ad4b4367b72a853cb
<7>  1245    Yes   kernel BUG in bch2_btree_path_peek_slot
                   https://syzkaller.appspot.com/bug?extid=3ebaf90b49bd97e920ee
<8>  1156    Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<9>  939     Yes   possible deadlock in bch2_symlink
                   https://syzkaller.appspot.com/bug?extid=7836a68852a10ec3d790
<10> 484     Yes   KMSAN: uninit-value in bch2_alloc_v4_validate (2)
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
