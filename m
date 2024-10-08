Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118B223A0
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 08:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728377406; cv=none; b=esmvJdP5/L3/T1bM8aHSknL8lrz6Oc4jP5iVUllNjieiVOQ04z6zczMReQk1852QjM8FwGSHheZiMIa/6flnuoWdxZjAn4Wf8pw8oeaTCydqnp3mo8aYe+5wU607/yLgL4XUzyMZZo0A14GGl6m3Uj8YTav4N/aI2mTyEo5H7Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728377406; c=relaxed/simple;
	bh=U1ovfypYMIhQmtiZi2K/KRO7l4WfNQM2nK8I2rd0ucQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Nfz9N7NHN8mpkZFwYHyYs2/CaTXBCHjueVtRLpGn+QIJQ2Omrwh0WR2Pyyy0059yAyJy4whUqxuD3/A/LNGz2Xad67X38GKgyqUxraTXdyD68e+8K72EHidrokwqMSSZ7Jz3HPumDi1Aw8oCXC4cP5wh7D137xVYujAbIVL3XTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8324396d0abso472812639f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Oct 2024 01:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728377403; x=1728982203;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CBvKpDn9GrRhj3YxBgIM7qO8I2+gyEgbuwpf8yiHtBI=;
        b=vYsZ00uwbVSYyXWf8ZEs1Oq3TZTP8mmHMpU9Tbq1Z0lp1CalxwcLlpGysogpG4Uwdt
         vGLjQakc44YPQ2KknWVc6Y5d+bfD59LxU4R2e0+hVzV9SQUKrFfe4nJqjfM/piB2MFDq
         Hot6UaibFhfRt5qohQnyZMPrd+lXdrdRs0b9zFfLmpsdgMMoVwOqYD7ift7t80DmwhjU
         X+TJvIyTbjM8YKOFUqn2AXwFe4Zm7Vi3MyPyrmZDO2W86gRY102rHOii/HR5FR2o2qkT
         ct63hJjYVgtiSEPJLWbBikwm9PErbignA7RGZXXtgFykzpw46eGo/sd6FhSIcEs2MPeT
         9Hzg==
X-Forwarded-Encrypted: i=1; AJvYcCWqRANfXlUFsSv0eKs2oNiyvcniSIn0Ejage7o9AgNkpVOS+OhLacyidnQzZR4VjO6FCFgRs/eUTQLSwOn2AQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YymZK8mqjMsD3hK0uIA3oDBVZwLr3HgrxUz7vnYag5IcHftV0+g
	IR1ck8dSe4NGJLgNQVJsVoqgQ7AXfIi8MevHzJVINkzSUqZn7nwG7Lmr18U8JiT1GHYENZf070R
	lWP9LfmBDhZQqHFEPcR+xm9BKS/62diqRxle4Fpm5e8vY6owiXQs1Tc0=
X-Google-Smtp-Source: AGHT+IFA6pdilpZEWRCu6RFnLR3T1nvedPKJLWW8oYyLLPhmY98zuXMLzPfqjW9gE8T0n/whKpmWeJNjitTfQE05EeLoE0Z6Wp7c
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c5:b0:3a0:9244:1916 with SMTP id
 e9e14a558f8ab-3a375a9e8famr137522615ab.11.1728377403354; Tue, 08 Oct 2024
 01:50:03 -0700 (PDT)
Date: Tue, 08 Oct 2024 01:50:03 -0700
In-Reply-To: <feacd590-f315-4cfc-a8c6-eb664cc6350b@126.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6704f23b.050a0220.1e4d62.0088.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_stripe_to_text
From: syzbot <syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	zhaomzhao@126.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com

Tested on:

commit:         1ec6d097 Merge tag 's390-6.12-1' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=140617d0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6265dd30e362bb47
dashboard link: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1105a327980000

Note: testing is done by a robot and is best-effort only.
