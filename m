Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B3E1FF7DC
	for <linux-bcachefs@vger.kernel.org>; Mon, 16 Dec 2024 09:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734342326; cv=none; b=ZkiInDGdbyNjJKwla3o3kf5/VKoViNY8m33rbbwH+S+tZETv3TbQT1yY82tsS56Oo0jdvIkGWeI+TxeAcmowmUlVr4kTISfyxzzMb4I4p9K73QqO95+j4TBGhlmTYOi98/SaQqCRSQ7HPNpDB0Y6siWiCDCc0u9zrfg/qQ1UCrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734342326; c=relaxed/simple;
	bh=8mtxzrWV4gewRcK71MhxjCFiKSHPwB7UxiiQc1sf8Ko=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WmvD/DMNxRovyC1SgfwRoZ9eEnINZV/zLPiH8j69/QbZP3GW9ZpLcAwtQX8KrAXOrAiXd6Z0WE1HIwvuSu+VL4TB6RD6JhjtPAQ7GgOQriJ4pExHd34n6Bfuam2VZRHVoM/iXPJHkZhZdkWb2xnDSXojHvgpV2I/ljiJAvAIvWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a817be161bso36435635ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 16 Dec 2024 01:45:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734342323; x=1734947123;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EMzVsBAaxz4G1X0acZCRaYr/sYpeNPkFz7MQrq+3vj4=;
        b=oCdRYjIrAvmdqDK9tDqHgpQobSYi/hACBFom/sG9EDWb9YMd8pLbuhaVH9BT16kZrH
         iFfD1ll/Lr6lXsqJO38YxS+q7Ro/tkwNrMfcqzgCe6iqI1TQbeDy3ULP4hgyDmooAC0J
         Mk4qGzMPB7vHQu/v7p82/VydAFqWsco7mzygC5iGSiymVOnpMiUNsrviZqk2+W41TroI
         cS/ac+ZER+9t5THDy36a8uHjzthPk+jacGyrGswOmviXDTyGCfeAL6GBVYTol8z3yI9z
         CbpCz71+smuQuS3eYr8vb/OXhzg8VqUaDn/Fl1SmUeH9tAqg+Ye0hEkSuzKvFcyyt0LK
         UpXA==
X-Forwarded-Encrypted: i=1; AJvYcCV3l4hfCD9P1VULi+goSY9YMqAthZ9feVKKNKOST5RbpIvvbfgjFMM2jjZuh3REZTiHdEKBpPWnL/Ws1qrzuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHGwk1eEwjVxS+eQnSp+hlFm5O805tVQXfVZ5zkjB0AqdslleP
	hAhEKGNZmRf3I0K3m/tdQYtecpNLG5XiRb2Qh8RlFMWlYoNrnGu1wVu3DaNFdERsW7eq9h/Gkob
	cHWVgKt4mN5mUv5c0TcOYQLXiNnVpFUgtGipya1JRLWAqn5fgmMfcUAY=
X-Google-Smtp-Source: AGHT+IEp6IecTjPnXdiY0kfC4wTydw2PyX4iC0kaDv2/zdYsJx/UpbptRIFAprzDKEY2ZSf5bK5Ma2LWOdyjz/TXxT9mL9z08fSx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:db48:0:b0:3a9:cde3:2ecc with SMTP id
 e9e14a558f8ab-3ae62c90bd4mr104509675ab.6.1734342323627; Mon, 16 Dec 2024
 01:45:23 -0800 (PST)
Date: Mon, 16 Dec 2024 01:45:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675ff6b3.050a0220.37aaf.0126.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Dec 2024)
From: syzbot <syzbot+list6f489e4466839f688ee5@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 37 new issues were detected and 0 were fixed.
In total, 108 issues are still open and 110 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  24764   Yes   INFO: task hung in bch2_copygc_stop
                   https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
<2>  6585    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3>  3362    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<4>  1635    Yes   KMSAN: uninit-value in bch2_inode_v3_validate
                   https://syzkaller.appspot.com/bug?extid=3cd97352d16f0e6066d9
<5>  1283    Yes   INFO: task hung in __bch2_fs_stop
                   https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
<6>  924     Yes   KASAN: slab-use-after-free Read in percpu_ref_put (2)
                   https://syzkaller.appspot.com/bug?extid=905d719acdbd213bf67e
<7>  904     Yes   BUG: Bad rss-counter state (5)
                   https://syzkaller.appspot.com/bug?extid=f2bbbb592debc978d46d
<8>  547     Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<9>  487     No    possible deadlock in bch2_symlink
                   https://syzkaller.appspot.com/bug?extid=7836a68852a10ec3d790
<10> 427     Yes   KMSAN: uninit-value in rw_aux_tree_set (2)
                   https://syzkaller.appspot.com/bug?extid=ed52fb987e4b52cbfad9

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
