Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979A81CB32E
	for <linux-bcachefs@vger.kernel.org>; Mon, 14 Oct 2024 19:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728934714; cv=none; b=SaXc+h4/w5H29fxscpxQwM4vXOjiqJKARMg+lnuSmy8FYzY3L3igEslW58P43UWV2zl1e+jAcpq25YGJPkEfaXSBCFyb5LdhsBBE9TFH8BUgpKexzrT2cHHGMynMVx/ahr8ljAL+YIg9bXxioUttS6Mzqtql4sm6fpRcTjDDfzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728934714; c=relaxed/simple;
	bh=QO+CSv4VGx8JbUD2ZDg/8qSW4If41pNyKy6Y7gsfac8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=o7wK0TyA7/k9XJlpvFrAgv4bB23dP0gZ3xSB7d+t7CbeAZbOrjaElmn/FymfToKTJDo9PbDoOLhQjCoMZ0eTr4OlcsSMdkhVmcASu2mwUoo1RgQAjabFV9O2wfef+WgmgNMXIvIu73knFz3mHDMgro0U3f1Pvga59Wxq8kTzbe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3ba4fcf24so31024955ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Oct 2024 12:38:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728934712; x=1729539512;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=myczMVO4FCJEHSfCMtmpEB4pzxaKn2r6djR1Rt0h5H8=;
        b=GF9+G0dL1lY5YCbOorQwDu7As04FiW11iCbrbrcjVYfRvKBsEKUMiXkpPgbNJH5vrO
         L43/txNHsq4YVkUQeZtxbsE4okSzltGLFrcEnqNU0n7mZ/NhkOE4U5SbZksWNr/rv327
         UPVCfy+zYWFMgUmmiaEZOFFDXxY0iAyudBM/LSig5rMVGM8KoAmJrVAAL+zMSKWvJUC7
         UIUaG20hMh049ppsndcde8Q4dyjEDVKEwvj2FVR0YHHB7zV/DSG42SGDyCDVLIvkVRNY
         GqlC77LVG3Ytw4u/SDsiFEGCwIUdijRZohIssfVj4JdaZeD9uakFczioPTCAH7HIQeqL
         bXvg==
X-Forwarded-Encrypted: i=1; AJvYcCXUfNr37e7GMlFY9LkdZ3S1ay8NE2uhX2U9ZUKeCCWPimdbts+MhQyAoXr1BHaQBkh8JmRKlblyheGSlQRgeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAhG8y1cUn8ngzFVcEtRRoJqJJKEX8BW1GjdiznDxLS02kWx3G
	Rcq3owlhcGzqscepP4wzLgjVi3N/LFuN1oIBisvFnh1GtTBa7NIzgVDmd99zEO6bpx3LV0dAI3t
	1Wn5mFZ0E6eECA5Vqpk3nee9PXJJ4+QCSqi1FpbmJoDduJz2fx9ulf+o=
X-Google-Smtp-Source: AGHT+IGiR1esojjd+JJy5DQzMIgxp2crwY+LbYOI5GgIrK48JQIJlod5shIVJmy0jovHGY5I+r6ICrAH0j9ZaJYIREf2pwRW+GvT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4c:0:b0:3a0:92b1:ec3c with SMTP id
 e9e14a558f8ab-3a3b5f785ebmr116844045ab.4.1728934711898; Mon, 14 Oct 2024
 12:38:31 -0700 (PDT)
Date: Mon, 14 Oct 2024 12:38:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670d7337.050a0220.4cbc0.0050.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Oct 2024)
From: syzbot <syzbot+listf06e1cd1cd7c615c04f9@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 24 new issues were detected and 5 were fixed.
In total, 57 issues are still open and 82 have been fixed so far.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  12004   Yes   INFO: task hung in bch2_copygc_stop
                   https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
<2>  5871    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3>  3161    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<4>  1200    Yes   INFO: task hung in __bch2_fs_stop
                   https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
<5>  537     Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<6>  278     Yes   INFO: task hung in bch2_fs_read_only_work
                   https://syzkaller.appspot.com/bug?extid=8996d8f176cf946ef641
<7>  243     No    WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<8>  208     No    INFO: task hung in bch2_write_iter
                   https://syzkaller.appspot.com/bug?extid=d8b126a5bfdcd1f3e7c5
<9>  73      Yes   possible deadlock in __bch2_disk_reservation_add
                   https://syzkaller.appspot.com/bug?extid=089ffc4307915afa0da7
<10> 62      Yes   INFO: task hung in bch2_fs_read_only
                   https://syzkaller.appspot.com/bug?extid=c7aacacf99dcfd3475a7

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
