Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67721210FB
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Nov 2024 02:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730772545; cv=none; b=Tv7brQ1t1DWgBpUz7h6VpPWpHRePUafNze0kP60O3clLTwdsGhEmBt4jrxnGgKbSOePT7vjCB7Ow7ZgMJBHc9HVgn1iE2qygo/DjkWhtkGHCr1g5qxz2luo9B7jOtdCy7JopbORWiwjmysM+yBL/CwS5Mt7/kk07fs+l+CzuHUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730772545; c=relaxed/simple;
	bh=y7f4emwH4MxN9Dk0nJiJoZuVuQH0g82lOcV2DXxYyv4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Pu5+xYG3IXNOGEp14FsoEpczc8ZurFZ93tQOF3jj3raH6aPEr9brFcxfE13eCk3Pgf6Uz8lpz/HXnPPpgneCKDoqoMEXTrnKuDjnFJ5Egb/bKp+rQT1ZXUJyeqC4mWEEVE5ZcHwV5sVHbG24xK+F1yBYjLYh+8WUSObqasINJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83aecd993faso421936239f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Nov 2024 18:09:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730772543; x=1731377343;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHNDfZhIwCuUlXyaUbaOjkk68adelWGd6TWuMHqVT7g=;
        b=TL/UBtTtMp0zltmKHTJWfSaGRMaQi3PCzBJkcZB3xbfSTdgLB3lAvyH7/4WVPodjs+
         6LhIJldQMe5Ov1/td2obWzN67pOGteQt76J33KTnj0atiP8CNlk7eK7qRexPBcKjgB/L
         dk625QheoNo2tKYosZ4fw0mLs4JgSxJ74UgO3AmnVfo6mEuu3MuEjHcfTHOU8FBipLVw
         u82LzgWsg7QG1hU/BeLAHF8Y3EGdoiFDW+icHjQsKvRFEqAFkD9rD+lfaQSaru1eL3wT
         VeqEYwxHwRuZQC033kKk8nRhzqNMHhkxyDKCWFSZRi/8b8QCOX1zhksRjUnQKZlze/sm
         CCxA==
X-Forwarded-Encrypted: i=1; AJvYcCVCCtvRiGCT5g0uVDgQjz7Qk+Em+6+kyWvh3mQ88Ldli4BYj4MRiGz6o8lSbwnNWlYbGmB+HysnzWvfYQe46g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5tOpG2eojYsxI5a+J4PkLVDv438ITmf03R3AyvpDc4nnxkll0
	5chFrDOKBostHpK8EMaw0b80fZ66Xnl9kI+5AvaWz/mfs/QcCKlbmuzKwvV/Rk+Lc2EHX2BkYxU
	8xWrzQivHesI0OVjExM/yR+CV8erA1L1++GpEpZC9zUOHsjFHJd03zrA=
X-Google-Smtp-Source: AGHT+IHUOaRGjr6Z7Rj30tI8k0Sxs+JeGMXdFOU1wywHgxh4+nFtHQTf3vwLwRalZBURSLTG839Ea6f146LAOJm2yw3nGVWYdQpy
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cd8d:0:b0:3a6:b26f:a5c4 with SMTP id
 e9e14a558f8ab-3a6b26fa5efmr113399645ab.8.1730772543360; Mon, 04 Nov 2024
 18:09:03 -0800 (PST)
Date: Mon, 04 Nov 2024 18:09:03 -0800
In-Reply-To: <671a8834.050a0220.2eb763.00c5.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67297e3f.050a0220.2edce.14fd.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_run_recovery_pass
From: syzbot <syzbot+a27c3aaa3640dd3e1dfb@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11da0e30580000
start commit:   59b723cd2adb Linux 6.12-rc6
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13da0e30580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15da0e30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=921b01cbfd887a9b
dashboard link: https://syzkaller.appspot.com/bug?extid=a27c3aaa3640dd3e1dfb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e1a587980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10bc46a7980000

Reported-by: syzbot+a27c3aaa3640dd3e1dfb@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
