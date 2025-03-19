Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161181EDA2F
	for <linux-bcachefs@vger.kernel.org>; Wed, 19 Mar 2025 21:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742419767; cv=none; b=DqJ41i9gfKdo5MMqozEpihJ5mn2fhkisxOW0CXnx3fPAB8qxCwrVZvboAM6eh+dETi4cib3cK/BNc4RCGZsFveKyYSZfKWgstKR+Unhx7TxnHk1B550d55mVN/zQD/Z4N+cYbBiLv30P+zGwcnbElqx9TBILnEJY083f0B5CfFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742419767; c=relaxed/simple;
	bh=fPnbNObDotL649FEnfff/h/52LjX/j0sEYkkC7QUKU4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JC6EQ6xYZ4t9EJz72+4yizJow9ghffNfwL3+IZe+1K3UcQgsAQ9vM8ydqbUwyc6U5d4N8y25e3cvOhTD22Pi6+v/R98LjxlGmcU59F8McNoCg2TTXwrFxKx5W/QAJRAx7RTm817MxrFSCEqsM+7dIcSjIDg+ekSTHERIbDCvu1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3cf64584097so1566355ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Mar 2025 14:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742419765; x=1743024565;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vz21S4qNzzAqyrIxen6zEuuSUBt6BYGIWgbvRziLXiQ=;
        b=OruS018Fr4gBF/EHkjwDsoMfHyVyuktwNf1nuWnYjq/EeUEmUrtl2fiHNjHo8MN4b0
         7q0iSNPGNInj8O8Wfb7XdW90+kQC8gLl70X2seAQ6a4mrTItOkao2JkrG1noQZVtF6bT
         cjrbh6awyzXwca8j6yucmsGhJl1U5KwQYvj/jlW+hNBw4A4ROg+ih69d53/wcAJ/hUsS
         zKVkadY7o3tFUu+z7UVT+3Gbl/spn0afU+3JForothOLho/ed5G4I/W/pnjLtPRZgggo
         nE49jDEohZmBod3DuqyfbKslZ0bf8xBFbHQdT6UbRtssiSWYMZq0WhF8S+x3jdcY4sNa
         2TmA==
X-Forwarded-Encrypted: i=1; AJvYcCV0zgBVnjWRmuwo7Gq9gpq0aEPCgqL6/+zPEfFX2sRP1SOo0e5wnI+F5HkEPfzFPl6UE7p0/LVZU9F8mnGiSw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLyCqm2/xGDMIkCzWNjheTAeDCw0/kVgjV/QIgu05EzPZpM7/B
	pCFRipgdv+h4+5lFu4LiyIur1IWaJ78uAo6wN7oA7q/MnTp43iWi0auKuuzwPPK2ZZNaYOAc3qh
	47wyQRgMikp+BmSOPnQ2XOk6qLOq0aYjr4y+CmdityvcI7AVbrpccbQw=
X-Google-Smtp-Source: AGHT+IGLpopHz8Pnsq75sZ4L0GsNzyxAHMn2y9QHI8TV1NTIKZTGzA1Xyq57Y2G5S70H9lX5DC9sj9B7EuJFN/NQ06SY+E8vTIxq
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3d43:b0:3d5:891c:13fb with SMTP id
 e9e14a558f8ab-3d58ebaa572mr11341875ab.4.1742419765275; Wed, 19 Mar 2025
 14:29:25 -0700 (PDT)
Date: Wed, 19 Mar 2025 14:29:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67db3735.050a0220.3657bb.0145.GAE@google.com>
Subject: [syzbot] Monthly bcachefs report (Mar 2025)
From: syzbot <syzbot+list1844da6a324b378d2182@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello bcachefs maintainers/developers,

This is a 31-day syzbot report for the bcachefs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bcachefs

During the period, 17 new issues were detected and 3 were fixed.
In total, 160 issues are still open and 138 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  29679   Yes   INFO: task hung in bch2_copygc_stop
                   https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
<2>  7346    Yes   INFO: task hung in __closure_sync
                   https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
<3>  5807    Yes   KMSAN: uninit-value in bch2_inode_v3_validate
                   https://syzkaller.appspot.com/bug?extid=3cd97352d16f0e6066d9
<4>  3541    Yes   WARNING in bch2_trans_srcu_unlock
                   https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
<5>  3442    Yes   KASAN: slab-use-after-free Read in percpu_ref_put (2)
                   https://syzkaller.appspot.com/bug?extid=905d719acdbd213bf67e
<6>  2491    Yes   WARNING in bch2_fs_release
                   https://syzkaller.appspot.com/bug?extid=08d08d52c3a09bfc70f7
<7>  2333    Yes   KMSAN: uninit-value in rw_aux_tree_set (2)
                   https://syzkaller.appspot.com/bug?extid=ed52fb987e4b52cbfad9
<8>  1166    Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
                   https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
<9>  983     Yes   possible deadlock in bch2_symlink
                   https://syzkaller.appspot.com/bug?extid=7836a68852a10ec3d790
<10> 821     Yes   KMSAN: uninit-value in bch2_trans_start_alloc_update
                   https://syzkaller.appspot.com/bug?extid=f02ee424846cc4e04e04

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
