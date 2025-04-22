Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511F013B2B8
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Apr 2025 12:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325691; cv=none; b=tyH28l1Exr+xw69yPDiSVdQ0qUV3qRWx/mXePjCSOaCEkp+loyCpR5sPSL6u86toVBEEojjrEefZLRgkHB0sS4lzU/2uuN1YB7WvrU3NRQ+pXbp/DPtX6o2t36D7dKOKDzg+nzpeUc3ybX2Y9LuzjsCLOLqdBy01InHUoSWrqMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325691; c=relaxed/simple;
	bh=Kfr7yoo/gwlOIW5psf5E0iPQL0tj4oTNfTbsvyiD7KU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Rdqz3gxy8VRbUAasUYaeBFNTiQE+R1EG796vGzfdUrooVm0KORKGyRFqOZ3qUOgXQip2TJ6JK7EpX5NUqkSXSLNjsZxEiETJk0ulsQMUH9Ph0NTXAP2MCmAVjYX4uSonWsHM+ftvraOo/xqeGePV6Sywp/3kgoj/myFdYF2yCoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d8fc035433so66320985ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Apr 2025 05:41:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745325689; x=1745930489;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VofB/6an6VhnaTLehxLmKxnWDf7GjkjvEj6LIuQEf+s=;
        b=fhS+MjHHrP4jLbEe0NdeSjQ+j6jojeR3ouisg8ltJE/Yni1x7Pxafz/iGxV0QfXX7t
         pKgnaOvr5zccznCKUHq4V+2WvkvJ9jwUc/uDTlOsT7mWd0Cma8ZhaDghSJ4xPZPr08ns
         LHHKvr9+e5OvLvRuO9Dzp4D9veGKlzhTpU11zz05xItwgqG8RmjsfQOSy/hwa0huxBUd
         1rC06UsFdYbC6SM4J8nLYgxqFvmhpCl4oy/gORlW04MeHme8YuCxvuQL1X1ZQjT000kQ
         ZujfozmC4haqF/8agh9NWVMNewiwHgom2eap3u8nd0ARv+heKhmMDLvco4tbrp74nyZ1
         I4eA==
X-Forwarded-Encrypted: i=1; AJvYcCUgOE0FCRG7BoGqN6QGFQ20HhevL9heAsr6j4qLrOujU+LV/tl8RKc3Mx8V+kb4TciwHrk9WU3g/dw3nwoVoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk9buBhNRGL8kWkLoDCsMyHWtBN0sYIAlsrCGxg9fMCefIWdhu
	Jw1YHl/yzkGuFYcQ4GF1EdMDXNRy/si4DU54lLB1WNAMgra/NrC7nAHF7kS3t+2kWtJUZkUdwWa
	PdqFjZ/jgDKTAIUZMvbouV9CFPkZoXPoaGdsFFak/CIGwbpDi9s66CWA=
X-Google-Smtp-Source: AGHT+IEjd82KzbL/35HJApVw5wh/zmnYQbBq88QjJBsj8E4M00AKomtHN5MQdn6EG9Z96FG4gsrvkEp1MvDSUdq068aia98Tr3PS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b25:b0:3d3:dcfd:2768 with SMTP id
 e9e14a558f8ab-3d88eda86e9mr138019815ab.4.1745325689346; Tue, 22 Apr 2025
 05:41:29 -0700 (PDT)
Date: Tue, 22 Apr 2025 05:41:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68078e79.050a0220.8500a.0015.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Apr 2025)
From: syzbot <syzbot+list73b2921034e46fc2b5c8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 8 new issues were detected and 6 were fixed.
In total, 123 issues are still open and 175 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  30320   Yes   INFO: task hung in bch2_copygc_stop
                   https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
<2>  7504    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3>  3678    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<4>  1495    Yes   kernel BUG in __journal_res_get (2)
                   https://syzkaller.appspot.com/bug?extid=53bb24d476ef8368a7f0
<5>  1301    Yes   INFO: task hung in __bch2_fs_stop
                   https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
<6>  1211    Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<7>  1073    Yes   possible deadlock in bch2_symlink
                   https://syzkaller.appspot.com/bug?extid=7836a68852a10ec3d790
<8>  573     Yes   kernel BUG in bch2_quota_check_limit
                   https://syzkaller.appspot.com/bug?extid=8364d1e040a88ed5657d
<9>  387     Yes   WARNING in bch2_trans_put
                   https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
<10> 319     Yes   WARNING in __bch2_truncate_folio
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
