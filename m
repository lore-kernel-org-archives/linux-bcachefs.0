Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EB02AD04
	for <linux-bcachefs@vger.kernel.org>; Wed, 30 Jul 2025 04:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753849025; cv=none; b=shGimJ3lY+xRoL8wkHEsn2cYVSK8BvbOklCSiS21hIKtKXAp9IPO+hzsicMF6vwty5KsGj2j0CwN1VTncY7jE4bjtBRpSX9GwwZjA2hnIGh+dtk8d/2JOBhpmGAh3bJgGEe+WoEi33vpld1R4BTxouhG3MeulLSJwewUePiV+tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753849025; c=relaxed/simple;
	bh=VwOF/o1PjdMKXxm1/y9IoLX5f3DlHxD4K8mEVhdNm58=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=DJL7J4YbxgqI1Poe+Riixn03OmofmxmfXZuFrtz48WaZ+wxHgFGPeA+FRC5KkejlnCh8dp0zF7OV7/lMZy/wGqd/lHGP2ocLjy1ASm3cHpzS/aQ9fmEYWp6Ub0Rjtd7XVF5vHQnmI2BYJlE6wKjk5xCaoWYG+QqXVwVft51kyfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e3e979be63so39791615ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 29 Jul 2025 21:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753849023; x=1754453823;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hwgtqR7FrVTLZ4saJllTkNFjtO4klXw4taUmxflYLTM=;
        b=Ds4zfyLzcsTcy6akYiWlZKPKPFEgAXX1XnNUxXHVE6rpSKzWLUuK3l146WoP7LErGE
         dnMdBcP/duMuAiNtsXTqIaAX1JKoEaOuO5z1O0dA9xmezNL2AaJbCVZr6HzOsWwbJCKz
         kAXgelH8jXM6tm2gKQme43dM3HEydfKnHtG2dvoM2bd4gXusDma8m/o8TIrQA2W21U7g
         0FNIQKbHz14T7ljpHidBAmkZir2FinUeV1rphQIQ611xxAR3a8PKyuE0D7Iq6jT/ciY2
         ea86l87ZMmbD2cCWhL4et4GhaCItR5pZh8iw1bxoIkdRjC51XntHjc6QcJHa0LjAu6kx
         Yq1A==
X-Forwarded-Encrypted: i=1; AJvYcCWapLFLTzv/TI9GXqOxFPyZC17MKuzKxbD6zGHAry0rk3IhWmBfNKXHClcRPQzADuqptktLs7+41qomCKygYg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoADlnA7c8Oo9ecbSpoSxydO87SeTjYxdlOCO1YDt8+7h5H08K
	GnQp0QyA8PVwylqhU1KqBk8Jrq9X4ow0u8VT8UqyJRuc933c8lC3ubgH6CMaR0UG//qTxNcuKS7
	aHSF9MUEe7r2xoKA2zrYLF/+dhDZCp/Bqf0K1KesaykYTJJPbKwzSei0ryew=
X-Google-Smtp-Source: AGHT+IH/7wfLdxlyOy09YB9JGrTJdr18UCOd8GwD6hZFolQuEY/gAFr6r69cAP/LOc+0McuJeeHF+37nTWH60FnroXAJ66NC34Q3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:792:b0:3e2:9e9d:a978 with SMTP id
 e9e14a558f8ab-3e3f62850c7mr28935245ab.21.1753849023627; Tue, 29 Jul 2025
 21:17:03 -0700 (PDT)
Date: Tue, 29 Jul 2025 21:17:03 -0700
In-Reply-To: <6879a305.a70a0220.693ce.0058.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68899cbf.a00a0220.26d0e1.0017.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_run_recovery_passes
From: syzbot <syzbot+c2294ae43bae606e3c7d@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, frederic@kernel.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 39cea302f13a0a9dc4cf39248529a42e79d06842
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri May 9 21:01:05 2025 +0000

    bcachefs: bch2_check_bucket_backpointer_mismatch()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17590834580000
start commit:   ae388edd4a8f Merge tag 'landlock-6.17-rc1' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14d90834580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10d90834580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8004f1b1e0ae8198
dashboard link: https://syzkaller.appspot.com/bug?extid=c2294ae43bae606e3c7d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1583f034580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1038d4a2580000

Reported-by: syzbot+c2294ae43bae606e3c7d@syzkaller.appspotmail.com
Fixes: 39cea302f13a ("bcachefs: bch2_check_bucket_backpointer_mismatch()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
