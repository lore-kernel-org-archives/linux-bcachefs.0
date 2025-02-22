Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F836C139
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 01:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186067; cv=none; b=h43DGm7IgRwKuwnXZK2EEg91CHebpniTQdR2qlpnwA16jlcweguGeCOfRIbbA1Pwnx10o67TlY2JnqZfP54c0CmM2d9Dhlg5JzPMJRUd6BK5+eQsT7/j5Ejxs+gS7pn/S2uV4Ze9PLNstImq5QQY0Pa3HihC/IVfbs3g8vlK+jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186067; c=relaxed/simple;
	bh=fBCMcXRPLtFr7kTbuvv2zc6MOF5uzJoIw3tIBZVBRJA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nj4ZU6D9NYL55OjDVRdSeZc5rG6I023+dzyfWkFuEydkAWcTyFelMu2xHSavgCBLXd7ix5OdFGPm+Fyp+mO7+w8anSJp/Vf3hP1T/t/69Ab9H3Cwk1wnNLQ1wuCrfiRlErowfVcf24BQlUP5LMkTz3AZvgL3nMVd6YiTIcuRcp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d2a379bbf0so45208175ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Feb 2025 17:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740186065; x=1740790865;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/g4S0rtmAw1ot+JHLgqMoNm8oJhYI82knnP6GthPD8=;
        b=j8evazhqATyOfuIBk/wbGiUBzs43J8OpIjP+oaHRHfOE5/eiAL6UMr8v+StaWIUVsT
         ELb8OYSjzQGaXJDe64kDMq7yfLfozSlrfscYUWOnWizLfgQFPFjeaSAG7dyDHsOUvPkP
         5FLEQsYOWm/1nBYUkBds0U98k1sIf348dTBrCjOS0MeclsI66ztMP7M73Zj2N94Ekv81
         rlzanoah7/0I3BbIa6ZyOQSvBm0kpsauDE3tw1HFcnKvNFgtrXx23AYNHg4sCN/dazdf
         +Pbh2kq/ssegcdBQH8SnfPzUdG7HzrkjdxXIU1nhoj+jlzVb/06URGQ4Dd6DonFDMMj/
         woDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQmF1Di7RsN2wyGlMIo8Ap3+brNgxtfUrG+Zy/CnnFDxEEq4BvWB0Nu2hV9OXVkkECXkhCsWuaAGwRYAWoug==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpxT1+YCUGuBfrTK9ouTDjNhx5C1c7yBGytKtbE5F6RkLmR/DS
	pGjRhOeicF3t0tnjSAOOPW6mjmguL+8nIajZ3MqdJUIUY/L5ZAJc8BihtWoEaLUs7ev+EuXVOjQ
	hN4He38rHHbYF7CfrmX/JIJ9a7B/RI8/sML35+/ACuuxhLN/dyQkfGDE=
X-Google-Smtp-Source: AGHT+IHgoyRHGT8n2U0f5nj6pPzqwrGKygIICQiEr2OtsSPaOB+ITbxhNydQsZDxgGQfDtmdo9Zxgj/pJ5wVYO0LRhPBmI7sHNy8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe6:b0:3d1:9cee:3d2f with SMTP id
 e9e14a558f8ab-3d2cb51e40amr59265405ab.18.1740186063888; Fri, 21 Feb 2025
 17:01:03 -0800 (PST)
Date: Fri, 21 Feb 2025 17:01:03 -0800
In-Reply-To: <67b8a9a7.050a0220.14d86d.0578.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b921cf.050a0220.14d86d.059a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in check_dirent
From: syzbot <syzbot+87078ad27cd8af3263cc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit cf3da2d627037a0848e25dbaeaedfadfe534c7c4
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Dec 16 18:58:02 2024 +0000

    bcachefs: Handle -BCH_ERR_need_mark_replicas in gc

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10e887a4580000
start commit:   27eddbf34490 Merge tag 'net-6.14-rc4' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12e887a4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14e887a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b03346163189483c
dashboard link: https://syzkaller.appspot.com/bug?extid=87078ad27cd8af3263cc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ce6ba4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11300db0580000

Reported-by: syzbot+87078ad27cd8af3263cc@syzkaller.appspotmail.com
Fixes: cf3da2d62703 ("bcachefs: Handle -BCH_ERR_need_mark_replicas in gc")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
